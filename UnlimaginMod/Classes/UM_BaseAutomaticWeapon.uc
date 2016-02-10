//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseAutomaticWeapon
//	Parent class:	 UM_BaseWeapon
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 02.05.2013 23:11
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseAutomaticWeapon extends UM_BaseWeapon
	DependsOn(UM_BaseActor)
	Abstract;


//========================================================================
//[block] Variables

enum	EFireMode
{
	FM_Auto,
	FM_SemiAuto,
	FM_2RoundBurst,
	FM_3RoundBurst,
	FM_4RoundBurst,
	FM_5RoundBurst
};

var		Class< CriticalEventPlus >	FireModeSwitchMessageClass;
var		array< EFireMode >			SelectiveFireModes;		// Array with weapon fire modes. Used for switching between Auto and Semi-Auto modes etc.
var		byte						SelectiveFireModeNum;
var		UM_BaseActor.AnimData		FireModeSwitchAnim;
var		float						FireModeSwitchTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		SelectiveFireModeNum;
	
	reliable if ( Role == ROLE_Authority )
		SetFireMode;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function bool FireModesReadyToFire()
{
	local	int		Mode;
	
	for ( Mode = 0; Mode < NUM_FIRE_MODES; ++Mode )  {
		if ( FireMode[Mode] == None )
			Continue;
		else if ( FireMode[Mode].IsInState('Initialization') || (FireMode[Mode].bModeExclusive 
					 && (FireMode[Mode].bIsFiring || FireMode[Mode].IsInState('FireLoop') || FireMode[Mode].IsInState('Bursting'))) )
			Return False;
	}
	
	Return True;
}

function bool AllowToggleTacticalModule()
{
	if ( IsInState('SwitchingFireMode') )
		Return False;
	
	Return Super.AllowToggleTacticalModule();
}

function bool AllowSwitchFireMode()
{
	if ( bIsReloading || IsInState('TogglingTacticalModule') || IsInState('SwitchingFireMode') )
		Return False;
	
	Return FireModesReadyToFire() && SelectiveFireModes.Length > 0;
}

exec function SwitchFireMode()
{
	if ( AllowSwitchFireMode() )
		GotoState('SwitchingFireMode');
}

simulated function SetFireMode(EFireMode NewFM)
{
	switch(NewFM)  {
		case FM_Auto:
			FireMode[0].bWaitForRelease = False;
			if ( UM_BaseAutomaticWeaponFire(FireMode[0]) != None )
				UM_BaseAutomaticWeaponFire(FireMode[0]).bSetToBurst = False;
			Break;
		
		case FM_SemiAuto:
			FireMode[0].bWaitForRelease = True;
			if ( UM_BaseAutomaticWeaponFire(FireMode[0]) != None )
				UM_BaseAutomaticWeaponFire(FireMode[0]).bSetToBurst = False;
			Break;
	
		case FM_2RoundBurst:
		case FM_3RoundBurst:
		case FM_4RoundBurst:
		case FM_5RoundBurst:
			FireMode[0].bWaitForRelease = True;
			if ( UM_BaseAutomaticWeaponFire(FireMode[0]) != None )  {
				UM_BaseAutomaticWeaponFire(FireMode[0]).RoundsInBurst = NewFM;
				UM_BaseAutomaticWeaponFire(FireMode[0]).bSetToBurst = True;
			}
			Break;
	}
}

state SwitchingFireMode
{
	simulated event BeginState()
	{
		local	PlayerController	Player;
		
		++SelectiveFireModeNum;
		if ( SelectiveFireModeNum >= SelectiveFireModes.Length )
			SelectiveFireModeNum = 0;
		
		SetFireMode(SelectiveFireModes[SelectiveFireModeNum]);
		SetTimer(FireModeSwitchTime, false);
		
		if ( Instigator.IsLocallyControlled() && HasAnim(FireModeSwitchAnim.Anim) )
			PlayAnim(FireModeSwitchAnim.Anim, FireModeSwitchAnim.Rate, FireModeSwitchAnim.TweenTime);
		
		Player = Level.GetLocalPlayerController();
		if ( Player != None )  {
			if ( ModeSwitchSound.Snd != None )
				PlayOwnedSound(ModeSwitchSound.Snd, ModeSwitchSound.Slot, ModeSwitchSound.Vol, ModeSwitchSound.bNoOverride, ModeSwitchSound.Radius, BaseActor.static.GetRandPitch(ModeSwitchSound.PitchRange), ModeSwitchSound.bUse3D);
			//ToDo: â äàëüíåéøåì çàìåíèòü ýòî íà îòäåëüíóþ ñòðîêó íà ýêðàíå è ìåíÿòü å¸ ñîäåðæèìîå
			Player.ReceiveLocalizedMessage(FireModeSwitchMessageClass, SelectiveFireModeNum);
		}
	}
	
	simulated event Timer()
	{
		SetTimer(0.0, false);
		GotoState(InitialState);
	}
}

simulated function bool ReadyToFire(int Mode)
{
	if ( IsInState('SwitchingFireMode') )
		Return False;
	
	Return Super.ReadyToFire(Mode);
}

