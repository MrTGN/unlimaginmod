//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPThompsonM1928Pickup
//	Parent class:	 UM_BaseSMGPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:26
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SPThompsonM1928Pickup extends UM_BaseSMGPickup;


defaultproperties
{
     Weight=6.000000
     cost=1200
     AmmoCost=12
     BuyClipSize=40
     PowerValue=35
     SpeedValue=80
     RangeValue=50
     Description="Thy weapon is before you. May it's drum beat a sound of terrible fear into your enemies."
     ItemName="Dr. T's Lead Delivery System"
     ItemShortName="Dr. T's L.D.S."
     AmmoItemName="L.D.S. Ammo"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_SPThompsonM1928SMG'
     PickupMessage="You got Dr. T's Lead Dispensing System"
     PickupSound=Sound'KF_SP_ThompsonSnd.KFO_SP_Thompson_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_IJC_Summer_Weps.Steampunk_Thompson'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
