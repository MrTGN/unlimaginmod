class OperationY_UMP45EOTechPickup extends UM_BaseSMGPickup;


defaultproperties
{
     Weight=5.000000
     cost=1800
     AmmoCost=12
     BuyClipSize=25
     PowerValue=45
     SpeedValue=60
     RangeValue=50
     Description="The UMP45 EOTech is a .45 ACP submachine gun with EOTech holographic sight developed and manufactured by Heckler & Koch."
     ItemName="HK UMP45 EOTech"
     ItemShortName="UMP45 EOT"
     AmmoItemName=".45 ACP Ammo"
     //showMesh=SkeletalMesh'UMP45LLI_A.UMP45LLI_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.OperationY_UMP45EOTech'
     PickupMessage="You got the HK UMP45 EOTech"
     PickupSound=Sound'UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'UMP45LLI_A.UMP45LLI_st'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
