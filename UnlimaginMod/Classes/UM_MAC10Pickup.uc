//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10Pickup
//	Parent class:	 UM_BaseSMGPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:01
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MAC10Pickup extends UM_BaseSMGPickup;


defaultproperties
{
     Weight=4.000000
     cost=500
     AmmoCost=10
     BuyClipSize=30
     PowerValue=30
     SpeedValue=98
     RangeValue=40
     Description="A highly compact machine pistol. Can be fired in semi or full auto."
     ItemName="MAC-10"
     ItemShortName="MAC-10"
     AmmoItemName=".45 Cal"
     //showMesh=SkeletalMesh'KF_Weapons3rd2_Trip.mac10_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=5
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_MAC10MP'
     PickupMessage="You got the MAC-10"
     PickupSound=Sound'KF_MAC10MPSnd.MAC10_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Supers.MAC10_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
