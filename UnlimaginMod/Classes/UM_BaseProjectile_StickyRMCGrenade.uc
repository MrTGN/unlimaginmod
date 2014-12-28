//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_StickyRMCGrenade
//	Parent class:	 UM_BaseProjectile_StickyGrenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 19.07.2013 03:17
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Sticky grenade with remote control (RMC)
//================================================================================
class UM_BaseProjectile_StickyRMCGrenade extends UM_BaseProjectile_StickyGrenade
	Abstract;

//========================================================================
//[block] Variables

var		bool	bDelayedExplode;
var		float	DelayedExplodeTimer;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

event Timer()
{
	if ( IsArmed() )  {
		if ( !FriendlyPawnIsInRadius(DamageRadius) )
			Explode(Location, Vector(Rotation));
		else  { 
			if ( !bDelayedExplode )  {
				bDelayedExplode = True;
				SetTimer(DelayedExplodeTimer, True);
			}
			if ( BeepSound.Snd != None )
				PlaySound(BeepSound.Snd, BeepSound.Slot, BeepSound.Vol, BeepSound.bNoOverride, BeepSound.Radius, BaseActor.static.GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
		}
	}
	else
		Destroy();
}

function Activate()
{
	if ( BeepSound.Snd != None )
		PlaySound(BeepSound.Snd, BeepSound.Slot, (BeepSound.Vol * 1.5), BeepSound.bNoOverride, BeepSound.Radius, BaseActor.static.GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
	
	SetTimer(ExplodeTimer, True);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 ExplodeTimer=0.150000
	 DelayedExplodeTimer=0.200000
	 Damage=280.000000
	 DamageRadius=330.000000
	 MomentumTransfer=50000.000000
}
