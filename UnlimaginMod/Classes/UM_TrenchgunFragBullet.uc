//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_TrenchgunFragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 18.11.2012 15:51
//================================================================================
class UM_TrenchgunFragBullet extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeTrenchgunFragImpact'
     ImpactDamage=200.000000
	 //MuzzleVelocity
	 MuzzleVelocity=440.000000		// m/sec
     Damage=185.000000
	 DamageRadius=150.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeTrenchgunFragBullet'
}
