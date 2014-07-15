//=============================================================================
// Braindead_MP5SDPickup
//=============================================================================
// Pickup class for the MP5 Medic Gun
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5SDPickup extends UM_BaseSMGPickup;

defaultproperties
{
     Weight=4.000000
     cost=1100
     AmmoCost=10
     BuyClipSize=32
     PowerValue=30
     SpeedValue=85
     RangeValue=45
     Description="MP5 sub machine gun with suppressor."
     ItemName="MP5SD"
     ItemShortName="MP5SD"
     AmmoItemName="9x19mm Ammo"
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.Braindead_MP5SD'
     PickupMessage="You got the MP5SD Sub Machine Gun"
     PickupSound=Sound'KF_MP5Snd.foley.WEP_MP5_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'BD_MP5_SM.MP5SD_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
