//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_HK417Pickup extends UM_BaseBattleRiflePickup;

/*
function ShowDeagleInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KillingfloorHUD.ClassMenu.Deagle', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=6.000000
     cost=3000
     BuyClipSize=20
	 AmmoCost=48
     PowerValue=60
     SpeedValue=30
     RangeValue=95
     Description="Sniper variant of gas-operated, selective fire Battle Rifle by Heckler & Koch with 20 inch barrel."
     ItemName="HK417 Sniper Rifle"
     ItemShortName="HK417"
     AmmoItemName="7.62x51mm NATO"
     //showMesh=SkeletalMesh'HK417_A.HK417_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_HK417BattleRifle'
     PickupMessage="You got the HK417 Sniper Rifle"
     PickupSound=Sound'HK417_A.HK417_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'HK417_A.HK417_st'
	 DrawScale=0.8
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
