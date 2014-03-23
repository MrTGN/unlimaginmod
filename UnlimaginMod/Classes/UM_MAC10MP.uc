//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10MP
//	Parent class:	 UM_BaseSMG
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.06.2013 02:49
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MAC10MP extends UM_BaseSMG;

#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax

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
		// Case - semi fire
		if ( !FireMode[0].bWaitForRelease )
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.ZedekPD_XM8SwitchMessage',1);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.ZedekPD_XM8SwitchMessage',0);
			ItemName = default.ItemName $ " [Semi-Auto]";
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

exec function SwitchModes()
{
	DoToggle();
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

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local color   clr;
	local Color   fog;

	clr.R = 255;
	clr.G = 255;
	clr.B = 255;
	clr.A = 255;

	if( Instigator.Region.Zone.bDistanceFog )
	{
		fog = Instigator.Region.Zone.DistanceFogColor;
		val = 0;
		val = Max( val, fog.R);
		val = Max( val, fog.G);
		val = Max( val, fog.B);
		if( val > 128 )
		{
			val -= 128;
			clr.R -= val;
			clr.G -= val;
			clr.B -= val;
		}
	}
	c.DrawColor = clr;
}


defaultproperties
{
     MagCapacity=30
     ReloadRate=3.340000
	 TacticalReloadTime=2.160000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Mac10"
     Weight=4.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Mac_10'
     bIsTier2Weapon=True
     MeshRef="KF_Weapons2_Trip.Mac10_Trip"
     SkinRefs(0)="KF_Weapons2_Trip_T.Special.MAC10_cmb"
     SkinRefs(1)="KF_Weapons2_Trip_T.Special.MAC10_SIL_cmb"
     SelectSoundRef="KF_MAC10MPSnd.MAC10_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Mac_10_Unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Mac_10"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_MAC10Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A highly compact machine pistol. Can be fired in semi or full auto."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=75
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=6
     PickupClass=Class'UnlimaginMod.UM_MAC10Pickup'
     PlayerViewOffset=(X=25.000000,Y=20.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_MAC10Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="MAC-10"
     TransientSoundVolume=1.250000
}
