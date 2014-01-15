//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FNFAL_ACOG_Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:27
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_FNFAL_ACOG_Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=2600
     AmmoCost=25
     BuyClipSize=20
     PowerValue=45
     SpeedValue=90
     RangeValue=70
     Description="Classic NATO battle rifle. Has a high rate of fire and decent accuracy, with good power."
     ItemName="FN FAL (ACOG)"
     ItemShortName="FN FAL"
     AmmoItemName="7.62x51mm Ammo"
     showMesh=SkeletalMesh'KF_Weapons3rd_Trip.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_FNFAL_ACOG_AssaultRifle'
     PickupMessage="You got the FN FAL with ACOG Sight"
     PickupSound=Sound'KF_FNFALSnd.FNFAL_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups4_Trip.Rifles.Fal_Acog_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
