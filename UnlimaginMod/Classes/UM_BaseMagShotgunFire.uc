//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseMagShotgunFire
//	Parent class:	 UM_BaseShotgunFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 30.04.2013 17:10
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Base fire class of pump-action or automatic shotgun
//					 with box or drum magazine.
//================================================================================
class UM_BaseMagShotgunFire extends UM_BaseShotgunFire
	Abstract;


// Overridden to disallow interrupting the reload
simulated function bool AllowFire()
{
	Return Super(UM_BaseProjectileWeaponFire).AllowFire();
}


defaultproperties
{
}
