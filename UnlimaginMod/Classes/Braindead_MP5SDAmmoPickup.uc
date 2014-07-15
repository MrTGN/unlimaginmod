//=============================================================================
// Braindead_MP5SDPickup
//=============================================================================
// Ammo pickup class for the Braindead_MP5SD
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5SDAmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=32
     InventoryType=Class'UnlimaginMod.Braindead_MP5SDAmmo'
     PickupMessage="Rounds 9x19mm"
     StaticMesh=StaticMesh'KillingFloorStatics.L85Ammo'
}
