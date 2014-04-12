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
var				bool		bAutoLifeSpan;	// calculates Projectile LifeSpan automatically
var				bool		bCanHurtOwner;	// This projectile can hurt Owner
var				bool		bCanBounce;		// This projectile can bounce (ricochet) from the wall

// Replication variables
var				Vector		SpawnLocation;	// The location where this projectile was spawned
var				bool		bReplicateSpawnLocation; // Storing and replicate projectile spawn location from server in SpawnLocation variable

var				float		SpawnTime;	// The time when this projectile was spawned
var				bool		bReplicateSpawnTime;	// Storing and replicate projectile spawn time from server in SpawnTime variable

//[block] Ballistic performance
var(Headshots)	class<DamageType>	HeadShotDamageType;	// Headshot damage type
var(Headshots)	float				HeadShotDamageMult;	// Headshot damage multiplier

var				SurfaceTypeImpactData		ImpactSurfaces[20];

// Projectile Expansion Coefficient.
// For FMJ bullets ExpansionCoefficient less then 1.01 (approximately 1.0)
// For JHP and HP bullets ExpansionCoefficient more then 1.4
var(Ballistic)	float		ExpansionCoefficient;
var(Ballistic)	float		ProjectileDiameter;		// Projectile diameter in mm
var				float		ProjectileCrossSectionalArea;	// Projectile cross-sectional area in mm2. Calculated automatically.

// EffectiveRange - effective range of this projectile in meters. Will be converted to unreal units in PreBeginPlay()
// MaxEffectiveRangeScale - How much to scale MaxEffectiveRange from EffectiveRange
var(Ballistic)	float		EffectiveRange, MaxEffectiveRangeScale;
var				float		MaxEffectiveRange;	// Temporary variable. Used for calculations.

var(Ballistic)	float		BallisticRandPercent; // Percent of Projectile ballistic performance randomization
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
var				float		EnergyToSpeedSquared;		// 2.0 / (ProjectileMass * SquareMeterInUU)
var				bool		bHasLostAllEnergy;

// This var used for pawns, who don't have GetPenetrationEnergyLoss function
// The energy of the bullet will drop to value = MuzzleEnergy * PenetrationEnergyReduction
var(Ballistic)	float		PenetrationEnergyReduction;	// Standard penetration energy reduction (must be < 1.000000 )
var(Ballistic)	float		BounceEnergyReduction;	// Standard bounce energy reduction (must be < 1.000000 )
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
    reliable if ( bReplicateSpawnTime && Role == ROLE_Authority && bNetInitial )
		SpawnTime;
	
	reliable if ( bReplicateSpawnLocation && Role == ROLE_Authority && bNetInitial )
		SpawnLocation;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

//[block] Sound functions
// Play a sound effect from the SoundData struct with replication from the server to the clients.
final function ServerPlaySoundData( SoundData SD, optional float VolMult )
{
	// VolMult
	if ( VolMult > 0.0 )
		SD.Vol *= VolMult;
	// PitchRange
	if ( SD.PitchRange.Min > 0.0 && SD.PitchRange.Max > 0.0 )
		SD.PitchRange.Max = SD.PitchRange.Min + (SD.PitchRange.Max - SD.PitchRange.Min) * FRand();
	else
		SD.PitchRange.Max = 1.0;
	// PlaySound
	PlaySound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.PitchRange.Max, SD.bUse3D);
}

// Play a sound effect from the SoundData struct without server replication.
simulated final function ClientPlaySoundData( SoundData SD, optional float VolMult )
{
	// VolMult
	if ( VolMult > 0.0 )
		SD.Vol *= VolMult;
	// PitchRange
	if ( SD.PitchRange.Min > 0.0 && SD.PitchRange.Max > 0.0 )
		SD.PitchRange.Max = SD.PitchRange.Min + (SD.PitchRange.Max - SD.PitchRange.Min) * FRand();
	else
		SD.PitchRange.Max = 1.0;
	// PlaySound
	PlaySound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.PitchRange.Max, SD.bUse3D);
}

