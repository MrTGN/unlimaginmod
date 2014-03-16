//=============================================================================
// ZedekPD_BrowningPickup.
//=============================================================================
class ZedekPD_BrowningPickup extends UM_BaseHandgunPickup;


defaultproperties
{
     Weight=2.000000
     cost=600
     AmmoCost=12
     BuyClipSize=10
     PowerValue=90
     SpeedValue=35
     RangeValue=60
     Description="The Browning High-Power is a single-action, .40 S&W semi-automatic handgun."
     ItemName="Browning Hi-Power"
     ItemShortName="Browning HP"
     AmmoItemName=".40 S&W Bullets"
     //showMesh=SkeletalMesh'Browning_A.browning_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=1
     //GoldenVariantClass=Class'UnlimaginMod.ZedekPD_GoldenBrowningPickup'
     InventoryType=Class'UnlimaginMod.ZedekPD_BrowningPistol'
     PickupMessage="You got the Browning Hi-Power."
     PickupSound=Sound'KF_HandcannonSnd.50AE_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Browning_SM.browning_pickup'
     CollisionHeight=5.000000
}
