//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM4A1Pickup
//	Parent class:	 UM_BaseSMGPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:37
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM4A1Pickup extends UM_BaseSMGPickup;


defaultproperties
{
     Weight=5.000000
     cost=900
     AmmoCost=10
     BuyClipSize=30
     PowerValue=35
     SpeedValue=80
     RangeValue=45
     Description="The Thompson sub-machine gun. An absolute classic of design and functionality, beloved by soldiers and gangsters for decades!"
     ItemName="Thompson SMG M1A1"
     ItemShortName="Thompson SMG M1A1"
     AmmoItemName="45. ACP Ammo"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_ThompsonM4A1SMG'
     PickupMessage="You got the Thompson"
     PickupSound=Sound'KF_IJC_HalloweenSnd.Handling.Thompson_Handling_Bolt_Back'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_IJC_Halloween_Weps.thompson_pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
