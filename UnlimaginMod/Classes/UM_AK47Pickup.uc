//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_AK47Pickup
//	Parent class:	 UM_BaseAssaultRiflePickup
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 01.11.2013 09:17
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_AK47Pickup extends UM_BaseAssaultRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=800
     AmmoCost=10
     BuyClipSize=30
     PowerValue=40
     SpeedValue=80
     RangeValue=50
     Description="Standard issue military rifle. Equipped with an integrated 2X scope."
     ItemName="AK47"
     ItemShortName="AK47"
     AmmoItemName="7.62mm Ammo"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     //VariantClasses(0)=Class'KFMod.GoldenAK47pickup'
     InventoryType=Class'UnlimaginMod.UM_AK47AssaultRifle'
     PickupMessage="You got the AK47"
     PickupSound=Sound'KF_AK47Snd.AK47_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Rifle.AK47_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
