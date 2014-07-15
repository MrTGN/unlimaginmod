//===================================================================================
// Shotgun Ammo.
//===================================================================================
class Hemi_Braindead_Moss12Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=7
     MaxAmmo=56
     InitialAmount=35
	 PickupClass=Class'UnlimaginMod.Hemi_Braindead_Moss12AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=451,Y1=445,X2=510,Y2=500)
}
