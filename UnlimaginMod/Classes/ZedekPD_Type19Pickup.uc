//===================================================================================
// Type-19 Pickup
//===================================================================================
class ZedekPD_Type19Pickup extends UM_BasePDWPickup;

/*
simulated function RenderPickupImage(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.L85', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);

}
*/

defaultproperties
{
     Weight=5.000000
     cost=1700
     BuyClipSize=50
     PowerValue=35
     SpeedValue=85
     RangeValue=60
     Description="A quality futuristic military rifle, designed with a very peculiar reloading system."
     ItemName="Type-19 PDW"
     ItemShortName="Type-19"
     AmmoItemName="5.7x28 Ammo"
     showMesh=SkeletalMesh'Type19_A.type19_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.ZedekPD_Type19PDW'
     PickupMessage="You got the Type-19 PDW."
     PickupSound=Sound'Type19_S.type19_boltback'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Type19_SM.type19_pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
