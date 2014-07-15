//===================================================================================
// Hunting_Rifle Pickup.
//===================================================================================
class Braindead_HuntingRiflePickup extends UM_BaseSniperRiflePickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=7.000000
     cost=1360
     AmmoCost=36
	 BuyClipSize=10
     PowerValue=55
     SpeedValue=42
     RangeValue=95
     Description="Bolt-action rifle manufactured by Remington Arms. Caliber .338 Lapua Magnum"
     ItemName="Remington 700"
     ItemShortName="Remington 700"
     AmmoItemName=".338 Lapua Magnum bullets"
     //showMesh=SkeletalMesh'HuntingRifleA.HuntingRifle3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.Braindead_HuntingRifle'
     PickupMessage="You got the Remington 700"
     PickupSound=Sound'KF_RifleSnd.RifleBase.Rifle_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'HuntingRifleS.HR_Pickup'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
