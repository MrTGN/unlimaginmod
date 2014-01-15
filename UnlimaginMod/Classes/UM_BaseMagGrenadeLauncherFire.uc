//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMagGrenadeLauncherFire
//	Parent class:	 UM_BaseGrenadeLauncherFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 02:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
