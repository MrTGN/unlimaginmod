//=============================================================================
// UnlimaginMod - Maria_Cz75LaserAmmo
// Copyright (C) 2012
// - Maria
//=============================================================================
class Maria_Cz75LaserAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=32
     MaxAmmo=384
     InitialAmount=192
     PickupClass=Class'UnlimaginMod.Maria_Cz75LaserAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
     ItemName="Cz75 9mm bullets"
}
