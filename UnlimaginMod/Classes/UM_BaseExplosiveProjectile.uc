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
	DependsOn(UM_BaseActor)
	DependsOn(UM_BaseObject)
	Abstract;

//========================================================================
//[block] Variables

// camera shakes
var(Shakes)		vector				ShakeRotMag;		// how far to rot view
var(Shakes)		vector				ShakeRotRate;		// how fast to rot view
var(Shakes)		float				ShakeRotTime;		// how much time to rot the instigator's view
var(Shakes)		vector				ShakeOffsetMag;		// max view offset vertically
var(Shakes)		vector				ShakeOffsetRate;	// how fast to offset view vertically
var(Shakes)		float				ShakeOffsetTime;	// how much time to offset view

var(Shakes)		float				ShakeRadiusScale;	// ShakeRadius = DamageRadius * ShakeRadiusScale;
var(Shakes)		float				MaxEpicenterShakeScale; // Maximum shake scale in explosion epicenter


// With DisintegrationDamageTypes array you can set damage types 
// that will Disintegrate Projectile instead of simple detonation
var		array< class<DamageType> >	DisintegrationDamageTypes;

// Use IgnoredVictims array to assign Victims that will be ignored in HurtRadius function
var		array< name >				IgnoredVictims;

//Shrapnel
var		class<UM_BaseProjectile>	ShrapnelClass;
var		UM_BaseObject.IRange		ShrapnelAmount;

//[block] Effects
var		bool						bShouldExplode, bHasExploded; 	// This Projectile has Exploded.
var		bool						bShouldDisintegrate, bDisintegrated;	// This Projectile has been disintegrated by a siren scream.
var		float						DisintegrationChance;	// Chance of this projectile to Disintegrate
var		float						DisintegrationDamageScale; // Scale damage by this multiplier when projectile has been disintegrated

// Sounds
var		UM_BaseActor.SoundData		DisintegrationSound, ExplosionSound;

// Visual Effect
var		class<Emitter>				ExplosionVisualEffect, DisintegrationVisualEffect;
//[end]

// ArmingDelay
var		float						ArmingRange; // Detonator will be armed after this distance (meters). Converted to UU and squared in CalcDefaultProperties().
var		float						SquaredArmingRange;
var		float						ArmingDelay; // Detonator will be armed after a specified amount of time in sec.
var		transient	float			ArmedTime;
var					bool			bArmed;

// How much damage to do when this Projectile impacts something before exploding
var(Impact)		float				ImpactDamage;
var(Impact)		float				ImpactMomentumTransfer;		// Momentum magnitude imparted by impacting projectile.
var		class<DamageType>			ImpactDamageType;	// Damagetype of this Projectile hitting something, before exploding


//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bShouldDisintegrate, bShouldExplode;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated static function CalcDefaultProperties()
{
	Super.CalcDefaultProperties();
	
	// ArmingRange
	if ( default.ArmingRange > 0.0 )  {
		default.ArmingRange = default.ArmingRange * MeterInUU;
		// Squared ArmingRange
		default.SquaredArmingRange = Square(default.ArmingRange);
		// ArmingDelay
		if ( default.ArmingDelay <= 0.0 && default.MaxSpeed > 0.0 )  {
			default.ArmingDelay = default.ArmingRange / default.MaxSpeed;
			// InitialAccelerationTime
			if ( default.bTrueBallistics && default.bInitialAcceleration )
				default.ArmingDelay += default.InitialAccelerationTime;
		}
	}
}

simulated function ResetToDefaultProperties()
{
	Super.ResetToDefaultProperties();
	// ArmingRange
	ArmingRange = default.ArmingRange;
	SquaredArmingRange = default.SquaredArmingRange;
	// ArmingDelay
	if ( default.ArmingDelay > 0.0 )  {
		bArmed = False;
		ArmingDelay = default.ArmingDelay;
	}
}

//[block] Dynamic Loading
simulated static function PreloadAssets(Projectile Proj)
{
	// Loading Defaults
	default.DisintegrationSound.Snd = BaseActor.static.LoadSound( default.DisintegrationSound.Ref );
	default.ExplosionSound.Snd = BaseActor.static.LoadSound( default.ExplosionSound.Ref );
	
	if ( UM_BaseExplosiveProjectile(Proj) != None )  {
		UM_BaseExplosiveProjectile(Proj).DisintegrationSound.Snd = default.DisintegrationSound.Snd;
		UM_BaseExplosiveProjectile(Proj).ExplosionSound.Snd = default.ExplosionSound.Snd;
	}
	
	Super.PreloadAssets(Proj);
}

