//=============================================================================
// Shotgun Ammo.
//=============================================================================
class MrQuebec_HekuT_Spas12Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=8
     MaxAmmo=64
     InitialAmount=40
	 PickupClass=Class'UnlimaginMod.MrQuebec_HekuT_Spas12AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=451,Y1=445,X2=510,Y2=500)
}
