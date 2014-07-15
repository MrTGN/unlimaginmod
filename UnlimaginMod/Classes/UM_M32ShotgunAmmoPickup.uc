//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32ShotgunAmmoPickup
//	Parent class:	 KFAmmoPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:20
//================================================================================
class UM_M32ShotgunAmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=6
     InventoryType=Class'UnlimaginMod.UM_M32ShotgunAmmo'
     PickupMessage="M32 Flechette Shotgun Shells"
     StaticMesh=StaticMesh'KillingFloorStatics.FragPickup'
     CollisionRadius=25.000000
}
