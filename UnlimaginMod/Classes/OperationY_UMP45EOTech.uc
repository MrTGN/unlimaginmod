class OperationY_UMP45EOTech extends OperationY_UMP45SMG;

#exec OBJ LOAD FILE="UMP45LLI_A.ukx"

simulated function Notify_ShowBullets()
{
	local	int		AvailableAmmo;
	
	AvailableAmmo = AmmoAmount(0);

	if ( AvailableAmmo == 0 )
		SetBoneScale (0, 0.0, 'BulletsLLI');
	else
		SetBoneScale (0, 1.0, 'BulletsLLI');
}

simulated function Notify_HideBullets()
{
	if ( MagAmmoRemaining <= 0 )
		SetBoneScale (0, 0.0, 'BulletsLLI');
}

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'UMP45LLI_A.UMP45LLI_mesh'
	 MeshRef="UMP45LLI_A.UMP45LLI_mesh"
     //Skins(0)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_1_cmb'
	 SkinRefs(0)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_1_cmb"
     //Skins(1)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_2_cmb'
	 SkinRefs(1)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_2_cmb"
     //Skins(2)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_3_cmb'
	 SkinRefs(2)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_3_cmb"
     //Skins(3)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_4_cmb'
	 SkinRefs(3)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_4_cmb"
     //Skins(4)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_5_cmb'
	 SkinRefs(4)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_5_cmb"
     //Skins(5)=Combiner'UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_6_cmb'
	 SkinRefs(5)="UMP45LLI_A.UMP45LLI_T.UMP45LLI_tex_6_cmb"
     //Skins(6)=Shader'KF_Weapons_Trip_T.Rifles.reflex_sight_A_unlit'
	 SkinRefs(6)="KF_Weapons_Trip_T.Rifles.reflex_sight_A_unlit"
     //Skins(7)=Texture'KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P'
	 //SkinRefs(7)="KF_Weapons3_Trip_T.hands.Priest_Hands_1st_P"
	 //SelectSound=Sound'UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_select'
	 SelectSoundRef="UMP45LLI_A.UMP45LLI_Snd.UMP45LLI_select"
	 //HudImage=Texture'UMP45LLI_A.UMP45LLI_T.UMP45LLI_Unselected'
	 HudImageRef="UMP45LLI_A.UMP45LLI_T.UMP45LLI_Unselected"
     //SelectedHudImage=Texture'UMP45LLI_A.UMP45LLI_T.UMP45LLI_selected'
	 SelectedHudImageRef="UMP45LLI_A.UMP45LLI_T.UMP45LLI_selected"
	 //[end]
	 TacticalReloadAnim="Reload_LLIePLLIeHb"
     //TacticalReloadRate=2.880000
	 //TacticalReloadRate=2.880000 / 1.25 = 2.304000
	 TacticalReloadRate=2.304000
	 MagCapacity=25
	 //ReloadRate=3.560000
	 //ReloadRate=3.560000 / 1.25 = 2.848000
     ReloadRate=2.848000
	 ReloadAnim="Reload"
	 //ReloadAnimRate=1.000000
	 //ReloadAnimRate=1.000000 * 1.25 = 1.250000
     ReloadAnimRate=1.250000
     WeaponReloadAnim="Reload_SCAR"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=7
     TraderInfoTexture=Texture'UMP45LLI_A.UMP45LLI_T.UMP45LLI_Trader'
     bIsTier2Weapon=True
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.OperationY_UMP45EOTechFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectAnimRate=1.300000
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The UMP45 EOTech is a .45 ACP submachine gun with EOTech holographic sight developed and manufactured by Heckler & Koch."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=145
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'UnlimaginMod.OperationY_UMP45EOTechPickup'
     PlayerViewOffset=(X=5.500000,Y=20.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_UMP45EOTechAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="HK UMP45 (EOTech, Foregrip)"
     TransientSoundVolume=1.250000
}
