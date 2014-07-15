//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseAutomaticWeaponFire
//	Parent class:	 UM_BaseProjectileWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.04.2013 19:25
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseAutomaticWeaponFire extends UM_BaseProjectileWeaponFire
	Abstract;


//========================================================================
//[block] Variables

//[block] Spread Bonuses
var(Spread)		float			SemiAutoSpreadBonus;
var(Spread)		float			BurstSpreadBonus;
//[end]

// Burst firemode
var(BurstMode)	bool			bSetToBurst;
var(BurstMode)	int				RoundsInBurst, BurstRoundsRemaining;

// If bHighRateOfFire=True, weapon will use FireLoop state. 
// In this state weapon will loop sounds and animation while firing.
var				bool			bHighRateOfFire;

// Copied from KFHighROFFire to add HighRateOfFire weapon support
// sounds
var				sound			FireEndSound;				// The sound to play at the end of the ambient fire sound
var				sound			FireEndStereoSound;    		// The sound to play at the end of the ambient fire sound in first person stereo
var				sound			AmbientFireSound;           // How loud to play the looping ambient fire sound
var				float			AmbientFireSoundRadius;		// The sound radius for the ambient fire sound
var				byte			AmbientFireVolume;          // The ambient fire sound

var				string			FireEndSoundRef;
var				string			FireEndStereoSoundRef;
var				string			AmbientFireSoundRef;

// Default anim names for the HighRateOfFire weapons.
const		DefaultFireLoopAnimName = 'Fire_Loop';
const		DefaultFireLoopAimedAnimName = 'Fire_Iron_Loop';
const		DefaultFireEndAnimName = 'Fire_End';
const		DefaultFireEndAimedAnimName = 'Fire_Iron_End';

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// Copied from KFHighROFFire with some changes to add HighRateOfFire weapon support
simulated static function PreloadAssets(LevelInfo LevelInfo, optional KFShotgunFire Spawned)
{
	if ( default.bHighRateOfFire )  {
		//[block] Loading Defaults
		if ( default.FireEndSoundRef != "" )
			default.FireEndSound = sound(DynamicLoadObject(default.FireEndSoundRef, class'sound', true));

		if ( LevelInfo.bLowSoundDetail || (default.FireEndStereoSoundRef == "" && default.FireEndStereoSound == None) )
			default.FireEndStereoSound = default.FireEndSound;
		else if ( default.FireEndStereoSoundRef != "" )
			default.FireEndStereoSound = sound(DynamicLoadObject(default.FireEndStereoSoundRef, class'Sound', true));

		if ( default.AmbientFireSoundRef != "" )
			default.AmbientFireSound = sound(DynamicLoadObject(default.AmbientFireSoundRef, class'sound', true));
				
		if ( UM_BaseAutomaticWeaponFire(Spawned) != None )   {
			if ( default.FireEndSound != None )
				UM_BaseAutomaticWeaponFire(Spawned).FireEndSound = default.FireEndSound;
			if ( default.FireEndStereoSound != None )
				UM_BaseAutomaticWeaponFire(Spawned).FireEndStereoSound = default.FireEndStereoSound;
			if ( default.AmbientFireSound != None )
				UM_BaseAutomaticWeaponFire(Spawned).AmbientFireSound = default.AmbientFireSound;
		}
		//[end]
	}
	Super.PreloadAssets(LevelInfo, Spawned);
}

// Copied from KFHighROFFire with some changes to add HighRateOfFire weapon support
simulated static function bool UnloadAssets()
{
	if ( default.bHighRateOfFire )  {
		if ( default.FireEndSound != None )
			default.FireEndSound = None;
		if ( default.FireEndStereoSound != None )
			default.FireEndStereoSound = None;
		if ( default.AmbientFireSound != None )
			default.AmbientFireSound = None;
	}
	
	Return Super.UnloadAssets();
}

