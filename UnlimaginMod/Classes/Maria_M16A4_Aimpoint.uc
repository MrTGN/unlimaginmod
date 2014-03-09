//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// UnlimaginMod - Maria_M16A4_Aimpoint
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_Aimpoint extends UM_BaseAssaultRifle
	config(user);

#exec OBJ LOAD FILE=M16A4Rifle_A.ukx
#exec OBJ LOAD FILE=M16A4Rifle_SM.usx
#exec OBJ LOAD FILE=M16A4Rifle_T.utx

var bool bWasClipEmpty;

//var bool bToggling;
var array<string> ToggleKeyNames,ToggleKeyNamesL;

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	ItemName = default.ItemName $ " [Burst]";
}

// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	if ( !FireMode[0].bIsFiring && !bIsReloading )
		DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
	local PlayerController Player;
	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		
		Maria_M16A4_AimpointFire(FireMode[0]).bSetToBurst = !Maria_M16A4_AimpointFire(FireMode[0]).bSetToBurst;
		if ( Maria_M16A4_AimpointFire(FireMode[0]).bSetToBurst )
		{
			ItemName = default.ItemName $ " [Semi-Auto]";
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Maria_M16A4_BurstSwitchMessage',0);
		}
		else
		{
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Maria_M16A4_BurstSwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(Maria_M16A4_AimpointFire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewSetToBurst)
{
	Maria_M16A4_AimpointFire(FireMode[0]).bSetToBurst = bNewSetToBurst;
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
	 Mesh=SkeletalMesh'M16A4Rifle_A.M16A4_Aimpoint_1st'
	 //MeshRef="M16A4Rifle_A.M16A4_Aimpoint_1st"
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
     Skins(6)=Texture'M16A4Rifle_T.M16A4.06_M68_Aimpoint'
	 //SkinRefs(6)="M16A4Rifle_T.M16A4.06_M68_Aimpoint"
     Skins(7)=Shader'KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr'
	 //SkinRefs(7)="KF_Weapons2_Trip_T.Special.Aimpoint_sight_shdr"
     Skins(8)=Texture'M16A4Rifle_T.M16A4.06_M68_Aimpoint'
	 //SkinRefs(8)="M16A4Rifle_T.M16A4.06_M68_Aimpoint"
	 //SelectSound=Sound'KF_M4RifleSnd.foley.WEP_M4_Foley_Select'
	 SelectSoundRef="KF_M4RifleSnd.foley.WEP_M4_Foley_Select"
	 HudImage=Texture'M16A4Rifle_T.ui.M16A4_Aimpoint_Unselected'
	 //HudImageRef="M16A4Rifle_T.ui.M16A4_Aimpoint_Unselected"
     SelectedHudImage=Texture'M16A4Rifle_T.ui.M16A4_Aimpoint_Selected'
	 //SelectedHudImageRef="M16A4Rifle_T.ui.M16A4_Aimpoint_Selected"
	 //[end]
	 MagCapacity=30
     ReloadRate=3.633300
	 TacticalReloadRate=2.450000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_M4"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'M16A4Rifle_T.ui.M16A4_Aimpoint_Trader'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=25.000000
     FireModeClass(0)=Class'UnlimaginMod.Maria_M16A4_AimpointFire'
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
     PickupClass=Class'UnlimaginMod.Maria_M16A4_AimpointPickup'
     PlayerViewOffset=(X=25.000000,Y=20.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Maria_M16A4_AimpointAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="M16A4 (Red Dot)"
     TransientSoundVolume=1.250000
}
