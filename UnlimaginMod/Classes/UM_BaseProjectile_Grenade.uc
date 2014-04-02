//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Grenade
//	Parent class:	 UM_BaseExplosiveProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 21:23
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_Grenade extends UM_BaseExplosiveProjectile
	Abstract;


//========================================================================
//[block] Variables

var		float		FlyingTime, TimeToStartFalling;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	// Synchronization between server and clients if network is not overloaded.
	unreliable if ( RemoteRole == ROLE_SimulatedProxy && bNetInitial )
		TimeToStartFalling;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	Super.CalcDefaultProperties();
	
	// FlyingTime
	if ( default.MaxSpeed > 0.0 && default.MaxEffectiveRange > 0.0 )  {
		default.FlyingTime = default.MaxEffectiveRange / default.MaxSpeed;
		if ( default.bInitialAcceleration )
			default.FlyingTime += default.InitialAccelerationTime;
		FlyingTime = default.FlyingTime;
	}
}

simulated function SetInitialVelocity()
{
	if ( FlyingTime > 0.0 )
		TimeToStartFalling = Level.TimeSeconds + FlyingTime;
	
	Super.SetInitialVelocity();
}

simulated event Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);

	if ( (Physics == default.Physics || Physics == PHYS_Falling)
		 && Level.TimeSeconds > NextProjectileUpdateTime
		 && Velocity != Vect(0.0, 0.0, 0.0) )  {
		// Updating Projectile
		UpdateProjectilePerformance();
		// Time to start falling
		if ( Physics == default.Physics && TimeToStartFalling > 0.0 
			 && Level.TimeSeconds >= TimeToStartFalling )
			SetPhysics(PHYS_Falling);
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 //Physics
	 Physics=PHYS_Projectile
	 UpdateTimeDelay=0.100000
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 //1 pound (lb) = 453.59237 g
	 //Mass=0.500000
	 //EffectiveRange in Meters
	 EffectiveRange=180.000000
	 MaxEffectiveRangeScale=1.250000
	 //TrueBallistics
	 bTrueBallistics=True
	 bInitialAcceleration=True
	 BallisticCoefficient=0.150000
	 SpeedFudgeScale=1.000000
     MinFudgeScale=0.025000
     InitialAccelerationTime=0.100000
	 //Trail
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_PanzerfaustTrail',EmitterRotation=(Pitch=32768))
	 //HitEffects
	 HitSoundVolume=1.250000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
}
