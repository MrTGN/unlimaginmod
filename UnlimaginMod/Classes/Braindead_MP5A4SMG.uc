//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// Shotgun Inventory class
//=============================================================================
class Braindead_MP5A4SMG extends UM_BaseSMG;

//#exec obj load File=..\Textures\BD_MP5_FL_T.utx
#exec obj load File=BD_MP5_FL_T.utx
//#exec OBJ LOAD FILE=..\animations\BD_FL_MP5_A.ukx
#exec OBJ LOAD FILE=BD_FL_MP5_A.ukx
//#exec obj Load File=..\Sounds\KF_MP5Snd.uax
#exec obj Load File=KF_MP5Snd.uax
//#exec obj Load File=..\Sounds\BD_MP5SD_S.uax
#exec obj Load File=BD_MP5SD_S.uax


//var bool bToggling;
var array<string> ToggleKeyNames,ToggleKeyNamesL;

/*replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}*/

/* [block] Functions for alternative fire mode switching 
simulated function BringUp(optional Weapon PrevWeapon)
{

	local KFPlayerController Player;

	// Hint check
	Player = KFPlayerController(Instigator.Controller);

	if ( Player != none )
	{
	Braindead_MP5A4Fire(FireMode[0]).bSetToBurst = False;
	}


	//CheckKeys();

	Super(KFWeapon).BringUp();
}


// Commented out because this functions just copied from KFWeapon without any changes.
// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
}

function AdjustLightGraphic()
{
	if ( TacShine==none )
	{
		TacShine = Spawn(TacShineClass,,,,);
		AttachToBone(TacShine,'LightBone');
	}
	if( FlashLight!=none )
		Tacshine.bHidden = !FlashLight.bHasLight;
}


// Toggle semi/auto fire
simulated function DoToggle()
{
	local PlayerController Player;
	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		Class'UM_BaseActor'.static.ActorPlayOwnedSoundData(self, ModeSwitchSound);
		
		Braindead_MP5A4Fire(FireMode[0]).bSetToBurst = !Braindead_MP5A4Fire(FireMode[0]).bSetToBurst;
		if ( Braindead_MP5A4Fire(FireMode[0]).bSetToBurst )
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',0);
		else 
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.Braindead_MP5SwitchMessage',1);
	}
	UM_ServerChangeFireMode(Braindead_MP5A4Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewSetToBurst)
{
	Braindead_MP5A4Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

exec function SwitchModes()
{
	DoToggle();
}


simulated function WeaponTick(float dt)
{

	// Turn it off on death  / battery expenditure
	if (FlashLight != none)
	{
		// Keep the 1Pweapon client beam up to date.
		AdjustLightGraphic();
		if (FlashLight.bHasLight)
		{
			if (Instigator.Health <= 0 || KFHumanPawn(Instigator).TorchBatteryLife <= 0 || Instigator.PendingWeapon != none )
			{
				//Log("Killing Light...you're out of batteries, or switched / dropped weapons");
				Braindead_MP5A4Fire(FireMode[0]).bSetToBurst = False;
				KFHumanPawn(Instigator).bTorchOn = false;
				ServerSpawnLight();
			}
		}
	}

	Super.WeaponTick(dt);
}



// GetCurrentBind( "Space", CommandBoundToSpace ); return true if successful
final function bool GetCurrentBind( string BindKeyName, out string BindKeyValue )
{
	if ( BindKeyName != "" )
	{
		BindKeyValue = ConsoleCommand("KEYBINDING" @ BindKeyName);
		return BindKeyValue != "";
	}

	return false;
}

// SetKeyBind( "Space", "Jump" ); return true if successful
final function bool SetKeyBind( string BindKeyName, string BindKeyValue )
{
	ConsoleCommand("set Input" @ BindKeyName @ BindKeyValue );
	return true;
}


// GetAssignedKeys( "Jump", ArrayOfKeysThatPerformJump ); return true if successful
final function bool GetAssignedKeys( string BindAlias, out array<string> BindKeyNames, out array<string> LocalizedBindKeyNames )
{
	local int i, iKey;
	local string s;

	BindKeyNames.Length = 0;
	LocalizedBindKeyNames.Length = 0;
	s = ConsoleCommand("BINDINGTOKEY" @ "\"" $ BindAlias $ "\"");
	if ( s != "" )
	{
		Split(s, ",", BindKeyNames);
		for ( i = 0; i < BindKeyNames.Length; i++ )
		{
			iKey = int(ConsoleCommand("KEYNUMBER" @ BindKeyNames[i]));
			if ( iKey != -1 )
				LocalizedBindKeyNames[i] = ConsoleCommand("LOCALIZEDKEYNAME" @ iKey);
		}
	}

	return BindKeyNames.Length > 0;
}

// Check if the zoom in and out keys are set, if not, set to defaults, if they are not set
// to some other func
function CheckKeys()
{
    local string CurBind;
	if (!GetAssignedKeys("bToggling",ToggleKeyNames,ToggleKeyNamesL))
    {
        if (!GetCurrentBind("H",CurBind))
        {
            SetKeyBind("H","bToggling");
            GetAssignedKeys("bToggling",ToggleKeyNames,ToggleKeyNamesL);
        }
    }

	if (ToggleKeyNamesL[0] == "H")
        ToggleKeyNamesL[0] = "H";

}

simulated exec function bToggling()
{
	DoToggle();
} [end] */

