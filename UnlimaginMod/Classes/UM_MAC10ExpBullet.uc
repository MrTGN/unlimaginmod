//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10ExpBullet
//	Parent class:	 UM_BaseProjectile_45ACPExplosive
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.08.2013 21:22
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MAC10ExpBullet extends UM_BaseProjectile_45ACPExplosive;


defaultproperties
{
     MuzzleVelocity=280.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeMAC10ExpImpact'
     MyDamageType=Class'UnlimaginMod.UM_DamTypeMAC10ExpBullet'
}
