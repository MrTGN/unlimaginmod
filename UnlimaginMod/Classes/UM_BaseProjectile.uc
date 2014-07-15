//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile
//	Parent class:	 Projectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.03.2013 21:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base Projectile class in UnlimaginMod
//================================================================================
class UM_BaseProjectile extends ROBallisticProjectile
	Abstract;


//========================================================================
//[block] Variables

// Constants
const	Maths = Class'UnlimaginMod.UnlimaginMaths';
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

// 1 meter = 60.352 Unreal Units in Killing Floor
// Info from http://forums.tripwireinteractive.com/showthread.php?t=1149 
const	MeterInUU = 60.352;
const	SquareMeterInUU = 3642.363904;

// From UT3
const	DegToRad = 0.017453292519943296;	// Pi / 180
const	RadToDeg = 57.295779513082321600;	// 180 / Pi
const	UnrRotToRad = 0.00009587379924285;	// Pi / 32768
const 	RadToUnrRot = 10430.3783504704527;	// 32768 / Pi
const 	DegToUnrRot = 182.0444;
const 	UnrRotToDeg = 0.00549316540360483;

const	EnergyToPenetratePawnHead = 400.0;
const	EnergyToPenetratePawnBody = 520.0;

// Read http://udn.epicgames.com/Two/SoundReference.html for more info
struct	SoundData
{
	var	string		Ref;
	var	sound		Snd;
	var	ESoundSlot	Slot;
	var	float		Vol;
	var	bool		bNoOverride;
	var	float		Radius;
	var	Range		PitchRange;	// Random pitching within range
	var	bool		bUse3D;	// Use (Ture) or not (False) 3D sound positioning in the world from the actor location
};

struct SurfaceTypeImpactData
{
	var	float	ImpactStrength;			// J / mm2
	var	float	ProjectileEnergyToStuck;
	var	float	FrictionCoefficient;	// Surface material friction coefficient. 1.0 - no friction. 0.0 - 100% friction.
	var	float	PlasticityCoefficient;	// Plasticity coefficient of the surface material. 1.0 - not plastic material. 0.0 - 100% plastic material.
};

// EmitterTrails for smoke trails and etc.
struct	TrailData
{
	// xEmitter
	var	Class< xEmitter >	xEmitterClass;
	var	xEmitter			xEmitterEffect;
	var	Rotator				xEmitterRotation;
	// Emitter
	var	Class< Emitter >	EmitterClass;
	var	Emitter				EmitterEffect;
	var	Rotator				EmitterRotation;
};

// Dynamic Loading vars
var				string		MeshRef, StaticMeshRef, AmbientSoundRef;

// Logging
var(Logging)	bool		bEnableLogging, bDefaultPropertiesCalculated;
var				bool		bAssetsLoaded;	// Prevents from calling PreloadAssets() on each spawn.
var				bool		bFriendlyFireIsAllowed;	// Friendly fire is allowed or not. Replicates from the server to the clients.
var				bool		bAutoLifeSpan;	// calculates Projectile LifeSpan automatically
var				bool		bCanHurtOwner;	// This projectile can hurt Owner
var				bool		bCanRebound;	// This projectile can bounce (ricochet) from the wall/floor

// Replication variables
var				Vector		SpawnLocation;	// The location where this projectile was spawned
var				bool		bReplicateSpawnLocation; // Storing and replicate projectile spawn location from server in SpawnLocation variable

var				float		SpawnTime;	// The time when this projectile was spawned
var				bool		bReplicateSpawnTime;	// Storing and replicate projectile spawn time from server in SpawnTime variable

//[block] Ballistic performance
var(Headshots)	class<DamageType>	HeadShotDamageType;	// Headshot damage type
var(Headshots)	float				HeadShotDamageMult;	// Headshot damage multiplier

var				SurfaceTypeImpactData		ImpactSurfaces[20];

var				float		SurfaceTraceRange;
var				Vector		CollisionExtent;
var				float		LandedPrePivotCollisionScale;
// Projectile Expansion Coefficient.
// For FMJ bullets ExpansionCoefficient less then 1.01 (approximately 1.0)
// For JHP and HP bullets ExpansionCoefficient more then 1.4
var(Ballistic)	float		ExpansionCoefficient;
var(Ballistic)	float		ProjectileDiameter;		// Projectile diameter in mm
var				float		ProjectileCrossSectionalArea;	// Projectile cross-sectional area in mm2. Calculated automatically.

var(Ballistic)	float		EffectiveRange, MaxEffectiveRange;	// EffectiveRange and MaxEffectiveRange of this projectile in meters. 
var(Ballistic)	range		BallisticRandRange;	// Projectile ballistic performance randomization range
var(Ballistic)	float		MuzzleVelocity;	// Projectile muzzle velocity in m/s.
var(Ballistic)	float		ProjectileMass;	// Projectile mass in kilograms.

