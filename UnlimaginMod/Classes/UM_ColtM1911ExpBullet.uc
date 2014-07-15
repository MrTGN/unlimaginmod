//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ColtM1911ExpBullet
//	Parent class:	 UM_BaseProjectile_45ACPExplosive
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.06.2013 23:54
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ColtM1911ExpBullet extends UM_BaseProjectile_45ACPExplosive;


defaultproperties
{
     MuzzleVelocity=230.000000
	 ImpactDamage=35.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeColtM1911ExpImpact'
	 Damage=66.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeColtM1911ExpBullet'
}
