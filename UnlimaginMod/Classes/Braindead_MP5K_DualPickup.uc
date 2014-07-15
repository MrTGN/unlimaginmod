//=============================================================================
// Dual MP5K Pickup.
//=============================================================================
class Braindead_MP5K_DualPickup extends UM_BaseSMGPickup;

defaultproperties
{
     Weight=6.000000
     cost=1200
	 AmmoCost=24
     BuyClipSize=60
     PowerValue=35
     SpeedValue=85
     RangeValue=35
     Description="A pair of MP5K Sub Machine Guns."
     ItemName="Dual MP5K"
     ItemShortName="Dual MP5K"
     AmmoItemName="9mm Rounds"
     //showMesh=SkeletalMesh'BD_FL_MP5_A.MP5K'
     AmmoMesh=StaticMesh'KillingFloorStatics.DualiesAmmo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=1
     InventoryType=Class'UnlimaginMod.Braindead_MP5K_Dual'
     PickupMessage="You found a pair of MP5Ks"
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'BD_MP5_SM.MP5SK_Pickup'
     CollisionHeight=5.000000
}
