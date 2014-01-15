//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_L22A1Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:43
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_L22A1Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=5.000000
     cost=500
     AmmoCost=10
     BuyClipSize=30
     PowerValue=24
     SpeedValue=90
     RangeValue=60
     Description="Standard issue military rifle. Equipped with an integrated 2X scope."
     ItemName="L22A1 (EOTech)"
     ItemShortName="L22A1"
     AmmoItemName="5.56 NATO Ammo"
     showMesh=SkeletalMesh'KF_Weapons3rd_Trip.BullPup_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.UM_L22A1Carbine'
     PickupMessage="You got the L22A1 (EOTech)"
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Rifle.Bullpup_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
