//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BenelliM3FragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 20.09.2012 17:25
//================================================================================
class UM_BenelliM3FragBullet extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
     SoundEffectsVolume=2.300000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM3FragImpact'
     ImpactDamage=200.000000
	 //MuzzleVelocity
	 MuzzleVelocity=450.000000		// m/sec
     Damage=190.000000
     DamageRadius=140.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM3FragBullet'
}
