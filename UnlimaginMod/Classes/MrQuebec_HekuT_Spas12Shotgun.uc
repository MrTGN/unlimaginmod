//=============================================================================
// Shotgun Inventory class
//=============================================================================
class MrQuebec_HekuT_Spas12Shotgun extends UM_BaseShotgun;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'Spas_A.Shotgun_Trip'
	 MeshRef="Spas_A.Shotgun_Trip"
	 //Skins(0)=Combiner'Spas_T.shotgun_cmb'
	 SkinRefs(0)="Spas_T.shotgun_cmb"
	 //SelectSound=Sound'KF_PumpSGSnd.SG_Select'
	 SelectSoundRef="KF_PumpSGSnd.SG_Select"
	 //HudImage=Texture'Spas_T.Spas_Unselect'
	 HudImageRef="Spas_T.Spas_Unselect"
     //SelectedHudImage=Texture'Spas_T.Spas_Select'
	 SelectedHudImageRef="Spas_T.Spas_Select"
	 //[end]
	 FirstPersonFlashlightOffset=(X=-25.000000,Y=-18.000000,Z=8.000000)
     ForceZoomOutOnFireTime=0.000000
     MagCapacity=8
     ReloadRate=0.666667
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=6.000000
     bTorchEnabled=True
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'Spas_T.Spas_Shop'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.MrQuebec_HekuT_Spas12Fire'
     FireModeClass(1)=Class'KFMod.ShotgunLightFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="Pump-action and gas-actuated shotgun manufactured by Italian firearms company Franchi from 1979 to 2000."
     DisplayFOV=65.000000
     Priority=140
     InventoryGroup=3
     GroupOffset=2
     PickupClass=Class'UnlimaginMod.MrQuebec_HekuT_Spas12Pickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-7.500000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.MrQuebec_HekuT_Spas12Attachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Spas-12"
     TransientSoundVolume=1.000000
}
