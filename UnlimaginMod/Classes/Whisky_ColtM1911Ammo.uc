//=============================================================================
// Whisky_ColtM1911Ammo
//=============================================================================
class Whisky_ColtM1911Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=7
     MaxAmmo=280
     InitialAmount=140
     PickupClass=Class'UnlimaginMod.Whisky_ColtM1911AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
     ItemName="45 ACP bullets"
}
