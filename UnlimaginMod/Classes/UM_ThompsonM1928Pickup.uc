//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM1928Pickup
//	Parent class:	 UM_BaseSMGPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:28
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM1928Pickup extends UM_BaseSMGPickup;


defaultproperties
{
     Weight=6.000000
     cost=1100
     AmmoCost=15
     BuyClipSize=50
     PowerValue=35
     SpeedValue=80
     RangeValue=45
     Description="This Tommy gun M1928 with a drum magazine was used heavily during the WWII pacific battles as seen in Rising Storm."
     ItemName="Thompson SMG M1928"
     ItemShortName="Tommy Gun"
     AmmoItemName="45. ACP Ammo"
     //showMesh=SkeletalMesh'KF_Weapons3rd_Trip.AK47_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_ThompsonM1928SMG'
     PickupMessage="You got the Rising Storm Thompson with Drum Mag"
     PickupSound=Sound'KF_IJC_HalloweenSnd.Handling.Thompson_Handling_Bolt_Back'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_IJC_Summer_Weps.Thompson_Drum'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
