//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPSniperRifleBullet
//	Parent class:	 UM_BaseProjectile_30_06Springfield
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.08.2013 14:26
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SPSniperRifleBullet extends UM_BaseProjectile_30_06Springfield;


defaultproperties
{
     MuzzleVelocity=810.000000		//Meter/sec
	 HeadShotDamageMult=2.200000
	 ImpactDamage=140.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeSPSniperRifle'
}
