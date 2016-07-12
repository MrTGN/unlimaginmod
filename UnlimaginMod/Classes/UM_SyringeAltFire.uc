/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_SyringeAltFire
	Creation date:	 17.12.2014 21:35
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 Syringe Self-Healing
==================================================================================*/
class UM_SyringeAltFire extends SyringeAltFire;

//========================================================================
//[block] Variables

var		float		HealBoostAmount;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated function bool AllowFire()
{
	if ( UM_Syringe(Weapon) == None || UM_HumanPawn(Instigator) == None || !UM_HumanPawn(Instigator).CanSelfHeal(UM_Syringe(Weapon).bCanOverheal) )
		Return False;

	Return Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire;
}

// server function
event Timer()
{
	// Heal Instigator
	if ( UM_HumanPawn(Instigator).Heal(HealBoostAmount, UM_Syringe(Weapon).bCanOverheal, UM_HumanPawn(Instigator)) )
		Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire); // Consume Ammo
}

// Server function
function DoFireEffect()
{
	SetTimer(InjectDelay, False);
}

// Server and client function
event ModeDoFire()
{
	Load = 0.0;	// float
	Super(WeaponFire).ModeDoFire(); // We don't consume the ammo just yet.
}

//[end] Functions
//====================================================================

defaultproperties
{
     InjectDelay=0.100000
     HealeeRange=70.000000
     TransientSoundVolume=1.800000
     FireAnim="AltFire"
     FireRate=3.600000
     AmmoPerFire=500
	 HealBoostAmount=30
}
