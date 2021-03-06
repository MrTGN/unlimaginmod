//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ThompsonM4A1SMG
//	Parent class:	 UM_BaseSMG
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 23.05.2013 23:01
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Thompson SMG M1A1
//================================================================================
class UM_ThompsonM4A1SMG extends UM_BaseSMG;

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax

//========================================================================
//[block] Replication

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	ItemName = default.ItemName $ " [Auto]";
}

//[block] Switching Fire Modes
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
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		
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

exec function SwitchModes()
{
	DoToggle();
}
//[end]

function bool RecommendRangedAttack()
{
	Return True;
}


function bool RecommendLongRangedAttack()
{
	Return True;
}

function float SuggestAttackStyle()
{
	Return -1.0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		Return AIRating;

	Return AIRating;
}

function byte BestMode()
{
	Return 0;
}

simulated function SetZoomBlendColor(Canvas c)
{
	local Byte    val;
	local Color   clr;
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

//[end] Functions
//====================================================================

defaultproperties
{
     MagCapacity=30
     ReloadRate=3.600000
	 TacticalReloadTime=2.400000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_Thompson"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KF_IJC_HUD.Trader_Weapon_Icons.Trader_Thompson'
     bIsTier2Weapon=True
     MeshRef="KF_IJC_Halloween_Weps3.Thompson"
     SkinRefs(0)="KF_IJC_Halloween_Weapons.Thompson.thompson_cmb"
     SelectSoundRef="KF_IJC_HalloweenSnd.Thompson_Handling_Bolt_Back"
     HudImageRef="KF_IJC_HUD.WeaponSelect.Thompson_unselected"
     SelectedHudImageRef="KF_IJC_HUD.WeaponSelect.Thompson"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_ThompsonM4A1Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The Thompson sub-machine gun. An absolute classic of design and functionality, beloved by soldiers and gangsters for decades!"
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=55.000000
     Priority=120
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=16
     PickupClass=Class'UnlimaginMod.UM_ThompsonM4A1Pickup'
     PlayerViewOffset=(X=10.000000,Y=16.000000,Z=-7.000000)
     BobDamping=4.000000
     AttachmentClass=Class'UnlimaginMod.UM_ThompsonM4A1SMGAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Thompson SMG M1A1"
     TransientSoundVolume=1.250000
}