//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_UMP45ExpBullet
//	Parent class:	 UM_BaseProjectile_45ACPExplosive
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.06.2013 20:55
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_UMP45ExpBullet extends UM_BaseProjectile_45ACPExplosive;


defaultproperties
{
     //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 ImpactDamage=31.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeUMP45ExpImpact'
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeUMP45ExpBullet'
}
