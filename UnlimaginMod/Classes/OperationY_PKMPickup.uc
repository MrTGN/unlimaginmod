//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_PKMPickup extends UM_BaseMachineGunPickup;

defaultproperties
{
     Weight=14.000000
     cost=4800
     AmmoCost=200
     BuyClipSize=100
     PowerValue=43
     SpeedValue=80
     RangeValue=50
     Description="7.62x54mmR general-purpose machine gun designed in the Soviet Union and currently in production in Russia."
     ItemName="PKM"
     ItemShortName="PKM"
     AmmoItemName="7.62x54mmR Ammo"
     showMesh=SkeletalMesh'Pkm_A.pkm3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_PKM'
     PickupMessage="You got the PKM"
     PickupSound=Sound'PKM_SN.pkm_holster'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Pkm_SM.Rifle.PkmSM'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
