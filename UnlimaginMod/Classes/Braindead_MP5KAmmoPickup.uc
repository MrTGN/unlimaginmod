//=============================================================================
// MP5KPickup
//=============================================================================
// Ammo pickup class for the MP5K
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5KAmmoPickup extends KFAmmoPickup;

defaultproperties
{
     AmmoAmount=30
     InventoryType=Class'UnlimaginMod.Braindead_MP5KAmmo'
     PickupMessage="Rounds 9x19mm"
     StaticMesh=StaticMesh'KillingFloorStatics.L85Ammo'
}
