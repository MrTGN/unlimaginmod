//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MK23Pistol
//	Parent class:	 MK23Pistol
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.07.2012 23:37
//================================================================================
class UM_MK23Pistol extends MK23Pistol;

//[block] Dynamic Loading Vars
var		string	FireModeSwitchSoundRef;
//[end]
var		sound	FireModeSwitchSound;

replication
{
	reliable if(Role < ROLE_Authority)
		UM_ServerChangeFireMode;
}

//[block] Dynamic Loading
static function PreloadAssets(Inventory Inv, optional bool bSkipRefCount)
{
	Super.PreloadAssets(Inv, bSkipRefCount);
	
	default.FireModeSwitchSound = sound(DynamicLoadObject(default.FireModeSwitchSoundRef, class'sound'));
	if ( UM_MK23Pistol(Inv) != None )
		UM_MK23Pistol(Inv).FireModeSwitchSound = default.FireModeSwitchSound;
}

static function bool UnloadAssets()
{
	if ( super.UnloadAssets() )
	{
		default.SelectSound = none;
		default.FireModeSwitchSound = none;
	}

	return true;
}
//[end]

//[block] Switching Fire Modes
// Use alt fire to switch fire modes
simulated function AltFire(float F)
{
	DoToggle();
}

// Toggle semi/auto fire
simulated function DoToggle ()
{
	local PlayerController Player;
	Player = Level.GetLocalPlayerController();
	if ( Player!=None )
	{
		PlayOwnedSound(FireModeSwitchSound,SLOT_None,2.2,,,,false);
		UM_MK23Fire(FireMode[0]).bSetToBurst = !UM_MK23Fire(FireMode[0]).bSetToBurst;
		if ( UM_MK23Fire(FireMode[0]).bSetToBurst )
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_MK23SwitchMessage',0);
		else Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_MK23SwitchMessage',1);
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(UM_MK23Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewSetToBurst)
{
	UM_MK23Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

exec function SwitchModes()
{
	DoToggle();
}
//[end]

function bool HandlePickupQuery( pickup Item )
{
	if ( Item.InventoryType == Class )
	{
		if ( KFHumanPawn(Owner) != none && !KFHumanPawn(Owner).CanCarry(class'UM_DualMK23Pistol'.Default.Weight) )
		{
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 2);
			return true;
		}

		if ( KFPlayerController(Instigator.Controller) != none )
		{
			KFPlayerController(Instigator.Controller).PendingAmmo = WeaponPickup(Item).AmmoAmount[0];
		}

		return false; // Allow to "pickup" so this weapon can be replaced with dual MK23.
	}

	return Super(KFWeapon).HandlePickupQuery(Item);
}

simulated function bool PutDown()
{
	if ( Instigator.PendingWeapon.class == class'UM_DualMK23Pistol' )
	{
		bIsReloading = false;
	}

	return super(KFWeapon).PutDown();
}

defaultproperties
{
     FireModeSwitchSoundRef="Inf_Weapons_Foley.stg44.stg44_firemodeswitch01"
	 MagCapacity=15
     Weight=2.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_MK23Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PickupClass=Class'UnlimaginMod.UM_MK23Pickup'
     ItemName="MK23"
}
