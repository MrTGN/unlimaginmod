//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ProtectaFragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 03.11.2013 15:37
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_ProtectaFragBullet extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeProtectaFragImpact'
     ImpactDamage=90.000000
	 //MuzzleVelocity
	 MuzzleVelocity=420.000000		// m/sec
     Damage=80.000000
	 DamageRadius=120.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeProtectaFragBullet'
	 DrawScale=1.800000
}
