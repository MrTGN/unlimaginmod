//===================================================================================
// L85A2 Ammo.
//===================================================================================
class JSullivan_L85A2Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=30
     MaxAmmo=450
     InitialAmount=240
     PickupClass=Class'UnlimaginMod.JSullivan_L85A2AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=413,Y1=82,X2=457,Y2=125)
     ItemName="Stanag Magazines"
}
