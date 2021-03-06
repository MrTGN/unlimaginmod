//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_M32ShotgunPickup
//	Parent class:	 M32Pickup
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 28.12.2012 23:18
//================================================================================
class UM_M32ShotgunPickup extends M32Pickup;

defaultproperties
{
	Weight=6.000000
	cost=3000
	AmmoCost=48
	BuyClipSize=6
	ItemName="M32 Shotgun"
	ItemShortName="M32 Shotgun"
	AmmoItemName="M32 Flechette Shotgun Shells"
	CorrespondingPerkIndex=1
	InventoryType=Class'UnlimaginMod.UM_M32Shotgun'
	PickupMessage="You got the M32 Shotgun."
}