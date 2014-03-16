class OperationY_VALDTPickup extends UM_BaseAssaultRiflePickup;

defaultproperties
{
     Weight=4.000000
     cost=2000
     AmmoCost=10
     BuyClipSize=20
     PowerValue=50
     SpeedValue=95
     RangeValue=50
     Description="The AS Val is a Soviet designed assault rifle featuring an integrated suppressor."
     ItemName="AS Val"
     ItemShortName="AS Val"
     AmmoItemName="Bullets 9x39mm SP5"
     //showMesh=SkeletalMesh'VALDT_v2_A.ValDT3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_VALDTAssaultRifle'
     PickupMessage="You got the AS Val"
     PickupSound=Sound'KF_AK47Snd.AK47_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'VALDT_v2_A.ValDT_sm'
     DrawScale=1.300000
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
