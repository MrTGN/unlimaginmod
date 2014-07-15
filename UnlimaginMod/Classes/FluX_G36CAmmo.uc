//===================================================================================
// G36C Ammo class
// Made by FluX
// http://www.fluxiserver.co.uk
//===================================================================================
class FluX_G36CAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=30
     MaxAmmo=450
     InitialAmount=240
     PickupClass=Class'UnlimaginMod.FluX_G36CAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="G36C bullets"
}
