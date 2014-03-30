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


event Timer()
{
	if ( !bHidden && !bTriggered )  {
		if ( !FriendlyPawnIsInRadius(DamageRadius) )
			Explode(Location, vect(0,0,1));
		else if ( BeepSound.Snd != None )
			PlaySoundData(BeepSound);
	}
	else
		Destroy();
}

function Activate()
{
	if ( BeepSound.Snd != None )
		PlaySoundData(BeepSound, 1.5);
	SetTimer(ExplodeTimer, True);
}

defaultproperties
{
	 ExplodeTimer=0.160000
	 Damage=280.000000
	 DamageRadius=330.000000
	 MomentumTransfer=50000.000000
}
