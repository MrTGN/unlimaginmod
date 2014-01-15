//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseProjectile
//	Parent class:	 Projectile
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 26.03.2013 21:19
//������������������������������������������������������������������������������
//	Comments:		 Base Projectile class in UnlimaginMod
//================================================================================
class UM_BaseProjectile extends ROBallisticProjectile
	Abstract;


//========================================================================
//[block] Variables

// Logging
var(Logging)	bool		bEnableLogging, bDefaultPropertiesCalculated;
var				bool		bAssetsLoaded;	// Prevents from calling PreloadAssets() on each spawn.
var				bool		bAutoLifeSpan;	// calculates Projectile LifeSpan automatically

// Replication variables
var				Vector		SpawnLocation;	// The location where this projectile was spawned
var				bool		bReplicateSpawnLocation; // Storing and replicate projectile spawn location from server in SpawnLocation variable

var				float		SpawnTime;	// The time when this projectile was spawned
var				bool		bReplicateSpawnTime;	// Storing and replicate projectile spawn time from server in SpawnTime variable

// Dynamic Loading vars
var				string		MeshRef, StaticMeshRef, AmbientSoundRef;

//[block] Ballistic performance

// EffectiveRange - effective range of this projectile in meters. Will be converted to unreal units in PreBeginPlay()
// MaxEffectiveRangeScale - How much to scale MaxEffectiveRange from EffectiveRange
var(Ballistic)	float		EffectiveRange, MaxEffectiveRangeScale;
var				float		MaxEffectiveRange;	// Temporary variable. Used for calculations.

var(Ballistic)	float		BallisticRandPercent; // Percent of Projectile ballistic performance randomization
var(Ballistic)	float		MuzzleVelocity;	// Projectile muzzle velocity in m/s.
var(Ballistic)	float		ProjectileMass;	// Projectile mass in kilograms.

var				float		SpeedDropInWaterCoefficient;	// The projectile speed reduction in the water
var				float		FullStopSpeedCoefficient;	// If Speed <= (MaxSpeed * FullStopSpeedCoefficient) the projectile will fully stop moving

// This variables used to decrease the load on the CPU
var				float		NextProjectileUpdateTime, UpdateTimeDelay, InitialUpdateTimeDelay;

// Projectile energy in Joules. Used for penetrations and bounces calculation.
// [!] Do not set/change this variables defaults value! 
// MuzzleEnergy and ProjectileEnergy Calculates automaticly in PreBeginPlay() function.
var				float		MuzzleEnergy, ProjectileEnergy;

// This var used for pawns, who don't have GetPenetrationEnergyLoss function
// The energy of the bullet will drop to value = MuzzleEnergy * PenitrationEnergyReduction
var(Ballistic)	float		PenitrationEnergyReduction;	// Standard penetration energy reduction (must be < 1.000000 )
var(Ballistic)	float		BounceEnergyReduction;	// Standard bounce energy reduction (must be < 1.000000 )

var				Class<UnlimaginMaths>	Maths;
//[end]

// Constants
// 1 meter = 60.352 Unreal Units in Killing Floor
// Info from http://forums.tripwireinteractive.com/showthread.php?t=1149 
const	MeterInUU = 60.352000;
const	SquareMeterInUU = 3642.363904;

// From UT3
const	DegToRad = 0.017453292519943296;	// Pi / 180
const	RadToDeg = 57.295779513082321600;	// 180 / Pi
const	UnrRotToRad = 0.00009587379924285;	// Pi / 32768
const 	RadToUnrRot = 10430.3783504704527;	// 32768 / Pi
const 	DegToUnrRot = 182.0444;
const 	UnrRotToDeg = 0.00549316540360483;

//[block] Effects
// xEmitterTrails
var(Effects)	array<xEmitter>				xEmitterTrails;
var(Effects)	array< class<xEmitter> >	xEmitterTrailClasses;

// EmitterTrails for smoke trails and etc.
struct	EmitterTrailData
{
	var	class<Emitter>	TrailClass;
	var	bool			bAttachTrail;
	var	Rotator			TrailRotation;
};
var(Effects)	array<EmitterTrailData>		EmitterTrailsInfo;

// Spawned emitters
var(Effects)	array<Emitter>				SpawnedEmitterTrails;

var				bool						bTrailsSpawned;
var				bool						bTrailsDestroyed;	//Trails has been destroyed.

// HitEffects
var(Effects)	class<UM_BaseHitEffects>	HitEffectsClass;
var(Effects)	float						HitSoundVolume;	// Volume of Projectile hit sound. Every hit sounds already have their own volumes but you can change it by this var
var(Effects)	float						HitSoundRadius;	// This var allows you to set radius in which actors will hear hit sounds.
//[end]

