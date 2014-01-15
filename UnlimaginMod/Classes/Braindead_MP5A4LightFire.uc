//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// MP5MAltFire
//=============================================================================
// MP5 Medic Gun secondary fire class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
//=============================================================================
// Flashlight
//=============================================================================
class Braindead_MP5A4LightFire extends KFFire;

var name FireAnim2;

simulated function ModeDoFire()
{

	if (Weapon != none && KFPlayerController(pawn(Weapon.Owner).Controller) != none )
	{
		KFPlayerController(pawn(Weapon.Owner).Controller).ToggleTorch();
		KFWeapon(Weapon).AdjustLightGraphic();
//		KFWeapon(Weapon).DoToggle();
	}
	Super.ModeDoFire();
}

function DoTrace(Vector Start, Rotator Dir)
{

}

// Sends a value to the 9mm attachment telling whether the light is being used.
function bool LightFiring()
{
	return bIsFiring;
}

simulated function bool AllowFire()
{
	if(KFWeapon(Weapon).bIsReloading || KFPawn(Instigator).SecondaryItem!=none || KFPawn(Instigator).bThrowingNade )
		return false;
	if(Level.TimeSeconds - LastClickTime > FireRate)
		return true;
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'KF_9MMSnd.Ninemm_AltFire1'
	 FireSoundRef="KF_9MMSnd.Ninemm_AltFire1"
	 //[end]
	 bFiringDoesntAffectMovement=True
     RecoilRate=0.150000
     bDoClientRagdollShotFX=False
     DamageType=Class'KFMod.DamTypeDualies'
     Momentum=0.000000
     bPawnRapidFireAnim=True
     bAttachSmokeEmitter=True
     TransientSoundVolume=1.800000
     FireAnim="Light_on"
     FireForce="AssaultRifleFire"
     AmmoClass=Class'KFMod.SingleAmmo'
     BotRefireRate=0.500000
     AimError=0.000000
}
