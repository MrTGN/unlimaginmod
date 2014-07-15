//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Trenchgun
//	Parent class:	 UM_BaseShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2013 19:01
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_Trenchgun extends UM_BaseShotgun;


defaultproperties
{
     MagCapacity=6
     ReloadRate=0.700000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_TrenchGun'
     bIsTier2Weapon=True
     MeshRef="KF_Wep_TrenchGun.TrenchGun"
     SkinRefs(0)="KF_Weapons8_Trip_T.Weapons.Trenchgun_cmb"
     SelectSoundRef="KF_PumpSGSnd.SG_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.TrenchGun_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.TrenchGun"
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_TrenchgunFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="A WWII-era trench shotgun in 12 gauge, loaded with Dragon's Breath flame rounds. Toasty."
     DisplayFOV=65.000000
     Priority=142
     InventoryGroup=3
     GroupOffset=14
     PickupClass=Class'UnlimaginMod.UM_TrenchgunPickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-8.000000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.UM_TrenchgunAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Winchester Model 1897"
     TransientSoundVolume=1.000000
}