simulated function AnimEnd(int channel)
{
	local name anim;
	local float frame, rate;

	if ( !FireMode[0].IsInState('FireLoop') && !FireMode[1].IsInState('FireLoop') &&
		 !FireMode[0].IsInState('Bursting') && !FireMode[1].IsInState('Bursting') )  {
		GetAnimParams(0, anim, frame, rate);
		
		if ( ClientState == WS_ReadyToFire 
			 && ((FireMode[0] == None || !FireMode[0].bIsFiring) 
				  && (FireMode[1] == None || !FireMode[1].bIsFiring)) )
				PlayIdle();
	}
}

// Called by the native code when the interpolation of the first person weapon
// to the zoomed position finishes
simulated event OnZoomInFinished()
{
	local	name	anim;
	local	float	frame, rate;
	local	UM_BaseAutomaticWeaponFire	AWFF, AWFS;
	
	AWFF = UM_BaseAutomaticWeaponFire(FireMode[0]);
	AWFS = UM_BaseAutomaticWeaponFire(FireMode[1]);
	
	if ( (AWFF != None && AWFF.bHighRateOfFire) ||
		 (AWFS != None && AWFS.bHighRateOfFire) )  {
		GetAnimParams(0, anim, frame, rate);
		
		if (ClientState == WS_ReadyToFire)  {
			// Play the iron idle anim when we're finished zooming in
			if ( anim == IdleAnim )
				PlayIdle();
			else if ( AWFF != None && AWFF.IsInState('FireLoop') 
					 && AWFF.FireLoopAnims.Length > AWFF.MuzzleNum
					 && anim == AWFF.FireLoopAnims[AWFF.MuzzleNum].Anim 
					 && HasAnim( AWFF.FireLoopAimedAnims[AWFF.MuzzleNum].Anim ) )
				LoopAnim( AWFF.FireLoopAimedAnims[AWFF.MuzzleNum].Anim, AWFF.FireLoopAimedAnims[AWFF.MuzzleNum].Rate, AWFF.FireLoopAimedAnims[AWFF.MuzzleNum].TweenTime );
			else if ( AWFS != None && AWFS.IsInState('FireLoop')  
					 && AWFS.FireLoopAnims.Length > AWFS.MuzzleNum
					 && anim == AWFS.FireLoopAnims[AWFS.MuzzleNum].Anim 
					 && HasAnim( AWFS.FireLoopAimedAnims[AWFS.MuzzleNum].Anim ) )
				LoopAnim( AWFS.FireLoopAimedAnims[AWFS.MuzzleNum].Anim, AWFS.FireLoopAimedAnims[AWFS.MuzzleNum].Rate, AWFS.FireLoopAimedAnims[AWFS.MuzzleNum].TweenTime );
		}
	}
	else
		Super.OnZoomInFinished();
}


// Called by the native code when the interpolation of the first person weapon
// from the zoomed position finishes
simulated event OnZoomOutFinished()
{
	local	name	anim;
	local	float	frame, rate;
	local	UM_BaseAutomaticWeaponFire	AWFF, AWFS;
	
	AWFF = UM_BaseAutomaticWeaponFire(FireMode[0]);
	AWFS = UM_BaseAutomaticWeaponFire(FireMode[1]);
	
	if ( (AWFF != None && AWFF.bHighRateOfFire) ||
		 (AWFS != None && AWFS.bHighRateOfFire) )  {
		GetAnimParams(0, anim, frame, rate);
		
		if ( ClientState == WS_ReadyToFire )  {
			// Play the regular idle anim when we're finished zooming out
			if ( anim == IdleAimAnim )
				PlayIdle();
			else if ( AWFF != None && AWFF.IsInState('FireLoop') 
					 && AWFF.FireLoopAimedAnims.Length > AWFF.MuzzleNum
					 && anim == AWFF.FireLoopAimedAnims[AWFF.MuzzleNum].Anim 
					 && HasAnim( AWFF.FireLoopAnims[AWFF.MuzzleNum].Anim ) )
				LoopAnim( AWFF.FireLoopAnims[AWFF.MuzzleNum].Anim, AWFF.FireLoopAnims[AWFF.MuzzleNum].Rate, AWFF.FireLoopAnims[AWFF.MuzzleNum].TweenTime);
			else if ( AWFS != None && AWFS.IsInState('FireLoop') 
					 && AWFS.FireLoopAimedAnims.Length > AWFS.MuzzleNum
					 && anim == AWFS.FireLoopAimedAnims[AWFS.MuzzleNum].Anim
					 && HasAnim( AWFS.FireLoopAnims[AWFS.MuzzleNum].Anim ) )
				LoopAnim( AWFS.FireLoopAnims[AWFS.MuzzleNum].Anim, AWFS.FireLoopAnims[AWFS.MuzzleNum].Rate, AWFS.FireLoopAnims[AWFS.MuzzleNum].TweenTime);
		}
	}
	else
		Super.OnZoomOutFinished();
}

//[end] Functions
//====================================================================


defaultproperties
{
     FireModeSwitchAnim=(Rate=1.000000,TweenTime=0.001000)
	 FireModeSwitchTime=0.150000
	 bHasTacticalReload=True
	 FireModeSwitchMessageClass=Class'UnlimaginMod.UM_SelectiveFireModeSwitchMessage'
}
