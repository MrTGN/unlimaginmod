//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M4203Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M4203Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=5.000000
     cost=2000
	 AmmoCost=16
     BuyClipSize=30
     PowerValue=90
     RangeValue=75
     Description="An assault rifle with an attached grenade launcher."
     ItemName="M4 203"
     ItemShortName="M4 203"
     SecondaryAmmoShortName="M4 203 Grenades"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     //VariantClasses(0)=Class'KFMod.CamoM4Pickup'
     InventoryType=Class'UnlimaginMod.UM_M4203AssaultRifle'
     PickupSound=Sound'KF_M4RifleSnd.foley.WEP_M4_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups3_Trip.Rifles.M4M203_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
     PickupMessage="You got the M4 203"
}
