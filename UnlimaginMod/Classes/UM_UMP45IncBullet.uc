//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_UMP45IncBullet
//	Parent class:	 UM_BaseProjectile_45ACPIncendiary
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.06.2013 19:37
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_UMP45IncBullet extends UM_BaseProjectile_45ACPIncendiary;


defaultproperties
{
	 //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 ImpactDamage=24.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeUMP45IncImpact'
	 Damage=30.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeUMP45IncBullet'
}
