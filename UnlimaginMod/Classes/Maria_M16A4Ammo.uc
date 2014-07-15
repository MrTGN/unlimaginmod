//===================================================================================
// M4Ammo
//===================================================================================
// Ammo for the M4 assault rifle primary fire
//===================================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//===================================================================================
class Maria_M16A4Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=60
     MaxAmmo=540
     InitialAmount=240
     PickupClass=Class'UnlimaginMod.Maria_M16A4AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="M16 bullets"
}
