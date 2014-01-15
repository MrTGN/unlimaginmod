//===================================================================================
// M4AmmoPickup
//===================================================================================
// Ammo pickup class for the M4 assault rifle primary fire
//===================================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//===================================================================================
class Maria_M16A4AmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=30
     InventoryType=Class'UnlimaginMod.Maria_M16A4Ammo'
     PickupMessage="Rounds 5.56mm"
     StaticMesh=StaticMesh'KillingFloorStatics.L85Ammo'
}
