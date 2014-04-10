//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M99Bullet
//	Parent class:	 UM_BaseProjectile_M1022LRSniper
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.05.2013 02:07
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M99Bullet extends UM_BaseProjectile_M1022LRSniper;


defaultproperties
{
     HeadShotDamageType=Class'UnlimaginMod.UM_DamTypeM99HeadShot'
     MyDamageType=Class'UnlimaginMod.UM_DamTypeM99SniperRifle'
	 Damage=720.000000
	 HeadShotDamageMult=2.800000
}
