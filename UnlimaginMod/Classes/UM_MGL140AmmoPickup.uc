//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140AmmoPickup
//	Parent class:	 UM_BaseGrenadeLauncherAmmoPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 06:28
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140AmmoPickup extends UM_BaseGrenadeLauncherAmmoPickup;


defaultproperties
{
     AmmoAmount=6
     InventoryType=Class'UnlimaginMod.UM_MGL140Ammo'
     PickupMessage="MGL140 RMC Grenades"
     StaticMesh=StaticMesh'KillingFloorStatics.FragPickup'
     CollisionRadius=25.000000
}
