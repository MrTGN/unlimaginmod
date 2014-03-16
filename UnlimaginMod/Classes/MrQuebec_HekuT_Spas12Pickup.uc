//=============================================================================
// Shotgun Pickup.
//=============================================================================
class MrQuebec_HekuT_Spas12Pickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=6.000000
     cost=900
     BuyClipSize=8
	 AmmoCost=15
     PowerValue=55
     SpeedValue=40
     RangeValue=17
     Description="Pump-action and gas-actuated shotgun manufactured by Italian firearms company Franchi from 1979 to 2000."
     ItemName="Spas-12"
     ItemShortName="Spas-12"
     AmmoItemName="12-gauge shells"
     //showMesh=SkeletalMesh'Spas_A.spas12_3rd'
     CorrespondingPerkIndex=1
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.MrQuebec_HekuT_Spas12Shotgun'
     PickupMessage="You got the spas-12."
     PickupSound=Sound'KF_PumpSGSnd.SG_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Spas_SM.Spas12'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
