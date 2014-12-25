/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_SyringeFire
	Creation date:	 22.12.2014 00:58
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
class UM_SyringeFire extends UM_SyringeAltFire;

//========================================================================
//[block] Variables

const	Maths = Class'UnlimaginMod.UnlimaginMaths';

var				float			HealBoostAmount;
var				float			HealingRange;
var				float			MaxPatientSearchAngle; // Maximum deviation angle (in degrees) from the view axis to find Patient
var	transient	UM_HumanPawn	Patient;

var	localized	string			NoPatientMessage;
var				float			NoPatientMessageDelay;
var transient	float			NextNoPatientMessageTime;

var				float			PotentialPatientSearchRange;
var				float			NoPatientSpeechDelay;
var	transient	float			NextNoPatientSpeechTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated function bool AllowFire()
{
	if ( UM_Syringe(Weapon) == None || UM_HumanPawn(Instigator) == None )
		Return False;
	
	Return Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire;
}

// Find a Human to heal
function UM_HumanPawn FindPatient()
{
	local	UM_HumanPawn	NewPatient, BestPatient;
	local	vector			HitLoc, HitNorm, TraceStart, ViewDir;
	local	float			BestAngle, NewAngle;
	
	TraceStart = Instigator.Location + Instigator.EyePosition();
	ViewDir = UM_HumanPawn(Instigator).GetViewDirection();
	
	NewPatient = UM_HumanPawn( Instigator.Trace(HitLoc, HitNorm, (StartTrace + ViewDir * HealingRange), TraceStart, True) );
	if ( NewPatient != None && !NewPatient.bDeleteMe && NewPatient != Instigator && NewPatient.CanBeHealed(UM_Syringe(Weapon).bCanOverheal, UM_HumanPawn(Instigator)) )
		Return NewPatient;
	
	// Try to find another Patient
	BestAngle = MaxPatientSearchAngle;
	foreach Instigator.VisibleCollidingActors( Class'UM_HumanPawn', NewPatient, HealingRange, TraceStart, True )  {
		if ( NewPatient != None && !NewPatient.bDeleteMe && NewPatient != Instigator )  {
			NewAngle = Maths.static.DegBetweenVectors( ViewDir, (NewPatient.Location - Instigator.Location) );
			if ( NewAngle < BestAngle && NewPatient.CanBeHealed(UM_Syringe(Weapon).bCanOverheal, UM_HumanPawn(Instigator)) )  {
				BestAngle = NewAngle;
				BestPatient = NewPatient;
			}
		}
	}
	
	Return BestPatient;
}

// Called from UM_Syringe(Weapon).ClientNotifySuccessfulHealing()
function ClientModeDoFire()
{
	Super.ModeDoFire();
}

// Called from the UM_Syringe(Weapon).ServerAttemptHeal() function on the server
function ServerAttemptHeal()
{
	local	UM_HumanPawn	PotentialPatient;
	
	Patient = FindPatient();
	if ( Patient != None )  {
		// Replicate Notify to client-owner
		UM_Syringe(Weapon).ClientNotifySuccessfulHealing();
		Super.ModeDoFire();
	}
	else if ( UM_PlayerController(Instigator.Controller) != None )  {
		// No Patient Hint
		UM_PlayerController(Instigator.Controller).CheckForHint(53);
		// No Patient Message
		if ( Level.TimeSeconds >= NextNoPatientMessageTime )  {
			NextNoPatientMessageTime = Level.TimeSeconds + NoPatientMessageDelay;
			UM_PlayerController(Instigator.Controller).ClientMessage( NoPatientMessage, 'CriticalEvent' );
		}
		// No Patient Speech
		if ( Level.TimeSeconds >= NextNoPatientSpeechTime )  {
			foreach Instigator.VisibleCollidingActors( Class'UM_HumanPawn', PotentialPatient, PotentialPatientSearchRange, Instigator.Location, True )  {
				if ( PotentialPatient != None && !PotentialPatient.bDeleteMe && PotentialPatient != Instigator &&
					 && PotentialPatient.CanBeHealed(UM_Syringe(Weapon).bCanOverheal, UM_HumanPawn(Instigator)) )  {
					NextNoPatientSpeechTime = Level.TimeSeconds + NoPatientSpeechDelay;
					UM_PlayerController(Instigator.Controller).Speech('AUTO', 5, "");
					Break;
				}
			}
		}
	}
}

// server function
event Timer()
{
	local	UM_HumanPawn	HealalingPatient;
	
	HealalingPatient = Patient;
	Patient = None;
	if ( HealalingPatient != None && HealalingPatient.Heal(HealBoostAmount, UM_Syringe(Weapon).bCanOverheal, UM_HumanPawn(Instigator), UM_Syringe(Weapon).MoneyPerHealedHealth) )  {
		// Consume Ammo
		Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);
		// Tell the Patient we're healing them
		if ( UM_PlayerController(Instigator.Controller) != None && Level.TimeSeconds >= NextNoPatientSpeechTime )  {
			NextNoPatientSpeechTime = Level.TimeSeconds + NoPatientSpeechDelay;
			UM_PlayerController(Instigator.Controller).Speech('AUTO', 5, "");
		}
	}
}

event ModeDoFire()
{
	/*	Replicate ServerAttemptHeal() function call	from client-owner to the server 
		by the Weapon class. And then call ServerAttemptHeal() from there.	*/
	// # попробую обойти это и вызывать функцию сразу на сервере.
	// ToDo: проверить!
	/*	
	if ( AllowFire() && Instigator.IsLocallyControlled() )
		UM_Syringe(Weapon).ServerAttemptHeal();	*/
	if ( AllowFire() && Weapon.Role == ROLE_Authority )
		ServerAttemptHeal();
}

simulated function DestroyEffects()
{
	Super.DestroyEffects();
	Patient = None;
}

//[end] Functions
//====================================================================

defaultproperties
{
	 InjectDelay=0.360000
	 bWaitForRelease=True
	 FireAnim="Fire"
     FireRate=2.800000
     AmmoPerFire=250
	 HealBoostAmount=20
	 // Healing
	 HealingRange=80.0
	 PotentialPatientSearchRange=100.0
	 MaxPatientSearchAngle=50.0
	 // No healing delays
	 NoPatientMessage="You must be near another player to heal them!"
	 NoPatientMessageDelay=0.5
	 NoPatientSpeechDelay=10.0
}
