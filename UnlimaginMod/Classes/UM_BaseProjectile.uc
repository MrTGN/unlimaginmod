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
	DependsOn(UM_BaseActor)
	Abstract;

//========================================================================
//[block] Variables

// Constants
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';
const	Maths = Class'UnlimaginMod.UnlimaginMaths';

// Metric System to Unreal Units (bUseMetricSystem)
// ProjectileMass in grams
// MuzzleVelocity in meter per second
// KineticEnergy in Joules
const	MeterInUU = 60.352;
const	SquareMeterInUU = 3642.363904;
const	EnergyConst = 2000.0; // (2.0 * 1000)

// United States customary system to Unreal Units (bUseUSCustomarySystem)
// ProjectileMass in grains
// MuzzleVelocity in feet per second
const	FootToMeter = 0.3048;
const	SquareFootToSquareMeter = 0.09290304;
const	GrainToGram = 0.06479891;
const	InchToMM = 25.4;
const	FootInUU = 18.4;
const	SquareFootInUU = 338.56;
const	USCEnergyConst = 450434.6; // (2 x 32.1739 x 7000)

// ImpactStrength * ProjectileCrossSectionalArea = KineticEnergy to penetrate this area
// if ImpactStrength < 6.2 standard 19x9mm bullet can penetrate this area
const	DefaultPawnHeadImpactStrength = 5.5;
const	DefaultPawnBodyImpactStrength = 7.5;

