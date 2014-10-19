//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseExplosiveProjectile
//	Parent class:	 UM_BaseProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.05.2013 21:08
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseExplosiveProjectile extends UM_BaseProjectile
	Abstract;

//========================================================================
//[block] Variables

// camera shakes
var(Shakes)		vector		ShakeRotMag;		// how far to rot view
var(Shakes)		vector		ShakeRotRate;		// how fast to rot view
var(Shakes)		float		ShakeRotTime;		// how much time to rot the instigator's view
var(Shakes)		vector		ShakeOffsetMag;		// max view offset vertically
var(Shakes)		vector		ShakeOffsetRate;	// how fast to offset view vertically
var(Shakes)		float		ShakeOffsetTime;	// how much time to offset view

var(Shakes)		float		ShakeRadiusScale;	// ShakeRadius = DamageRadius * ShakeRadiusScale;
var(Shakes)		float		MaxEpicenterShakeScale; // Maximum shake scale in explosion epicenter


// With DisintegrateDamageTypes array you can set damage types 
// that will Disintegrate Projectile instead of simple detonation
var		array< class<DamageType> >	DisintegrateDamageTypes;

// Use IgnoreVictims array to assign Victims that will be ignored in HurtRadius function
var		array< name >		IgnoreVictims;
var		bool				bIgnoreSameClassProj;	//Ignore projectiles with the same class in HurtRadius

//Shrapnel
var		class<UM_BaseProjectile>	ShrapnelClass;
var		int					MaxShrapnelAmount, MinShrapnelAmount;

//[block] Effects
var		bool				bDisintegrated;	// This Projectile has been disintegrated by a siren scream.
var		bool				bShouldExplode, bHasExploded; 	// This Projectile has Exploded.

var		float				DisintegrateChance;	// Chance of this projectile to Disintegrate
var		float				DisintegrateDamageScale; // Scale damage by this multiplier when projectile disintegrating

// Sounds
var		SoundData			DisintegrateSound, ExplodeSound;

// Visual Effect
var		class<Emitter>		ExplosionVisualEffect, DisintegrationVisualEffect;
//[end]

var		float				ArmingRange;	// Detonator will be armed after this distance (meters). Converted to UU and squared in CalcDefaultProperties().
var		float				SquaredArmingRange;

//DramaticEvents
var		float				SmallDramaticEventDuration, MediumDramaticEventDuration, LongDramaticEventDuration;
var		int					SmallDramaticEventKills, MediumDramaticEvenKills, LongDramaticEventKills;


// How much damage to do when this Projectile impacts something before exploding
var(Impact)		float		ImpactDamage;
var(Impact)		float		ImpactMomentumTransfer;		// Momentum magnitude imparted by impacting projectile.
var		class<DamageType>	ImpactDamageType;	// Damagetype of this Projectile hitting something, before exploding


//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bShouldExplode;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	Super.CalcDefaultProperties();
	// ArmingRange
	if ( default.ArmingRange > 0.0 )  {
		default.ArmingRange = default.ArmingRange * MeterInUU;
		ArmingRange = default.ArmingRange;
		// Squared ArmingRange
		default.SquaredArmingRange = default.ArmingRange * default.ArmingRange;
		SquaredArmingRange = default.SquaredArmingRange;
	}
}

//[block] Dynamic Loading
simulated static function PreloadAssets(Projectile Proj)
{
	// Loading Defaults
	default.DisintegrateSound.Snd = BaseActor.static.LoadSound( default.DisintegrateSound.Ref );
	default.ExplodeSound.Snd = BaseActor.static.LoadSound( default.ExplodeSound.Ref );
	
	if ( UM_BaseExplosiveProjectile(Proj) != None )  {
		UM_BaseExplosiveProjectile(Proj).DisintegrateSound.Snd = default.DisintegrateSound.Snd;
		UM_BaseExplosiveProjectile(Proj).ExplodeSound.Snd = default.ExplodeSound.Snd;
	}
	
	Super.PreloadAssets(Proj);
}

simulated static function bool UnloadAssets()
{
	default.DisintegrateSound.Snd = None;
	default.ExplodeSound.Snd = None;
	
	Return Super.UnloadAssets();
}
//[end]

simulated event PostNetReceive()
{
	if ( bHidden && !bDisintegrated )
		Disintegrate(Location, Vector(Rotation));
	else if ( bShouldExplode && !bHidden && !bHasExploded )
		Explode(Location, Vector(Rotation));
}

// Detonator is armed
simulated function bool IsArmed()
{
	if ( bHidden || bShouldExplode )
		Return False;
	
	Return True;
}

