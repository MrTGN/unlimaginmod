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

var		bool			bShouldStop, bHasStopped;	// This projectile has stopped
var		bool			bGasCloudSpawned;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bShouldStop;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated function SpawnTrail()
{
	if ( !bShouldStop )
		Super.SpawnTrail();
}

simulated function SpawnGasCloud()
{
	local	Emitter		GasCloud;
	
	if ( bGasCloudSpawned )
		Return;
	
	bGasCloudSpawned = True;
	if ( Level.NetMode == NM_DedicatedServer || PhysicsVolume.bWaterVolume || GasCloudEmitterClass == None )
		Return;
	
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

simulated function StopProjectile()
{
	bHasStopped = True;
	bShouldStop = True;
	Velocity = Vect(0, 0, 0);
	Acceleration = Vect(0, 0, 0);
	Speed = 0.0;
	DestroyTrail();
	SpawnGasCloud();
	SetPhysics(PHYS_None);
	bCollideWorld = False;
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( bShouldStop && !bHasStopped )
		StopProjectile();
	else if ( Velocity != Vect(0,0,0) && SpeedDropScale > 0.0 )
		Acceleration = -Velocity * SpeedDropScale;
}

simulated event Tick(float DeltaTime)
{
	if ( Level.TimeSeconds > NextProjectileUpdateTime && !bHasStopped )  {
		UpdateBallisticPerformance();
		if ( Speed <= MinSpeed )
			StopProjectile();
	}
}

simulated function ProcessTouchActor( Actor A )
{
	LastTouched = A;
	if ( !bHasStopped )  {
		UpdateBallisticPerformance(True);
		if ( Speed > 0.0 )
			StopProjectile();
	}
	LastTouched = None;
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	if ( !bHasStopped )  {
		UpdateBallisticPerformance(True);
		if ( Speed > 0.0 )
			StopProjectile();
	}
}

simulated event Landed( vector HitNormal )
{
	if ( !bHasStopped )  {
		UpdateBallisticPerformance(True);
		if ( Speed > 0.0 )
			StopProjectile();
	}
}

//[end] Functions
//====================================================================


defaultproperties
{
     MomentumTransfer=0.0
	 SpawnCheckRadiusScale=0.2
	 bCanRicochet=False
	 bOrientToVelocity=True
	 //Ballistic performance randomization
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 ProjectileMass=0.0
	 UpdateTimeDelay=0.100000
	 SpeedDropScale=0.750000
	 FullStopSpeedCoefficient=0.075000
	 Damage=15.000000
	 DamageRadius=120.000000
	 bNetTemporary=True
	 bNetNotify=True
}
