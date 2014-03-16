class Exod_PooSH_StingerMinigunPickup extends UM_BaseMachineGunPickup;

#exec OBJ LOAD FILE=Stinger_A.ukx
#exec OBJ LOAD FILE=Stinger_Snd.uax
#exec OBJ LOAD FILE=Stinger_SM.usx
#exec OBJ LOAD FILE=Stinger_T.utx

defaultproperties
{
     Weight=14.000000
     cost=5000
     AmmoCost=100
     BuyClipSize=150
     PowerValue=35
     SpeedValue=100
     RangeValue=40
     Description="Shut up and kill'em."
     ItemName="Stinger Minigun"
     ItemShortName="Stinger Minigun"
     AmmoItemName="5.56x45mm Ammo"
     //showMesh=SkeletalMesh'Stinger_A.SK_WP_Stinger_3P_Mid'
     AmmoMesh=StaticMesh'KillingFloorStatics.L85Ammo'
     CorrespondingPerkIndex=3
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.Exod_PooSH_StingerMinigun'
     PickupMessage="Its Time to Kill!"
     PickupSound=Sound'Stinger_Snd.Stinger.StingerTakeOut'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'Stinger_SM.UT3StingerPickup'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
