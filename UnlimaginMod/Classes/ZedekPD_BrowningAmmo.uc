//=============================================================================
// ZedekPD_BrowningAmmo.
//=============================================================================
class ZedekPD_BrowningAmmo extends UM_BaseHandgunAmmo;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     AmmoPickupAmount=10
     MaxAmmo=240
     InitialAmount=80
	 PickupClass=Class'UnlimaginMod.ZedekPD_BrowningAmmoPickup'
     IconMaterial=Texture'KillingFloorHUD.Generic.HUD'
     IconCoords=(X1=338,Y1=40,X2=393,Y2=79)
     ItemName="Browning HP .40 S&W bullets"
}
