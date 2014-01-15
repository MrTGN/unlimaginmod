//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM4Shotgun
//	Parent class:	 UM_BaseShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2013 18:28
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BenelliM4Shotgun extends UM_BaseShotgun;


defaultproperties
{
     MagCapacity=6
     //ReloadRate=0.900000
	 ReloadRate=0.750000	//(0.900000 / 1.20)
     ReloadAnim="Reload"
     //ReloadAnimRate=1.000000
	 ReloadAnimRate=1.200000	//(1.000000 * 1.20)
     WeaponReloadAnim="Reload_Shotgun"
     Weight=5.000000
     bTorchEnabled=True
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Beneli'
     bIsTier2Weapon=True
     MeshRef="KF_Wep_Benelli.Benelli_Trip"
     SkinRefs(0)="KF_Weapons4_Trip_T.Weapons.Benelli_M4_cmb"
     SkinRefs(1)="KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr"
     SelectSoundRef="KF_M4ShotgunSnd.WEP_Benelli_Foley_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Beneli_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Beneli"
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_BenelliM4Fire'
     FireModeClass(1)=Class'KFMod.ShotgunLightFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="A military tactical shotgun with semi automatic fire capability. Holds up to 6 shells. "
     DisplayFOV=65.000000
     Priority=170
     InventoryGroup=3
     GroupOffset=9
     PickupClass=Class'UnlimaginMod.UM_BenelliM4Pickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-7.500000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.UM_BenelliM4Attachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Benelli M4"
     TransientSoundVolume=1.000000
}
