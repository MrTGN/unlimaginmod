//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseActor
//	Parent class:	 Actor
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.03.2014 14:41
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseActor extends Actor
	Abstract;


//========================================================================
//[block] Variables

struct	AnimData
{
	var	name	Anim;
	var	float	Rate;
	var	float	TweenTime;
	var	int		Channel;
};

struct	SoundData
{
	var	name		Ref;
	var	sound		Snd;
	var	ESoundSlot	Slot;
	var	float		Vol;
	var	bool		bNoOverride;
	var	float		Radius;
	var	float		Pitch;
	var	bool		Attenuate;
};

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

// Play a sound effect from SoundData struct.
simulated final function PlaySoundStruct(SoundData SName)
{
	local	float	Vol, Radius, Pitch;
	
	if (  SName.Snd != None )  {
		// Volume
		if ( SName.Vol > 0.0 )
			Vol = FClamp(SName.Vol, 0.0, 1.0);
		else
			Vol = 1.0;
		// Radius
		Radius = FMax(SName.Radius, 0.0);
		// Pitch
		if ( SName.Pitch > 0.0 )
			Pitch = FClamp(SName.Pitch, 0.5, 2.0);
		else
			Pitch = 1.0;
		// PlaySound
		PlaySound(SName.Snd, SName.Slot, Vol, SName.bNoOverride, Radius, Pitch, SName.Attenuate);
	}
}

// play a sound effect, but don't propagate to a remote owner
// (he is playing the sound clientside)
simulated final function PlayOwnedSoundStruct( SoundData SName )
{
	local	float	Vol, Radius, Pitch;
	
	if (  SName.Snd != None )  {
		// Volume
		if ( SName.Vol > 0.0 )
			Vol = FClamp(SName.Vol, 0.0, 1.0);
		else
			Vol = 1.0;
		// Radius
		Radius = FMax(SName.Radius, 0.0);
		// Pitch
		if ( SName.Pitch > 0.0 )
			Pitch = FClamp(SName.Pitch, 0.5, 2.0);
		else
			Pitch = 1.0;
		//PlayOwnedSound
		PlayOwnedSound(SName.Snd, SName.Slot, Vol, SName.bNoOverride, Radius, Pitch, SName.Attenuate);
	}
}

//[end] Functions
//====================================================================


defaultproperties
{
}
