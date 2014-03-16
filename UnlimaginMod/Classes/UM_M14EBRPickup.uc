//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M14EBRPickup
//	Parent class:	 UM_BaseBattleRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:47
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M14EBRPickup extends UM_BaseBattleRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=2500
     AmmoCost=45
     BuyClipSize=20
     PowerValue=55
     SpeedValue=20
     RangeValue=95
     Description="Updated M14 Enhanced Battle Rifle - Semi Auto variant. Equipped with a laser sight."
     ItemName="M14 EBR"
     ItemShortName="M14 EBR"
     AmmoItemName="7.62x51mm Ammo"
     //showMesh=SkeletalMesh'KF_Weapons3rd2_Trip.M14_EBR_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_M14EBR'
     PickupMessage="You got the M14 EBR"
     PickupSound=Sound'KF_M14EBRSnd.M14EBR_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Rifles.M14_EBR_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