var				float		SpeedDropInWaterCoefficient;	// The projectile speed drop in the water
var				float		FullStopSpeedCoefficient;	// If Speed < (MaxSpeed * FullStopSpeedCoefficient) the projectile will fully stop moving
var				float		MinSpeed;					// If Speed < MinSpeed projectile will stop moving.

// This variables used to decrease the load on the CPU
var				float		NextProjectileUpdateTime, UpdateTimeDelay, InitialUpdateTimeDelay;

// Projectile energy in Joules. Used for penetrations and bounces calculation.
// [!] Do not set/change default values of this variables!
// MuzzleEnergy and ProjectileEnergy Calculates automatically.
var				float		MuzzleEnergy, ProjectileEnergy;
var				float		SpeedSquaredToEnergy;		// ProjectileMass / (2.0 * SquareMeterInUU)
var				float		EnergyToSpeedSquared;		// (2.0 * SquareMeterInUU) / default.ProjectileMass

var				float		PenetrationBonus;
var				float		BounceBonus;
//[end]

//[block] Effects
var(Effects)	TrailData					Trail;
var				bool						bTrailSpawned;
var				bool						bTrailDestroyed;	// Trail have been destroyed.

// HitEffects
var(Effects)	class<UM_BaseHitEffects>	HitEffectsClass;
var(Effects)	float						HitSoundVolume;	// Volume of Projectile hit sound. Every hit sounds already have their own volumes but you can change it by this var
var(Effects)	float						HitSoundRadius;	// This var allows you to set radius in which actors will hear hit sounds.
//[end]

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
    reliable if ( Role == ROLE_Authority && bNetDirty )
		bFriendlyFireIsAllowed;
	
	reliable if ( bReplicateSpawnTime && Role == ROLE_Authority && bNetInitial )
		SpawnTime;
	
	reliable if ( bReplicateSpawnLocation && Role == ROLE_Authority && bNetInitial )
		SpawnLocation;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated function Reset()
{
	Super(Actor).Reset();
	SetPhysics(default.Physics);
	PreBeginPlay();
	PostBeginPlay();
}

// RandPitch
simulated final function float GetRandPitch( range PitchRange )
{
	if ( PitchRange.Min > 0.0 && PitchRange.Max > 0.0 )  {
		if ( PitchRange.Min != PitchRange.Max )
			Return PitchRange.Min + (PitchRange.Max - PitchRange.Min) * FRand();
		else
			Return PitchRange.Max;	// Just return Max Pitch
	}
	else
		Return 1.0;
}

simulated static final function Vector GetDefaultCollisionExtent()
{
	Return default.CollisionRadius * Vect(1.0, 1.0, 0.0) + default.CollisionHeight * Vect(0.0, 0.0, 1.0);
}

simulated final function float GetBallisticRandMult()
{
	Return BallisticRandRange.Min + (BallisticRandRange.Max - BallisticRandRange.Min) * FRand();
}

