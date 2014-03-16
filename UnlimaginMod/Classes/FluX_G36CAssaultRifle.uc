//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//================================================================================
// G36C Inventory class
// Made by FluX
// http://www.fluxiserver.co.uk
//================================================================================
class FluX_G36CAssaultRifle extends UM_BaseAssaultRifle;

#exec OBJ LOAD FILE=FX-G36C_T.utx
#exec OBJ LOAD FILE=FX-G36C_v2_A.ukx
#exec OBJ LOAD FILE=FX-G36C_SM.usx
#exec OBJ LOAD FILE=FX-G36C_v2_Snd.uax

var globalconfig bool bIsToggling;
var name ToggleAnimation;
var float ToggleTime;

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
    if(ReadyToFire(0))
    {
        bIsToggling = True;
        PlayAnim(ToggleAnimation, 0.70, 0.01);
        DoToggle();
        GoToState('ToggleState');
    }
}

// Toggle semi/auto fire
simulated function DoToggle()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
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

state ToggleState 
{
	event BeginState()
	{
		ToggleTime = Level.TimeSeconds;
	}

	simulated event Tick( float DeltaTime )
	{
		global.Tick(DeltaTime);

		if ( Level.TimeSeconds >= ToggleTime + 0.5 ) 
		{
			bIsToggling = False;
			GotoState('');			
		}
	}
}

defaultproperties
{
     //[block] Dynamic Loading vars
	 MeshRef="FX-G36C_v2_A.G36C"
     SkinRefs(1)="FX-G36C_T.G36CMagFix"
     SelectSoundRef="KF_AK47Snd.AK47_Select"
     HudImageRef="FX-G36C_T.Trader_G36C_unselected"
     SelectedHudImageRef="FX-G36C_T.Trader_G36C_selected"
	 //[end]
	 ToggleAnimation="FlickToggle"
     MagCapacity=30
     ReloadRate=2.640000
	 TacticalReloadRate=1.212000
     ReloadAnim="Reload"
     ReloadAnimRate=0.833333
     WeaponReloadAnim="Reload_AK47"
     Weight=5.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     SleeveNum=0
     TraderInfoTexture=Texture'FX-G36C_T.Trader_G36C'
     bIsTier2Weapon=True
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=32.000000
     FireModeClass(0)=Class'UnlimaginMod.FluX_G36CFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     SelectForce="SwitchToAssaultRifle"
     AIRating=0.550000
     CurrentRating=0.550000
     bShowChargingBar=True
     Description="The G36C is a german-made assault rifle manufactured by Heckler und Koch."
     EffectOffset=(X=100.000000,Y=25.000000)
     DisplayFOV=55.000000
     Priority=165
     CustomCrosshair=11
     CustomCrossHairTextureName="Crosshairs.HUD.Crosshair_Cross5"
     InventoryGroup=3
     GroupOffset=7
     PickupClass=Class'UnlimaginMod.FluX_G36CPickup'
     PlayerViewOffset=(X=18.000000,Y=15.000000,Z=-6.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.FluX_G36CAttachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="HK G36C"
     TransientSoundVolume=1.500000
}