//var				float		RandMult;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
    reliable if ( bReplicateSpawnTime && Role == ROLE_Authority && bNetDirty && bNetInitial )
		SpawnTime;
	
	reliable if ( bReplicateSpawnLocation && Role == ROLE_Authority && bNetDirty && bNetInitial )
		SpawnLocation;
		
	/*
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		RandMult; */
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
	//[block] MaxEffectiveRange
	if ( default.MaxEffectiveRange <= 0.0 && default.EffectiveRange > 0.0 )  {
		default.MaxEffectiveRange = default.EffectiveRange * MeterInUU * MaxEffectiveRangeScale;
		MaxEffectiveRange = default.MaxEffectiveRange;  // Randoming MaxEffectiveRange for this Projectile
	}
	//[end]
	
	//[block] Speed
	if ( (default.Speed <= 0.0 || default.MaxSpeed <= 0.0) && default.MuzzleVelocity > 0.0 )  {
		// Assign Speed defaults
		default.MaxSpeed = FMax(default.MuzzleVelocity, 5.00) * MeterInUU;
		MaxSpeed = default.MaxSpeed;
		default.Speed = default.MaxSpeed;
		Speed = default.MaxSpeed;
	}
	//[end]
	
	//[block] LifeSpan
	// Calculating LifeSpan
	if ( bAutoLifeSpan && MaxEffectiveRange > 0.0 && MaxSpeed > 0.0 )  {
		if ( bTrueBallistics )  {
			if ( bInitialAcceleration )
				default.LifeSpan = (MaxEffectiveRange / MaxSpeed) + InitialAccelerationTime + (1.0 - FMin(BallisticCoefficient, 1.0));
			else
				default.LifeSpan = (MaxEffectiveRange / MaxSpeed) + (1.0 - FMin(BallisticCoefficient, 1.0));
		}
		else
			default.LifeSpan = MaxEffectiveRange / MaxSpeed;
		LifeSpan = default.LifeSpan;
	}
	//[end]
	
	// Calculating MuzzleEnergy and ProjectileEnergy
	// Divide on (2 * SquareMeterInUU) because we need to convert 
	// speed square from uu/sec to meter/sec
	if ( default.ProjectileMass > 0.0 && (default.MuzzleEnergy <= 0.0 || default.ProjectileEnergy <= 0.0)  )  {
		default.MuzzleEnergy = (default.ProjectileMass * Speed * Speed) / (2 * SquareMeterInUU);
		MuzzleEnergy = default.MuzzleEnergy;
		default.ProjectileEnergy = default.MuzzleEnergy;
		ProjectileEnergy = default.MuzzleEnergy;
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
	//[block] Loading Defaults
	if ( default.AmbientSoundRef != "" )
		default.AmbientSound = sound(DynamicLoadObject(default.AmbientSoundRef, class'Sound', true));
	
	if ( default.DrawType == DT_Mesh && default.MeshRef != "" )
		UpdateDefaultMesh(Mesh(DynamicLoadObject(default.MeshRef, class'Mesh', true)));
	else if ( default.DrawType == DT_StaticMesh && default.StaticMeshRef != "" )
		UpdateDefaultStaticMesh(StaticMesh(DynamicLoadObject(default.StaticMeshRef, class'StaticMesh', true)));
	//[end]
	
	if ( UM_BaseProjectile(Proj) != None )  {
		if ( default.DrawType == DT_Mesh && default.Mesh != None )
			Proj.LinkMesh(default.Mesh);
		else if ( default.DrawType == DT_StaticMesh && default.StaticMesh != None )
			Proj.SetStaticMesh(default.StaticMesh);
		
		if ( default.AmbientSound != None && UM_BaseProjectile(Proj).AmbientSound == None )
			UM_BaseProjectile(Proj).AmbientSound = default.AmbientSound;
	}
	default.bAssetsLoaded = True;
}

simulated static function bool UnloadAssets()
{
	if ( default.AmbientSound != None )
		default.AmbientSound = None;
	if ( default.DrawType == DT_Mesh && default.Mesh != None )
		UpdateDefaultMesh(None);
	else if ( default.DrawType == DT_StaticMesh && default.StaticMesh != None )
		UpdateDefaultStaticMesh(None);
	
	default.bAssetsLoaded = False;
	
	Return True;
}
//[end]

