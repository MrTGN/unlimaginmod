//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WinchesterM1894Bullet
//	Parent class:	 UM_BaseProjectile_30WCF_H160FTX
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 19:29
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_WinchesterM1894Bullet extends UM_BaseProjectile_30WCF_H160FTX;


defaultproperties
{
     MuzzleVelocity=730.000000		//Meter/sec
	 HeadShotDamageMult=2.250000
   	 ImpactDamage=95.000000
     ImpactDamageType=Class'UnlimaginMod.UM_DamTypeWinchesterM1894Rifle'
}
