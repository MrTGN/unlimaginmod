//===================================================================================
// Trenchgun Ammo.
//===================================================================================
class Maria_M37IthacaAmmo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=6
     MaxAmmo=60
     InitialAmount=36
	 PickupClass=Class'UnlimaginMod.UM_M37IthacaAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=451,Y1=445,X2=510,Y2=500)
}