simulated function CalcDefaultProperties()
{
	local	int		i;
	
	if ( default.ProjectileDiameter > 0.0 )  {
		default.ProjectileCrossSectionalArea = Pi * default.ProjectileDiameter * default.ProjectileDiameter / 4.0;
		ProjectileCrossSectionalArea = default.ProjectileCrossSectionalArea;
		// ImpactSurfaces
		for ( i = 0; i < ArrayCount(ImpactSurfaces); ++i )  {
			// Surfaces ImpactStrength for this projectile
			default.ImpactSurfaces[i].ImpactStrength *= default.ProjectileCrossSectionalArea;
			ImpactSurfaces[i].ImpactStrength = default.ImpactSurfaces[i].ImpactStrength;
			// ProjectileEnergyToStuck
			default.ImpactSurfaces[i].ProjectileEnergyToStuck = default.ImpactSurfaces[i].ImpactStrength * FMax((default.ProjectileDiameter / 2.0), 1.0);
			ImpactSurfaces[i].ProjectileEnergyToStuck = default.ImpactSurfaces[i].ProjectileEnergyToStuck;
		}
	}
	
	// EffectiveRange
	if ( default.EffectiveRange > 0.0 )  {
		default.EffectiveRange = default.EffectiveRange * MeterInUU;
		EffectiveRange = default.EffectiveRange;
	}
	// MaxEffectiveRange
	if ( default.MaxEffectiveRange > 0.0 )  {
		default.MaxEffectiveRange = default.MaxEffectiveRange * MeterInUU;
		MaxEffectiveRange = default.MaxEffectiveRange;
	}
	
	// Speed
	if ( default.MuzzleVelocity > 0.0 )  {
		// Assign Speed defaults
		default.MaxSpeed = FMax(default.MuzzleVelocity, 5.00) * MeterInUU;
		MaxSpeed = default.MaxSpeed;
		default.Speed = default.MaxSpeed;
		Speed = default.MaxSpeed;
	}
	
	if ( default.MaxSpeed > 0.0 )  {
		if ( default.MinSpeed <= 0.0 )  {
			default.MinSpeed = default.MaxSpeed * FullStopSpeedCoefficient;
			MinSpeed = default.MinSpeed;
		}
		
		// Calculating LifeSpan
		if ( bAutoLifeSpan && default.MaxEffectiveRange > 0.0 )  {
			default.LifeSpan = default.MaxEffectiveRange / default.MaxSpeed;
			if ( default.bTrueBallistics )  {
				default.LifeSpan += 1.0 - FMin(default.BallisticCoefficient, 1.0);
				if ( default.bInitialAcceleration )
					default.LifeSpan += default.InitialAccelerationTime;
			}
			LifeSpan = default.LifeSpan;
		}
		
		// Calculating MuzzleEnergy and ProjectileEnergy
		// Divide on (2 * SquareMeterInUU) because we need to convert 
		// speed square from uu/sec to meter/sec
		if ( default.ProjectileMass > 0.0 )  {
			// SpeedSquaredToEnergy
			default.SpeedSquaredToEnergy = default.ProjectileMass / (2.0 * SquareMeterInUU);
			SpeedSquaredToEnergy = default.SpeedSquaredToEnergy;
			// EnergyToSpeedSquared
			default.EnergyToSpeedSquared = (2.0 * SquareMeterInUU) / default.ProjectileMass;
			EnergyToSpeedSquared = default.EnergyToSpeedSquared;
			// MuzzleEnergy
			default.MuzzleEnergy = default.MaxSpeed * default.MaxSpeed * default.SpeedSquaredToEnergy;
			MuzzleEnergy = default.MuzzleEnergy;
			// ProjectileEnergy
			default.ProjectileEnergy = default.MuzzleEnergy;
			ProjectileEnergy = default.MuzzleEnergy;
		}
	}
	
	// CollisionExtent
	default.CollisionExtent = GetDefaultCollisionExtent();
	CollisionExtent = default.CollisionExtent;
	// SurfaceTraceRange
	default.SurfaceTraceRange = VSize(default.CollisionExtent) + 16.0;
	SurfaceTraceRange = default.SurfaceTraceRange;
	
	// Logging
	/* if ( bEnableLogging )
	{
		log(self$": PreBeginPlay default.MaxEffectiveRange="$default.MaxEffectiveRange);
		log(self$": PreBeginPlay MaxEffectiveRange="$MaxEffectiveRange);
	} */
	
	// Assign BCInverse of this Projectile
	if ( default.BCInverse <= 0.0 )  {
		default.BCInverse = 1 / default.BallisticCoefficient;
		BCInverse = default.BCInverse;
	}
	
	default.bDefaultPropertiesCalculated = True;
}

// Veterancy Penetration and Bounce bonuses
simulated function UpdateBonuses()
{
	local	KFPlayerReplicationInfo		KFPRI;
	local	Class<UM_SRVeterancyTypes>	SRVT;
	
	KFPRI = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	if ( KFPRI != None )  {
		SRVT = Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill);
		if ( SRVT != None )  {
			PenetrationBonus *= SRVT.static.GetProjectilePenetrationBonus(KFPRI, Class) / ExpansionCoefficient;
			BounceBonus *= SRVT.static.GetProjectileBounceBonus(KFPRI, Class) / ExpansionCoefficient;
			Return;
		}
	}
	
	PenetrationBonus /= ExpansionCoefficient;
	BounceBonus /= ExpansionCoefficient;
}

simulated event PreBeginPlay()
{
	Super(Actor).PreBeginPlay();
	
	if ( !default.bDefaultPropertiesCalculated )
		CalcDefaultProperties();

	// Level.Game variable exists only on the server-side
	if ( Role == ROLE_Authority )
		bFriendlyFireIsAllowed = TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale > 0.0;
	
	if ( Pawn(Owner) != None )
        Instigator = Pawn(Owner);
	
	UpdateBonuses();
	
	// Forcing to not call UpdateProjectilePerformance() at the InitialAccelerationTime
	if ( bInitialAcceleration )
		NextProjectileUpdateTime = Level.TimeSeconds + InitialAccelerationTime + InitialUpdateTimeDelay;
	else
		NextProjectileUpdateTime = Level.TimeSeconds + InitialUpdateTimeDelay;
}

//[block] Dynamic Loading
simulated static function PreloadAssets( Projectile Proj )
{
	default.AmbientSound = BaseActor.static.LoadSound( default.AmbientSoundRef );
	
	if ( default.DrawType == DT_Mesh )  {
		if ( Proj != None )
			BaseActor.static.LoadActorMesh( default.MeshRef, Proj );
		else
			UpdateDefaultMesh( BaseActor.static.LoadMesh(default.MeshRef) );
	}
	else if ( default.DrawType == DT_StaticMesh )  {
		if ( Proj != None )
			BaseActor.static.LoadActorStaticMesh( default.StaticMeshRef, Proj );
		else
			UpdateDefaultStaticMesh( BaseActor.static.LoadStaticMesh(default.StaticMeshRef) );
	}
	
	if ( UM_BaseProjectile(Proj) != None )
			UM_BaseProjectile(Proj).AmbientSound = default.AmbientSound;
	
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	default.AmbientSound = None;
	
	if ( default.DrawType == DT_Mesh )
		UpdateDefaultMesh(None);
	else if ( default.DrawType == DT_StaticMesh )
		UpdateDefaultStaticMesh(None);
	
	default.bAssetsLoaded = False;
	
	Return True;
}
//[end]

