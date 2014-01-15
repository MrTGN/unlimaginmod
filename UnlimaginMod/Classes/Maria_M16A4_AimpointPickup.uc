//===================================================================================
// UnlimaginMod - Maria_M16A4_AimpointPickup
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_AimpointPickup extends UM_BaseAssaultRiflePickup;

defaultproperties
{
     Weight=5.000000
     cost=1200
     AmmoCost=10
     BuyClipSize=30
     PowerValue=30
     SpeedValue=90
     RangeValue=60
     Description="A 5.56mm, air-cooled, direct-gas operated, magazine-fed rifle, with a rotating bolt. The M16A4 MWS is the primary Infantry rifle of the US Army."
     ItemName="M16A4 (Red Dot)"
     ItemShortName="M16A4 (Red Dot)"
     AmmoItemName="5.56mm Ammo"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.Maria_M16A4_Aimpoint'
     PickupMessage="You got the M16A4 (Red Dot)"
     PickupSound=Sound'KF_M4RifleSnd.foley.WEP_M4_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'M16A4Rifle_SM.M16A4_Aimpoint_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
