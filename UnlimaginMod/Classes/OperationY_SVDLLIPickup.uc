//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_SVDLLIPickup extends UM_BaseSniperRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=2800
     BuyClipSize=10
	 AmmoCost=45
     PowerValue=80
     SpeedValue=40
     RangeValue=100
     Description="The Dragunov sniper rifle is a semi-automatic sniper rifle chambered in 7.62x54mmR and developed in the Soviet Union."
     ItemName="SVD"
     ItemShortName="SVD"
     AmmoItemName="7.62x54mmR Rounds"
     //showMesh=SkeletalMesh'SVDLLI_A.SVDLLI_3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_SVDLLI'
     PickupMessage="You got the SVD"
     PickupSound=Sound'SVDLLI_A.SVDLLI_Snd.SVDLLI_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'SVDLLI_A.SVDLLI_st'
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
