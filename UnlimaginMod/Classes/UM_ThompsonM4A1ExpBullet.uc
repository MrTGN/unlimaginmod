//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ThompsonM4A1ExpBullet
//	Parent class:	 UM_BaseProjectile_45ACPExplosive
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.08.2013 20:55
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_ThompsonM4A1ExpBullet extends UM_BaseProjectile_45ACPExplosive;


defaultproperties
{
     //MuzzleVelocity
	 MuzzleVelocity=280.000000	// m/sec
	 ImpactDamage=30.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM4A1ExpImpact'
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM4A1ExpBullet'
}
