//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ColtM1911IncBullet
//	Parent class:	 UM_BaseProjectile_45ACPIncendiary
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.06.2013 23:47
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ColtM1911IncBullet extends UM_BaseProjectile_45ACPIncendiary;


defaultproperties
{
     MuzzleVelocity=230.000000
	 ImpactDamage=26.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeColtM1911IncImpact'
	 Damage=32.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeColtM1911IncBullet'
}
