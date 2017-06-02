//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_StickyRMCGrenade
//	Parent class:	 UM_BaseProjectile_StickyGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 03:17
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Sticky grenade with remote control (RMC)
//================================================================================
class UM_BaseProjectile_StickyRMCGrenade extends UM_BaseProjectile_StickyGrenade
	Abstract;

//========================================================================
//[block] Variables

var	 transient		bool		bDelayedExplode;
var					float		DelayedExplodeTimer;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

event Timer()
{
	if ( IsArmed() )  {
		if ( AllyIsInRadius(DamageRadius) )  { 
			if ( !bDelayedExplode )  {
				bDelayedExplode = True;
				SetTimer(DelayedExplodeTimer, bDelayedExplode);
			}
			if ( BeepSound.Snd != None )
				PlaySound(BeepSound.Snd, BeepSound.Slot, BeepSound.Vol, BeepSound.bNoOverride, BeepSound.Radius);
		}
		else  {
			Explode(Location, Vector(Rotation));
			SetTimer(0.0, False);
		}
	}
	else
		Destroy();
}

function Activate()
{
	if ( bArmed )
		Return;
	
	if ( BeepSound.Snd != None )
		PlaySound(BeepSound.Snd, BeepSound.Slot, (BeepSound.Vol * 1.5), BeepSound.bNoOverride, BeepSound.Radius);
	
	bArmed = True;
	SetTimer(ArmingDelay, bLoopTimer);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bLoopTimer=False
	 ArmingDelay=0.15
	 bDelayArming=True
	 DelayedExplodeTimer=0.25
	 Damage=280.000000
	 DamageRadius=330.000000
	 MomentumTransfer=50000.000000
}
