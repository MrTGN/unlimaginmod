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
var		class<Projectile>	ShrapnelClass;
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

var		float				ArmingRange;	// Detonator will be armed after this distance

//DramaticEvents
var		float				SmallDramaticEventDuration, MediumDramaticEventDuration, LongDramaticEventDuration;
var		int					SmallDramaticEventKills, MediumDramaticEvenKills, LongDramaticEventKills;


// How much damage to do when this Projectile impacts something before exploding
var(Impact)		float		ImpactDamage, ImpactDamageRadius;
var(Impact)		float		HeadShotImpactDamageMult;	// headshot ImpactDamage multiplier
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

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if ( default.ImpactDamage > 0.0 )
		ImpactDamage = default.ImpactDamage * GetRandMultByPercent(BallisticRandPercent);
	
	if ( default.Damage > 0.0 )
		Damage = default.Damage * GetRandMultByPercent(BallisticRandPercent);
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
		Disintegrate(Location, vect(0,0,1));
	else if ( bShouldExplode && !bHidden && !bHasExploded )
		Explode(Location, vect(0,0,1));
}

// Detonator is armed
function bool IsArmed()
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
			dist = FMax(1, VSize(dir));
			dir = dir / dist;
			damageScale = 1 - FMax( 0, ((dist - Victims.CollisionRadius) / DamageRadius) );
			
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
		dist = FMax(1, VSize(dir));
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
	local	Vector		THitLoc, THitNorm, TraceEnd;
	
	if ( ShrapnelClass != None && MaxShrapnelAmount > 0 )  {
		if ( MaxShrapnelAmount > 1 )  {
			for ( i = Rand( Max((MaxShrapnelAmount - MinShrapnelAmount), 1) ); i < MaxShrapnelAmount; ++i )  {
				SpawnRotation = RotRand(True);
				ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, SpawnRotation);
				if ( ShrapnelProj == None )  {
					// Number 30 here is a distance in unreal units and nothing more =)
					TraceEnd = Location + Vector(SpawnRotation) * 30;
					SpawnBlocker = Trace(THitLoc, THitNorm, (Location + Vector(SpawnRotation) * 30), Location, false);
					// If something blocking shrapnel spawn location
					if ( SpawnBlocker != None )  {
						THitLoc = (2.0 + FMax(ShrapnelClass.default.CollisionRadius, ShrapnelClass.default.CollisionHeight)) * -Normal(THitLoc - Location) + THitLoc;
						Spawn(ShrapnelClass, Instigator,, THitLoc, SpawnRotation);
					}
				}
			}
		}
		else  {
			SpawnRotation = RotRand(True);
			ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, SpawnRotation);
			if ( ShrapnelProj == None )  {
				// Number 30 here is a distance in unreal units and nothing more =)
				TraceEnd = Location + Vector(SpawnRotation) * 30;
				SpawnBlocker = Trace(THitLoc, THitNorm, (Location + Vector(SpawnRotation) * 30), Location, false);
				// If something blocking shrapnel spawn location
				if ( SpawnBlocker != None )  {
					THitLoc = (2.0 + FMax(ShrapnelClass.default.CollisionRadius, ShrapnelClass.default.CollisionHeight)) * -Normal(THitLoc - Location) + THitLoc;
					Spawn(ShrapnelClass, Instigator,, THitLoc, SpawnRotation);
				}
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
		Explode(Location, vect(0,0,1));
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
		BlowUp(HitLocation);
		SetTimer(0.1, false);
		NetUpdateTime = Level.TimeSeconds - 1;
	}
	
	// Explode effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExplodeSound.Snd != None )
			ClientPlaySoundData(ExplodeSound);
		// VFX
		if ( !Level.bDropDetail && EffectIsRelevant(Location, False) )  {
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		}
	}
	
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
		Damage *= DisintegrateDamageScale;
		MomentumTransfer *= DisintegrateDamageScale;
		BlowUp(HitLocation);
		SetTimer(0.1, false);
		NetUpdateTime = Level.TimeSeconds - 1;
	}
	
	// Disintegrate effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( DisintegrateSound.Snd != None )
			ClientPlaySoundData(DisintegrateSound);
		// VFX
		if ( !Level.bDropDetail && DisintegrationVisualEffect != None && EffectIsRelevant(Location, False) )
			Spawn(DisintegrationVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
	}

	// Destroying on client-side
	if ( Role < ROLE_Authority )
		Destroy();
}

event TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local	int		i;

	if ( Monster(InstigatedBy) != None || InstigatedBy == Instigator ||
		 (TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale > 0.0) )  {
		// Disintegrate this Projectile instead of simple detonation
		if ( DisintegrateDamageTypes.Length > 0 )  {
			for ( i = 0; i < DisintegrateDamageTypes.Length; ++i )  {
				if ( damageType == DisintegrateDamageTypes[i] )  {
					if ( FRand() <= DisintegrateChance )
						Disintegrate(HitLocation, vect(0.0, 0.0, 1.0));
					
					Return;
				}
			}
		}
		
		Explode(HitLocation, vect(0.0, 0.0, 1.0));
	}
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority )  {
		if ( ImpactDamageType != None && ImpactDamage > 0.0 && !Wall.bStatic && !Wall.bWorldGeometry )  {
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController(InstigatorController);

			Wall.TakeDamage(ImpactDamage, Instigator, Location, (ImpactMomentumTransfer * Normal(Velocity)), ImpactDamageType);

			if ( ImpactDamageRadius > 0.0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0 )
				Vehicle(Wall).DriverRadiusDamage(ImpactDamage, ImpactDamageRadius, InstigatorController, ImpactDamageType, ImpactMomentumTransfer, Location);

			HurtWall = Wall;
		}
		
		if ( IsArmed() )
			Explode((Location + ExploWallOut * HitNormal), HitNormal);
	}
	
	HurtWall = None;
	ZeroProjectileEnergy();
}


simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
}

simulated event Destroyed()
{
	if ( bHidden && !bDisintegrated )
		Disintegrate(Location, vect(0,0,1));
	else if ( bShouldExplode && !bHidden && !bHasExploded )
		Explode(Location, vect(0,0,1));
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
     bCanBeDamaged=True
	 bIgnoreSameClassProj=True
	 DisintegrateDamageScale=0.100000
	 ImpactDamageRadius=0.00000
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
}
