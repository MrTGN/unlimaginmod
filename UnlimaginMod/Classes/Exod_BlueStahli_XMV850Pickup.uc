//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Exod_BlueStahli_XMV850Pickup extends UM_BaseMachineGunPickup;

defaultproperties
{
     Weight=14.000000
     cost=6000
     AmmoCost=106
     BuyClipSize=160
     PowerValue=44
     SpeedValue=100
     RangeValue=50
     Description="Shut up and kill'em."
     ItemName="XMV850 Minigun"
     ItemShortName="XMV850"
     AmmoItemName="5.56x45mm Ammo"
     //showMesh=SkeletalMesh'XMV850_A.XMV850-3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.Exod_BlueStahli_XMV850Minigun'
     PickupMessage="Shut up and kill'em."
     PickupSound=Sound'XMV850_A.XMV-Pullout'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'XMV850_A.XMV850.XMV850Pickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