// play a sound effect, but don't propagate to a remote owner
// (he is playing the sound clientside)
simulated final function PlayOwnedSoundData( SoundData SD, optional float VolMult )
{
	// VolMult
	if ( VolMult > 0.0 )
		SD.Vol *= VolMult;
	// PitchRange
	if ( SD.PitchRange.Min > 0.0 && SD.PitchRange.Max > 0.0 )
		SD.PitchRange.Max = SD.PitchRange.Min + (SD.PitchRange.Max - SD.PitchRange.Min) * FRand();
	else
		SD.PitchRange.Max = 1.0;
	// PlayOwnedSound
	PlayOwnedSound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.PitchRange.Max, SD.bUse3D);
}
//[end]

simulated function Reset()
{
	Super(Actor).Reset();
	SetPhysics(default.Physics);
	PreBeginPlay();
	PostBeginPlay();
}

// Returns the random multiplier by percent of 1.0
// 50.0% RandRangePercent value will return random float value in the range from 0.75 up to 1.25
// Min RandRangePercent value: 2.0%
// Max RandRangePercent value: 198.0%
simulated final function float GetRandMultByPercent(float RandRangePercent)
{
	local	float	MinMult, MaxMult, RandMultiplier;
	
	RandRangePercent = FClamp( (RandRangePercent * 0.005), 0.01, 0.99 );
	MinMult = 1.0 - RandRangePercent;
	MaxMult = 1.0 + RandRangePercent;
	//Logic copied from RandRange() function
	RandMultiplier = MinMult + (MaxMult - MinMult) * FRand();
	
	Return RandMultiplier;
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
	
	// MaxEffectiveRange
	if ( default.MaxEffectiveRange <= 0.0 && default.EffectiveRange > 0.0 )  {
		default.MaxEffectiveRange = default.EffectiveRange * MeterInUU * MaxEffectiveRangeScale;
		MaxEffectiveRange = default.MaxEffectiveRange;  // Randoming MaxEffectiveRange for this Projectile
	}
	
	// Speed
	if ( (default.Speed <= 0.0 || default.MaxSpeed <= 0.0) && default.MuzzleVelocity > 0.0 )  {
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
			default.EnergyToSpeedSquared = 2.0 / (default.ProjectileMass * SquareMeterInUU);
			EnergyToSpeedSquared = default.EnergyToSpeedSquared;
			// MuzzleEnergy
			default.MuzzleEnergy = default.MaxSpeed * default.MaxSpeed * default.SpeedSquaredToEnergy;
			MuzzleEnergy = default.MuzzleEnergy;
			// ProjectileEnergy
			default.ProjectileEnergy = default.MuzzleEnergy;
			ProjectileEnergy = default.MuzzleEnergy;
		}
	}
	
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

simulated event PreBeginPlay()
{
	Super(Projectile).PreBeginPlay();
	
	if ( !default.bDefaultPropertiesCalculated )
		CalcDefaultProperties();

    // Prevents from touching owner at spawn
	LastTouched = Owner;
	
	if ( Pawn(Owner) != None )
        Instigator = Pawn(Owner);
	
	// Forcing to not call UpdateBulletPerformance() at the InitialAccelerationTime
	if ( bInitialAcceleration )
		NextProjectileUpdateTime = Level.TimeSeconds + InitialAccelerationTime + InitialUpdateTimeDelay;
	else
		NextProjectileUpdateTime = Level.TimeSeconds + InitialUpdateTimeDelay;
}

