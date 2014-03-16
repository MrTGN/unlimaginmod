//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FlameThrowerPickup
//	Parent class:	 UM_BaseFlameThrowerPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:24
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_FlameThrowerPickup extends UM_BaseFlameThrowerPickup;


defaultproperties
{
     Weight=9.000000
	 cost=750
     AmmoCost=40
     BuyClipSize=100
     PowerValue=30
     SpeedValue=100
     RangeValue=40
     Description="A deadly experimental weapon designed by Horzine industries. It can fire streams of burning liquid which ignite on contact."
     ItemName="FlameThrower"
     ItemShortName="FlameThrower"
     AmmoItemName="Napalm"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.Flamethrower_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.FT_AmmoMesh'
     CorrespondingPerkIndex=5
     EquipmentCategoryID=3
     //VariantClasses(0)=Class'KFMod.GoldenFTPickup'
     InventoryType=Class'UnlimaginMod.UM_FlameThrower'
     PickupMessage="You got the FlameThrower"
     PickupSound=Sound'KF_FlamethrowerSnd.FT_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Super.Flamethrower_pickup'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
