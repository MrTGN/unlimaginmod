//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// Dualies Inventory class
//=============================================================================
class Braindead_MP5K_Dual extends UM_BaseSMG;

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
simulated function DoToggle ()
{
	local PlayerController Player;

	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		if ( ModeSwitchSound.Snd != None )
			PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
		// Case - burst fire
		if ( FireMode[0].bWaitForRelease && Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst )
		{
			// Switching to Semi-Auto
			FireMode[0].bWaitForRelease = FireMode[0].bWaitForRelease;
			Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst = !Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',2);
			ItemName = default.ItemName $ " [Semi-Auto]";
		}
		// Case - semi fire
		else if ( FireMode[0].bWaitForRelease && !Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst )
		{
			// Switching to Auto
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst = Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
			ItemName = default.ItemName $ " [Auto]";
		}
		// Case - auto
		else
		{
			// Switching to burst
			FireMode[0].bWaitForRelease = !FireMode[0].bWaitForRelease;
			Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst = !Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst;
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
			ItemName = default.ItemName $ " [Burst]";
		}
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(FireMode[0].bWaitForRelease, Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewWaitForRelease, bool bNewSetToBurst)
{
	FireMode[0].bWaitForRelease = bNewWaitForRelease;
	Braindead_MP5K_DualFire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

function bool RecommendLongRangedAttack()
{
	return true;
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

/**
 * Handles all the functionality for zooming in including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomIn(bool bAnimateTransition)
{
    super.ZoomIn(bAnimateTransition);

    if( bAnimateTransition )
    {
        if( bZoomOutInterrupted )
        {
            PlayAnim('GOTO_Iron',1.0,0.1);
        }
        else
        {
            PlayAnim('GOTO_Iron',1.0,0.1);
        }
    }
}

/**
 * Handles all the functionality for zooming out including
 * setting the parameters for the weapon, pawn, and playercontroller
 *
 * @param bAnimateTransition whether or not to animate this zoom transition
 */
simulated function ZoomOut(bool bAnimateTransition)
{
    local float AnimLength, AnimSpeed;
    super.ZoomOut(false);

    if( bAnimateTransition )
    {
        AnimLength = GetAnimDuration('GOTO_Hip', 1.0);

        if( ZoomTime > 0 && AnimLength > 0 )
        {
            AnimSpeed = AnimLength/ZoomTime;
        }
        else
        {
            AnimSpeed = 1.0;
        }
        PlayAnim('GOTO_Hip',AnimSpeed,0.1);
    }
}

function byte BestMode()
{
    return 0;
}

function bool RecommendRangedAttack()
{
	return true;
}

function float SuggestAttackStyle()
{
    return -0.7;
}

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'BD_FL_MP5_A.MP5KWeapon'
	 MeshRef="BD_FL_MP5_A.MP5KWeapon"
     //Skins(0)=Combiner'BD_MP5_FL_T.MP5K_cmb'
	 SkinRefs(0)="BD_MP5_FL_T.MP5K_cmb"
	 //SelectSound=Sound'KF_MP5Snd.foley.WEP_MP5_Foley_Select'
	 SelectSoundRef="KF_MP5Snd.foley.WEP_MP5_Foley_Select"
	 //HudImage=Texture'BD_MP5_FL_T.HUD.MP5K_UnSelected'
	 HudImageRef="BD_MP5_FL_T.HUD.MP5K_UnSelected"
     //SelectedHudImage=Texture'BD_MP5_FL_T.HUD.MP5K_Selected'
	 SelectedHudImageRef="BD_MP5_FL_T.HUD.MP5K_Selected"
	 //[end]
     FirstPersonFlashlightOffset=(X=-15.000000,Z=5.000000)
     MagCapacity=60
	 TacticalReloadCapacityBonus=2
     ReloadRate=7.000000
     ReloadAnim="Reload"
     ReloadAnimRate=1.200000
     WeaponReloadAnim="Reload_Dual9mm"
     Weight=6.000000
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=65.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'BD_MP5_FL_T.HUD.MP5K_Trader'
     ZoomInRotation=(Pitch=0,Roll=0)
     ZoomedDisplayFOV=80.000000
     FireModeClass(0)=Class'UnlimaginMod.Braindead_MP5K_DualFire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PutDownAnim="PutDown"
     AIRating=0.440000
     CurrentRating=0.440000
     Description="A pair of custom 9mm pistols. What they lack in stopping power, they compensate for with a quick refire."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-10.000000)
     DisplayFOV=65.000000
     Priority=65
     InventoryGroup=3
     GroupOffset=3
     PickupClass=Class'UnlimaginMod.Braindead_MP5K_DualPickup'
     PlayerViewOffset=(X=25.000000,Z=-12.000000)
     BobDamping=7.000000
     AttachmentClass=Class'UnlimaginMod.Braindead_MP5K_Dual_Attachment'
     IconCoords=(X1=229,Y1=258,X2=296,Y2=307)
     ItemName="Dual MP5K"
     TransientSoundVolume=1.800000
}
