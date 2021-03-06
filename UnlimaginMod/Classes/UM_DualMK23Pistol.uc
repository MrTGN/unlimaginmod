//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DualMK23Pistol
//	Parent class:	 DualMK23Pistol
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.07.2012 23:44
//================================================================================
class UM_DualMK23Pistol extends DualMK23Pistol;

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
	if ( UM_DualMK23Pistol(Inv) != None )
		UM_DualMK23Pistol(Inv).FireModeSwitchSound = default.FireModeSwitchSound;
}

static function bool UnloadAssets()
{
	if ( super.UnloadAssets() )
	{
		default.SelectSound = None;
		default.FireModeSwitchSound = None;
	}

	Return True;
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
		PlayOwnedSound(FireModeSwitchSound,SLOT_None,2.2,,,,False);
		UM_DualMK23Fire(FireMode[0]).bSetToBurst = !UM_DualMK23Fire(FireMode[0]).bSetToBurst;
		if ( UM_DualMK23Fire(FireMode[0]).bSetToBurst )
			Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_MK23SwitchMessage',0);
		else Player.ReceiveLocalizedMessage(class'UnlimaginMod.UM_MK23SwitchMessage',1);
	}
	if ( Role < ROLE_Authority )
		UM_ServerChangeFireMode(UM_DualMK23Fire(FireMode[0]).bSetToBurst);
}

// Set the new fire mode on the server
function UM_ServerChangeFireMode(bool bNewSetToBurst)
{
	UM_DualMK23Fire(FireMode[0]).bSetToBurst = bNewSetToBurst;
}

exec function SwitchModes()
{
	DoToggle();
}
//[end]

function bool HandlePickupQuery( pickup Item )
{
	if ( Item.InventoryType==Class'UM_MK23Pistol' )
	{
		if( LastHasGunMsgTime < Level.TimeSeconds && PlayerController(Instigator.Controller) != None )
		{
			LastHasGunMsgTime = Level.TimeSeconds + 0.5;
			PlayerController(Instigator.Controller).ReceiveLocalizedMessage(Class'KFMainMessages', 1);
		}

		Return True;
	}

	Return Super(Dualies).HandlePickupQuery(Item);
}

function GiveTo( pawn Other, optional Pickup Pickup )
{
	local Inventory I;
	local int OldAmmo;
	local bool bNoPickup;

	MagAmmoRemaining = 0;

	For( I = Other.Inventory; I != None; I =I.Inventory )
	{
		if ( UM_MK23Pistol(I) != None )
		{
			if( WeaponPickup(Pickup)!= None )
			{
				WeaponPickup(Pickup).AmmoAmount[0] += Weapon(I).AmmoAmount(0);
			}
			else
			{
				OldAmmo = Weapon(I).AmmoAmount(0);
				bNoPickup = True;
			}

			MagAmmoRemaining = UM_MK23Pistol(I).MagAmmoRemaining;

			I.Destroyed();
			I.Destroy();

			Break;
		}
	}

	if ( KFWeaponPickup(Pickup) != None && Pickup.bDropped )
	{
		MagAmmoRemaining = Clamp(MagAmmoRemaining + KFWeaponPickup(Pickup).MagAmmoRemaining, 0, MagCapacity);
	}
	else
	{
		MagAmmoRemaining = Clamp(MagAmmoRemaining + Class'UM_MK23Pistol'.Default.MagCapacity, 0, MagCapacity);
	}

	Super(Weapon).GiveTo(Other, Pickup);

	if ( bNoPickup )
	{
		AddAmmo(OldAmmo, 0);
		Clamp(Ammo[0].AmmoAmount, 0, MaxAmmo(0));
	}
}

function DropFrom(vector StartLocation)
{
	local int m;
	local Pickup Pickup;
	local Inventory I;
	local int AmmoThrown, OtherAmmo;

	if( !bCanThrow )
		Return;

	AmmoThrown = AmmoAmount(0);
	ClientWeaponThrown();

	for (m = 0; m < NUM_FIRE_MODES; m++)
	{
		if (FireMode[m].bIsFiring)
			StopFire(m);
	}

	if ( Instigator != None )
		DetachFromPawn(Instigator);

	if( Instigator.Health > 0 )
	{
		OtherAmmo = AmmoThrown / 2;
		AmmoThrown -= OtherAmmo;
		I = Spawn(Class'UM_MK23Pistol');
		I.GiveTo(Instigator);
		Weapon(I).Ammo[0].AmmoAmount = OtherAmmo;
		UM_MK23Pistol(I).MagAmmoRemaining = MagAmmoRemaining / 2;
		MagAmmoRemaining = Max(MagAmmoRemaining-UM_MK23Pistol(I).MagAmmoRemaining,0);
	}

	Pickup = Spawn(Class'MK23Pickup',,, StartLocation);

	if ( Pickup != None )
	{
		Pickup.InitDroppedPickupFor(self);
		Pickup.Velocity = Velocity;
		WeaponPickup(Pickup).AmmoAmount[0] = AmmoThrown;
		if( KFWeaponPickup(Pickup)!=None )
			KFWeaponPickup(Pickup).MagAmmoRemaining = MagAmmoRemaining;
		if (Instigator.Health > 0)
			WeaponPickup(Pickup).bThrown = True;
	}

    Destroyed();
	Destroy();
}

simulated function bool PutDown()
{
	if ( Instigator.PendingWeapon.class == class'UM_MK23Pistol' )
	{
		bIsReloading = False;
	}

	Return Super(Dualies).PutDown();
}

defaultproperties
{
     FireModeSwitchSoundRef="Inf_Weapons_Foley.stg44.stg44_firemodeswitch01"
	 MagCapacity=30
     Weight=4.000000
     FireModeClass(0)=Class'UnlimaginMod.UM_DualMK23Fire'
     FireModeClass(1)=Class'KFMod.NoFire'
     PickupClass=Class'UnlimaginMod.UM_DualMK23Pickup'
     ItemName="Dual MK23"
}
