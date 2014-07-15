//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_V94Pickup extends UM_BaseSniperRiflePickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=12.000000
     cost=4600
     BuyClipSize=5
	 AmmoCost=250
     PowerValue=100
     SpeedValue=40
     RangeValue=100
     Description="Russian large calibre semi-automatic sniper rifle chambered for the 12.7 x 108 mm round."
     ItemName="V-94"
     ItemShortName="V-94"
     AmmoItemName="12.7 x 108 mm round"
     //showMesh=SkeletalMesh'B94_A.b94mesh_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_V94SniperRifle'
     PickupMessage="You got the V-94"
     PickupSound=Sound'B94_SN.holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'B94_SM.B94static'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
