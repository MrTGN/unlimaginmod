//===================================================================================
// Hunting_Rifle Rifle Ammo.
//===================================================================================
class Braindead_HuntingRifleAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=10
     MaxAmmo=50
     InitialAmount=20
     PickupClass=Class'UnlimaginMod.Braindead_HuntingRifleAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=338,Y1=40,X2=393,Y2=79)
     ItemName=".338 Lapua Magnum bullets"
}
