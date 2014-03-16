//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// G36C Pickup class
// Made by FluX
// http://www.fluxiserver.co.uk
//===================================================================================
class FluX_G36CPickup extends KFWeaponPickup;

defaultproperties
{
     Weight=5.000000
     cost=1700
     AmmoCost=15
     BuyClipSize=30
     PowerValue=40
     SpeedValue=90
     RangeValue=70
     Description="The G36C is a German-made assault rifle manufactured by Heckler und Koch"
     ItemName="HK G36C"
     ItemShortName="G36C"
     AmmoItemName="5.56mm Ammo"
     //showMesh=SkeletalMesh'FX-G36C_v2_A.G36C_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.FluX_G36CAssaultRifle'
     PickupMessage="You got the G36C"
     PickupSound=Sound'KF_AK47Snd.AK47_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'FX-G36C_SM.G36C'
     DrawScale=1.400000
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
