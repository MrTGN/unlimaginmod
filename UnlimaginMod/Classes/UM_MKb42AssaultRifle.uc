//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MKb42AssaultRifle
//	Parent class:	 UM_BaseAssaultRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.06.2013 14:09
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MKb42AssaultRifle extends UM_BaseAssaultRifle;


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
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		
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
     ReloadRate=3.000000
	 //TODO: Οξκΰ νε οπξοθρϋβΰώ, θαξ ΰνθμΰφθÿ οεπεηΰπÿδκθ νε οξηβξλÿες νεηΰμεςνξ εΈ οπεπβΰςό.
	 // ΐβςξμΰς οπθ οεπεηΰπÿδκε ηΰδπΰν ββεπυ θ ασδες βθδνξ κΰκ ξν πεηκξ ξοσρςθςρÿ βνθη.
	 //TacticalReloadRate=
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M4"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_MKB42'
     bIsTier2Weapon=True
     MeshRef="KF_Wep_MKB42.MKB42"
     SkinRefs(0)="KF_Weapons8_Trip_T.Weapons.MKB42_cmb"
     SelectSoundRef="KF_AK47Snd.AK47_Select"
     HudImageRef="KillingFloor2HUD.WeaponSelect.MKB42_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.MKB42"
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=35.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_MKb42Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="German WWII prototype assault rifle. Used by heroes from the Battle of Stalingrad to the present day!"
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=115
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=13
     PickupClass=Class'UnlimaginMod.UM_MKb42Pickup'
     PlayerViewOffset=(X=20.000000,Y=18.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_MKb42Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="MKb42"
     TransientSoundVolume=1.250000
}
