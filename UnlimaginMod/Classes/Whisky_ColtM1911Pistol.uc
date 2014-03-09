//=============================================================================
// Colt M1911
//=============================================================================
class Whisky_ColtM1911Pistol extends UM_BaseHandgun;

#exec obj load file="WM1911Pistol_T.utx"
#exec obj load file="UM_WM1911Pistol_A.ukx"
#exec obj load file="WM1911Pistol_SM.usx"

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'UM_WM1911Pistol_A.colt_mesh'
	 MeshRef="UM_WM1911Pistol_A.colt_mesh"
     //Skins(1)=Combiner'WM1911Pistol_T.Colt1911_cmb'
	 SkinRefs(1)="WM1911Pistol_T.Colt1911_cmb"
	 //SelectSound=Sound'KF_9MMSnd.9mm_Select'
	 SelectSoundRef="KF_9MMSnd.9mm_Select"
	 //HudImage=Texture'WM1911Pistol_T.HUD.1911_unselect'
	 HudImageRef="WM1911Pistol_T.HUD.1911_unselect"
	 //SelectedHudImage=Texture'WM1911Pistol_T.HUD.1911_select'
	 SelectedHudImageRef="WM1911Pistol_T.HUD.1911_select"
	 //[end]
	 EmptyIdleAimAnim="Idle_Empty"
	 EmptyIdleAnim="Idle_Empty"
	 TacticalReloadAnim=(Anim="Reload_Half",Rate=1.000000)
	 TacticalReloadRate=1.633330
     MagCapacity=7
     ReloadRate=1.633330
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Single9mm"
     Weight=2.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
	 TraderInfoTexture=Texture'WM1911Pistol_T.HUD.1911_trader'
     ZoomedDisplayFOV=65.000000
     FireModeClass(0)=Class'UnlimaginMod.Whisky_ColtM1911Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutAway"
     AIRating=0.250000
     CurrentRating=0.250000
     bShowChargingBar=True
     Description="A Colt M1911 Pistol"
     DisplayFOV=70.000000
     Priority=60
     InventoryGroup=2
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.Whisky_ColtM1911Pickup'
     PlayerViewOffset=(X=20.000000,Y=25.000000,Z=-10.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Whisky_ColtM1911Attachment'
     IconCoords=(X1=434,Y1=253,X2=506,Y2=292)
     ItemName="Colt M1911"
}
