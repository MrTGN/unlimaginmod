//===================================================================================
// L85A2 Pickup
//===================================================================================
class JSullivan_L85A2Pickup extends UM_BaseAssaultRiflePickup;

defaultproperties
{
     Weight=6.000000
     cost=1200
     AmmoCost=16
     BuyClipSize=30
     PowerValue=45
     SpeedValue=60
     RangeValue=70
     Description="It is a 5.56mm selective fire, gas-operated assault rifle with SUSAT sight."
     ItemName="L85A2 (SUSAT)"
     ItemShortName="L85A2 (SUSAT)"
     AmmoItemName="5.556x45mm Ammo"
     showMesh=SkeletalMesh'JS_L85A2_3rd.L85A2_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.JSullivan_L85A2AssaultRifle'
     PickupMessage="You got the L85A2 (SUSAT)"
     PickupSound=Sound'KF_FNFALSnd.FNFAL_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'JS_L85A2_M.Rifle.L85A2_Static'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
