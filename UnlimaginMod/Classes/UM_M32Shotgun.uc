//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32Shotgun
//	Parent class:	 M32GrenadeLauncher
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:15
//================================================================================
class UM_M32Shotgun extends M32GrenadeLauncher;

defaultproperties
{
	MagCapacity=6
	// ReloadRate = 1.634000 / 1.15
	ReloadRate=1.420000
	// ReloadAnimRate = 1.000000 * 1.15
	ReloadAnimRate=1.150000
	Weight=6.000000
	FireModeClass(0)=Class'UnlimaginMod.UM_M32ShotgunFire'
	FireModeClass(1)=Class'KFMod.NoFire'
	Priority=186
	PickupClass=Class'UnlimaginMod.UM_M32ShotgunPickup'
	ItemName="M32 Shotgun"
}