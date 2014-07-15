//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Moss12 Inventory class
//===================================================================================
class Hemi_Braindead_Moss12Shotgun extends UM_BaseShotgun;

//#exec OBJ LOAD FILE=..\textures\KF_Moss12.utx
#exec OBJ LOAD FILE=KF_Moss12.utx

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'KF_Moss12Anims.Moss12Weapon'
	 MeshRef="KF_Moss12Anims.Moss12Weapon"
     //Skins(0)=Combiner'KF_Moss12.Moss12.Moss12_2048x2048'
	 SkinRefs(0)="KF_Moss12.Moss12.Moss12_2048x2048"
	 //SelectSound=Sound'KF_Moss12Snd.SG_Select'
	 SelectSoundRef="KF_Moss12Snd.SG_Select"
	 //HudImage=Texture'KF_Moss12.Trader_Moss12.Trader_Moss12_unselected'
	 HudImageRef="KF_Moss12.Trader_Moss12.Trader_Moss12_unselected"
     //SelectedHudImage=Texture'KF_Moss12.Trader_Moss12.Trader_Moss12_selected'
	 SelectedHudImageRef="KF_Moss12.Trader_Moss12.Trader_Moss12_selected"
	 //[end]
	 FirstPersonFlashlightOffset=(X=-25.000000,Y=-18.000000,Z=8.000000)
	 ForceZoomOutOnFireTime=0.000000
     MagCapacity=7
	 // ReloadRate = 0.666667 / 1.10 = 0.606060
	 ReloadRate=0.606060
     ReloadAnim="Reload"
	 // ReloadAnimRate = 0.875000 * 1.10 = 0.962500
     //ReloadAnimRate=0.880000
	 ReloadAnimRate=0.962500
     WeaponReloadAnim="Reload_Shotgun"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="IronSight_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'KF_Moss12.Trader_Moss12.Trader_Moss12'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.Hemi_Braindead_Moss12Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     SelectAnim="Raise"
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     Description="Nathan Drake's favorite shotgun is ready for combat."
     DisplayFOV=65.000000
     Priority=15
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.Hemi_Braindead_Moss12Pickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-7.500000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.Hemi_Braindead_Moss12Attachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Mossberg 500"
     TransientSoundVolume=1.000000
}
