//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M4Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:57
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M4Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=4.000000
     cost=1000
     AmmoCost=16
     BuyClipSize=30
     PowerValue=30
     SpeedValue=90
     RangeValue=60
     Description="A compact assault rifle. Can be fired in semi or full auto with good damage and good accuracy."
     ItemName="M4 (Red Dot)"
     ItemShortName="M4"
     AmmoItemName="5.56mm Ammo"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     VariantClasses(0)=Class'KFMod.CamoM4Pickup'
     InventoryType=Class'UnlimaginMod.UM_M4AssaultRifle'
     PickupMessage="You got the M4 (Red Dot)"
     PickupSound=Sound'KF_M4RifleSnd.foley.WEP_M4_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups3_Trip.Rifles.M4_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
