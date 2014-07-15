//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SCARMK17Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SCARMK17Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=5.000000
     cost=3000
     AmmoCost=25
     BuyClipSize=20
     PowerValue=45
     SpeedValue=85
     RangeValue=70
     Description="Advanced tactical assault rifle. Equipped with an aimpoint sight."
     ItemName="SCAR-H (Red Dot, Foregrip)"
     ItemShortName="SCAR-H"
     AmmoItemName="7.62x51mm Ammo"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_SCARMK17AssaultRifle'
     PickupMessage="You got the SCAR-H"
     PickupSound=Sound'KF_SCARSnd.SCAR_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Rifles.SCAR_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
