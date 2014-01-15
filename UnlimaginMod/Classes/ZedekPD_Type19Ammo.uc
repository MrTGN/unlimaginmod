//===================================================================================
// ZedekPD_Type19PDW Ammo.
//===================================================================================
class ZedekPD_Type19Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=40
     MaxAmmo=640
     InitialAmount=320
     PickupClass=Class'UnlimaginMod.ZedekPD_Type19AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="Type-19 Bullets"
}