simulated function CheckAnimArrays()
{
	local	byte	i;
	
	// Hack for the HighRateOfFire Animation.
	// Needed because UT2004 doesn't supports structdefaultproperties.
	// Also needed because peoples are to lazy and 
	// they doesn't sets the proper animations names in defaultproperties
	if ( bHighRateOfFire )  {
		//FireLoopAnims
		if ( FireLoopAnims.Length > 0 )  {
			for ( i = 0; i < FireLoopAnims.Length; ++i )  {
				if ( FireLoopAnims[i].Anim == '' || FireLoopAnims[i].Anim == 'FireLoop' )
					FireLoopAnims[i].Anim = DefaultFireLoopAnimName;
			}
		}
		else  {
			FireLoopAnims.Insert(0, 1);
			FireLoopAnims[0].Anim = DefaultFireLoopAnimName;
		}
		
		//FireLoopAimedAnims
		if ( FireLoopAimedAnims.Length > 0 )  {
			for ( i = 0; i < FireLoopAimedAnims.Length; ++i )  {
				if ( FireLoopAimedAnims[i].Anim == '' || FireLoopAimedAnims[i].Anim == 'FireLoop' )
					FireLoopAimedAnims[i].Anim = DefaultFireLoopAimedAnimName;
			}
		}
		else  {
			FireLoopAimedAnims.Insert(0, 1);
			FireLoopAimedAnims[0].Anim = DefaultFireLoopAimedAnimName;
		}
		
		//FireEndAnims
		if ( FireEndAnims.Length > 0 ) {
			for ( i = 0; i < FireEndAnims.Length; ++i )  {
				if ( FireEndAnims[i].Anim == '' || FireEndAnims[i].Anim == 'FireEnd' )
					FireEndAnims[i].Anim = DefaultFireEndAnimName;
			}
		}
		else {
			FireEndAnims.Insert(0, 1);
			FireEndAnims[0].Anim = DefaultFireEndAnimName;
		}
		
		//FireEndAimedAnims
		if ( FireEndAimedAnims.Length > 0 )  {
			for ( i = 0; i < FireEndAimedAnims.Length; ++i )  {
				if ( FireEndAimedAnims[i].Anim == '' || FireEndAimedAnims[i].Anim == 'FireEnd' )
					FireEndAimedAnims[i].Anim = DefaultFireEndAimedAnimName;
			}
		}
		else  {
			FireEndAimedAnims.Insert(0, 1);
			FireEndAimedAnims[0].Anim = DefaultFireEndAimedAnimName;
		}
	}
	
	Super.CheckAnimArrays();
}

// Copied from KFHighROFFire with some changes to add HighRateOfFire weapon support
// Sends the fire class to the looping or bursting state
function StartFiring()
{
    if ( bSetToBurst )
		GotoState('Bursting');
	else if ( bHighRateOfFire && !bWaitForRelease )
		GotoState('FireLoop');
}

// Copied from KFHighROFFire with some changes to add HighRateOfFire weapon support
// Handles toggling the weapon attachment's ambient sound on and off
function PlayAmbientSound(Sound aSound)
{
	local	WeaponAttachment	WA;

	WA = WeaponAttachment(Weapon.ThirdPersonActor);

    if ( Weapon == None || WA == None )
        Return;

	if ( aSound == None )  {
		WA.SoundVolume = WA.default.SoundVolume;
		WA.SoundRadius = WA.default.SoundRadius;
	}
	else  {
		WA.SoundVolume = AmbientFireVolume;
		WA.SoundRadius = AmbientFireSoundRadius;
	}

    WA.AmbientSound = aSound;
}

// Calculate modifications to spread bonus
function float UpdateSpread(float NewSpread)
{
	NewSpread = Super.UpdateSpread(NewSpread);
	
	// Small spread bonus for BurstMode firing or for firing in semi-auto mode
	if ( bSetToBurst )
		NewSpread *= BurstSpreadBonus;
	else if ( bWaitForRelease )
		NewSpread *= SemiAutoSpreadBonus;
	
	Return NewSpread;
}

event ModeDoFire()
{
	if ( (!bHighRateOfFire && !bSetToBurst) || (bWaitForRelease && !bSetToBurst) )
		Super(UM_BaseProjectileWeaponFire).ModeDoFire();
}

state Bursting
{
	event BeginState()
	{
		if ( !bWaitForRelease )
			bWaitForRelease = True;
		
		UpdateFireRate();
		if ( KFWeapon(Weapon).MagAmmoRemaining >= RoundsInBurst )
			BurstRoundsRemaining = RoundsInBurst;
		else
			BurstRoundsRemaining = KFWeapon(Weapon).MagAmmoRemaining;
		
		SetTimer(FireRate, True);
	}
	
	// Clearing this function to not change Muzzle every shot in burst
	simulated function ChangeMuzzleNum() { }
	
	event ModeDoFire()
	{
		if ( Global.AllowFire() )
			Super(UM_BaseProjectileWeaponFire).ModeDoFire();
		else  {
			SetTimer(0.0, False);
			BurstRoundsRemaining = 0;
			Global.ChangeMuzzleNum();
			GotoState('');
			Return;
		}
	}
	
	event Timer()
	{
		BurstRoundsRemaining--;
		if ( BurstRoundsRemaining < 1 )  {
			SetTimer(0.0, False);
			BurstRoundsRemaining = 0;
			Global.ChangeMuzzleNum();
			GotoState('');
			Return;
		}
		ModeDoFire();
	}
}

