class OperationY_VSSDTPickup extends UM_BaseAutomaticSniperRiflePickup;

defaultproperties
{
     Weight=5.000000
     cost=2500
     BuyClipSize=20
	 AmmoCost=32
     PowerValue=80
     SpeedValue=40
     RangeValue=100
     Description="Atomatic suppressed sniper rifle developed in the late 1980s by TsNIITochMash and manufactured by the Tula Arsenal."
     ItemName="VSS Vintorez"
     ItemShortName="VSS"
     AmmoItemName="9x39mm SP-5 bullets"
     showMesh=SkeletalMesh'VSSDT_v2_A.vintorezDT3rd'
     CorrespondingPerkIndex=2
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_VSSDT'
     PickupMessage="You got the VSS Vintorez"
     PickupSound=Sound'KF_RifleSnd.RifleBase.Rifle_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'VSSDT_v2_A.vintorezDT_sm'
	 DrawScale=1.200000
     CollisionRadius=30.000000
     CollisionHeight=5.000000
}