//simulated function used to Spawn trails on client side
simulated function SpawnTrail()
{
	if ( !bTrailSpawned )  {
		bTrailSpawned = True;
		
		// Level.bDropDetail is true when frame rate is below DesiredFrameRate
		// DM_Low - is a low-detail Mode
		if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail
			 && Level.DetailMode != DM_Low && !PhysicsVolume.bWaterVolume )  {
			// xEmitter
			if ( Trail.xEmitterClass != None )  {
				Trail.xEmitterEffect = Spawn( Trail.xEmitterClass, Self );
				if ( Trail.xEmitterEffect != None )  {
					Trail.xEmitterEffect.Lifespan = Lifespan;
					// Rotation
					if ( Trail.xEmitterRotation != Rot(0, 0, 0) )
						Trail.xEmitterEffect.SetRelativeRotation( Trail.xEmitterRotation );
				}
			}
			// Emitter
			if ( Trail.EmitterClass != None )  {
				Trail.EmitterEffect = Spawn( Trail.EmitterClass, Self );
				if ( Trail.EmitterEffect != None )  {
					Trail.EmitterEffect.SetBase(Self);
					// Rotation
					if ( Trail.EmitterRotation != Rot(0, 0, 0) )
						Trail.EmitterEffect.SetRelativeRotation( Trail.EmitterRotation );
				}
			}
		}
		
		if ( bTrailDestroyed )
			bTrailDestroyed = False;
	}
}

simulated function DestroyTrail()
{
	if ( bTrailSpawned && !bTrailDestroyed )  {
		bTrailDestroyed = True;
		
		if ( Level.NetMode != NM_DedicatedServer )  {
			// xEmitter
			if ( Trail.xEmitterEffect != None )  {
				Trail.xEmitterEffect.mRegen = False;
				Trail.xEmitterEffect.SetPhysics(PHYS_None);
			}
			// Emitter
			if ( Trail.EmitterEffect != None )
				Trail.EmitterEffect.Kill();
		}
		
		bTrailSpawned = False;
	}
}

function ServerInitialUpdate()
{
	// Use this function to init something on the server-side before InitialVelocity has set.
	// It is a good place to assign replicated variables.
}

// Called before initial replication
function ServerSetInitialVelocity()
{
	// Little Velocity randomization
	if ( Speed > 0.0 )
		Velocity = Vector(Rotation) * Speed * GetBallisticRandMult();
}

// Called after the actor is created but BEFORE any values have been replicated to it.
simulated event PostBeginPlay()
{
	local	PlayerController	PC;
	
	if ( Role == ROLE_Authority )  {
		// SpawnTime
		if ( bReplicateSpawnTime )
			SpawnTime = Level.TimeSeconds;
		// SpawnLocation
		if ( bReplicateSpawnLocation )
			SpawnLocation = Location;
		// InstigatorController
		if ( Instigator != None && Instigator.Controller != None )  {
			if ( Instigator.Controller.ShotTarget != None && Instigator.Controller.ShotTarget.Controller != None )
				Instigator.Controller.ShotTarget.Controller.ReceiveProjectileWarning( Self );
			InstigatorController = Instigator.Controller;
		}
    }
	
	if ( !default.bAssetsLoaded )
		PreloadAssets(self);
	
	//[block] Copied from Projectile.uc
    // DynamicLight
    if ( bDynamicLight && Level.NetMode != NM_DedicatedServer )  {
		PC = Level.GetLocalPlayerController();
		if ( PC == None || PC.ViewTarget == None || VSizeSquared(PC.ViewTarget.Location - Location) > 16000000.0
			 || Level.DetailMode == DM_Low )  {
			LightType = LT_None;
			bDynamicLight = False;
		}
	}
	bReadyToSplash = True;
	//[end]
	if ( Role == ROLE_Authority )  {
		// InitialUpdate on the server-side
		ServerInitialUpdate();
		// Setting Initial Velocity on the server before the initial replication
		ServerSetInitialVelocity();
	}
	// Spawning the Trail
	SpawnTrail();
}

simulated event PostNetBeginPlay()
{
	if ( PhysicsVolume.bWaterVolume && !IsInState('InTheWater') )
		GotoState('InTheWater');
}

