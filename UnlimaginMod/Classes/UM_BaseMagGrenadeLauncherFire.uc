//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseMagGrenadeLauncherFire
//	Parent class:	 UM_BaseGrenadeLauncherFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 11.07.2013 02:30
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Base fire class of Grenade Launchers with box
//					 or drum magazine.
//================================================================================
class UM_BaseMagGrenadeLauncherFire extends UM_BaseGrenadeLauncherFire
	Abstract;


// Overridden to disallow interrupting the reload
simulated function bool AllowFire()
{
	Return Super(UM_BaseProjectileWeaponFire).AllowFire();
}


defaultproperties
{
}