defaultproperties
{
     //[block] Dynamic Loading vars
	 //Mesh=SkeletalMesh'BD_FL_MP5_A.MP5_FL'
	 MeshRef="BD_FL_MP5_A.MP5_FL"
     //Skins(0)=Combiner'BD_MP5_FL_T.MP5_cmb'
	 SkinRefs(0)="BD_MP5_FL_T.MP5_cmb"
	 //SelectSound=Sound'KF_MP5Snd.foley.WEP_MP5_Foley_Select'
	 SelectSoundRef="KF_MP5Snd.foley.WEP_MP5_Foley_Select"
	 //HudImage=Texture'BD_MP5_FL_T.HUD.MP5_FL_unselected'
	 HudImageRef="BD_MP5_FL_T.HUD.MP5_FL_unselected"
     //SelectedHudImage=Texture'BD_MP5_FL_T.HUD.MP5_FL_selected'
	 SelectedHudImageRef="BD_MP5_FL_T.HUD.MP5_FL_selected"
	 //[end]
	 FirstPersonFlashlightOffset=(X=-25.000000,Y=-18.000000,Z=8.000000)
     MagCapacity=32
     ReloadRate=3.800000
     ReloadAnim="Reload"
     ReloadAnimRate=1.000000
     WeaponReloadAnim="Reload_MP5"
     ModeSwitchAnim="Light_on"
     Weight=4.000000
     bTorchEnabled=True
     bHasAimingMode=True
     IdleAimAnim="Idle_Iron"
     StandardDisplayFOV=55.000000
     bModeZeroCanDryFire=True
     TraderInfoTexture=Texture'BD_MP5_FL_T.HUD.MP5_FL_Trader'
     PlayerIronSightFOV=65.000000
     ZoomedDisplayFOV=45.000000
     FireModeClass(0)=Class'UnlimaginMod.Braindead_MP5A4Fire'
     FireModeClass(1)=Class'UnlimaginMod.Braindead_MP5A4LightFire'
     PutDownAnim="PutDown"
     AIRating=0.600000
     CurrentRating=0.600000
     bShowChargingBar=True
     Description="MP5 sub machine gun with Tactical Light attachment"
     DisplayFOV=55.000000
     Priority=90
     InventoryGroup=3
     GroupOffset=1
     PickupClass=Class'UnlimaginMod.Braindead_MP5A4Pickup'
     PlayerViewOffset=(X=29.000000,Y=18.000000,Z=-8.000000)
     BobDamping=6.000000
     AttachmentClass=Class'UnlimaginMod.Braindead_MP5A4Attachment'
     IconCoords=(X1=245,Y1=39,X2=329,Y2=79)
     ItemName="MP5A4"
     TransientSoundVolume=1.250000
}
