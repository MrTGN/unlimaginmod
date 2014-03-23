//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// UnlimaginMod - Maria_M16A4_IronSight
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_IronSight extends UM_BaseAssaultRifle
	config(user);

#exec OBJ LOAD FILE=M16A4Rifle_A.ukx
#exec OBJ LOAD FILE=M16A4Rifle_SM.usx
#exec OBJ LOAD FILE=M16A4Rifle_T.utx

var bool bWasClipEmpty;

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	ItemName = default.ItemName $ " [Auto]";
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

function bool RecommendRangedAttack()
{
	return true;
}


function bool RecommendLongRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
	return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	return AIRating;
}

function byte BestMode()
{
	return 0;
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 Mesh=SkeletalMesh'M16A4Rifle_A.M16A4_IronSight_1st'
	 //MeshRef="M16A4Rifle_A.M16A4_IronSight_1st"
     Skins(0)=Texture'M16A4Rifle_T.M16A4.00_Receiver'
	 //SkinRefs(0)="M16A4Rifle_T.M16A4.00_Receiver"
     Skins(2)=Texture'M16A4Rifle_T.M16A4.02_Foreend'
	 //SkinRefs(2)="M16A4Rifle_T.M16A4.02_Foreend"
     Skins(3)=Texture'M16A4Rifle_T.M16A4.03_Heatshield'
	 //SkinRefs(3)="M16A4Rifle_T.M16A4.03_Heatshield"
     Skins(4)=Texture'M16A4Rifle_T.M16A4.04_Stocks'
	 //SkinRefs(4)="M16A4Rifle_T.M16A4.04_Stocks"
     Skins(5)=Texture'M16A4Rifle_T.M16A4.05_30rndMag'
	 //SkinRefs(5)="M16A4Rifle_T.M16A4.05_30rndMag"
     Skins(6)=Texture'M16A4Rifle_T.M16A4.06_IronSights'
     //SkinRefs(6)="M16A4Rifle_T.M16A4.06_IronSights"
     SelectSound=Sound'KF_M4RifleSnd.foley.WEP_M4_Foley_Select'
	 //SelectSoundRef="KF_M4RifleSnd.foley.WEP_M4_Foley_Select"
	 HudImage=Texture'M16A4Rifle_T.ui.M16A4_IronSight_Unselected'
	 //HudImageRef="M16A4Rifle_T.ui.M16A4_IronSight_Unselected"
     SelectedHudImage=Texture'M16A4Rifle_T.ui.M16A4_IronSight_Selected'
     //SelectedHudImageRef="M16A4Rifle_T.ui.M16A4_IronSight_Selected"
	 //[end]
	 MagCapacity=30
     ReloadRate=3.633300
	 TacticalReloadTime=2.455000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M4"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
	 SleeveNum=2
     TraderInfoTexture=Texture'M16A4Rifle_T.ui.M16A4_IronSight_Trader'
	 PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.Maria_M16A4_IronSightFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A 5.56mm, air-cooled, direct-gas operated, magazine-fed rifle, with a rotating bolt. The M16A4 MWS is the primary Infantry rifle of the US Army."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=135
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=10
     PickupClass=Class'UnlimaginMod.Maria_M16A4_IronSightPickup'
     PlayerViewOffset=(X=25.000000,Y=20.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Maria_M16A4_IronSightAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="M16A3"
     TransientSoundVolume=1.250000
}