simulated static function float GetRange()
{
	if ( default.MaxEffectiveRange > 0.0 )
		Return default.MaxEffectiveRange;
	else if ( default.LifeSpan <= 0.0 || default.MaxSpeed <= 0.0 )
		Return 15000.0;
	else
		Return default.MaxSpeed * default.LifeSpan;
}

state InTheWater
{
	simulated event BeginState()
	{
		DestroyTrail();
		if ( Speed > 0.0 && SpeedDropInWaterCoefficient > 0.0 )  {
			Speed *= SpeedDropInWaterCoefficient;
			if ( Velocity != Vect(0.0,0.0,0.0) )
				Acceleration = -Normal(Velocity) * Speed;
		}
	}
	
	simulated event Tick( float DeltaTime )
	{
		if ( Level.TimeSeconds > NextProjectileUpdateTime
			 && (Velocity != Vect(0.0,0.0,0.0) || Acceleration != Vect(0.0,0.0,0.0)) )  {
			UpdateProjectilePerformance();			
			if ( Speed > 0.0 && Speed < MinSpeed )  {
				Acceleration = Vect(0.0,0.0,0.0);
				if ( ProjectileEnergy > 0.0 )
					ZeroProjectileEnergy();
				else  {
					Velocity = Vect(0.0,0.0,0.0);
					Speed = 0.0;
				}
			}
		}
	}
	
	simulated event PhysicsVolumeChange( PhysicsVolume Volume )
	{
		if ( !Volume.bWaterVolume && PhysicsVolume.bWaterVolume )  {
			if ( Acceleration != Vect(0.0,0.0,0.0) )
				Acceleration = Vect(0.0,0.0,0.0);
			SpawnTrail();
			GotoState('');
		}
	}
}

simulated event PhysicsVolumeChange( PhysicsVolume Volume )
{
	if ( Volume.bWaterVolume && !PhysicsVolume.bWaterVolume && !IsInState('InTheWater') )
		GotoState('InTheWater');
}

// Server only function because Level.Game variable exists only on the server-side
function bool CanHurtPawn( Pawn P )
{
	// Do not damage a friendly Pawn
	if ( P == None || (!bCanHurtOwner && P == Instigator) 
		 || (Instigator != None && P != Instigator && TeamGame(Level.Game) != None
			 && TeamGame(Level.Game).FriendlyFireScale <= 0.0 && P.GetTeamNum() == Instigator.GetTeamNum()) )
		Return False;
	
	Return True;
}

function HurtRadius( 
 float				DamageAmount, 
 float				DamageRadius,
 class<DamageType>	DamageType, 
 float				Momentum, 
 vector				HitLocation )
{}

function DelayedHurtRadius( 
 float				DamageAmount, 
 float				DamageRadius, 
 class<DamageType>	DamageType, 
 float				Momentum, 
 vector				HitLocation )
{}

function BlowUp(vector HitLocation) {}

simulated function Explode(vector HitLocation, vector HitNormal) {}

// Called when the projectile has lost all energy
simulated function ZeroProjectileEnergy()
{
	bBounce = False;
	Speed = 0.0;
	ProjectileEnergy = 0.0;
	Velocity = Vect(0.0, 0.0, 0.0);
	SetPhysics(PHYS_Falling);
}

// Called when the projectile loses some of it's energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	/* 
	Damage *= NewScale;
	*/
}

simulated function UpdateProjectilePerformance(
 optional	bool		bForceUpdate,
 optional	float		EnergyLoss )
{
	local	float	LastProjectileEnergy;
	
	if ( !bForceUpdate && Level.TimeSeconds < NextProjectileUpdateTime )
		Return;
		
	NextProjectileUpdateTime = Level.TimeSeconds + UpdateTimeDelay;
	// Performance update
	if ( ProjectileEnergy > 0.0 )  {
		LastProjectileEnergy = ProjectileEnergy;
		// Lose some energy
		if ( EnergyLoss > 0.0 )  {
			if ( EnergyLoss < ProjectileEnergy )  {
				ProjectileEnergy -= EnergyLoss;
				Speed = Sqrt(ProjectileEnergy * EnergyToSpeedSquared);
				Velocity = Speed * Normal(Velocity);
			}
			else
				ZeroProjectileEnergy();	// Lose all Energy
		}
		// Just update current projectile performance
		else  {
			Speed = VSize(Velocity);
			ProjectileEnergy = Speed * Speed * SpeedSquaredToEnergy;
		}
		ScaleProjectilePerformance(ProjectileEnergy / LastProjectileEnergy);
	}
	else
		Speed = VSize(Velocity);
}

