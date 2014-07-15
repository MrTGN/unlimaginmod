//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM4Pickup
//	Parent class:	 UM_BaseShotgunPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:20
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BenelliM4Pickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=5.000000
     cost=2000
	 AmmoCost=20
     BuyClipSize=6
     PowerValue=70
     SpeedValue=60
     RangeValue=15
     Description="A military tactical shotgun with semi automatic fire capability. Holds up to 6 shells. "
     ItemName="Benelli M4 Super 90"
     ItemShortName="Benelli M4"
     AmmoItemName="12-gauge shells"
     CorrespondingPerkIndex=1
     EquipmentCategoryID=2
     //VariantClasses(0)=Class'KFMod.GoldenBenelliPickup'
     InventoryType=Class'UnlimaginMod.UM_BenelliM4Shotgun'
     PickupMessage="You got the Benelli M4."
     PickupSound=Sound'KF_M4ShotgunSnd.foley.WEP_Benelli_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups3_Trip.Rifles.Benelli_Pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
