//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32ShotgunFragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:38
//================================================================================
class UM_M32ShotgunFragBullet extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
	 TransientSoundVolume=1.800000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeM32ShotgunFragImpact'
     ImpactDamage=80.000000
	 //MuzzleVelocity
	 MuzzleVelocity=360.000000		// m/sec
     Damage=78.000000
	 DamageRadius=120.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM32ShotgunFragBullet'
	 DrawScale=2.400000
}