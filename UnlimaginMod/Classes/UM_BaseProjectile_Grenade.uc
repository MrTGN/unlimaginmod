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

// This variables used to decrease the load on the CPU
var		float		TickUpdateDelay, NextTickUpdateTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event Tick( float DeltaTime )
{
	local	float	FlyDist;
	
	Super.Tick(DeltaTime);
	
	if ( (Physics == default.Physics || Physics == PHYS_Falling) &&
		 Level.TimeSeconds > NextTickUpdateTime )
	{
		if ( Physics == default.Physics )
		{
			FlyDist = VSize(SpawnLocation - Location);
			if ( FlyDist >= MaxEffectiveRange )
			{
				//bTrueBallistics = False;
				SetPhysics(PHYS_Falling);
			}
		}
		SetRotation(Rotator(Normal(Velocity)));
		NextTickUpdateTime = Level.TimeSeconds + TickUpdateDelay;
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
     bReplicateSpawnLocation=True
	 TickUpdateDelay=0.050000
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
	 //EmitterTrails
	 EmitterTrailsInfo(0)=(TrailClass=Class'UnlimaginMod.UM_PanzerfaustTrail',bAttachTrail=True,TrailRotation=(Pitch=32768))
	 //HitEffects
	 HitSoundVolume=1.250000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
}