simulated static function bool UnloadAssets()
{
	default.DisintegrationSound.Snd = None;
	default.ExplosionSound.Snd = None;
	
	Return Super.UnloadAssets();
}
//[end]

simulated function SetArmingDelay( float NewArmingDelay )
{
	if ( NewArmingDelay > 0.0 )  {
		bArmed = False;
		ArmedTime = Level.TimeSeconds + NewArmingDelay;
	}
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	// ArmedTime
	SetArmingDelay( ArmingDelay );
}

simulated event PostNetReceive()
{
	if ( bShouldDisintegrate && !bDisintegrated )
		Disintegrate(Location, vector(Rotation));
	else if ( bShouldExplode && !bHasExploded )
		Explode(Location, vector(Rotation));
}

// Detonator is armed
simulated function bool IsArmed()
{
	if ( bDisintegrated || bHasExploded )
		Return False;
	
	Return bArmed;
}

simulated function Disarm()
{
	ArmedTime = 0.0;
	bArmed = False;
	LifeSpan = 1.0;
}

simulated event Tick( float DeltaTime )
{
	// Arming
	if ( !bArmed && ArmedTime > 0.0 && Level.TimeSeconds >= ArmedTime )  {
		ArmedTime = 0.0;
		bArmed = True;
	}
}

// Check for friendly Pawns in radius
simulated function bool AllyIsInRadius( float AllySearchRadius )
{
	local	Pawn	P;
	
	// Check Instigator is in Radius
	if ( Instigator != None && VSizeSquared(Instigator.Location - Location) <= Square(AllySearchRadius) && FastTrace( Instigator.Location, Location ) )
		Return True;
	
	if ( UM_GameReplicationInfo(Level.GRI) != None && UM_GameReplicationInfo(Level.GRI).FriendlyFireScale <= 0.0 )
		Return False; // No need to check for Ally if no FriendlyFire
	
	foreach CollidingActors( Class'Pawn', P, AllySearchRadius, Location )  {
		if ( P != None && P.Health > 0 && P.GetTeamNum() == InstigatorTeamNum && FastTrace( P.Location, Location ) )
			Return True;
	}
	
	Return False;
}

