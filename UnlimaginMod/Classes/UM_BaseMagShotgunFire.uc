//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMagShotgunFire
//	Parent class:	 UM_BaseShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.04.2013 17:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
