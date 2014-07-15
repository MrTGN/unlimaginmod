//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMagGrenadeLauncher
//	Parent class:	 UM_BaseGrenadeLauncher
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 02:35
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base weapon class of Grenade Launchers with box
//					 or drum magazine.
//================================================================================
class UM_BaseMagGrenadeLauncher extends UM_BaseGrenadeLauncher
	Abstract;


simulated exec function ToggleIronSights()
{
	Super(UM_BaseWeapon).ToggleIronSights();
}

simulated exec function IronSightZoomIn()
{
	Super(UM_BaseWeapon).IronSightZoomIn();
}

simulated function AddReloadedAmmo()
{
	Super(UM_BaseWeapon).AddReloadedAmmo();
}

//StartFire with out InterruptReload() function
simulated function bool StartFire(int Mode)
{
	Return Super(UM_BaseWeapon).StartFire(Mode);
}


defaultproperties
{
     bHoldToReload=False
}