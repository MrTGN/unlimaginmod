//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BenelliM3IncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 20.09.2012 17:47
//================================================================================
class UM_BenelliM3IncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM3IncImpact'
     ImpactDamage=100.000000
	 //MuzzleVelocity
	 MuzzleVelocity=450.000000		// m/sec
     Damage=105.000000
	 DamageRadius=140.000000
     MomentumTransfer=5000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM3IncBullet'
}
