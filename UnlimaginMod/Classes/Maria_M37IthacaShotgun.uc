//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Maria_M37IthacaShotgun extends UM_BaseShotgun;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'FMX_Ithaca_A.Ithaca_Wep'
	 MeshRef="FMX_Ithaca_A.Ithaca_Wep"
     //Skins(0)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
	 SkinRefs(0)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     //Skins(1)=Combiner'FMX_Ithaca_T.Skin.M37_cmb'
	 SkinRefs(1)="FMX_Ithaca_T.Skin.M37_cmb"
     //Skins(2)=Combiner'FMX_Ithaca_T.Skin.Shellholder_cmb'
	 SkinRefs(2)="FMX_Ithaca_T.Skin.Shellholder_cmb"
     //Skins(3)=Combiner'FMX_Ithaca_T.Skin.12ga_cmb'
	 SkinRefs(3)="FMX_Ithaca_T.Skin.12ga_cmb"
     //Skins(4)=Combiner'FMX_Ithaca_T.Skin.Actionbar_cmb'
	 SkinRefs(4)="FMX_Ithaca_T.Skin.Actionbar_cmb"
	 //SelectSound=Sound'KF_PumpSGSnd.SG_Select'
	 SelectSoundRef="KF_PumpSGSnd.SG_Select"
	 //HudImage=Texture'FMX_Ithaca_T.Icons.Ithaca_unselected'
	 HudImageRef="FMX_Ithaca_T.Icons.Ithaca_unselected"
     //SelectedHudImage=Texture'FMX_Ithaca_T.Icons.Ithaca'
	 SelectedHudImageRef="FMX_Ithaca_T.Icons.Ithaca"
	 //[end]
	 //ForceZoomOutOnFireTime=0.010000
	 ForceZoomOutOnFireTime=0.000000
     MagCapacity=6
     ReloadRate=0.700000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'FMX_Ithaca_T.Icons.Ithaca_Trader'
     bIsTier2Weapon=True
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=50.000000
     FireModeClass(0)=Class'UnlimaginMod.Maria_M37IthacaFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="A pump-action shotgun made in large numbers for the civilian, military, and police markets. It utilizes a novel combination ejection/loading port on the bottom of the gun which leaves the sides closed to the elements. In addition, the outline of the gun is clean. Finally, since shells load and eject from the bottom, operation of the gun is equally convenient for both right and left hand shooters. This makes the gun popular with left-handed shooters."
     DisplayFOV=65.000000
     Priority=142
     InventoryGroup=3
     GroupOffset=14
     PickupClass=Class'UnlimaginMod.Maria_M37IthacaPickup'
     PlayerViewOffset=(X=20.000000,Y=18.750000,Z=-8.000000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.Maria_M37IthacaAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="M37 Ithaca Shotgun"
     TransientSoundVolume=1.000000
}
