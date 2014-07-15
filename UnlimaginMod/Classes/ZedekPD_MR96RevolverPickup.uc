//=============================================================================
// ZedekPD_MR96RevolverPickup
//=============================================================================
// MR96 Revolver pickup class
//=============================================================================
class ZedekPD_MR96RevolverPickup extends UM_BaseHandgunPickup;


defaultproperties
{
     Weight=2.000000
     cost=700
     AmmoCost=10
     BuyClipSize=6
     PowerValue=75
     SpeedValue=40
     RangeValue=65
     Description="The Manurhin MR96 is a French-manufactured, double-action revolver chambered in .357 Magnum."
     ItemName="Manurhin MR96 Revolver"
     ItemShortName="MR96 Revolver"
     AmmoItemName="MR96 Revolver Ammo"
     CorrespondingPerkIndex=2
     EquipmentCategoryID=1
     InventoryType=Class'UnlimaginMod.ZedekPD_MR96Revolver'
     PickupMessage="You got the MR96 Revolver."
     PickupSound=Sound'KF_RevolverSnd.foley.WEP_Revolver_Foley_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'MR96_SM.mr96_pickup'
     CollisionHeight=5.000000
}
