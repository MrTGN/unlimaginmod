//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM4A1IncBullet
//	Parent class:	 UM_BaseProjectile_45ACPIncendiary
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.06.2013 20:01
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM4A1IncBullet extends UM_BaseProjectile_45ACPIncendiary;



defaultproperties
{
	 MuzzleVelocity=280.000000
	 ImpactDamage=24.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM4A1IncImpact'
	 Damage=30.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeThompsonM4A1IncBullet'
}