// Check for friendly Pawns within radius
function bool FriendlyPawnIsInRadius( float FriendlyPawnSearchRadius )
{
	local	KFHumanPawn	HP;
	
	foreach VisibleCollidingActors( Class 'KFHumanPawn', HP, FriendlyPawnSearchRadius, Location )  {
		if ( HP != None && HP.Health > 0 && (HP == Instigator || (TeamGame(Level.Game) != None 
				 && TeamGame(Level.Game).FriendlyFireScale > 0.0 && HP.GetTeamNum() == Instigator.GetTeamNum())) )
			Return True;
	}
	
	Return False;
}

// Check for KFMonster within radius
function bool MonsterIsInRadius( float MonsterSearchRadius )
{
	local	KFMonster	M;
	
	foreach VisibleCollidingActors( Class 'KFMonster', M, MonsterSearchRadius, Location )  {
		if ( M != None && M.Health > 0 )
			Return True;
	}
	
	Return False;
}

// Called when projectile has lost all energy
simulated function ZeroProjectileEnergy()
{
	Super.ZeroProjectileEnergy();
	ImpactDamage = 0.0;
}

// Called when the projectile loses some of the energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	ImpactDamage *= NewScale;
	ImpactMomentumTransfer *= NewScale;
}

// HurtRadius()
// Hurt locally authoritative actors within the radius.
function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local Actor			Victims;
	local float			damageScale, dist;
	local vector		dir, VictimHitLocation;
	local int			NumKilled, i;
	local KFMonster		KFMonsterVictim;
	local Pawn			P;
	local array<Pawn>	CheckedPawns;
	local bool			bAlreadyChecked, bIgnoreThisVictim;

	if ( bHurtEntry )
		Return;

	bHurtEntry = True;
	
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )  {
		// Clearing varibles.
		P = None;
		KFMonsterVictim = None;
		
		if ( Victims != None && !Victims.bDeleteMe && Victims != Self && Victims != Hurtwall
			 && !Victims.IsA('FluidSurfaceInfo') && ExtendedZCollision(Victims) == None )  {
			// Ignore projectile with the same class
			if ( bIgnoreSameClassProj && Victims.Class == Class )
				Continue;
			
			if ( IgnoreVictims.Length > 0 )  {
				bIgnoreThisVictim = False;
				for ( i = 0; i < IgnoreVictims.Length; ++i )  {
					if ( Victims.IsA(IgnoreVictims[i]) )  {
						bIgnoreThisVictim = True;
						Break;
					}
				}
				
				// Skip this Victims if IgnoreVictims array contain this Victims.class
				if ( bIgnoreThisVictim )
					Continue;
			}
			
			dir = Victims.Location - HitLocation;
			dist = FMax(1.0, VSize(dir));
			dir = dir / dist;
			damageScale = 1.0 - FMax( 0.0, ((dist - Victims.CollisionRadius) / DamageRadius) );
			
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
				
			if ( Victims == LastTouched )
				LastTouched = None;
				
			//[block] Cheking damageScale modifiers
			P = Pawn(Victims);
			if ( P != None )  {
				// Do not damage a friendly Pawn
				if ( !CanHurtPawn(P) )
					Continue;
				
				for ( i = 0; i < CheckedPawns.Length; ++i )  {
					if ( CheckedPawns[i] == P )  {
						bAlreadyChecked = True;
						Break;
					}
				}

				if ( bAlreadyChecked )  {
					bAlreadyChecked = False;
					P = None;
					Continue;
				}

				KFMonsterVictim = KFMonster(Victims);
				if ( KFMonsterVictim != None && KFMonsterVictim.Health > 0 )
					damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
				else if ( KFPawn(Victims) != None && KFPawn(Victims).Health > 0 )
					damageScale *= KFPawn(Victims).GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));

				CheckedPawns[CheckedPawns.Length] = P;
				P = None;
				if ( damageScale <= 0.0 )
					Continue;
			}
			//[end]
			
			VictimHitLocation = Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir;
			Victims.TakeDamage(
				(damageScale * DamageAmount), Instigator, VictimHitLocation,
				(damageScale * Momentum * dir), DamageType
			);
			
			if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0 )
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
				
			// Calculating number of victims
			if ( KFMonsterVictim != None && KFMonsterVictim.Health <= 0 )
				NumKilled++;
		}
	}
	
	if ( LastTouched != None && LastTouched != Self && !LastTouched.IsA('FluidSurfaceInfo') )  {
		Victims = LastTouched;
		LastTouched = None;
		
		P = Pawn(Victims);
		// Do not damage a friendly Pawn
		if ( (bIgnoreSameClassProj && Victims.Class == Class) || !CanHurtPawn(P) )
			Return;
				
		if ( IgnoreVictims.Length > 0 )  {
			bIgnoreThisVictim = False;
			for ( i = 0; i < IgnoreVictims.Length; ++i )  {
				if ( Victims.IsA(IgnoreVictims[i]) )  {
					bIgnoreThisVictim = True;
					Break;
				}
			}
			
			// Skip this Victims if IgnoreVictims array contain this Victims.class
			if ( bIgnoreThisVictim )
				Return;
		}
		
		dir = Victims.Location - HitLocation;
		dist = FMax(1.0, VSize(dir));
		dir = dir / dist;
		damageScale = FMax((Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight)),(1.0 - FMax(0, ((dist - Victims.CollisionRadius) / DamageRadius))));
		if ( damageScale <= 0.0 )
			Return;
		
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController( InstigatorController );
		
		VictimHitLocation = Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir;
		Victims.TakeDamage(
			(damageScale * DamageAmount), Instigator, VictimHitLocation,
			(damageScale * Momentum * dir), DamageType
		);
		
		if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0 )
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	if ( NumKilled >= LongDramaticEventKills )
		KFGameType(Level.Game).DramaticEvent(0.08, LongDramaticEventDuration);
	else if ( NumKilled >= MediumDramaticEvenKills )
		KFGameType(Level.Game).DramaticEvent(0.05, MediumDramaticEventDuration);
	else if ( NumKilled >= SmallDramaticEventKills )
		KFGameType(Level.Game).DramaticEvent(0.03, SmallDramaticEventDuration);
	
	bHurtEntry = False;
}