//[block] Dynamic Loading
simulated static function PreloadAssets(Projectile Proj)
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
		
		if ( Level.NetMode != NM_DedicatedServer && !PhysicsVolume.bWaterVolume )  {
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

simulated function SetInitialVelocity()
{
	// Assign Velocity
	if ( Speed > 0.0 )  {
		if ( PhysicsVolume.bWaterVolume && SpeedDropInWaterCoefficient > 0.0 )
			Speed *= SpeedDropInWaterCoefficient;
			
		Velocity = Speed * Vector(Rotation);
	}
}

// Called after the actor is created but BEFORE any values have been replicated to it.
simulated event PostBeginPlay()
{
	if ( bReplicateSpawnTime )
		SpawnTime = Level.TimeSeconds;
	
	if ( bReplicateSpawnLocation )
		SpawnLocation = Location;
	
	if ( !default.bAssetsLoaded )
		PreloadAssets(self);
	
	Super(Projectile).PostBeginPlay();
	
	// Assign Velocity
	SetInitialVelocity();
	// Spawning the Trail
	SpawnTrail();

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
		if ( Speed > 0.0 && Velocity != Vect(0.0,0.0,0.0) && SpeedDropInWaterCoefficient > 0.0 )
			Acceleration = Speed * SpeedDropInWaterCoefficient * -Normal(Velocity);
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


simulated function float GetBounceBonus()
{
	Return 1.0;
}

simulated function float GetPenetrationBonus()
{
	Return 1.0;
}

// Called when the projectile has lost all energy
simulated function ZeroProjectileEnergy()
{
	bHasLostAllEnergy = True;
	DestroyTrail();
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
	local	vector	VelNormal;
	local	float	LastProjectileEnergy;
	
	if ( !bForceUpdate && Level.TimeSeconds < NextProjectileUpdateTime )
		Return;
		
	NextProjectileUpdateTime = Level.TimeSeconds + UpdateTimeDelay;
	VelNormal = Normal(Velocity);
	// Rotation Update
	SetRotation(Rotator(VelNormal));
	// Performance update
	if ( ProjectileEnergy > 0.0 )  {
		LastProjectileEnergy = ProjectileEnergy;
		// Need to lose some energy
		if ( EnergyLoss > 0.0 )  {
			if ( EnergyLoss < ProjectileEnergy )  {
				ProjectileEnergy -= EnergyLoss;
				Speed = Sqrt(ProjectileEnergy * EnergyToSpeedSquared);
				Velocity = Speed * VelNormal;
			}
			// Lose all Energy
			else
				ZeroProjectileEnergy();
		}
		// Just update current projectile performance
		else  {
			Speed = VSize(Velocity);
			ProjectileEnergy = Speed * Speed * SpeedSquaredToEnergy;
		}
		// Stop the projectile if its Speed less than MinSpeed
		if ( !bHasLostAllEnergy && Speed < MinSpeed )
			ZeroProjectileEnergy();
		
		ScaleProjectilePerformance(ProjectileEnergy / LastProjectileEnergy);
	}
	else
		Speed = VSize(Velocity);
}

simulated function SpawnHitEffects(
			vector			HitLocation, 
			vector			HitNormal, 
 optional	ESurfaceTypes	HitSurfaceType, 
 optional	ESurfaceTypes	HitSoundSurfaceType, 
 optional	Actor			Victim, 
 optional	Sound			NewHitSound, 
 optional	float			NewHitSoundVolume, 
 optional	float			NewHitSoundRadius )
{
	local	UM_BaseHitEffects	HitEffects;
	local	float				Vol, Rad;
	
	if ( Level.NetMode != NM_DedicatedServer && !Level.bDropDetail && 
		 Level.DetailMode != DM_Low )  {
		if ( HitEffectsClass != None )  {
			if ( Class'UM_AData'.default.ActorPool != None )
				HitEffects = UM_BaseHitEffects(Class'UM_AData'.default.ActorPool.AllocateActor(HitEffectsClass,HitLocation,rotator(-HitNormal)));
			else
				HitEffects = Spawn(HitEffectsClass,,, HitLocation, rotator(-HitNormal));
		}
		
		if ( HitEffects != None )  {
			if ( NewHitSoundVolume > 0.0 )
				Vol = NewHitSoundVolume;
			else if ( HitSoundVolume > 0.0 )
				Vol = HitSoundVolume;
			
			if ( NewHitSoundRadius > 0.0 )
				Rad = NewHitSoundRadius;
			else if ( HitSoundRadius > 0.0 )
				Rad = HitSoundRadius;
			
			if ( Pawn(Victim) != None )  {
				if ( Pawn(Victim).ShieldStrength > 0 )
					HitEffects.PlayHitEffects(EST_MetalArmor, , Vol, Rad, NewHitSound);
				else
					HitEffects.PlayHitEffects(EST_Flesh, , Vol, Rad, NewHitSound);
			}
			else
				HitEffects.PlayHitEffects(HitSurfaceType, HitSoundSurfaceType, Vol, Rad, NewHitSound);
		}
	}
}

simulated function ClientSideTouch(Actor Other, Vector HitLocation) {}


simulated function Pawn CastTouchedActorToPawn( Actor A, optional bool bIgnoreWhipAttachment )
{
	// ROBulletWhipAttachment - Collision for projectiles whip sounds.
	// ExtendedZCollision is a Killing Floor hack for a large zombies.
	// This collisions is attached to Pawn owners.
	if ( (!bIgnoreWhipAttachment && ROBulletWhipAttachment(A) != None) || ExtendedZCollision(A) != None )
		Return Pawn(A.Owner);
	else if ( Pawn(A) != None )
		Return Pawn(A);
	else
		Return Pawn(A.Base);
}

simulated function bool CanHurtPawn( Pawn P )
{
	if ( P == None || Instigator != None && ((!bCanHurtOwner && (P == Instigator || P.Base == Instigator))
			|| (TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale <= 0.0 && Instigator.GetTeamNum() == P.GetTeamNum())) )
		Return False;
		
	Return True;
}

simulated function ProcessHitActor( 
			Actor				A, 
			vector				HitLocation, 
			float				DamageAmount, 
			float				MomentumAmount,
			class<DamageType>	DmgType, 
 optional	class<DamageType>	HeadShotDmgType )
{
	local	vector	VelNormal;
	local	float	EnergyLoss;
	local	Pawn	P;
	
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and Damage while flying
	UpdateProjectilePerformance();
	SpawnHitEffects(Location, Normal(HitLocation - A.Location), , , A);
	VelNormal = Normal(Velocity);
	
	P = CastTouchedActorToPawn(A);
	// If it is a Pawn actor
	if ( P != None )  {
		// Do not damage a friendly Pawn
		if ( !CanHurtPawn(P) )
			Return;
		
		if ( P.IsHeadShot(HitLocation, VelNormal, 1.0) )  {
			DamageAmount *= HeadShotDamageMult;
			if ( HeadShotDmgType != None )
				DmgType = HeadShotDmgType;
			// HeadShot EnergyLoss
			if ( UM_Monster(P) != None )
				EnergyLoss = UM_Monster(P).GetPenetrationEnergyLoss(True) * ExpansionCoefficient / GetPenetrationBonus();
			else
				EnergyLoss = EnergyToPenetratePawnHead * ExpansionCoefficient / GetPenetrationBonus();
		}
		else if ( UM_Monster(P) != None )
			EnergyLoss = UM_Monster(P).GetPenetrationEnergyLoss(False) * ExpansionCoefficient / GetPenetrationBonus();
		else
			EnergyLoss = EnergyToPenetratePawnBody * ExpansionCoefficient / GetPenetrationBonus();

		if ( Role == ROLE_Authority )  {
			if ( Instigator == None || Instigator.Controller == None )
				A.SetDelayedDamageInstigatorController( InstigatorController );
			// Hurt this actor
			P.TakeDamage(DamageAmount, Instigator, HitLocation, (MomentumAmount * VelNormal), DmgType);
			MakeNoise(1.0);
		}

		UpdateProjectilePerformance(True, EnergyLoss);
	}
	else if ( Role == ROLE_Authority )  {
		if ( Instigator == None || Instigator.Controller == None )
			A.SetDelayedDamageInstigatorController( InstigatorController );
		// Hurt this actor
		A.TakeDamage(DamageAmount, Instigator, HitLocation, (MomentumAmount * VelNormal), DmgType);
		MakeNoise(1.0);
	}
	
	// Decreasing performance
	if ( bTrueBallistics )
		BallisticCoefficient = FMax((BallisticCoefficient * 0.85), (default.BallisticCoefficient * 0.5));
}

simulated function bool CanTouchThisActor( Actor A, out vector TouchLocation, optional out vector TouchNormal )
{
	if ( A != None && !A.bDeleteMe && A != LastTouched && A.Base != LastTouched && !A.bStatic
		 && !A.bWorldGeometry && (A.bProjTarget || A.bBlockActors || A.bBlockHitPointTraces) )  {
		if ( Velocity == Vect(0.0, 0.0, 0.0) || A.IsA('Mover') 
			 || A.TraceThisActor(TouchLocation, TouchNormal, Location, (Location - 2 * Velocity), GetCollisionExtent()) )
			TouchLocation = Location;
		
		Return True;
	}
	
	Return False;
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	LastTouched = A;
	ProcessHitActor(Other, TouchLocation, Damage, MomentumTransfer, MyDamageType);
	LastTouched = None;
}

// Called when the actor's collision hull is touching another actor's collision hull.
simulated singular event Touch( Actor Other )
{
	local	Vector	TouchLocation;

	if ( CanTouchThisActor(Other, TouchLocation) )
		ProcessTouch(Other, TouchLocation);
}


simulated function ProcessHitWall( vector HitNormal )
{
	local	Vector			VectVelDotNorm, TmpVect;
	local	Material		HitMat;
	local	ESurfaceTypes	ST;
	local	float			f, EnergyByNormal;
	
	// Updating bullet performance before hit the wall
	// Needed because bullet lose Speed and Damage while flying
	UpdateProjectilePerformance();
	SpawnHitEffects(Location, HitNormal);
	if ( Role == ROLE_Authority )
		MakeNoise(0.3);
	
	if ( bCanBounce )  {
		// Finding out surface material
		Trace(VectVelDotNorm, TmpVect, (Location + Vector(Rotation) * 20), Location, false,, HitMat);
		if ( HitMat != None && ESurfaceTypes(HitMat.SurfaceType) < ArrayCount(ImpactSurfaces) )
			ST = ESurfaceTypes(HitMat.SurfaceType);
		else
			ST = EST_Default;
		
		// Speed by HitNormal
		f = Velocity Dot HitNormal;
		EnergyByNormal = f * f * SpeedSquaredToEnergy;
		VectVelDotNorm = HitNormal * f;
		
		if ( EnergyByNormal < ImpactSurfaces[ST].ProjectileEnergyToStuck )  {
			// Getting the bounce bonus
			if ( EnergyByNormal < ImpactSurfaces[ST].ImpactStrength )
				f = GetBounceBonus() / ExpansionCoefficient;
			// Projectile has entered into the surface but not stuck into it. Projectile should lose more speed.
			else
				f = GetBounceBonus() / ExpansionCoefficient * EnergyByNormal / ImpactSurfaces[ST].ProjectileEnergyToStuck;
			
			// Mirroring Velocity Vector by HitNormal with lossy
			Velocity -= VectVelDotNorm * FMin((ImpactSurfaces[ST].FrictionCoefficient * f), 0.99) + VectVelDotNorm * FMin((ImpactSurfaces[ST].PlasticityCoefficient * f), 0.98);
			UpdateProjectilePerformance(True);
			// Decreasing performance
			if ( bTrueBallistics )
				BallisticCoefficient = FMax((BallisticCoefficient * 0.8), (default.BallisticCoefficient * 0.5));
			
			Return;
		}
	}
	
	ZeroProjectileEnergy();
}

// Called when the actor can collide with world geometry and just hit a wall.
simulated singular event HitWall( vector HitNormal, actor Wall )
{
	local	Vector	HitLocation;

	if ( CanTouchThisActor(Wall, HitLocation) )
		ProcessTouch(Wall, HitLocation);
	
	ProcessHitWall(HitNormal);
	HurtWall = None;
}

// Event Landed() called when the actor is no longer falling.
// If you want to receive HitWall() instead of Landed() when the actor has 
// finished falling set bBounce to True.
simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
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
	 ImpactSurfaces(EST_Default)=(ImpactStrength=1.0,FrictionCoefficient=0.85,PlasticityCoefficient=0.7)
	 ImpactSurfaces(EST_Rock)=(ImpactStrength=1.3,FrictionCoefficient=0.8,PlasticityCoefficient=0.9)
	 ImpactSurfaces(EST_Dirt)=(ImpactStrength=0.01,FrictionCoefficient=0.65,PlasticityCoefficient=0.4)
	 ImpactSurfaces(EST_Metal)=(ImpactStrength=0.8,FrictionCoefficient=0.95,PlasticityCoefficient=0.8)
	 ImpactSurfaces(EST_Wood)=(ImpactStrength=0.08,FrictionCoefficient=0.8,PlasticityCoefficient=0.5)
	 ImpactSurfaces(EST_Plant)=(ImpactStrength=0.001,FrictionCoefficient=0.7,PlasticityCoefficient=0.3)
	 ImpactSurfaces(EST_Flesh)=(ImpactStrength=0.025,FrictionCoefficient=0.6,PlasticityCoefficient=0.4)
	 ImpactSurfaces(EST_Ice)=(ImpactStrength=0.1,FrictionCoefficient=0.98,PlasticityCoefficient=0.7)
	 ImpactSurfaces(EST_Snow)=(ImpactStrength=0.01,FrictionCoefficient=0.7,PlasticityCoefficient=0.4)
	 ImpactSurfaces(EST_Water)=(ImpactStrength=0.005,FrictionCoefficient=0.85,PlasticityCoefficient=0.3)
	 ImpactSurfaces(EST_Glass)=(ImpactStrength=0.5,FrictionCoefficient=0.9,PlasticityCoefficient=0.7)
	 ImpactSurfaces(EST_Gravel)=(ImpactStrength=0.5,FrictionCoefficient=0.7,PlasticityCoefficient=0.5)
	 ImpactSurfaces(EST_Concrete)=(ImpactStrength=1.0,FrictionCoefficient=0.85,PlasticityCoefficient=0.75)
	 ImpactSurfaces(EST_HollowWood)=(ImpactStrength=0.07,FrictionCoefficient=0.8,PlasticityCoefficient=0.5)
	 ImpactSurfaces(EST_Mud)=(ImpactStrength=0.001,FrictionCoefficient=0.7,PlasticityCoefficient=0.2)
	 ImpactSurfaces(EST_MetalArmor)=(ImpactStrength=1.2,FrictionCoefficient=0.9,PlasticityCoefficient=0.75)
	 ImpactSurfaces(EST_Paper)=(ImpactStrength=0.04,FrictionCoefficient=0.75,PlasticityCoefficient=0.5)
	 ImpactSurfaces(EST_Cloth)=(ImpactStrength=0.005,FrictionCoefficient=0.7,PlasticityCoefficient=0.4)
	 ImpactSurfaces(EST_Rubber)=(ImpactStrength=0.05,FrictionCoefficient=0.8,PlasticityCoefficient=0.6)
	 ImpactSurfaces(EST_Poop)=(ImpactStrength=0.0005,FrictionCoefficient=0.8,PlasticityCoefficient=0.1)
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
	 //[block] Ballistic performance
	 SpeedDropInWaterCoefficient=0.650000
	 FullStopSpeedCoefficient=0.085000
	 Speed=0.000000
	 MaxSpeed=0.000000
	 ProjectileDiameter=10.0
	 //EffectiveRange in Meters
	 EffectiveRange=500.000000
	 MaxEffectiveRangeScale=1.000000
	 //Visible Distance
	 CullDistance=4000.000000
	 //Ballistic performance randomization percent
	 BallisticRandPercent=2.000000
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
	 // bReplicateMovement need to be True by default to replicate Velocity, Location 
	 // and other movement variables of this projectile at spawn.
	 bReplicateMovement=True
	 // bUpdateSimulatedPosition need to be False by default.
	 // If it's True server will replicate Velocity, Location 
	 // and etc all of the life time of this projectile.
     bUpdateSimulatedPosition=False
	 //[end]
     //[block] Physics options.
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bOrientToVelocity=False	// Orient in the direction of current velocity.
	 bIgnoreOutOfWorld=False	// Don't destroy if enters zone zero
	 Physics=PHYS_Projectile
	 //[end]
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=8.000000
}
