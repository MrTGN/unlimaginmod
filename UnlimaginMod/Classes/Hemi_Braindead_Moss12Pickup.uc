//===================================================================================
// Shotgun Pickup.
//===================================================================================
class Hemi_Braindead_Moss12Pickup extends UM_BaseShotgunPickup;

/*
function ShowShotgunInfo(Canvas C)
{
  C.SetPos((C.SizeX - C.SizeY) / 2,0);
  C.DrawTile( Texture'KF_Moss12.Trader_Moss12.Trader_Moss12', C.SizeY, C.SizeY, 0.0, 0.0, 256, 256);
}
*/

defaultproperties
{
     Weight=5.000000
     cost=700
     BuyClipSize=7
     PowerValue=70
     SpeedValue=40
     RangeValue=15
     Description="Nathan Drake's favorite shotgun is ready for combat. "
     ItemName="Mossberg 500"
     ItemShortName="Moss500"
     AmmoItemName="12-gauge shells"
     showMesh=SkeletalMesh'KF_Moss12Anims.Moss12_3rd'
     CorrespondingPerkIndex=1
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.Hemi_Braindead_Moss12Shotgun'
     PickupMessage="You got the Mossberg 500."
     PickupSound=Sound'KF_Moss12Snd.SG_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_Moss12_pickups.KF_Moss12'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