//simulated function used to Spawn trails on client side
simulated function SpawnTrails()
{
	local	int		i;
	
	if ( !bTrailsSpawned )  {
		bTrailsSpawned = True;
		
		if ( Level.NetMode != NM_DedicatedServer && !PhysicsVolume.bWaterVolume )  {
			for ( i = 0; i < xEmitterTrailClasses.Length; i++ )  {
				if ( xEmitterTrailClasses[i] != None )  {
					xEmitterTrails[i] = Spawn(xEmitterTrailClasses[i], self);
					if ( xEmitterTrails[i] != None )
						xEmitterTrails[i].Lifespan = Lifespan;
				}
			}
			
			for ( i = 0; i < EmitterTrailsInfo.Length; i++ )  {
				if ( EmitterTrailsInfo[i].TrailClass != None )  {
					SpawnedEmitterTrails[i] = Spawn(EmitterTrailsInfo[i].TrailClass,Self);
					if ( SpawnedEmitterTrails[i] != None )  {
						if ( EmitterTrailsInfo[i].bAttachTrail )
							SpawnedEmitterTrails[i].SetBase(self);
						
						if ( EmitterTrailsInfo[i].TrailRotation.Pitch > 0
							 || EmitterTrailsInfo[i].TrailRotation.Yaw > 0 
							 || EmitterTrailsInfo[i].TrailRotation.Roll > 0 )
							SpawnedEmitterTrails[i].SetRelativeRotation(EmitterTrailsInfo[i].TrailRotation);
					}
				}
			}
		}
		
		if ( bTrailsDestroyed )
			bTrailsDestroyed = False;
	}
}

simulated function DestroyTrails()
{
	local	int		i;
		
	if ( bTrailsSpawned && !bTrailsDestroyed )  {
		bTrailsDestroyed = True;
		
		if ( Level.NetMode != NM_DedicatedServer )  {
			while ( xEmitterTrails.Length > 0 )  {
				i = xEmitterTrails.Length - 1;
				if ( xEmitterTrails[i] != None )  {
					xEmitterTrails[i].mRegen = False;
					xEmitterTrails[i].SetPhysics(PHYS_None);
				}
				xEmitterTrails.Remove(i,1);
			}
		
			while ( SpawnedEmitterTrails.Length > 0 )  {
				i = SpawnedEmitterTrails.Length - 1;
				if ( SpawnedEmitterTrails[i] != None )  {
					if ( EmitterTrailsInfo[i].bAttachTrail )
						SpawnedEmitterTrails[i].SetBase(None);
					SpawnedEmitterTrails[i].Kill();
					SpawnedEmitterTrails[i].SetPhysics(PHYS_None);
				}
				SpawnedEmitterTrails.Remove(i,1);
			}
		}
		
		bTrailsSpawned = False;
	}
}

simulated function AdjustVelocity()
{
	// Assign Velocity
	if ( Speed > 0.0 )  {
		if ( PhysicsVolume.bWaterVolume && SpeedDropInWaterCoefficient > 0.0 )
			Speed *= SpeedDropInWaterCoefficient;
			
		Velocity = Speed * Vector(Rotation);
	}
}

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
	AdjustVelocity();
	// Spawning Trails
	SpawnTrails();

	if ( PhysicsVolume.bWaterVolume && !IsInState('InTheWater') )
		GotoState('InTheWater');
}

