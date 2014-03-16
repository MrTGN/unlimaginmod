//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WinchesterM1894Pickup
//	Parent class:	 UM_BaseSniperRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:41
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_WinchesterM1894Pickup extends UM_BaseSniperRiflePickup;


defaultproperties
{
     Weight=5.000000
     cost=500
     AmmoCost=24
	 BuyClipSize=14
     PowerValue=50
     SpeedValue=35
     RangeValue=90
     Description="A rugged and reliable single-shot rifle."
     ItemName="Winchester Model 1894"
     ItemShortName="Winchester M1894"
     AmmoItemName="Rifle bullets"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.Winchester_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.UM_WinchesterM1894Rifle'
     PickupMessage="You got the Winchester Model 1894"
     PickupSound=Sound'KF_RifleSnd.RifleBase.Rifle_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Rifle.LeverAction_pickup'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
