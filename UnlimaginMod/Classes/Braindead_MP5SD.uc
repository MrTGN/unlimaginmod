//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// Shotgun Inventory class
//=============================================================================
class Braindead_MP5SD extends UM_BaseSMG;

//#exec obj load File=..\Textures\BD_MP5_FL_T.utx
#exec obj load File=BD_MP5_FL_T.utx
//#exec OBJ LOAD FILE=..\animations\BD_FL_MP5_A.ukx
#exec OBJ LOAD FILE=BD_FL_MP5_A.ukx
//#exec obj Load File=..\Sounds\KF_MP5Snd.uax
#exec obj Load File=KF_MP5Snd.uax
//#exec obj Load File=..\Sounds\BD_MP5SD_S.uax
#exec obj Load File=BD_MP5SD_S.uax

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

simulated event PostBeginPlay()
{
	ItemName = default.ItemName $ " [Auto]";
	
	Super.PostBeginPlay();
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}	

// Toggle semi/auto fire
simulated function DoToggle()
{
	local PlayerController Player;
	
	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		// Case - burst fire
		if ( FireMode[0].bWaitForRelease && Braindead_MP5SDFire(FireMode[0]).bSetToBurst )
		{
			// Switching to Semi-Auto
			FireMode[0].bWaitForRelease = FireMode[0].bWaitForRelease;
			Braindead_MP5SDFire(FireMode[0]).bSetToBurst = !Braindead_MP5SDFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',2);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		// Case - semi fire
		else if ( FireMode[0].bWaitForRelease && !Braindead_MP5SDFire(FireMode[0]).bSetToBurst )
		{
			// Switching to Auto
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			Braindead_MP5SDFire(FireMode[0]).bSetToBurst = Braindead_MP5SDFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			// Switching to burst
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			Braindead_MP5SDFire(FireMode[0]).bSetToBurst = !Braindead_MP5SDFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	UM_ServerChangeFireMode(FireMode[0].bWaitForRelease, Braindead_MP5SDFire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease, bool bNewSetToBurst)
{
	FireMode[0].bWaitForRelease = bNewWaitForRelease;
	Braindead_MP5SDFire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

exec function SwitchModes()
{
	DoToggle();
}

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'BD_FL_MP5_A.MP5SDWeapon'
	 MeshRef="BD_FL_MP5_A.MP5SDWeapon"
     //Skins(0)=Combiner'BD_MP5_FL_T.MP5SD_Env_cmb'
     //Skins(2)=Combiner'BD_MP5_FL_T.MP5SD_Env_cmb'
	 SkinRefs(0)="BD_MP5_FL_T.MP5SD_Env_cmb"
	 SkinRefs(2)="BD_MP5_FL_T.MP5SD_Env_cmb"
	 //SelectSound=Sound'KF_MP5Snd.foley.WEP_MP5_Foley_Select'
	 SelectSoundRef="KF_MP5Snd.foley.WEP_MP5_Foley_Select"
	 //HudImage=Texture'BD_MP5_FL_T.HUD.MP5SD_unselected'
	 HudImageRef="BD_MP5_FL_T.HUD.MP5SD_unselected"
     //SelectedHudImage=Texture'BD_MP5_FL_T.HUD.MP5SD_selected'
	 SelectedHudImageRef="BD_MP5_FL_T.HUD.MP5SD_selected"
	 //[end]
	 FirstPersonFlashlightOffset=(X=-25.000000,Y=-2.000000,Z=8.000000)
     MagCapacity=32
     ReloadRate=3.800000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_MP5"
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'BD_MP5_FL_T.HUD.MP5SD_Trader'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.Braindead_MP5SDFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="MP5 sub machine gun with suppressor"
     DisplayFOV=55.000000
     Priority=90
     InventoryGroup=3
     GroupOffset=2
     PickupClass=Class'UnlimaginMod.Braindead_MP5SDPickup'
     PlayerViewOffset=(X=29.000000,Y=18.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Braindead_MP5SDAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="MP5SD"
     LightType=LT_None
     LightBrightness=0.000000
     LightRadius=0.000000
     TransientSoundVolume=1.800000
}