/* =================================================================================== *
* FireLoop
* 	This state handles looping the firing animations and ambient fire sounds as well
*	as firing rounds.
*
* modified by: Ramm 1/17/05
* =================================================================================== */
state FireLoop
{
	event BeginState()
	{
		//Log(self$": In state FireLoop");
		UpdateFireRate();
		if ( KFWeap.bAimingRifle && FireLoopAimedAnims.Length > MuzzleNum
			 && Weapon.HasAnim( FireLoopAimedAnims[MuzzleNum].Anim ) )
			Weapon.LoopAnim( FireLoopAimedAnims[MuzzleNum].Anim, 
							 (FireLoopAimedAnims[MuzzleNum].Rate * FireSpeedModif), 
							 0.0 );
		else if ( FireLoopAnims.Length > MuzzleNum && Weapon.HasAnim( FireLoopAnims[MuzzleNum].Anim ) )
			Weapon.LoopAnim( FireLoopAnims[MuzzleNum].Anim, 
							 (FireLoopAnims[MuzzleNum].Rate * FireSpeedModif), 
							 0.0 );
		PlayAmbientSound(AmbientFireSound);
	}

	event ModeDoFire()
	{
		if ( Global.AllowFire() )
			Super(UM_BaseProjectileWeaponFire).ModeDoFire();
		else  {
			GotoState('');
			Return;
		}
	}

	// Overriden because we play an anbient fire sound
	function PlayFiring() { }
	function ServerPlayFiring() { }

	function StopFiring()
	{
		GotoState('');
		Return;
	}

	// Protects from the non-stopping FireLoop
	event ModeTick(float dt)
	{
		Global.ModeTick(dt);
		
		if ( bInstantStop || !bIsFiring )  {
			GotoState('');
			Return;
		}
	}

	event EndState()
	{
		//Log(self$": Outing from state FireLoop");
		Weapon.AnimStopLooping();
		PlayAmbientSound(None);
		
		if ( Weapon.Instigator != None && Weapon.Instigator.IsLocallyControlled() &&
			 Weapon.Instigator.IsFirstPerson() && StereoFireSound != None )
			Weapon.PlayOwnedSound(FireEndStereoSound, SLOT_None, (AmbientFireVolume / 127),, AmbientFireSoundRadius,, false);
		else
			Weapon.PlayOwnedSound(FireEndSound, SLOT_None, (AmbientFireVolume / 127),, AmbientFireSoundRadius);
			
		if ( bIsFiring )
			Weapon.StopFire(ThisModeNum);
	}
}

function PlayFireEnd()
{
	if ( !bHighRateOfFire || (bHighRateOfFire && !bWaitForRelease && !bSetToBurst) )
		Super(UM_BaseProjectileWeaponFire).PlayFireEnd();
}

//[end] Functions
//====================================================================

defaultproperties
{
     bHighRateOfFire=False
	 // Animation
	 //Default TweenTime
	 TweenTime=0.025000
	 //EmptyAnim
	 EmptyAnim="empty"
     EmptyAnimRate=1.000000
     //EmptyFireAnims
	 EmptyFireAnims(0)=(Anim="EmptyFire",Rate=1.000000)
	 //Sounds
	 AmbientFireSoundRadius=500.000000
     AmbientFireVolume=255
	 TransientSoundVolume=1.800000
	 TransientSoundRadius=400.000000
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.750000
	 FireMovingSpeedScale=0.500000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.950000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.950000
	 SemiAutoSpreadBonus=0.850000
	 BurstSpreadBonus=0.950000
     //AimError
     AimingAimErrorBonus=0.600000
     CrouchedAimErrorBonus=0.850000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.050000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001000
	 //[end]
	 //Booleans
     bPawnRapidFireAnim=True
	 bWaitForRelease=False
	 bSetToBurst=False
	 bChangeProjByPerk=False
	 //Fire properties
	 FireForce="AssaultRifleFire"
	 AmmoPerFire=1
	 ProjPerFire=1
	 RoundsInBurst=3
	 RecoilRate=0.090000
	 RecoilVelocityScale=3.000000
	 BotRefireRate=0.100000
	 AimError=30.000000
	 //Spread
	 Spread=0.010000
	 ShotsForMaxSpread=6
	 MaxSpread=0.100000
}
