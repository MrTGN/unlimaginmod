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
	var	string		Ref;
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
simulated final function PlaySoundStruct( SoundData SD )
{
	if (  SD.Snd != None )  {
		// Volume
		if ( SD.Vol > 0.0 )
			SD.Vol = FClamp(SD.Vol, 0.0, 1.0);
		else
			SD.Vol = 1.0;
		// Radius
		SD.Radius = FMax(SD.Radius, 0.0);
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		// PlaySound
		PlaySound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
	}
}

// Static function for classes which do not extend this class
simulated static final function ActorPlaySoundStruct( Actor A, SoundData SD )
{
	if (  A != None && SD.Snd != None )  {
		// Volume
		if ( SD.Vol > 0.0 )
			SD.Vol = FClamp(SD.Vol, 0.0, 1.0);
		else
			SD.Vol = 1.0;
		// Radius
		SD.Radius = FMax(SD.Radius, 0.0);
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		// PlaySound
		A.PlaySound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
	}
}

// play a sound effect, but don't propagate to a remote owner
// (he is playing the sound clientside)
simulated final function PlayOwnedSoundStruct( SoundData SD )
{
	if (  SD.Snd != None )  {
		// Volume
		if ( SD.Vol > 0.0 )
			SD.Vol = FClamp(SD.Vol, 0.0, 1.0);
		else
			SD.Vol = 1.0;
		// Radius
		SD.Radius = FMax(SD.Radius, 0.0);
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		//PlayOwnedSound
		PlayOwnedSound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
	}
}

// Static function for classes which do not extend this class
simulated static final function ActorPlayOwnedSoundStruct( Actor A, SoundData SD )
{
	if (  A != None && SD.Snd != None )  {
		// Volume
		if ( SD.Vol > 0.0 )
			SD.Vol = FClamp(SD.Vol, 0.0, 1.0);
		else
			SD.Vol = 1.0;
		// Radius
		SD.Radius = FMax(SD.Radius, 0.0);
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		//PlayOwnedSound
		A.PlayOwnedSound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
	}
}

simulated static final function PreloadSound( string Ref, out sound Snd )
{
	if ( Ref != "" )
		Snd = sound(DynamicLoadObject(Ref, class'sound'));
}

simulated static final function PreloadTexture( string Ref, out texture T )
{
	if ( Ref != "" )
		T = texture(DynamicLoadObject(Ref, class'texture'));
}

//[end] Functions
//====================================================================


defaultproperties
{
}