// HurtRadius()
// Hurt locally authoritative actors within the radius.
function DelayedHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	HurtRadius(DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
}

function BlowUp(vector HitLocation)
{
	MakeNoise(1.0);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
}

// Server-side only
function SpawnShrapnel()
{
	local	int			i;
	local	Rotator		SpawnRotation;
	local	Projectile	ShrapnelProj;
	local	Actor		SpawnBlocker;
	local	Vector		THitLoc, THitNorm, ShrapnelCollisionExtent;
	
	if ( ShrapnelClass != None && MaxShrapnelAmount > 0 )  {
		if ( MaxShrapnelAmount > 1 )  {
			for ( i = Rand( Max((MaxShrapnelAmount - MinShrapnelAmount), 1) ); i < MaxShrapnelAmount; ++i )  {
				SpawnRotation = RotRand(True);
				ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, SpawnRotation);
				// Can't spawn Shrapnel
				if ( ShrapnelProj == None || ShrapnelProj.bDeleteMe )  {
					ShrapnelCollisionExtent = Vector(SpawnRotation) * VSize(ShrapnelClass.static.GetDefaultCollisionExtent());
					SpawnBlocker = Trace(THitLoc, THitNorm, (Location + 2.0 * ShrapnelCollisionExtent), Location, False, ShrapnelCollisionExtent);
					// If something blocking shrapnel spawn location
					if ( SpawnBlocker != None )
						Spawn(ShrapnelClass, Instigator,, (THitLoc + ShrapnelCollisionExtent), SpawnRotation);
				}
			}
		}
		else  {
			SpawnRotation = RotRand(True);
			ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, SpawnRotation);
			// Can't spawn Shrapnel
			if ( ShrapnelProj == None || ShrapnelProj.bDeleteMe )  {
				ShrapnelCollisionExtent = Vector(SpawnRotation) * VSize(ShrapnelClass.static.GetDefaultCollisionExtent());
				SpawnBlocker = Trace(THitLoc, THitNorm, (Location + 2.0 * ShrapnelCollisionExtent), Location, False, ShrapnelCollisionExtent);
				// If something blocking shrapnel spawn location
				if ( SpawnBlocker != None )
					Spawn(ShrapnelClass, Instigator,, (THitLoc + ShrapnelCollisionExtent), SpawnRotation);
			}
		}
	}
}

simulated function ShakePlayersView()
{
	local	PlayerController	PC;
	local	float				Dist, ShakeScale, ShakeRadius;
	
	PC = Level.GetLocalPlayerController();
	if ( PC != None && PC.ViewTarget != None )  {
		ShakeRadius = DamageRadius * ShakeRadiusScale;
		Dist = VSize(Location - PC.ViewTarget.Location);
		
		if ( Dist < ShakeRadius )  {
			ShakeScale = FClamp(((ShakeRadius - Dist) / DamageRadius), 0.001, MaxEpicenterShakeScale);
			PC.ShakeView(
				(ShakeRotMag * ShakeScale), ShakeRotRate, ShakeRotTime, 
				(ShakeOffsetMag * ShakeScale), ShakeOffsetRate, ShakeOffsetTime
			);
		}
	}
}

