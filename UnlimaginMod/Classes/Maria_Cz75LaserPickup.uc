//=============================================================================
// UnlimaginMod - Maria_Cz75LaserPickup
// Copyright (C) 2012
// - Maria
//=============================================================================
class Maria_Cz75LaserPickup extends UM_BaseHandgunPickup;


defaultproperties
{
     Weight=1.000000
     cost=300
     AmmoCost=10
     BuyClipSize=32
     PowerValue=20
     SpeedValue=50
     RangeValue=35
     Description="Cz75 9x19mm Parabellum with Laser Pointer"
     ItemName="Cz75 Laser"
     ItemShortName="Cz75"
     AmmoItemName="9x19mm Parabellum"
     AmmoMesh=StaticMesh'KillingFloorStatics.DualiesAmmo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=1
     InventoryType=Class'UnlimaginMod.Maria_Cz75Laser'
     PickupMessage="You got the Cz75 with Laser Pointer"
     PickupSound=Sound'KF_9MMSnd.9mm_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Cz75Laser_SM.Cz75Laser_PickUp'
     CollisionHeight=5.000000
}
