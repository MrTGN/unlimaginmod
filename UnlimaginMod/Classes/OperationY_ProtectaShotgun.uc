class OperationY_ProtectaShotgun extends UM_BaseShotgun;

#exec OBJ LOAD FILE="Protecta_A.ukx"

function byte BestMode()
{
	return 0;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	local int Mode;
	local KFPlayerController Player;

	HandleSleeveSwapping();

	// Hint check
	Player = KFPlayerController(Instigator.Controller);

	if ( Player != none && ClientGrenadeState != GN_BringUp )
	{
		if ( class == class'OperationY_ProtectaShotgun' )
		{
			Player.CheckForHint(19);
			Player.WeaponPulloutRemark(23);
		}

		bShowPullOutHint = true;
	}

	if ( KFHumanPawn(Instigator) != none )
		KFHumanPawn(Instigator).SetAiming(false);

	bAimingRifle = false;
	bIsReloading = false;
	IdleAnim = default.IdleAnim;
	//Super.BringUp(PrevWeapon);

	// From Weapon.uc
    if ( ClientState == WS_Hidden || ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
	{
		PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

		if ( Instigator.IsLocallyControlled() )
		{
			if ( (Mesh!=None) && HasAnim(SelectAnim) )
			{
                if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
				{
					PlayAnim(SelectAnim, SelectAnimRate * (BringUpTime/QuickBringUpTime), 0.0);
				}
				else
				{
					PlayAnim(SelectAnim, SelectAnimRate, 0.0);
				}
			}
		}

		ClientState = WS_BringUp;
        if( ClientGrenadeState == GN_BringUp || KFPawn(Instigator).bIsQuickHealing > 0 )
		{
			ClientGrenadeState = GN_None;
			SetTimer(QuickBringUpTime, false);
		}
		else
		{
			SetTimer(BringUpTime, false);
		}
	}

	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}

	if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;
}

defaultproperties
{
	 bHasTacticalReload=False
	 //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'Protecta_A.Protecta_mesh'
	 MeshRef="Protecta_A.Protecta_mesh"
	 //Skins(0)=Combiner'Protecta_A.Protecta_tex_1_cmb'
	 SkinRefs(0)="Protecta_A.Protecta_tex_1_cmb"
     //Skins(1)=Combiner'Protecta_A.Protecta_tex_2_cmb'
	 SkinRefs(1)="Protecta_A.Protecta_tex_2_cmb"
     //Skins(2)=Combiner'Protecta_A.Protecta_tex_3_cmb'
	 SkinRefs(2)="Protecta_A.Protecta_tex_3_cmb"
     //Skins(3)=Combiner'KF_Weapons_Trip_T.hands.hands_1stP_military_cmb'
	 //SkinRefs(3)="KF_Weapons_Trip_T.hands.hands_1stP_military_cmb"
     //Skins(4)=Shader'KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr'
	 SkinRefs(4)="KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr"
	 //SelectSound=Sound'Protecta_A.striker_select'
	 SelectSoundRef="Protecta_A.striker_select"
	 //HudImage=Texture'Protecta_A.Protecta_Unselected'
	 HudImageRef="Protecta_A.Protecta_Unselected"
     //SelectedHudImage=Texture'Protecta_A.Protecta_selected'
	 SelectedHudImageRef="Protecta_A.Protecta_selected"
	 //[end]
	 MagCapacity=12
     ReloadRate=0.910000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Shotgun"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Iron_Idle"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     SleeveNum=3
     TraderInfoTexture=Texture'Protecta_A.Protecta_Trader'
     PlayerIronSightFOV=70.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.OperationY_ProtectaFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="Protecta - is a revolver 12-gauge shotgun designed for riot control and combat."
     DisplayFOV=65.000000
     Priority=199
     InventoryGroup=4
     GroupOffset=9
     PickupClass=Class'UnlimaginMod.OperationY_ProtectaPickup'
     PlayerViewOffset=(X=18.000000,Y=9.000000,Z=-5.000000)
     BobDamping=5.000000
     AttachmentClass=Class'UnlimaginMod.OperationY_ProtectaAttachment'
     IconCoords=(X1=169,Y1=172,X2=245,Y2=208)
     ItemName="Protecta"
     TransientSoundVolume=1.250000
}
