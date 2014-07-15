//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10IncBullet
//	Parent class:	 UM_BaseProjectile_45ACPIncendiary
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.06.2013 02:56
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MAC10IncBullet extends UM_BaseProjectile_45ACPIncendiary;


defaultproperties
{
     ImpactDamage=23.000000
	 MuzzleVelocity=280.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeMAC10IncImpact'
     MyDamageType=Class'UnlimaginMod.UM_DamTypeMAC10IncBullet'
}
