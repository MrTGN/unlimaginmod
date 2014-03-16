//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_UMP45Pickup extends UM_BaseSMGPickup;

defaultproperties
{
     Weight=4.000000
     cost=1300
     AmmoCost=12
     BuyClipSize=25
     PowerValue=45
     SpeedValue=60
     RangeValue=50
     Description="The UMP45 is a .45 ACP submachine gun developed and manufactured by Heckler & Koch."
     ItemName="HK UMP45"
     ItemShortName="UMP45"
     AmmoItemName=".45 ACP Ammo"
     //showMesh=SkeletalMesh'UMP45_A.ump45_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_UMP45SMG'
     PickupMessage="You got the HK UMP45"
     PickupSound=Sound'UMP45_Snd.ump45_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'UMP45_sm.ump45_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