// Check for enemy Pawns in radius
simulated function bool EnemyIsInRadius( float EnemySearchRadius )
{
	local	Pawn	P;
	
	foreach CollidingActors( Class'Pawn', P, EnemySearchRadius, Location )  {
		if ( P != None && P.Health > 0 && P.GetTeamNum() != InstigatorTeamNum && FastTrace( P.Location, Location ) )
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

function bool CanHurtVictim(Actor Victim)
{
	local	int		i;
	
	if ( Victim == None || Victim.bDeleteMe || Victim.bHidden || !Victim.bCanBeDamaged
		 || Victim == Self || Victim == Hurtwall || FluidSurfaceInfo(Victim) != None )
		Return False;
	
	// Check IgnoredVictims array
	for ( i = 0; i < IgnoredVictims.Length; ++i )  {
		if ( Victim.IsA(IgnoredVictims[i]) )
			Return False;
	}
	
	Return True;
}

// HurtRadius()
// Hurt locally authoritative actors within the radius.
function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local	Actor			Victim;
	local	float			DamageScale;
	local	vector			Dir;
	local	int				NumKilled, i;
	local	array<Pawn>		CheckedPawns;
	local	bool			bIgnoreThisVictim;

	if ( bHurtEntry || DamageAmount <= 0.0 )
		Return;

	bHurtEntry = True;
	
	if ( LastTouched != None && CanHurtVictim(LastTouched) )  {
		Victim = LastTouched;
		LastTouched = None;
		// BallisticCollision check
		if ( UM_BallisticCollision(Victim) != None )  {
			if ( UM_BallisticCollision(Victim).CanBeDamaged() )
				Victim = Victim.Instigator;
			else
				bIgnoreThisVictim = True;	// Skip this BallisticCollision
		}
		else if ( Projectile(Victim) != None && !CanHurtProjectile( Projectile(Victim) ) )
			bIgnoreThisVictim = True;
		
		// Skip this Victim if IgnoredVictims array contain this Victim.class
		if ( !bIgnoreThisVictim )  {
			Dir = Victim.Location - HitLocation;
			DamageScale = FMax( (1.0 - FMax((VSize(Dir) - Victim.CollisionRadius), 0.0) / DamageRadius), 0.0 );
			Dir = Normal(Dir);
			if ( Pawn(Victim) != None )  {
				if ( CanHurtPawn(Pawn(Victim)) )  {
					// Extended FastTraces from bones Locations
					if ( KFMonster(Victim) != None )
						DamageScale *= KFMonster(Victim).GetExposureTo(HitLocation);
					else if ( KFPawn(Victim) != None )
						DamageScale *= KFPawn(Victim).GetExposureTo(HitLocation);	
				}
				else
					bIgnoreThisVictim = True;	// Do not damage a friendly Pawn
				
				CheckedPawns[CheckedPawns.Length] = Pawn(Victim);
			}
			else
				bIgnoreThisVictim = !FastTrace( Victim.Location, HitLocation );
			
			i = Round(DamageAmount * DamageScale);
			// if not outside the DamageRadius
			if ( !bIgnoreThisVictim && i > 0 )  {
				if ( Instigator == None || Instigator.Controller == None )
					Victim.SetDelayedDamageInstigatorController( InstigatorController );
				// Damage Victim
				Victim.TakeDamage( i, Instigator,
					(Victim.Location - (Victim.CollisionHeight + Victim.CollisionRadius) * 0.5 * Dir),
					(Momentum * DamageScale * Dir), DamageType );
				// Damage Vehicle Driver
				if ( Vehicle(Victim) != None && Vehicle(Victim).Health > 0 )
					Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
				
				// Calculating number of Victim
				if ( Pawn(Victim) != None && Pawn(Victim).Health < 1 )
					++NumKilled;
			}
		}
	}
	
	foreach CollidingActors( class'Actor', Victim, DamageRadius, HitLocation )  {
		if ( !CanHurtVictim(Victim) )
			Continue;
		
		// BallisticCollision check
		if ( UM_BallisticCollision(Victim) != None )  {
			if ( UM_BallisticCollision(Victim).CanBeDamaged() )
				Victim = Victim.Instigator;
			else
				Continue;	// Skip this BallisticCollision
		}
		// Projectile check
		else if ( Projectile(Victim) != None && !CanHurtProjectile( Projectile(Victim) ) )
			Continue;
		
		Dir = Victim.Location - HitLocation;
		DamageScale = FMax( (1.0 - FMax((VSize(Dir) - Victim.CollisionRadius), 0.0) / DamageRadius), 0.0 );		
		Dir = Normal(Dir);
		// if Pawn
		if ( Pawn(Victim) != None )  {
			// Do not damage a friendly Pawn
			if ( !CanHurtPawn(Pawn(Victim)) )
				Continue;
			
			bIgnoreThisVictim = False;
			// Check CheckedPawns array
			for ( i = 0; i < CheckedPawns.Length; ++i )  {
				// comparison by object
				if ( CheckedPawns[i] == Victim )  {
					bIgnoreThisVictim = True;
					Break;
				}
			}
			// Ignore already Checked Pawns
			if ( bIgnoreThisVictim )
				Continue;
			
			CheckedPawns[CheckedPawns.Length] = Pawn(Victim);
			// Extended FastTraces from bones Locations
			if ( KFMonster(Victim) != None )
				DamageScale *= KFMonster(Victim).GetExposureTo(HitLocation);
			else if ( KFPawn(Victim) != None )
				DamageScale *= KFPawn(Victim).GetExposureTo(HitLocation);	
		}
		// Check for the blocking world geometry
		else if ( !FastTrace( Victim.Location, HitLocation ) )
			Continue;
		
		i = Round(DamageAmount * DamageScale);
		// not in the DamageRadius
		if ( i < 1 )
			Continue;
		
		if ( Instigator == None || Instigator.Controller == None )
			Victim.SetDelayedDamageInstigatorController( InstigatorController );
		// Damage Victim
		Victim.TakeDamage( i, Instigator, 
			(Victim.Location - (Victim.CollisionHeight + Victim.CollisionRadius) * 0.5 * Dir),
			(Momentum * DamageScale * Dir), DamageType );
		// Damage Vehicle Driver
		if ( Vehicle(Victim) != None && Vehicle(Victim).Health > 0 )
			Vehicle(Victim).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
			
		// Calculating number of Victim
		if ( Pawn(Victim) != None && Pawn(Victim).Health < 1 )
			++NumKilled;
	}
	
	if ( UM_BaseGameInfo(Level.Game) != None )
		UM_BaseGameInfo(Level.Game).CheckForDramaticKill( NumKilled );
	
	// Show Explosion to InstigatorController
	if ( NumKilled > 7 && UM_PlayerController(InstigatorController) != None )
		UM_PlayerController(InstigatorController).ShowActor( Self, 2.0 );
	
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
	local	rotator		SpawnRotation;
	local	Projectile	ShrapnelProj;
	local	Actor		SpawnBlocker;
	local	float		CollisionVSize;
	local	vector		THitLoc, THitNorm, CollisionExtent;
	
	if ( ShrapnelClass == None || ShrapnelAmount.Max < 1 )
		Return;
	
	CollisionExtent = ShrapnelClass.static.GetDefaultCollisionExtent();
	if ( CollisionExtent != vect(0, 0, 0) )
		CollisionVSize = FMax(VSize(ShrapnelClass.static.GetDefaultCollisionExtent()), 1.0);
	else
		CollisionVSize = 1.0;
	// Random ShrapnelAmount spawn
	if ( ShrapnelAmount.Max > 1 && ShrapnelAmount.Min < ShrapnelAmount.Max )
		i = Rand(ShrapnelAmount.Max - ShrapnelAmount.Min + 1);
	else
		i = 0;
	
	while ( i < ShrapnelAmount.Max )  {
		++i;
		SpawnRotation = RotRand(True);
		ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, SpawnRotation);
		if ( ShrapnelProj != None && !ShrapnelProj.bDeleteMe )
			Continue;
		// Can't spawn Shrapnel
		CollisionExtent = vector(SpawnRotation) * CollisionVSize;
		SpawnBlocker = Trace( THitLoc, THitNorm, (Location + CollisionExtent), (Location - CollisionExtent), False );
		// If something blocking shrapnel spawn location
		if ( SpawnBlocker != None )
			Spawn(ShrapnelClass, Instigator,, (THitLoc - THitNorm * CollisionVSize), SpawnRotation);
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
			ShakeScale = FClamp(((ShakeRadius - Dist) / DamageRadius), 0.005, MaxEpicenterShakeScale);
			PC.ShakeView(
				(ShakeRotMag * ShakeScale), ShakeRotRate, ShakeRotTime, 
				(ShakeOffsetMag * ShakeScale), ShakeOffsetRate, ShakeOffsetTime );
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

simulated function Explode( vector HitLocation, vector HitNormal )
{
	if ( bHasExploded || bDisintegrated )
		Return;
	
	bCanBeDamaged = False;
	bHidden = True;
	bHasExploded = True;
	StopProjectile();
	SetPhysics(PHYS_None);
	
	// Send update to the clients and destroy
	if ( Role == ROLE_Authority )  {
		bShouldExplode = True;
		if ( !bNetTemporary )
			NetUpdateTime = Level.TimeSeconds - 1.0;
		// BlowUp
		MakeNoise(1.0);
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	}
	
	SetCollision(False);
	// Explode effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExplosionSound.Snd != None )
			PlaySound(ExplosionSound.Snd, ExplosionSound.Slot, ExplosionSound.Vol, ExplosionSound.bNoOverride, ExplosionSound.Radius, BaseActor.static.GetRandPitch(ExplosionSound.PitchRange), ExplosionSound.bUse3D);
		// VFX
		if ( !Level.bDropDetail && EffectIsRelevant(Location, False) )  {
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, Rotator(-HitNormal));
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, Rotator(-HitNormal));
		}
	}
	
	// Shrapnel
	if ( Role == ROLE_Authority )
		SpawnShrapnel();
	
	// Shake nearby players screens
	ShakePlayersView();
	
	if ( Role == ROLE_Authority && !bNetTemporary )
		LifeSpan = 0.2; // Auto-Destroy on the server after 200 ms to replicate variables
	else
		Destroy(); // Destroy on the client-side immediately
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate( vector HitLocation, vector HitNormal )
{
	if ( bHasExploded || bDisintegrated )
		Return;
	
	bCanBeDamaged = False;
	bHidden = True;
	bDisintegrated = True;
	StopProjectile();
	SetPhysics(PHYS_None);
	
	// Send update to the clients and destroy
	if ( Role == ROLE_Authority )  {
		bShouldDisintegrate = True;
		if ( !bNetTemporary )
			NetUpdateTime = Level.TimeSeconds - 1.0;
		Damage *= DisintegrationDamageScale;
		MomentumTransfer *= DisintegrationDamageScale;
		// BlowUp
		MakeNoise(1.0);
		HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	}
	
	SetCollision(False);
	// Disintegrate effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( DisintegrationSound.Snd != None )
			PlaySound(DisintegrationSound.Snd, DisintegrationSound.Slot, DisintegrationSound.Vol, DisintegrationSound.bNoOverride, DisintegrationSound.Radius, BaseActor.static.GetRandPitch(DisintegrationSound.PitchRange), DisintegrationSound.bUse3D);
		// VFX
		if ( !Level.bDropDetail && DisintegrationVisualEffect != None && EffectIsRelevant(Location, False) )
			Spawn(DisintegrationVisualEffect,,, HitLocation, rotator(-HitNormal));
	}

	if ( Role == ROLE_Authority && !bNetTemporary )
		LifeSpan = 0.2; // Auto-Destroy on the server after 200 ms to replicate variables
	else
		Destroy(); // Destroy on the client-side immediately
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	local	int		i;
	
	if ( EventInstigator == None || Damage < 1 )
		Return;
	
	if ( Instigator == None || EventInstigator == Instigator || EventInstigator.GetTeamNum() != Instigator.GetTeamNum()
		 || (UM_GameReplicationInfo(Level.GRI) != None && UM_GameReplicationInfo(Level.GRI).FriendlyFireScale > 0.0) )  {
		// Disintegrate this Projectile instead of simple detonation
		for ( i = 0; i < DisintegrationDamageTypes.Length; ++i )  {
			if ( DamageType == DisintegrationDamageTypes[i] )  {
				if ( FRand() <= DisintegrationChance )
					Disintegrate(HitLocation, Vector(Rotation));
				
				Return;
			}
		}
		
		if ( IsArmed() )
			Explode(HitLocation, Vector(Rotation));
	}
}

