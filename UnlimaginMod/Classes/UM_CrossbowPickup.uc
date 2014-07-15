//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_CrossbowPickup
//	Parent class:	 UM_BaseSniperRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 11:48
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_CrossbowPickup extends UM_BaseSniperRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=800
     AmmoCost=18
	 BuyClipSize=1
     PowerValue=64
     SpeedValue=50
     RangeValue=100
     Description="Recreational hunting weapon, equipped with powerful scope and firing trigger. Exceptional headshot damage."
     ItemName="Crossbow"
     ItemShortName="Crossbow"
     AmmoItemName="Crossbow Bolts"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.Crossbow_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.XbowAmmo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     MaxDesireability=0.790000
     InventoryType=Class'UnlimaginMod.UM_Crossbow'
     PickupMessage="You got the Xbow."
     PickupSound=Sound'KF_XbowSnd.Xbow_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Rifle.crossbow_pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
