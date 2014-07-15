//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM3Shotgun
//	Parent class:	 UM_BaseShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2013 18:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BenelliM3Shotgun extends UM_BaseShotgun;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'KF_Weapons_Trip.Shotgun_Trip'
	 MeshRef="KF_Weapons_Trip.Shotgun_Trip"
     //Skins(0)=Combiner'KF_Weapons_Trip_T.Shotguns.shotgun_cmb'
	 SkinRefs(0)="KF_Weapons_Trip_T.Shotguns.shotgun_cmb"
	 //SelectSound=Sound'KF_PumpSGSnd.SG_Select'
	 SelectSoundRef="KF_PumpSGSnd.SG_Select"
	 //HudImage=Texture'KillingFloorHUD.WeaponSelect.combat_shotgun_unselected'
	 HudImageRef="KillingFloorHUD.WeaponSelect.combat_shotgun_unselected"
     //SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.combat_shotgun'
	 SelectedHudImageRef="KillingFloorHUD.WeaponSelect.combat_shotgun"
	 //[end]
	 FirstPersonFlashlightOffset=(X=-25.000000,Y=-18.000000,Z=8.000000)
     MagCapacity=7
     ReloadRate=0.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=5.000000
     bTorchEnabled=True
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Combat_Shotgun'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_BenelliM3Fire'
     FireModeClass(1)=Class'KFMod.ShotgunLightFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="A rugged tactical pump action shotgun common to police divisions the world over. It accepts a maximum of 8 shells and can fire in rapid succession. "
     DisplayFOV=65.000000
     Priority=135
     InventoryGroup=3
     GroupOffset=2
     PickupClass=Class'UnlimaginMod.UM_BenelliM3Pickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-7.500000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.UM_BenelliM3Attachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Benelli M3"
     TransientSoundVolume=1.000000
}
