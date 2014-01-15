//=============================================================================
// Braindead_MP5SDAmmo
//=============================================================================
// Ammo for the MP5 Medic Gun primary fire
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5SDAmmo extends KFAmmunition;

defaultproperties
{
     AmmoPickupAmount=32
     MaxAmmo=640
     InitialAmount=320
     PickupClass=Class'UnlimaginMod.Braindead_MP5SDAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="MP5SD 9x19mm bullets"
}