event Timer()
{
	if ( IsArmed() )
		Explode(Location, Vector(Rotation));
	else
		Destroy();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	bCanBeDamaged = False;
	bHasExploded = True;
	bShouldExplode = True;
	
	// Send update to the clients and destroy
	if ( Role == ROLE_Authority )  {
		NetUpdateTime = Level.TimeSeconds - 1;
		BlowUp(HitLocation);
		SetTimer(0.1, false);
	}
	
	// Explode effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExplodeSound.Snd != None )
			PlaySound(ExplodeSound.Snd, ExplodeSound.Slot, ExplodeSound.Vol, ExplodeSound.bNoOverride, ExplodeSound.Radius, GetRandPitch(ExplodeSound.PitchRange), ExplodeSound.bUse3D);
		// VFX
		if ( !Level.bDropDetail && EffectIsRelevant(Location, False) )  {
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, Rotator(-HitNormal));
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, Rotator(-HitNormal));
		}
	}
	
	SetCollision(False);
	// Shrapnel
	if ( Role == ROLE_Authority )
		SpawnShrapnel();
	
	// Shake nearby players screens
	ShakePlayersView();
	
	// Destroying on client-side
	if ( Role < ROLE_Authority )
		Destroy();
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
	bCanBeDamaged = False;
	bDisintegrated = True;
	bHidden = True;
	
	// Send update to the clients and destroy
	if ( Role == ROLE_Authority )  {
		NetUpdateTime = Level.TimeSeconds - 1;
		Damage *= DisintegrateDamageScale;
		MomentumTransfer *= DisintegrateDamageScale;
		BlowUp(HitLocation);
		SetTimer(0.1, false);
	}
	
	// Disintegrate effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( DisintegrateSound.Snd != None )
			PlaySound(DisintegrateSound.Snd, DisintegrateSound.Slot, DisintegrateSound.Vol, DisintegrateSound.bNoOverride, DisintegrateSound.Radius, GetRandPitch(DisintegrateSound.PitchRange), DisintegrateSound.bUse3D);
		// VFX
		if ( !Level.bDropDetail && DisintegrationVisualEffect != None && EffectIsRelevant(Location, False) )
			Spawn(DisintegrationVisualEffect,,, HitLocation, rotator(-HitNormal));
	}

	// Destroying on client-side
	if ( Role < ROLE_Authority )
		Destroy();
}

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	local	int		i;

	if ( Monster(EventInstigator) != None || EventInstigator == Instigator ||
		 (TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale > 0.0) )  {
		// Disintegrate this Projectile instead of simple detonation
		if ( DisintegrateDamageTypes.Length > 0 )  {
			for ( i = 0; i < DisintegrateDamageTypes.Length; ++i )  {
				if ( DamageType == DisintegrateDamageTypes[i] )  {
					if ( FRand() <= DisintegrateChance )
						Disintegrate(HitLocation, Vector(Rotation));
					
					Return;
				}
			}
		}
		
		if ( IsArmed() )
			Explode(HitLocation, Vector(Rotation));
	}
}

simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
{
	LastTouched = A;
	if ( CanHitThisActor(A) )
		ProcessHitActor(A, TouchLocation, TouchNormal, ImpactDamage, ImpactMomentumTransfer, ImpactDamageType);
		
	LastTouched = None;
}

simulated event Destroyed()
{
	if ( bHidden && !bDisintegrated )
		Disintegrate(Location, Vector(Rotation));
	else if ( bShouldExplode && !bHidden && !bHasExploded )
		Explode(Location, Vector(Rotation));
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
     bCanBeDamaged=True
	 bIgnoreSameClassProj=True
	 bCanHurtOwner=True
	 DisintegrateDamageScale=0.100000
	 TransientSoundVolume=2.000000
	 //Sounds
	 DisintegrateSound=(PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 ExplodeSound=(PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 //Shrapnel
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 // Explosion camera shakes
	 ShakeRadiusScale=2.250000
	 MaxEpicenterShakeScale=1.500000
	 ShakeRotMag=(X=650.000000,Y=650.000000,Z=650.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=325.000000,Y=325.000000,Z=325.000000)
     ShakeOffsetTime=3.500000
	 //DramaticEvents
	 SmallDramaticEventDuration=2.000000
	 MediumDramaticEventDuration=3.000000
	 LongDramaticEventDuration=4.000000
	 SmallDramaticEventKills=2
	 MediumDramaticEvenKills=4
	 LongDramaticEventKills=8
	 //Disintegration
	 DisintegrateChance=0.950000
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //Replication
	 bNetTemporary=False
	 bReplicateInstigator=True
     bNetInitialRotation=True
	 bNetNotify=True
	 bReplicateMovement=True
	 bUpdateSimulatedPosition=False
	 //Light
	 bUnlit=True
	 //Collision
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 BallisticRandRange=(Min=0.98,Max=1.02)
}
