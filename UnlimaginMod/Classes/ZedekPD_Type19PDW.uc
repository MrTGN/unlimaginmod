//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Type-19 Weapon
//===================================================================================
class ZedekPD_Type19PDW extends UM_BasePDW
	config(user);

#exec OBJ LOAD FILE=KillingFloorWeapons.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=Inf_Weapons_Foley.uax
#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax

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
simulated function DoToggle ()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		
		// Case - burst fire
		if ( FireMode[0].bWaitForRelease && ZedekPD_Type19Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Semi-Auto
			FireMode[0].bWaitForRelease = FireMode[0].bWaitForRelease;
			ZedekPD_Type19Fire(FireMode[0]).bSetToBurst = !ZedekPD_Type19Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',2);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		// Case - semi fire
		else if ( FireMode[0].bWaitForRelease && !ZedekPD_Type19Fire(FireMode[0]).bSetToBurst )
		{
			// Switching to Auto
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			ZedekPD_Type19Fire(FireMode[0]).bSetToBurst = ZedekPD_Type19Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			// Switching to burst
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			ZedekPD_Type19Fire(FireMode[0]).bSetToBurst = !ZedekPD_Type19Fire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease, ZedekPD_Type19Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease, bool bNewSetToBurst)
{
	FireMode[0].bWaitForRelease = bNewWaitForRelease;
	ZedekPD_Type19Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
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
	 //Mesh=SkeletalMesh'Type19_A.Type19'
	 MeshRef="Type19_A.Type19"
     //Skins(1)=Texture'Type19_T.Type19'
	 SkinRefs(1)="Type19_T.Type19"
     //Skins(2)=Shader'Type19_T.screen_shdr'
	 SkinRefs(2)="Type19_T.screen_shdr"
	 //SelectSound=Sound'Type19_S.type19_draw'
	 SelectSoundRef="Type19_S.type19_draw"
	 //HudImage=Texture'Type19_T.pic_unsel'
	 HudImageRef="Type19_T.pic_unsel"
     //SelectedHudImage=Texture'Type19_T.pic_sel'
	 SelectedHudImageRef="Type19_T.pic_sel"
	 //[end]
	 MagCapacity=40
     // ReloadRate = 5.400000 / 1.35
	 ReloadRate=4.000000
	 //TacticalReloadRate = 3.160000 / 1.35
	 TacticalReloadRate=2.340000
     ReloadAnim="Reload"
     // ReloadAnimRate = 1.000000 * 1.35
	 ReloadAnimRate=1.350000
     WeaponReloadAnim="Reload_Thompson"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=60.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'Type19_T.pic_trader'
     bIsTier2Weapon=True
     PlayerIronSightFOV=55.000000
     ZoomedDisplayFOV=40.000000
     FireModeClass(0)=Class'UnlimaginMod.ZedekPD_Type19Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="A quality futuristic military rifle, designed with a very peculiar reloading system."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=60.000000
     Priority=70
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.ZedekPD_Type19Pickup'
     PlayerViewOffset=(X=20.000000,Y=21.500000,Z=-9.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.ZedekPD_Type19Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="Type-19 PDW"
     TransientSoundVolume=1.250000
}
