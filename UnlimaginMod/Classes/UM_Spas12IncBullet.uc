//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Spas12IncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 03.11.2013 15:27
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_Spas12IncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeSpas12IncImpact'
     ImpactDamage=100.000000
	 //MuzzleVelocity
	 MuzzleVelocity=460.000000		// m/sec
     Damage=100.000000
	 DamageRadius=150.000000
     MomentumTransfer=6500.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeSpas12IncBullet'
}
