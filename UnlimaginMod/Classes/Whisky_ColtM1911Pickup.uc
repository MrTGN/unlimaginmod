//=============================================================================
// ColtPickup.
//=============================================================================
class Whisky_ColtM1911Pickup extends UM_BaseHandgunPickup;

defaultproperties
{
     Weight=2.000000
     cost=400
     AmmoCost=9
     BuyClipSize=7
     PowerValue=20
     SpeedValue=50
     RangeValue=35
     Description="A Colt handgun."
     ItemName="Colt M1911"
     ItemShortName="Colt M1911"
     AmmoItemName="45ACP Rounds"
     AmmoMesh=StaticMesh'KillingFloorStatics.DualiesAmmo'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=1
     InventoryType=Class'UnlimaginMod.Whisky_ColtM1911Pistol'
     PickupMessage="You got the Colt M1911"
     PickupSound=Sound'KF_9MMSnd.9mm_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'WM1911Pistol_SM.ColtPickup'
     CollisionHeight=5.000000
}