state InTheWater
{
	simulated event BeginState()
	{
		DestroyTrails();
		if ( Speed > 0.0 && Velocity != Vect(0.0,0.0,0.0) && SpeedDropInWaterCoefficient > 0.0 )
			Acceleration = Speed * SpeedDropInWaterCoefficient * -Normal(Velocity);
	}
	
	simulated event Tick( float DeltaTime )
	{
		if ( Level.TimeSeconds > NextProjectileUpdateTime &&
			 (Velocity != Vect(0.0,0.0,0.0) || Acceleration != Vect(0.0,0.0,0.0)) )
		{
			UpdateProjectilePerformance();			
			if ( Speed > 0.0 && Speed <= (MaxSpeed * FullStopSpeedCoefficient) )  {
				Acceleration = Vect(0.0,0.0,0.0);
				if ( ProjectileEnergy > 0.0 )
					ProjectileHasLostAllEnergy();
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
			SpawnTrails();
			GotoState('');
		}
	}
}

function HurtRadius( 
 float				DamageAmount, 
 float				DamageRadius,
 class<DamageType>	DamageType, 
 float				Momentum, 
 vector				HitLocation )
{ }

function DelayedHurtRadius( 
 float				DamageAmount, 
 float				DamageRadius, 
 class<DamageType>	DamageType, 
 float				Momentum, 
 vector				HitLocation )
{ }

// Calculates projectile bounce energy loss by applying bonuses
simulated function float CalcBounceBonus(float EnergyLoss)
{
	Return EnergyLoss;
}

// Calculates projectile penitration energy loss by applying bonuses
simulated function float CalcPenitrationBonus(float EnergyLoss)
{
	Return EnergyLoss;
}

// Called when the projectile has lost all energy
simulated function ProjectileHasLostAllEnergy()
{
	Velocity = Vect(0.0, 0.0, 0.0);
	SetPhysics(PHYS_Falling);
	Speed = 0.0;
	ProjectileEnergy = 0.0;
	DestroyTrails();
}

// Called when the projectile loses some of it's energy
simulated function ChangeOtherProjectilePerformance(float NewScale)
{
	/* 
	Damage *= NewScale;
	*/
}

simulated function UpdateProjectilePerformance(
 optional	float		EnergyLoss, 
 optional	Actor		Victim,
 optional	Vector		NewVelocity)
{
	local	float	PrevProjectileEnergy;
	local	float	NewEnergyLoss;
	
	NextProjectileUpdateTime = Level.TimeSeconds + UpdateTimeDelay;
	if ( NewVelocity != Vect(0.0,0.0,0.0) )
		SetRotation(Rotator(Normal(NewVelocity)));
	else
		SetRotation(Rotator(Normal(Velocity)));
	
	if ( ProjectileEnergy > 0.0 )  {
		PrevProjectileEnergy = ProjectileEnergy;
		if ( EnergyLoss > 0.0 || Victim != None )  {
			if ( EnergyLoss > 0.0 && Victim == None )
				NewEnergyLoss = CalcBounceBonus(EnergyLoss);
			else if ( EnergyLoss > 0.0 && Pawn(Victim) != None )
				NewEnergyLoss = CalcPenitrationBonus(EnergyLoss);
			else if ( Pawn(Victim) != None )
				NewEnergyLoss = CalcPenitrationBonus(MuzzleEnergy * (1.0 - PenitrationEnergyReduction));
			else
				NewEnergyLoss = CalcBounceBonus(MuzzleEnergy * (1.0 - BounceEnergyReduction));
				
			if ( NewEnergyLoss >= ProjectileEnergy )
				ProjectileHasLostAllEnergy();
			else  {
				ProjectileEnergy -= NewEnergyLoss;
				Speed = Sqrt(ProjectileEnergy * 2 / ProjectileMass) * MeterInUU;
				Velocity = Speed * Vector(Rotation);
				ChangeOtherProjectilePerformance(ProjectileEnergy / PrevProjectileEnergy);
			}
		}
		else  {
			if ( NewVelocity != Vect(0.0,0.0,0.0) )
				Velocity = NewVelocity;
			Speed = VSize(Velocity);
			// Divide on (2 * SquareMeterInUU) because we need to convert 
			// speed square from uu/sec to meter/sec
			ProjectileEnergy = (ProjectileMass * Speed * Speed) / (2 * SquareMeterInUU);
			ChangeOtherProjectilePerformance(ProjectileEnergy / PrevProjectileEnergy);
		}
	}
	else  {
		if ( NewVelocity != Vect(0.0,0.0,0.0) )
			Velocity = NewVelocity;
		Speed = VSize(Velocity);
	}
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

simulated event PhysicsVolumeChange( PhysicsVolume Volume )
{
	if ( Volume.bWaterVolume && !PhysicsVolume.bWaterVolume && !IsInState('InTheWater') )
		GotoState('InTheWater');
}

function BlowUp(vector HitLocation){}

simulated function Explode(vector HitLocation, vector HitNormal){}

simulated event Destroyed()
{
	DestroyTrails();
	Super.Destroyed();
}

simulated static function float GetRange()
{
	if ( default.MaxEffectiveRange > 0.0 )
		Return default.MaxEffectiveRange;
	else if ( default.LifeSpan == 0.0 || default.MaxSpeed == 0.0 )
		Return 15000;
	else
		Return default.MaxSpeed * default.LifeSpan;
}

//[end] Functions
//====================================================================

defaultproperties
{
	 Maths=Class'UnlimaginMod.UnlimaginMaths'
	 // This projectile can take damage from something
	 bCanBeDamaged=True
	 // bReplicateMovement need to be True by default to replicate Velocity, Location 
	 // and other movement variables of this projectile at spawn.
	 bReplicateMovement=True
	 // bUpdateSimulatedPosition need to be False by default.
	 // If it's True server will replicate Velocity, Location 
	 // and etc all of the life time of this projectile.
     bUpdateSimulatedPosition=False
	 // bEnableLogging. I'm using logging for the simple debug =)
	 bEnableLogging=False
	 bAutoLifeSpan=False
	 bReplicateSpawnTime=False
	 bReplicateSpawnLocation=False
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
	 //[end]
	 //Replication
	 bNetTemporary=True
     bReplicateInstigator=True
     bNetInitialRotation=True
     //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=8.000000
}