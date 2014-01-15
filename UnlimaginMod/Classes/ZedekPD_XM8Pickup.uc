//=============================================================================
// XM8, from a CS:S mod.
//=============================================================================
class ZedekPD_XM8Pickup extends UM_BaseAssaultRiflePickup;

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
     cost=2000
     AmmoCost=10
     BuyClipSize=40
     PowerValue=24
     SpeedValue=90
     RangeValue=60
     Description="A compact XM8 military rifle."
     ItemName="XM8 Rifle"
     ItemShortName="XM8 Rifle"
     AmmoItemName="5.56 NATO Ammo"
     showMesh=SkeletalMesh'XM8_A.xm8_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.ZedekPD_XM8AssaultRifle'
     PickupMessage="You got the XM8 Rifle."
     PickupSound=Sound'XM8_Snd.xm8_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'XM8_SM.xm8_pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
