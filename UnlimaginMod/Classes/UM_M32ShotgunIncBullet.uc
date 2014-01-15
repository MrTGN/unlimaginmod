//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32ShotgunIncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:23
//================================================================================
class UM_M32ShotgunIncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
	 SoundEffectsVolume=1.500000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeM32ShotgunIncImpact'
     ImpactDamage=50.000000
	 //MuzzleVelocity
	 MuzzleVelocity=360.000000		// m/sec
     Damage=42.000000
	 DamageRadius=120.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM32ShotgunIncBullet'
	 DrawScale=2.500000
}