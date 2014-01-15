//=============================================================================
// L85 Ammo.
//=============================================================================
class ZedekPD_XM8Ammo extends KFAmmunition;

#EXEC OBJ LOAD FILE=KillingFloorHUD.utx

defaultproperties
{
     AmmoPickupAmount=30
	 MaxAmmo=450
     InitialAmount=240
     PickupClass=Class'UnlimaginMod.ZedekPD_XM8AmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=336,Y1=82,X2=382,Y2=125)
     ItemName="XM8 bullets"
}