simulated function SpawnHitEffects(
			vector			HitLocation, 
			vector			HitNormal, 
 optional	ESurfaceTypes	HitSurfaceType,
 optional	Actor			A )
{
	local	UM_BaseHitEffects	HitEffects;
	
	if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail
		 && Level.DetailMode != DM_Low && HitEffectsClass != None )  {
		// Spawn
		if ( Class'UM_AData'.default.ActorPool != None )
			HitEffects = UM_BaseHitEffects(Class'UM_AData'.default.ActorPool.AllocateActor(HitEffectsClass,HitLocation,rotator(-HitNormal)));
		else
			HitEffects = Spawn(HitEffectsClass,,, HitLocation, rotator(-HitNormal));
		// Play Hit Effects
		if ( HitEffects != None )  {
			if ( Pawn(A) != None && HitSurfaceType == EST_Default )  {
				if ( Pawn(A).ShieldStrength > 0 )
					HitSurfaceType = EST_MetalArmor;
				else
					HitSurfaceType = EST_Flesh;
			}
			HitEffects.PlayHitEffects(HitSurfaceType, HitSoundVolume, HitSoundRadius);
		}
	}
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation) {}

simulated function ProcessTouch(Actor Other, Vector HitLocation) {}

simulated function ProcessHitActor( 
	Actor				A, 
	Vector				HitLocation,
	Vector				HitNormal,
	float				DamageAmount, 
	float				MomentumAmount, 
	class<DamageType>	DmgType )
{
	local	Vector	VelNormal;
	local	float	EnergyLoss;
	local	Pawn	P;
	
	if ( DmgType == None || DamageAmount <= 0.0 )
		Return;
	
	// Updating Projectile Performance before hit the victim
	// Needed because Projectile can lose Speed and Damage while flying
	UpdateProjectilePerformance();
	VelNormal = Normal(Velocity);
	
	P = Pawn(A);
	// If projectile hit a Pawn
	if ( P != None )  {
		if ( P.IsHeadShot(HitLocation, VelNormal, 1.1) )  {
			DamageAmount *= HeadShotDamageMult;
			if ( HeadShotDamageType != None )
				DmgType = HeadShotDamageType;
			// HeadShot EnergyLoss
			if ( UM_Monster(P) != None )
				EnergyLoss = UM_Monster(P).GetPenetrationEnergyLoss(True) / PenetrationBonus;
			else
				EnergyLoss = EnergyToPenetratePawnHead / PenetrationBonus;
		}
		else if ( UM_Monster(P) != None )
			EnergyLoss = UM_Monster(P).GetPenetrationEnergyLoss(False) / PenetrationBonus;
		else
			EnergyLoss = EnergyToPenetratePawnBody / PenetrationBonus;
	}

	// Hit effects
	// Mover Hit effect will be spawned in the ProcessHitWall function
	if ( Mover(A) == None )
		SpawnHitEffects(HitLocation, HitNormal, ,A);
	
	// Damage
	if ( Role == ROLE_Authority )  {
		if ( Instigator == None || Instigator.Controller == None )
			A.SetDelayedDamageInstigatorController( InstigatorController );
		// Hurt this actor
		A.TakeDamage(DamageAmount, Instigator, HitLocation, (MomentumAmount * VelNormal), DmgType);
		MakeNoise(1.0);
	}
	
	// Updating Projectile
	if ( P != None )
		UpdateProjectilePerformance(True, EnergyLoss);
	else if ( Mover(A) != None )
		ProcessHitWall(HitNormal);
}

simulated function bool CanHitThisActor( Actor A )
{
	local	Pawn	P;

	if ( ROBulletWhipAttachment(A) != None )
		Return False;
	
	P = Pawn(A);
	if ( Instigator != None && (A == Instigator || A.Base == Instigator 
			|| (P != None && !bFriendlyFireIsAllowed && P.GetTeamNum() == Instigator.GetTeamNum())) )
		Return False;
	
	Return True;
}

simulated function bool CanTouchThisActor( out Actor A, out vector TouchLocation, optional out vector TouchNormal )
{
	if ( A != None && !A.bDeleteMe && !A.bStatic && !A.bWorldGeometry && (A.bProjTarget || A.bBlockActors) )  {
		if ( LastTouched != None && (A == LastTouched || A.Base == LastTouched) )
			Return False;
		
		if ( Pawn(A.Base) != None || Mover(A.Base) != None )
			A = A.Base;
		
		// If projectile is not moving or TraceThisActor did't hit the actor
		//if ( Velocity == Vect(0.0, 0.0, 0.0) || A.TraceThisActor(TouchLocation, TouchNormal, (Location + 0.5 * Velocity), (Location - 1.5 * Velocity), CollisionExtent) )  {
		if ( Velocity == Vect(0.0, 0.0, 0.0) || A.TraceThisActor(TouchLocation, TouchNormal, (Location + 0.35 * Velocity), (Location - 1.65 * Velocity), CollisionExtent) )  {
			//Log("Velocity="$Velocity @"Location="$Location @"TraceThisActor did't hit"@A.Name @A.Name@"Location="$A.Location, Name);
			TouchLocation = Location;
			TouchNormal = Normal((TouchLocation - A.Location) cross Vect(0.0, 0.0, 1.0));
		}
		
		Return True;
	}
	
	Return False;
}

simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
{
	LastTouched = A;
	if ( CanHitThisActor(A) )
		ProcessHitActor(A, TouchLocation, TouchNormal, Damage, MomentumTransfer, MyDamageType);
	
	LastTouched = None;
}

// Called when the actor's collision hull is touching another actor's collision hull.
simulated singular event Touch( Actor Other )
{
	local	Vector	TouchLocation, TouchNormal;

	if ( CanTouchThisActor(Other, TouchLocation, TouchNormal) )
		ProcessTouchActor(Other, TouchLocation, TouchNormal);
}


simulated function ProcessHitWall( Vector HitNormal )
{
	local	Vector			VectVelDotNorm, TmpVect;
	local	Material		HitMat;
	local	ESurfaceTypes	ST;
	local	float			f, EnergyByNormal;
	
	// Updating bullet performance before hit the wall
	// Needed because bullet lose Speed and Damage while flying
	UpdateProjectilePerformance();
	if ( Speed > MinSpeed )  {
		SpawnHitEffects(Location, HitNormal);
		if ( Role == ROLE_Authority )
			MakeNoise(0.3);
	}
	
	if ( bCanRebound )  {
		// Finding out surface material
		Trace(VectVelDotNorm, TmpVect, (Location + Normal(Velocity) * SurfaceTraceRange), Location, False, CollisionExtent, HitMat);
		if ( HitMat != None && ESurfaceTypes(HitMat.SurfaceType) < ArrayCount(ImpactSurfaces) )
			ST = ESurfaceTypes(HitMat.SurfaceType);
		else
			ST = EST_Default;
		// Speed by HitNormal
		f = Velocity Dot HitNormal;
		EnergyByNormal = f * f * SpeedSquaredToEnergy;
		// Stuck or Rebound
		if ( EnergyByNormal < ImpactSurfaces[ST].ProjectileEnergyToStuck )  {
			VectVelDotNorm = HitNormal * f;
			// Mirroring Velocity Vector by HitNormal with lossy
			Velocity = (Velocity - VectVelDotNorm) * FMin((ImpactSurfaces[ST].FrictionCoefficient * BounceBonus), 0.98) - VectVelDotNorm * FMin((ImpactSurfaces[ST].PlasticityCoefficient * BounceBonus), 0.96);
			// Start Falling
			if ( Physics == PHYS_Projectile )
				SetPhysics(PHYS_Falling);
			// Decreasing performance
			UpdateProjectilePerformance(True);
			// Landed on the next colliding with ground
			if ( Speed < MinSpeed )
				bBounce = False;
			
			Return;
		}
	}
	
	ZeroProjectileEnergy();
}

// Called when the actor can collide with world geometry and just hit a wall.
simulated singular event HitWall( Vector HitNormal, Actor Wall )
{
	local	Vector	HitLocation;

	if ( CanTouchThisActor(Wall, HitLocation) )  {
		HurtWall = Wall;
		ProcessTouchActor(Wall, HitLocation, HitNormal);
		Return;
	}
	
	ProcessHitWall(HitNormal);
	HurtWall = None;
}

// Event Landed() called when the actor is no longer falling.
// If you want to receive HitWall() instead of Landed() when the actor has 
// finished falling set bBounce to True.
simulated event Landed( Vector HitNormal )
{
	DestroyTrail();
	bOrientToVelocity = False;
	Velocity = Vect(0.0, 0.0, 0.0);
	Acceleration = Vect(0.0, 0.0, 0.0);
	PrePivot = CollisionExtent * LandedPrePivotCollisionScale;
	SetPhysics(PHYS_None);
}

simulated event EncroachedBy( Actor Other )
{
	if ( Other != None && (Other == Level || Other.bWorldGeometry) )
		ZeroProjectileEnergy();
}

