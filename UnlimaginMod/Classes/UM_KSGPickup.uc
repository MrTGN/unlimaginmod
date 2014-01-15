//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGPickup
//	Parent class:	 UM_BaseShotgunPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:41
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_KSGPickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=6.000000
     cost=1250
     AmmoCost=30
     BuyClipSize=14
     PowerValue=70
     SpeedValue=50
     RangeValue=30
     Description="An advanced Horzine prototype tactical shotgun. Features a large capacity ammo magazine and selectable tight/wide spread fire modes."
     ItemName="Kel-Tec KSG-M"
     ItemShortName="KSG-M"
     AmmoItemName="12-gauge mag"
     CorrespondingPerkIndex=1
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_KSGShotgun'
     PickupMessage="You got the Horzine HSG-1 shotgun."
     PickupSound=Sound'KF_KSGSnd.KSG_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups4_Trip.Shotguns.KSG_Pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