simulated function ProcessTouchActor( Actor A )
{
	local	vector	TouchLocation, TouchNormal;
	
	LastTouched = A;
	if ( CanHurtActor(A) )  {
		GetTouchLocation(A, TouchLocation, TouchNormal);
		ProcessHitActor(A, TouchLocation, TouchNormal, ImpactDamage, ImpactMomentumTransfer, ImpactDamageType);
		if ( IsArmed() )
			Explode(TouchLocation, TouchNormal);
	}
	LastTouched = None;
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	if ( CanTouchActor(Wall) )  {
		HurtWall = Wall;
		ProcessTouchActor(Wall);
		Return;
	}
	
	if ( IsArmed() )
		Explode((Location + ExploWallOut * HitNormal), HitNormal);
	
	HurtWall = None;
}

simulated event Destroyed()
{
	if ( bShouldDisintegrate && !bDisintegrated )
		Disintegrate(Location, vector(Rotation));
	else if ( bShouldExplode && !bHasExploded )
		Explode(Location, vector(Rotation));
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
     bCanBeDamaged=True
	 bArmed=True
	 bCanHurtSameTypeProjectile=False
	 bCanHurtOwner=True
	 DisintegrationDamageScale=0.100000
	 TransientSoundVolume=2.000000
	 //Sounds
	 DisintegrationSound=(PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 ExplosionSound=(PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 //Shrapnel
	 ShrapnelAmount=(Min=5,Max=10)
	 // Explosion camera shakes
	 ShakeRadiusScale=2.250000
	 MaxEpicenterShakeScale=1.400000
	 ShakeRotMag=(X=650.000000,Y=650.000000,Z=650.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=325.000000,Y=325.000000,Z=325.000000)
     ShakeOffsetTime=3.500000
	 //Disintegration
	 DisintegrationChance=0.950000
	 DisintegrationDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrationDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrationDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
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