simulated event Destroyed()
{
	DestroyTrail();
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // EST_Default
	 ImpactSurfaces(0)=(ImpactStrength=1.0,FrictionCoefficient=0.7,PlasticityCoefficient=0.5)
	 // EST_Rock
	 ImpactSurfaces(1)=(ImpactStrength=1.3,FrictionCoefficient=0.68,PlasticityCoefficient=0.6)
	 // EST_Dirt
	 ImpactSurfaces(2)=(ImpactStrength=0.01,FrictionCoefficient=0.52,PlasticityCoefficient=0.32)
	 // EST_Metal
	 ImpactSurfaces(3)=(ImpactStrength=0.8,FrictionCoefficient=0.74,PlasticityCoefficient=0.55)
	 // EST_Wood
	 ImpactSurfaces(4)=(ImpactStrength=0.08,FrictionCoefficient=0.61,PlasticityCoefficient=0.44)
	 // EST_Plant
	 ImpactSurfaces(5)=(ImpactStrength=0.001,FrictionCoefficient=0.54,PlasticityCoefficient=0.4)
	 // EST_Flesh
	 ImpactSurfaces(6)=(ImpactStrength=0.025,FrictionCoefficient=0.54,PlasticityCoefficient=0.39)
	 // EST_Ice
	 ImpactSurfaces(7)=(ImpactStrength=0.1,FrictionCoefficient=0.8,PlasticityCoefficient=0.55)
	 // EST_Snow
	 ImpactSurfaces(8)=(ImpactStrength=0.01,FrictionCoefficient=0.58,PlasticityCoefficient=0.4)
	 // EST_Water
	 ImpactSurfaces(9)=(ImpactStrength=0.005,FrictionCoefficient=0.7,PlasticityCoefficient=0.36)
	 // EST_Glass
	 ImpactSurfaces(10)=(ImpactStrength=0.5,FrictionCoefficient=0.74,PlasticityCoefficient=0.56)
	 // EST_Gravel
	 ImpactSurfaces(11)=(ImpactStrength=0.5,FrictionCoefficient=0.56,PlasticityCoefficient=0.43)
	 // EST_Concrete
	 ImpactSurfaces(12)=(ImpactStrength=1.0,FrictionCoefficient=0.65,PlasticityCoefficient=0.5)
	 // EST_HollowWood
	 ImpactSurfaces(13)=(ImpactStrength=0.07,FrictionCoefficient=0.6,PlasticityCoefficient=0.44)
	 // EST_Mud
	 ImpactSurfaces(14)=(ImpactStrength=0.001,FrictionCoefficient=0.5,PlasticityCoefficient=0.3)
	 // EST_MetalArmor
	 ImpactSurfaces(15)=(ImpactStrength=1.2,FrictionCoefficient=0.75,PlasticityCoefficient=0.6)
	 // EST_Paper
	 ImpactSurfaces(16)=(ImpactStrength=0.04,FrictionCoefficient=0.6,PlasticityCoefficient=0.44)
	 // EST_Cloth
	 ImpactSurfaces(17)=(ImpactStrength=0.005,FrictionCoefficient=0.55,PlasticityCoefficient=0.41)
	 // EST_Rubber
	 ImpactSurfaces(18)=(ImpactStrength=0.05,FrictionCoefficient=0.6,PlasticityCoefficient=0.5)
	 // EST_Poop
	 ImpactSurfaces(19)=(ImpactStrength=0.0005,FrictionCoefficient=0.5,PlasticityCoefficient=0.2)
	 // This projectile can take damage from something
	 bCanBeDamaged=False
	 bEnableLogging=False
	 bAutoLifeSpan=False
	 bReplicateSpawnTime=False
	 bReplicateSpawnLocation=False
	 bCanHurtOwner=True
	 // Do not use TrueBallistics by default
	 // Change it in the subclasses if you need TrueBallistics calculations
	 // TrueBallistics
	 bTrueBallistics=False
	 bInitialAcceleration=False
     BallisticCoefficient=0.300000
	 SpeedFudgeScale=1.000000
     MinFudgeScale=0.025000
     InitialAccelerationTime=0.100000
	 LandedPrePivotCollisionScale=0.25
	 //[block] Ballistic performance
	 PenetrationBonus=1.000000
	 BounceBonus=1.000000
	 ExpansionCoefficient=1.000000
	 SpeedDropInWaterCoefficient=0.850000
	 FullStopSpeedCoefficient=0.100000
	 Speed=0.000000
	 MaxSpeed=0.000000
	 ProjectileDiameter=10.0
	 //EffectiveRange in Meters
	 EffectiveRange=500.000000
	 MaxEffectiveRange=500.000000
	 //Visible Distance
	 CullDistance=4000.000000
	 //Ballistic performance randomization percent
	 BallisticRandRange=(Min=0.98,Max=1.02)
	 //ProjectileMass
	 ProjectileMass=0.020000	// kilograms
	 //MuzzleVelocity
     MuzzleVelocity=0.000000	// m/sec
	 //UpdateTimeDelay - prevents from non-stopping (looping) updates
	 InitialUpdateTimeDelay=0.100000
	 UpdateTimeDelay=0.100000
	 ImpactSound=None
	 //[end]
	 //[block] Replication
	 bNetTemporary=True
     bReplicateInstigator=True
     bNetInitialRotation=True
	 bGameRelevant=True
	 // bReplicateMovement need to be True by default to replicate Velocity, Location 
	 // and other movement variables of this projectile at spawn.
	 bReplicateMovement=True
	 // bUpdateSimulatedPosition need to be False by default.
	 // If it's True server will replicate Velocity, Location 
	 // and etc all of the life time of this projectile.
     bUpdateSimulatedPosition=False
	 //[end]
     //[block] Physics options.
	 bCanRebound=False
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=False
	 bIgnoreOutOfWorld=False	// Don't destroy if enters zone zero
	 bOrientToVelocity=False	// Orient in the direction of current velocity.
	 bOrientOnSlope=False	// when landing, orient base on slope of floor
	 Physics=PHYS_Projectile
	 //[end]
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=8.000000
}