struct SurfaceImpactData
{
	var	float	ImpactStrength;			// J / mm2
	var	float	KineticEnergyToStuck;
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

var				bool		bUseMetricSystem; // If set to true will be used Metric System
var				bool		bUseUSCustomarySystem;
// Logging
var(Logging)	bool		bEnableLogging;
var				bool		bDefaultPropertiesCalculated;
var				bool		bAssetsLoaded;	// Prevents from calling PreloadAssets() on each spawn.
var				bool		bAutoLifeSpan;	// calculates Projectile LifeSpan automatically
var				bool		bCanHurtOwner;	// This projectile can hurt Owner
var				bool		bCanRicochet;	// This projectile can ricochet from the wall/floor
var				bool		bCanHurtSameTypeProjectile; // This projectile can hurt the same type projectile (projectile with the same class)

var	UM_BaseWeaponMuzzle		WeaponMuzzle;

var				int			InstigatorTeamNum;

//[block] Ballistic performance
var(Headshots)	class<DamageType>			HeadShotDamageType;	// Headshot damage type
var(Headshots)	float						HeadShotDamageMult;	// Headshot damage multiplier

var				SurfaceImpactData			ImpactSurfaces[20];

var				Vector						CollisionExtent;
var				float						CollisionExtentVSize;
var				float						SurfaceTraceRange;
var				float						LandedPrePivotCollisionScale;
// Projectile Expansion Coefficient.
// For FMJ bullets ExpansionCoefficient less then 1.01 (approximately 1.0)
// For JHP and HP bullets ExpansionCoefficient more then 1.4
var(Ballistic)	float						ExpansionCoefficient;
var(Ballistic)	float						ProjectileDiameter;		// Projectile diameter in mm
var				float						ProjectileCrossSectionalArea;	// Projectile cross-sectional area in mm2. Calculated automatically.

var(Ballistic)	float						EffectiveRange, MaxEffectiveRange;	// EffectiveRange and MaxEffectiveRange of this projectile in meters. 
var(Ballistic)	range						BallisticRandRange;	// Projectile ballistic performance randomization range
var(Ballistic)	float						MuzzleVelocity;	// Projectile muzzle velocity in m/s (bUseMetricSystem) or in feet per second (bUseUSCustomarySystem).
var(Ballistic)	float						ProjectileMass;	// Projectile mass in grams (bUseMetricSystem) or in grains (bUseUSCustomarySystem).

var				float						SpeedDropInWaterCoefficient;	// The projectile speed drop in the water
var				float						FullStopSpeedCoefficient;	// If Speed < (MaxSpeed * FullStopSpeedCoefficient) the projectile will fully stop moving
var				float						MinSpeed;					// If Speed < MinSpeed projectile will stop moving.

// This variables used to decrease the load on the CPU
var	transient	float						NextProjectileUpdateTime;
var				float						UpdateTimeDelay, InitialUpdateTimeDelay;

// Projectile kinetic energy in Joules. Used for penetrations and bounces calculation.
// KineticEnergy Calculates automatically before initial replication.
var				bool						bNoKineticEnergy;
var	transient	float						KineticEnergy;
var				float						SpeedSquaredToKineticEnergy;		// default.ProjectileMass / (EnergyConst * SquareMeterInUU)
var				float						KineticEnergyToSpeedSquared;		// (EnergyConst * SquareMeterInUU) / default.ProjectileMass

var				float						PenetrationBonus;
var				float						BounceBonus;
//[end]

//[block] Effects
var(Effects)	TrailData					Trail;
var	transient	bool						bTrailSpawned;

// HitEffects
var(Effects)	class<UM_BaseHitEffects>	HitEffectsClass;
var(Effects)	float						HitSoundVolume;	// Volume of Projectile hit sound. Every hit sounds already have their own volumes but you can change it by this var
var(Effects)	float						HitSoundRadius;	// This var allows you to set radius in which actors will hear hit sounds.
//[end]

var				float						WeaponRecoilScale;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication


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

simulated static final function vector GetDefaultCollisionExtent()
{
	if ( CollisionRadius > 0.0 || CollisionHeight > 0.0 )
		Return default.CollisionRadius * Vect(1.0, 1.0, 0.0) + default.CollisionHeight * Vect(0.0, 0.0, 1.0);
	
	Return Vect(0,0,0);
}

simulated static function CalcDefaultProperties()
{
	local	int		i;
	
	if ( default.ProjectileDiameter > 0.0 )  {
		if ( bUseUSCustomarySystem )
			default.ProjectileDiameter *= InchToMM;
		
		default.ProjectileCrossSectionalArea = Pi * Sqrt(default.ProjectileDiameter) / 4.0;
		// ImpactSurfaces
		for ( i = 0; i < ArrayCount(default.ImpactSurfaces); ++i )  {
			// Surfaces ImpactStrength for this projectile
			default.ImpactSurfaces[i].ImpactStrength *= default.ProjectileCrossSectionalArea;
			default.ImpactSurfaces[i].KineticEnergyToStuck = default.ImpactSurfaces[i].ImpactStrength * FMax((default.ProjectileDiameter / 2.0), 1.0);
		}
	}
	
	if ( default.bUseMetricSystem )  {
		// EffectiveRange
		if ( default.EffectiveRange > 0.0 )
			default.EffectiveRange = default.EffectiveRange * MeterInUU;
		// MaxEffectiveRange
		if ( default.MaxEffectiveRange > 0.0 )
			default.MaxEffectiveRange = default.MaxEffectiveRange * MeterInUU;
		// Speed
		if ( default.MuzzleVelocity > 0.0 )  {
			default.MaxSpeed = FMax(default.MuzzleVelocity, 1.0) * MeterInUU * default.BallisticRandRange.Max;
			default.Speed = FMax(default.MuzzleVelocity, 1.0) * MeterInUU;
		}
	}
	else if ( bUseUSCustomarySystem )  {
		// EffectiveRange
		if ( default.EffectiveRange > 0.0 )
			default.EffectiveRange = default.EffectiveRange / FootToMeter * MeterInUU;
		// MaxEffectiveRange
		if ( default.MaxEffectiveRange > 0.0 )
			default.MaxEffectiveRange = default.MaxEffectiveRange / FootToMeter * MeterInUU;
		// Speed
		if ( default.MuzzleVelocity > 0.0 )  {
			default.MaxSpeed = FMax(default.MuzzleVelocity, 1.0) / FootToMeter * MeterInUU  * default.BallisticRandRange.Max;
			default.Speed = FMax(default.MuzzleVelocity, 1.0) / FootToMeter * MeterInUU;
		}
	}
	
	if ( default.Speed > 0.0 )  {
		if ( default.MinSpeed <= 0.0 && default.FullStopSpeedCoefficient > 0.0 )
			default.MinSpeed = default.Speed * default.FullStopSpeedCoefficient;
		
		// Calculating LifeSpan
		if ( default.bAutoLifeSpan && default.MaxEffectiveRange > 0.0 )  {
			default.LifeSpan = default.MaxEffectiveRange / default.Speed;
			if ( default.bTrueBallistics )  {
				default.LifeSpan += 1.0 - FMin(default.BallisticCoefficient, 1.0);
				if ( default.bInitialAcceleration )
					default.LifeSpan += default.InitialAccelerationTime;
			}
		}
		
		// Calculating SpeedSquaredToKineticEnergy and KineticEnergyToSpeedSquared
		if ( default.ProjectileMass > 0.0 )  {
			if ( default.bUseMetricSystem )  {
				default.SpeedSquaredToKineticEnergy = default.ProjectileMass / (EnergyConst * SquareMeterInUU);
				default.KineticEnergyToSpeedSquared = (EnergyConst * SquareMeterInUU) / default.ProjectileMass;
			}
			else if ( bUseUSCustomarySystem )  {
				default.SpeedSquaredToKineticEnergy = (default.ProjectileMass * GrainToGram) / (EnergyConst * SquareMeterInUU);
				default.KineticEnergyToSpeedSquared = (EnergyConst * SquareMeterInUU) / (default.ProjectileMass * GrainToGram);
			}
		}
	}
	
	// CollisionExtent
	default.CollisionExtent = GetDefaultCollisionExtent();
	if ( default.CollisionExtent != vect(0,0,0) )  {
		default.CollisionExtentVSize = VSize(default.CollisionExtent);
		default.SurfaceTraceRange = default.CollisionExtentVSize + 16.0;
	}
	else  {
		default.CollisionExtentVSize = 0.0;
		default.SurfaceTraceRange = 16.0;
	}
	
	// Assign BCInverse of this Projectile
	if ( default.BCInverse <= 0.0 )
		default.BCInverse = 1.0 / default.BallisticCoefficient;
	
	default.bDefaultPropertiesCalculated = True;
}

simulated function ResetToDefaultProperties()
{
	local	int		i;
	
	ProjectileDiameter = default.ProjectileDiameter;
	ProjectileCrossSectionalArea = default.ProjectileCrossSectionalArea;
	// ImpactSurfaces
	for ( i = 0; i < ArrayCount(default.ImpactSurfaces); ++i )  {
		// Surfaces ImpactStrength for this projectile
		ImpactSurfaces[i].ImpactStrength = default.ImpactSurfaces[i].ImpactStrength;
		ImpactSurfaces[i].KineticEnergyToStuck = default.ImpactSurfaces[i].KineticEnergyToStuck;
	}
	// EffectiveRange
	EffectiveRange = default.EffectiveRange;
	// MaxEffectiveRange
	MaxEffectiveRange = default.MaxEffectiveRange;
	// Speed
	MaxSpeed = default.MaxSpeed;
	Speed = default.Speed;
	MinSpeed = default.MinSpeed;
	// LifeSpan
	if ( default.bAutoLifeSpan && default.MaxEffectiveRange > 0.0 )
		LifeSpan = default.LifeSpan;
	// SpeedSquaredToKineticEnergy and KineticEnergyToSpeedSquared
	SpeedSquaredToKineticEnergy = default.SpeedSquaredToKineticEnergy;
	KineticEnergyToSpeedSquared = default.KineticEnergyToSpeedSquared;
	// CollisionExtent
	CollisionExtent = default.CollisionExtent;
	CollisionExtentVSize = default.CollisionExtentVSize;
	SurfaceTraceRange = default.SurfaceTraceRange;
	// Assign BCInverse of this Projectile
	BCInverse = default.BCInverse;
}

// Updates InstigatorTeamNum
simulated function UpdateInstigatorTeamNum()
{
	if ( Instigator != None )
		InstigatorTeamNum = Instigator.GetTeamNum();
	else if ( InstigatorController != None )
		InstigatorTeamNum = InstigatorController.GetTeamNum();
}

// returns InstigatorTeamNum
simulated function int GetInstigatorTeamNum()
{
	Return InstigatorTeamNum;
}

// Veterancy Penetration and Bounce bonuses
simulated function UpdateBonuses()
{
	local	UM_PlayerReplicationInfo	PRI;
	local	int		i;
	
	if ( Instigator != None )
		PRI = UM_PlayerReplicationInfo(Instigator.PlayerReplicationInfo);
	else
		Log("Can't find Instigator in UpdateBonuses() function!", Name);
	
	// Bonuses
	if ( PRI != None )  {
		PenetrationBonus = default.PenetrationBonus * PRI.GetProjectilePenetrationBonus(Class) / ExpansionCoefficient;
		BounceBonus = default.BounceBonus * PRI.GetProjectileBounceBonus(Class) / ExpansionCoefficient;
	}
	else  {
		PenetrationBonus = default.PenetrationBonus / ExpansionCoefficient;
		BounceBonus = default.BounceBonus / ExpansionCoefficient;
	}
	
	if ( !bCanRicochet )
		Return;
	
	for ( i = 0; i < ArrayCount(default.ImpactSurfaces); ++i )  {
		ImpactSurfaces[i].FrictionCoefficient = FMin( (default.ImpactSurfaces[i].FrictionCoefficient * BounceBonus), 0.98 );
		ImpactSurfaces[i].PlasticityCoefficient = FMin( (default.ImpactSurfaces[i].PlasticityCoefficient * BounceBonus), 0.96 );
	}
}

// Set new Instigator
simulated function SetInstigator( Pawn NewInstigator )
{
	if ( Instigator != NewInstigator )
		Instigator = NewInstigator;
	
	// InstigatorController
	if ( Instigator != None )
		InstigatorController = Instigator.Controller;
	
	UpdateInstigatorTeamNum();
	UpdateBonuses();
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

simulated event PreBeginPlay()
{
	Super(Actor).PreBeginPlay();
	
	if ( !default.bDefaultPropertiesCalculated )  {
		CalcDefaultProperties();
		ResetToDefaultProperties();
	}

	/* Set Instigator on the Server.
		Instigator will be replicated from the server to the clients. */
	if ( Role == ROLE_Authority )  {
		//WeaponMuzzle = UM_BaseWeaponMuzzle(Owner);
		//if ( WeaponMuzzle != None && WeaponMuzzle.Instigator != None )
			//Instigator = WeaponMuzzle.Instigator;
		//else
		if ( Pawn(Owner) != None )
			SetInstigator( Pawn(Owner) );
		else
			SetInstigator( Instigator );
	}
		
	if ( !default.bAssetsLoaded )
		PreloadAssets(self);
	
	// Forcing to not call UpdateBallisticPerformance() at the InitialAccelerationTime
	if ( bInitialAcceleration )
		NextProjectileUpdateTime = Level.TimeSeconds + InitialAccelerationTime + InitialUpdateTimeDelay;
	else
		NextProjectileUpdateTime = Level.TimeSeconds + InitialUpdateTimeDelay;
}

//simulated function used to Spawn trails on client side
simulated function SpawnTrail()
{
	// Level.bDropDetail is True when frame rate is below DesiredFrameRate
	// DM_Low - is a low-detail Mode
	if ( Level.NetMode == NM_DedicatedServer || bTrailSpawned || Level.bDropDetail || PhysicsVolume.bWaterVolume )
		Return;
	
	bTrailSpawned = True;
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

simulated function DestroyTrail()
{
	if ( Level.NetMode == NM_DedicatedServer || !bTrailSpawned )
		Return;
	
	bTrailSpawned = False;
	// xEmitter
	if ( Trail.xEmitterEffect != None )  {
		Trail.xEmitterEffect.mRegen = False;
		Trail.xEmitterEffect.SetPhysics(PHYS_None);
	}
	// Emitter
	if ( Trail.EmitterEffect != None )
		Trail.EmitterEffect.Kill();
}

simulated function CheckDynamicLight()
{
	local	PlayerController	PC;
	// DynamicLight
	PC = Level.GetLocalPlayerController();
	if ( PC == None || PC.ViewTarget == None || Level.DetailMode == DM_Low
		 || VSizeSquared(PC.ViewTarget.Location - Location) > 16000000.0 )  {
		LightType = LT_None;
		bDynamicLight = False;
	}
}

// Use this function to init something on the server-side before InitialVelocity has set.
// It is a good place to assign replicated variables.
function ServerInitialUpdate();

// Called before initial replication
function ServerSetInitialVelocity()
{
	if ( default.Speed > 0.0 )  {
		// Velocity randomization
		Speed = default.Speed * Lerp( FRand(), BallisticRandRange.Min, BallisticRandRange.Max );
		// Calculating KineticEnergy before initial replication
		if ( default.ProjectileMass > 0.0 )
			KineticEnergy = Square(Speed) * SpeedSquaredToKineticEnergy;
		// Initial velocity
		Velocity = Vector(Rotation) * Speed;
	}
}

// Called after the actor is created but BEFORE any values have been replicated to it.
simulated event PostBeginPlay()
{
    if ( bDynamicLight && Level.NetMode != NM_DedicatedServer )
		CheckDynamicLight();
	
	if ( Role == ROLE_Authority )  {
		// ReceiveProjectileWarning
		if ( InstigatorController != None && InstigatorController.ShotTarget != None && InstigatorController.ShotTarget.Controller != None )
			InstigatorController.ShotTarget.Controller.ReceiveProjectileWarning( Self );
		// InitialUpdate on the server-side
		ServerInitialUpdate();
		// Setting Initial Velocity on the server before the initial replication
		ServerSetInitialVelocity();
	}
	bReadyToSplash = True;
}

// Called on the client-side when the initial replication is completed.
simulated function ClientPostInitialReplication()
{
	local	float	SpeedSquared;
	
	// Updating Bonuses on clients
	SetInstigator( Instigator );
	
	if ( default.Speed > 0.0 )  {
		// Initial Velocity replicated from the server
		if ( Velocity != vect(0, 0, 0) )  {
			if ( default.ProjectileMass > 0.0 )  {
				SpeedSquared = VSizeSquared(Velocity);
				KineticEnergy = SpeedSquared * SpeedSquaredToKineticEnergy;
				Speed = Sqrt(SpeedSquared);
			}
			else
				Speed = VSize(Velocity);
		}
		else
			SetNoKineticEnergy();
	}
}

/*	PostNetBeginPlay() is called directly after PostBeginPlay() on the server. 
	On clients it will be called when the initial replication is completed.	*/
simulated event PostNetBeginPlay()
{
	if ( Role < ROLE_Authority )
		ClientPostInitialReplication();
	
	if ( PhysicsVolume.bWaterVolume )
		GotoState('InTheWater');
	else
		SpawnTrail(); // Spawning the Trail
}

simulated static function float GetRange()
{
	if ( default.MaxEffectiveRange > 0.0 )
		Return default.MaxEffectiveRange;
	else if ( default.LifeSpan <= 0.0 || default.Speed <= 0.0 )
		Return 15000.0;
	else
		Return default.Speed * default.LifeSpan;
}

state InTheWater
{
	simulated event BeginState()
	{
		DestroyTrail();
		if ( Speed > 0.0 && SpeedDropInWaterCoefficient > 0.0 )  {
			Speed *= SpeedDropInWaterCoefficient;
			if ( Velocity != Vect(0,0,0) )
				Acceleration = -Normal(Velocity) * Speed;
		}
	}
	
	simulated event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		if ( Level.TimeSeconds > NextProjectileUpdateTime && Speed > 0.0 )  {
			UpdateBallisticPerformance();
			if ( Speed > MinSpeed )
				Return;
			
			Acceleration = Vect(0,0,0);
			if ( KineticEnergy > 0.0 )
				SetNoKineticEnergy();
			else  {
				Velocity = Vect(0,0,0);
				Speed = 0.0;
			}
		}
	}
	
	simulated event PhysicsVolumeChange( PhysicsVolume Volume )
	{
		if ( !Volume.bWaterVolume && PhysicsVolume.bWaterVolume )  {
			if ( Acceleration != Vect(0,0,0) )
				Acceleration = Vect(0,0,0);
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

simulated function StopProjectile()
{
	Speed = 0.0;
	KineticEnergy = 0.0;
	Velocity = Vect(0, 0, 0);
	Acceleration = Vect(0, 0, 0);
}

// Called when the projectile has lost all kinetic energy
simulated function SetNoKineticEnergy()
{
	bNoKineticEnergy = True;
	DestroyTrail();
	StopProjectile();
	SetPhysics(PHYS_Falling);
}

// Called when the projectile loses some kinetic energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	//Damage *= NewScale;
}

simulated function UpdateBallisticPerformance( optional bool bForceUpdate )
{
	local	float	LastSpeed, SpeedSquared;
	
	if ( !bForceUpdate && Level.TimeSeconds < NextProjectileUpdateTime )
		Return;
	
	NextProjectileUpdateTime = Level.TimeSeconds + UpdateTimeDelay;
	if ( KineticEnergy <= 0.0 )  {
		Speed = VSize(Velocity);
		Return;
	}
	
	// Performance update
	LastSpeed = Speed;
	SpeedSquared = VSizeSquared(Velocity);
	KineticEnergy = SpeedSquared * SpeedSquaredToKineticEnergy;
	Speed = Sqrt(SpeedSquared);
	ScaleProjectilePerformance(Speed / LastSpeed);
}

simulated function SubtractKineticEnergy( float SubtractedEnergy )
{
	local	float	ScalePerformance;
	
	if ( SubtractedEnergy <= 0.0 )
		Return;
	
	NextProjectileUpdateTime = Level.TimeSeconds + UpdateTimeDelay;
	if ( SubtractedEnergy >= KineticEnergy )  {
		SetNoKineticEnergy();
		Return;
	}
	
	// Performance update
	ScalePerformance = Speed;
	KineticEnergy -= SubtractedEnergy;
	Speed = Sqrt(KineticEnergy * KineticEnergyToSpeedSquared);
	ScalePerformance = Speed / ScalePerformance;
	Velocity *= ScalePerformance;
	ScaleProjectilePerformance(ScalePerformance);
}

simulated function SpawnHitEffects(
			vector			HitLocation, 
			vector			HitNormal, 
 optional	Actor			A )
{
	local	UM_BaseHitEffects	HitEffects;
	local	Pawn				P;
	
	if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail
		 && Level.DetailMode != DM_Low && HitEffectsClass != None )  {
		// Spawn
		if ( Class'UM_GlobalData'.default.ActorPool != None )
			HitEffects = UM_BaseHitEffects(Class'UM_GlobalData'.default.ActorPool.AllocateActor(HitEffectsClass, HitLocation, rotator(-HitNormal)));
		else
			HitEffects = Spawn(HitEffectsClass,,, HitLocation, rotator(-HitNormal));
		
		if ( HitEffects == None )
			Return;
		
		// Play Hit Effects
		if ( A != None )  {
			if ( UM_BallisticCollision(A) != None )
				P = Pawn(A.Base);
			else
				P = Pawn(A);
			// New HitSurfaceType for Pawn
			if ( P != None )  {
				if ( P.ShieldStrength > 0 )
					HitSurfaceType = EST_MetalArmor;
				else
					HitSurfaceType = EST_Flesh;
			}
		}
		HitEffects.PlayHitEffects(HitSurfaceType, HitSoundVolume, HitSoundRadius);
	}
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation) {}

simulated function ProcessTouch(Actor Other, Vector HitLocation) {}

// Can this projectile hurt specified BallisticCollision
simulated function bool	CanHurtBallisticCollision( UM_BallisticCollision BallisticCollision )
{
	// Return False if no BallisticCollision was specified
	if ( BallisticCollision == None || !BallisticCollision.CanBeDamaged() )
		Return False;
	
	// HurtOwner
	if ( (Instigator != None && BallisticCollision.Instigator == Instigator)
		 || (InstigatorController != None && BallisticCollision.InstigatorController == InstigatorController) )
		Return bCanHurtOwner;
	// FriendlyFire
	else if ( UM_GameReplicationInfo(Level.GRI) != None && BallisticCollision.InstigatorTeamNum == InstigatorTeamNum )
		Return UM_GameReplicationInfo(Level.GRI).FriendlyFireScale > 0.0;
	
	Return True;
}

// Can this projectile damage specified pawn
simulated function bool CanHurtPawn( Pawn P )
{
	// Return False if no Pawn was specified
	if ( P == None || P.Health < 1 )
		Return False;
	
	// HurtOwner
	if ( (Instigator != None && P == Instigator) 
		 || (InstigatorController != None && P.Controller == InstigatorController) )
		Return bCanHurtOwner;
	// FriendlyFire
	else if ( UM_GameReplicationInfo(Level.GRI) != None 
			 && P.GetTeamNum() == InstigatorTeamNum )
		Return UM_GameReplicationInfo(Level.GRI).FriendlyFireScale > 0.0;
	
	Return True;
}

// Can this projectile damage specified projectile
simulated function bool CanHurtProjectile( Projectile Proj )
{
	// Return False if no projectile was specified
	if ( Proj == None )
		Return False;
	
	// Same Projectile Type
	if ( Proj.Class == Class )
		Return bCanHurtSameTypeProjectile;
	// Same Owner
	else if ( (Instigator != None && Proj.Instigator == Instigator)
			 || (InstigatorController != None && Proj.InstigatorController == InstigatorController) )
		Return True;
	// FriendlyFire
	else if ( UM_GameReplicationInfo(Level.GRI) != None && UM_GameReplicationInfo(Level.GRI).FriendlyFireScale <= 0.0 )  {
		if ( UM_BaseProjectile(Proj) != None )
			Return UM_BaseProjectile(Proj).InstigatorTeamNum != InstigatorTeamNum;
		else if ( Proj.Instigator != None )
			Return Proj.Instigator.GetTeamNum() != InstigatorTeamNum;
		else if ( Proj.InstigatorController != None )
			Return Proj.InstigatorController.GetTeamNum() != InstigatorTeamNum;
	}
	
	Return True;
}

// Can this projectile damage specified Actor
simulated function bool CanHurtActor( Actor A )
{
	if ( A == None || !A.bCanBeDamaged || ROBulletWhipAttachment(A) != None )
		Return False;
	
	if ( Instigator != None && A.Base == Instigator )
		Return bCanHurtOwner;
	
	if ( UM_BallisticCollision(A) != None )
		Return CanHurtBallisticCollision( UM_BallisticCollision(A) );
	else if ( Pawn(A) != None )
		Return CanHurtPawn( Pawn(A) );
	else if ( Projectile(A) != None )
		Return CanHurtProjectile( Projectile(A) );
	
	Return True;
}

simulated function GetTouchLocation( Actor A, out vector TouchLocation, optional out vector TouchNormal )
{
	if ( Velocity == Vect(0,0,0) || A.TraceThisActor(TouchLocation, TouchNormal, (Location + Velocity), (Location - Velocity * 1.5), CollisionExtent) )  {
		//Log("Velocity="$Velocity @"Location="$Location @"TraceThisActor did't hit"@A.Name @A.Name@"Location="$A.Location, Name);
		TouchLocation = Location;
		//TouchNormal = Normal((TouchLocation - A.Location) cross Vect(0.0, 0.0, 1.0));
		TouchNormal = Normal(TouchLocation - A.Location);
	}
}

simulated function GetProjectileImpactParameters( 
	out			float				DamageAmount,
	out			float				MomentumAmount,
	out			class<DamageType>	DamageType
	optional	bool				bIsHeadShot	)
{
	// out DamageAmount
	if ( bIsHeadShot )
		DamageAmount = Damage * HeadShotDamageMult;
	else
		DamageAmount = Damage;
	
	// out MomentumAmount
	MomentumAmount = MomentumTransfer;
	
	// out DamageType
	if ( bIsHeadShot && HeadShotDamageType != None )
		DamageType = HeadShotDamageType;
	else
		DamageType = MyDamageType;
}

simulated function ProcessHitMonster( UM_BaseMonster Monster )
{
	local	UM_BallisticCollision	BC;
	local	Vector					HitLocation, HitNormal, VelNormal, TraceStart, TraceEnd;
	local	float					DamageAmount, MomentumAmount;
	local	class<DamageType>		DamageType;
	local	bool					bSpawnHitEffects;
	
	if ( Monster == None )
		Return;
	
	GetTouchLocation(Monster, TraceStart);
	VelNormal = Normal(Velocity);
	TraceEnd = VelNormal * (2.0 * Monster.CollisionHeight + 2.0 * Monster.CollisionRadius);
	Monster.TraceActors(class'UM_BallisticCollision', BC, HitLocation, HitNormal, TraceEnd, TraceStart, CollisionExtent)  {
		if ( BC == None || !BC.CanBeDamaged() || BC.Instigator != Monster )
			Continue;
		
		// HeadShot
		if ( UM_PawnHeadCollision(BC) != None )
			GetProjectileImpactParameters(DamageAmount, MomentumAmount, DamageType, True);
		else
			GetProjectileImpactParameters(DamageAmount, MomentumAmount, DamageType);
		
		if ( DamageType == None || DamageAmount < 0.5 )
			Break;
		
		if ( !bSpawnHitEffects )
			bSpawnHitEffects = Speed > MinSpeed;
		
		// Damage
		if ( Role == ROLE_Authority )  {
			if ( Instigator == None || Instigator.Controller == None )
				Monster.SetDelayedDamageInstigatorController( InstigatorController );
			// Hurt this actor
			Monster.TakeDamage(DamageAmount, Instigator, HitLocation, (MomentumAmount * VelNormal), DamageType);
			MakeNoise(1.0);
		}
		SubtractKineticEnergy(BC.ImpactStrength * ProjectileCrossSectionalArea / PenetrationBonus);
		
		if ( bNoKineticEnergy )
			Break;
	}
	
	if ( bSpawnHitEffects )
		SpawnHitEffects(HitLocation, HitNormal, Monster);
}

simulated function ProcessHitActor( Actor A )
{
	local	vector				HitLocation, HitNormal, VelNormal;
	local	float				SubtractedEnergy, DamageAmount, MomentumAmount;
	local	class<DamageType>	DamageType;

	VelNormal = Normal(Velocity);
	GetTouchLocation(A, HitLocation, HitNormal);
	// If projectile hit a Pawn
	if ( Pawn(A) != None )  {
		// HeadShot
		if ( Pawn(A).IsHeadShot(HitLocation, VelNormal, 1.0) )  {
			SubtractedEnergy = DefaultPawnHeadImpactStrength * ProjectileCrossSectionalArea / PenetrationBonus;
			GetProjectileImpactParameters(DamageAmount, MomentumAmount, DamageType, True);
		}
		else  {
			SubtractedEnergy = DefaultPawnBodyImpactStrength * ProjectileCrossSectionalArea / PenetrationBonus;
			GetProjectileImpactParameters(DamageAmount, MomentumAmount, DamageType);
		}
	}
	
	if ( DamageType == None || DamageAmount < 0.5 )
		Return;
	
	// Damage
	if ( Role == ROLE_Authority )  {
		if ( Instigator == None || Instigator.Controller == None )
			A.SetDelayedDamageInstigatorController( InstigatorController );
		// Hurt this actor
		A.TakeDamage(DamageAmount, Instigator, HitLocation, (MomentumAmount * VelNormal), DamageType);
		MakeNoise(1.0);
	}
	
	if ( Mover(A) != None )  {
		ProcessHitWall(HitNormal);
		Return;
	}
	
	if ( Speed > MinSpeed )
		SpawnHitEffects(HitLocation, HitNormal, A);
	
	if ( SubtractedEnergy > 0.0 )
		SubtractKineticEnergy(SubtractedEnergy);
}

simulated function bool CanTouchActor( Actor A )
{
	if ( A == None || A.bDeleteMe || A.bStatic || A.bWorldGeometry || !A.bBlockActors || !A.bProjTarget )
		Return False;
	
	Return LastTouched == None || (A != LastTouched && A.Base != LastTouched);
}

simulated function ProcessTouchActor( Actor A )
{
	LastTouched = A;
	if ( CanHurtActor(A) )  {
		// Updating Projectile Performance before hit the victim
		// Needed because Projectile can lose some Speed and Damage while flying
		UpdateBallisticPerformance();
		if ( Speed <= MinSpeed )
			SetNoKineticEnergy();
		else if ( UM_BaseMonster(A) != None )
			ProcessHitMonster( UM_BaseMonster(A) );
		else
			ProcessHitActor(A);
	}
	LastTouched = None;
}

// Called when the actor's collision hull is touching another actor's collision hull.
simulated singular event Touch( Actor Other )
{
	if ( CanTouchActor(Other) )
		ProcessTouchActor(Other);
}


simulated function ProcessHitWall( Vector HitNormal )
{
	local	Vector			VectVelDotNorm, TmpVect;
	local	Material		HitMat;
	local	int				Num;
	local	float			VelDotNorm;
	
	// Updating bullet performance before hit the wall
	// Needed because bullet lose Speed and Damage while flying
	UpdateBallisticPerformance();
	if ( Speed <= MinSpeed )  {
		SetNoKineticEnergy();
		Return;
	}
	else  {
		SpawnHitEffects(Location, HitNormal);
		if ( Role == ROLE_Authority )
			MakeNoise(0.3);
	}
	
	if ( !bCanRicochet )  {
		SetNoKineticEnergy();
		Return;
	}
	
	// Finding out surface material
	Trace(VectVelDotNorm, TmpVect, (Location + Normal(Velocity) * SurfaceTraceRange), Location, False, CollisionExtent, HitMat);
	if ( HitMat != None && int(HitMat.SurfaceType) < ArrayCount(ImpactSurfaces) )
		Num = int(HitMat.SurfaceType);
	else
		Num = 0;
	
	// Speed by HitNormal
	VelDotNorm = Velocity dot HitNormal;
	// Stuck
	if ( (Square(VelDotNorm) * SpeedSquaredToKineticEnergy) >= ImpactSurfaces[Num].KineticEnergyToStuck )  {
		SetNoKineticEnergy();
		Return;
	}
	
	// ricochet
	VectVelDotNorm = HitNormal * VelDotNorm;
	// Mirroring Velocity Vector by HitNormal with lossy
	Velocity = (Velocity - VectVelDotNorm) * ImpactSurfaces[Num].FrictionCoefficient - VectVelDotNorm * ImpactSurfaces[Num].PlasticityCoefficient;
	// Start Falling
	if ( Physics == PHYS_Projectile )
		SetPhysics(PHYS_Falling);
	// Decreasing performance
	UpdateBallisticPerformance(True);
	// Landed on the next colliding with ground
	if ( Speed <= MinSpeed )
		bBounce = False;
}

// Called when the actor can collide with world geometry and just hit a wall.
simulated singular event HitWall( vector HitNormal, Actor Wall )
{
	if ( CanTouchActor(Wall) )  {
		HurtWall = Wall;
		ProcessTouchActor(Wall);
	}
	else
		ProcessHitWall(HitNormal);
	HurtWall = None;
}

// Event Landed() called when the actor is no longer falling.
// If you want to receive HitWall() instead of Landed() when the actor has 
// finished falling set bBounce to True.
simulated event Landed( vector HitNormal )
{
	bOrientToVelocity = False;
	DestroyTrail();
	StopProjectile();
	PrePivot = CollisionExtent * LandedPrePivotCollisionScale;
	SetPhysics(PHYS_None);
}

simulated event EncroachedBy( Actor Other )
{
	if ( Other != None && (Other == Level || Other.bWorldGeometry) )
		SetNoKineticEnergy();
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
	 bUseMetricSystem=True
	 InstigatorTeamNum=255	// Default TeamNum
	 bCanHurtSameTypeProjectile=False
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
	 bCanHurtOwner=True
	 //Collision
	 CollisionRadius=0.0
     CollisionHeight=0.0
     bCollideActors=True
     bCollideWorld=True
	 bBlockActors=False
     bUseCylinderCollision=True
	 bSwitchToZeroCollision=True
	 bBlockZeroExtentTraces=True
     bBlockNonZeroExtentTraces=True
     bBlockHitPointTraces=False
	 // Do not use TrueBallistics by default
	 // Change it in the subclasses if you need TrueBallistics calculations
	 // TrueBallistics
	 bTrueBallistics=False
	 bInitialAcceleration=False
     BallisticCoefficient=0.3
	 SpeedFudgeScale=1.0
     MinFudgeScale=0.025
     InitialAccelerationTime=0.1
	 LandedPrePivotCollisionScale=0.25
	 //[block] Ballistic performance
	 HeadShotDamageMult=1.0
	 PenetrationBonus=1.0
	 BounceBonus=1.0
	 ExpansionCoefficient=1.0
	 SpeedDropInWaterCoefficient=0.85
	 FullStopSpeedCoefficient=0.1
	 Speed=0.0
	 MaxSpeed=0.0
	 ProjectileDiameter=10.0
	 //EffectiveRange in Meters
	 EffectiveRange=500.0
	 MaxEffectiveRange=500.0
	 //Visible Distance
	 CullDistance=4000.0
	 //Ballistic performance randomization percent
	 BallisticRandRange=(Min=0.98,Max=1.02)
	 //ProjectileMass
	 ProjectileMass=20.0	// grams
	 //MuzzleVelocity
     MuzzleVelocity=0.0	// m/sec
	 //UpdateTimeDelay - prevents from non-stopping (looping) updates
	 InitialUpdateTimeDelay=0.1
	 UpdateTimeDelay=0.1
	 ImpactSound=None
	 // AmbientSound Settings
	 SoundVolume=255
	 SoundPitch=64
     SoundRadius=250.0
	 //[end]
	 WeaponRecoilScale=1.0
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
	 bCanRicochet=False
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bIgnoreOutOfWorld=False	// Don't destroy if enters zone zero
	 bOrientToVelocity=False	// Orient in the direction of current velocity.
	 bOrientOnSlope=False	// when landing, orient base on slope of floor
	 Physics=PHYS_Projectile
	 //[end]
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=0.0
}
