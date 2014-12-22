/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_Syringe
	Creation date:	 15.12.2014 06:33
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_Syringe extends Syringe;

//========================================================================
//[block] Variables

var		float		MoneyPerHealedHealth;
var		bool		bCanOverheal;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		ClientNotifySuccessfulHealing;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super(KFWeapon).PostBeginPlay();
	
	if ( UM_GameReplicationInfo(Level.GRI) != None )  {
		if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 2.0 )
			MoneyPerHealedHealth *= 1.8;
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 4.0 )
			MoneyPerHealedHealth *= 1.5;
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 5.0 )
			MoneyPerHealedHealth *= 1.2;
	}
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( UM_HumanPawn(Instigator) != None )
		UM_HumanPawn(Instigator).Syringe = self;
}

simulated event Tick( float DeltaTime )
{
	if ( Level.NetMode != NM_Client && AmmoCharge[0] < MaxAmmoCount && Level.TimeSeconds >= RegenTimer )  {
		RegenTimer = Level.TimeSeconds + AmmoRegenRate;
		if ( UM_HumanPawn(Instigator) != None )
			AmmoCharge[0] = Min( (AmmoCharge[0] + Round(10.0 + UM_HumanPawn(Instigator).VeterancySyringeChargeModifier)), MaxAmmoCount ) ;
		else
			AmmoCharge[0] = Min( (AmmoCharge[0] + 10), MaxAmmoCount );
	}
}

simulated function float ChargeBar()
{
	Return FClamp( (float(AmmoCharge[0]) / float(MaxAmmoCount)), 0.0, 1.0 );
}

simulated function bool HackClientStartFire()
{
	if ( StartFire(1) )  {
		if ( Role < ROLE_Authority )
			ServerStartFire(1);
		FireMode[1].ModeDoFire(); // Force to start animating.
		
		Return True;
	}
	
	Return False;
}

simulated event Timer()
{
	Super(KFWeapon).Timer();
	if ( UM_HumanPawn(Instigator) != None )  {
		if ( UM_HumanPawn(Instigator).bIsQuickHealing > 0 && ClientState == WS_ReadyToFire )  {
			if ( UM_HumanPawn(Instigator).bIsQuickHealing == 1 )  {
				if ( !HackClientStartFire() )  {
					if ( !UM_HumanPawn(Instigator).CanSelfHeal( bCanOverheal ) || ChargeBar() < 0.75 )
						UM_HumanPawn(Instigator).bIsQuickHealing = 2; // Was healed by someone else or some other error occurred.
					SetTimer(0.2, False);
					Return;
				}
				UM_HumanPawn(Instigator).bIsQuickHealing = 2;
				SetTimer( (FireMode[1].FireRate + 0.5), False );
			}
			else  {
				Instigator.SwitchToLastWeapon();
				UM_HumanPawn(Instigator).bIsQuickHealing = 0;
			}
		}
		else if ( ClientState == WS_Hidden )
			UM_HumanPawn(Instigator).bIsQuickHealing = 0; // Weapon was changed, ensure to reset this.
	}
}

/*	ServerAttemptHeal() function call replicated from the client-owner to the server.
	Called from ModeDoFire() event on the client-owner side.	*/
function ServerAttemptHeal()
{
	if ( UM_SyringeFire(FireMode[0]) != None )
		UM_SyringeFire(FireMode[0]).ServerAttemptHeal();
}

// Notify about Successful Healing. To play animation etc.
simulated function ClientNotifySuccessfulHealing()
{
	if ( Role < ROLE_Authority && UM_SyringeFire(FireMode[0]) != None )
		UM_SyringeFire(FireMode[0]).ClientModeDoFire();
}

simulated function Weapon PrevWeapon( Weapon CurrentChoice, Weapon CurrentWeapon )
{
	// Do not select this directly if Instigator is Quick Healing
	if ( UM_HumanPawn(Instigator) != None && UM_HumanPawn(Instigator).bIsQuickHealing > 0 )  {
		if ( Inventory == None )
			Return CurrentChoice;
		else
			Return Inventory.PrevWeapon(CurrentChoice, CurrentWeapon);
	}
	else
		Super.PrevWeapon(CurrentChoice, CurrentWeapon);
}

simulated function Weapon NextWeapon( Weapon CurrentChoice, Weapon CurrentWeapon )
{
	// Do not select this directly if Instigator is Quick Healing
	if ( UM_HumanPawn(Instigator) != None && UM_HumanPawn(Instigator).bIsQuickHealing > 0 )  {
		if ( Inventory == None )
			Return CurrentChoice;
		else
			Return Inventory.NextWeapon(CurrentChoice, CurrentWeapon);
	}
	else
		Super.NextWeapon(CurrentChoice, CurrentWeapon);
}

simulated function Weapon WeaponChange( byte F, bool bSilent )
{
	// Do not select this directly if Instigator is Quick Healing
	if ( UM_HumanPawn(Instigator) != None && UM_HumanPawn(Instigator).bIsQuickHealing > 0 )  {
		if ( Inventory == None )
			Return None;
		else 
			Return Inventory.WeaponChange(F, bSilent);
	}
	else
		Super.WeaponChange(F, bSilent);
}

//[end] Functions
//====================================================================

defaultproperties
{
     FireModeClass(0)=Class'UnlimaginMod.UM_SyringeFire'
     FireModeClass(1)=Class'UnlimaginMod.UM_SyringeAltFire'
	 bSpeedMeUp=True
	 bCanOverheal=True
	 MoneyPerHealedHealth=0.7
	 HealBoostAmount=20
}
