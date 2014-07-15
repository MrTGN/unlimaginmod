//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM3Pickup
//	Parent class:	 UM_BaseShotgunPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:09
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BenelliM3Pickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=5.000000
     cost=600
     AmmoCost=20
	 BuyClipSize=8
     PowerValue=70
     SpeedValue=40
     RangeValue=15
     Description="A rugged 12-gauge pump action shotgun. "
     ItemName="Benelli M3 Super 90"
     ItemShortName="Benelli M3"
     AmmoItemName="12-gauge shells"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.Shotgun_3rd'
     CorrespondingPerkIndex=1
     EquipmentCategoryID=2
     //VariantClasses(0)=Class'KFMod.CamoShotgunPickup'
     InventoryType=Class'UnlimaginMod.UM_BenelliM3Shotgun'
     PickupMessage="You got the Benelli M3."
     PickupSound=Sound'KF_PumpSGSnd.SG_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups_Trip.Shotgun.shotgun_pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
