//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Gas
//	Parent class:	 UM_BaseProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.06.2013 21:00
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_Gas extends UM_BaseProjectile
	Abstract;


//========================================================================
//[block] Variables

var		float			SpeedDropScale;		// Sets the speed drop per second by multiplying value on projectile speed
var		float			SpawnCheckRadiusScale;	// CheckRadius calculating by multiplying DamageRadius on GasCloudCheckRadiusScale

var		class<Emitter>	GasCloudEmitterClass;
var		Emitter			GasCloudEmitter;

var		bool			bStopped;	// This projectile has stopped
var		bool			bGasCloudSpawned;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bStopped;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated function SpawnTrail()
{
	if ( !bStopped )
		Super.SpawnTrail();
}

simulated function SpawnGasCloud()
{
	local	Emitter		GasCloud;
	
	bGasCloudSpawned = True;
	
	if ( Level.NetMode != NM_DedicatedServer && !PhysicsVolume.bWaterVolume
		 && GasCloudEmitterClass != None && GasCloudEmitter == None )  {
		foreach VisibleActors(Class'Emitter', GasCloud, (DamageRadius * SpawnCheckRadiusScale), Location)  {
			if ( GasCloud != None && GasCloud.Class == GasCloudEmitterClass )  {
				GasCloud.Reset();
				Break;
			}
			else
				GasCloud = None;
		}
		
		if ( GasCloud == None )
			GasCloudEmitter = Spawn(GasCloudEmitterClass, self);
	}
}

simulated function SetInitialVelocity()
{
	Super.SetInitialVelocity();
	
	if ( Speed > 0.0 && !bInitialAcceleration )  {
		default.bInitialAcceleration = True;
		bInitialAcceleration = default.bInitialAcceleration;
	}
	
	if ( Speed > 0.0 && Velocity != Vect(0.0,0.0,0.0) && SpeedDropScale > 0.0 )
		Acceleration = Speed * SpeedDropScale * -Normal(Velocity);
	else if ( !bGasCloudSpawned && (Velocity == Vect(0.0,0.0,0.0) || bStopped) )
		SpawnGasCloud();
}

simulated event PostNetReceive()
{
	if ( bStopped )  {
		if ( bTrailSpawned && !bTrailDestroyed )
			DestroyTrail();
		
		if ( !bGasCloudSpawned )
			SpawnGasCloud();
	}
}

simulated event Tick(float DeltaTime)
{
	if ( Level.TimeSeconds > NextProjectileUpdateTime && !bStopped 
		 && (Velocity != Vect(0.0,0.0,0.0) || Acceleration != Vect(0.0,0.0,0.0)) )  {
		UpdateProjectilePerformance();
		if ( Speed < MinSpeed )  {
			bStopped = True;
			Acceleration = Vect(0.0,0.0,0.0);
			Velocity = Vect(0.0,0.0,0.0);
			Speed = 0.0;
			SpawnGasCloud();
			DestroyTrail();
			SetPhysics(PHYS_None);
			
			if ( bCollideWorld )
				bCollideWorld = False;
		}
	}
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	if ( Other == None || Other == Instigator || Other.Base == Instigator 
		 || !Other.bBlockHitPointTraces )
		Return;
	
	if ( !bStopped 
		 && (Velocity != Vect(0.0,0.0,0.0) || Acceleration != Vect(0.0,0.0,0.0)) )  {
		UpdateProjectilePerformance();
		if ( Speed > 0.0 )  {
			bStopped = True;
			Acceleration = Vect(0.0,0.0,0.0);
			Velocity = Vect(0.0,0.0,0.0);
			Speed = 0.0;
			SpawnGasCloud();
			DestroyTrail();
			SetPhysics(PHYS_None);
			
			if ( bCollideWorld )
				bCollideWorld = False;
		}
	}
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	if ( !bStopped
		 && (Velocity != Vect(0.0,0.0,0.0) || Acceleration != Vect(0.0,0.0,0.0)) )  {
		UpdateProjectilePerformance();
		if ( Speed > 0.0 )  {
			bStopped = True;
			Acceleration = Vect(0.0,0.0,0.0);
			Velocity = Vect(0.0,0.0,0.0);
			Speed = 0.0;
			SpawnGasCloud();
			DestroyTrail();
			SetPhysics(PHYS_None);
			
			if ( bCollideWorld )
				bCollideWorld = False;
		}
	}
}

simulated event Landed( vector HitNormal )
{
	Acceleration = Vect(0.0,0.0,0.0);
	Velocity = Vect(0.0, 0.0, 0.0);
	SetPhysics(PHYS_None);
}

//[end] Functions
//====================================================================


defaultproperties
{
     SpawnCheckRadiusScale=0.200000
	 bCanRebound=False
	 bBounce=True
	 //Ballistic performance randomization percent
	 BallisticRandPercent=10.000000
	 bReplicateSpawnTime=True
	 ProjectileMass=0.000000
	 UpdateTimeDelay=0.100000
	 SpeedDropScale=0.750000
	 FullStopSpeedCoefficient=0.075000
	 Damage=15.000000
	 DamageRadius=120.000000
	 bNetTemporary=True
	 bNetNotify=True
}
