//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_L22A1Carbine
//	Parent class:	 UM_BaseAssaultRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.06.2013 03:24
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_L22A1Carbine extends UM_BaseAssaultRifle;


#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax

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
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		// Case - burst fire
		if ( FireMode[0].bWaitForRelease && UM_L22A1Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Semi-Auto
			FireMode[0].bWaitForRelease = FireMode[0].bWaitForRelease;
			UM_L22A1Fire(FireMode[0]).bSetToBurst = !UM_L22A1Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',2);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		// Case - semi fire
		else if ( FireMode[0].bWaitForRelease && !UM_L22A1Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Auto
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			UM_L22A1Fire(FireMode[0]).bSetToBurst = UM_L22A1Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			// Switching to burst
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			UM_L22A1Fire(FireMode[0]).bSetToBurst = !UM_L22A1Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease, UM_L22A1Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease, bool bNewSetToBurst)
{
	FireMode[0].bWaitForRelease = bNewWaitForRelease;
	UM_L22A1Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

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

exec function SwitchModes()
{
	DoToggle();
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

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //Mesh=SkeletalMesh'KF_Weapons_Trip.Bullpup_Trip'
	 MeshRef="KF_Weapons_Trip.Bullpup_Trip"
     //Skins(0)=Combiner'KF_Weapons_Trip_T.Rifles.bullpup_cmb'
	 SkinRefs(0)="KF_Weapons_Trip_T.Rifles.bullpup_cmb"
     //Skins(1)=Shader'KF_Weapons_Trip_T.Rifles.reflex_sight_A_unlit'
	 SkinRefs(1)="KF_Weapons_Trip_T.Rifles.reflex_sight_A_unlit"
	 //SelectSound=Sound'KF_BullpupSnd.Bullpup_Select'
	 SelectSoundRef="KF_BullpupSnd.Bullpup_Select"
	 //HudImage=Texture'KillingFloorHUD.WeaponSelect.bullpup_unselected'
	 HudImageRef="KillingFloorHUD.WeaponSelect.bullpup_unselected"
     //SelectedHudImage=Texture'KillingFloorHUD.WeaponSelect.Bullpup'
	 SelectedHudImageRef="KillingFloorHUD.WeaponSelect.Bullpup"
	 //[end]
	 MagCapacity=30
     ReloadRate=2.03300
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_BullPup"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=70.000000
     bModeZeroCanDryFire=True
     SleeveNum=2
     TraderInfoTexture=Texture'KillingFloorHUD.Trader_Weapon_Images.Trader_Bullpup'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_L22A1Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A military grade automatic rifle. Can be fired in semi-auto, burst or full auto firemodes and comes equipped with a scope for increased accuracy."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=70.000000
     Priority=70
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.UM_L22A1Pickup'
     PlayerViewOffset=(X=20.000000,Y=21.500000,Z=-9.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.UM_L22A1Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="L22A1 (EOTech)"
     TransientSoundVolume=1.250000
}
