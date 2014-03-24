//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12AutoShotgun
//	Parent class:	 AA12AutoShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 23.04.2013 00:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_AA12AutoShotgun extends UM_BaseMagShotgun;


replication
{
	reliable if ( Role < ROLE_Authority )
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
	if ( Player != None )
	{
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSoundData(ModeSwitchSound);
		
		FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
		if ( FireMode[0].bWaitForRelease )
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',1);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		else
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.OperationY_HK417SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease)
{
    FireMode[0].bWaitForRelease = bNewWaitForRelease;
}

exec function SwitchModes()
{
	DoToggle();
}

defaultproperties
{
	 MagCapacity=20
     ReloadRate=3.133000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_AA12"
	 Weight=8.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_AA12'
     bIsTier3Weapon=True
     MeshRef="KF_Weapons2_Trip.AA12_Trip"
     SkinRefs(0)="KF_Weapons2_Trip_T.Special.AA12_cmb"
     SelectSoundRef="KF_AA12Snd.AA12_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.AA12_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.AA12"
     PlayerIronSightFOV=80.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_AA12Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="An advanced automatic shotgun. Fires steel ball shot in semi or full auto."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=200
     InventoryGroup=4
     GroupOffset=10
     PickupClass=Class'UnlimaginMod.UM_AA12Pickup'
     PlayerViewOffset=(X=25.000000,Y=20.000000,Z=-2.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_AA12Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="AA12"
     TransientSoundVolume=1.250000
}
