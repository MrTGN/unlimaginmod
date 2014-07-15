//=============================================================================
// Braindead_MP5A4Pickup
//=============================================================================
// Ammo pickup class for the Braindead_MP5A4SMG
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5A4AmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=32
     InventoryType=Class'UnlimaginMod.Braindead_MP5A4Ammo'
     PickupMessage="Rounds 9x19mm"
     StaticMesh=StaticMesh'KillingFloorStatics.L85Ammo'
}
