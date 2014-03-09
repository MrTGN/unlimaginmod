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
//	Comments:		 UnlimaginMod base Actor class
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
simulated final function PlaySoundData( SoundData SD )
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
simulated static final function ActorPlaySoundData( Actor A, SoundData SD )
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
simulated final function PlayOwnedSoundData( SoundData SD )
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
simulated static final function ActorPlayOwnedSoundData( Actor A, SoundData SD )
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


// DynamicLoad Class specified in the Ref string
simulated static final function Class LoadClass( string Ref, optional out Class C, optional bool bMayFail )
{
	if ( Ref != "" )
		C = Class(DynamicLoadObject(Ref, class'Class', bMayFail));
	
	Return C;
}

// DynamicLoad Combiner specified in the Ref string
simulated static final function Combiner LoadCombiner( string Ref, optional out Combiner C, optional bool bMayFail )
{
	if ( Ref != "" )
		C = Combiner(DynamicLoadObject(Ref, class'Combiner', bMayFail));
	
	Return C;
}

// DynamicLoad FinalBlend specified in the Ref string
simulated static final function FinalBlend LoadFinalBlend( string Ref, optional out FinalBlend FB, optional bool bMayFail )
{
	if ( Ref != "" )
		FB = FinalBlend(DynamicLoadObject(Ref, class'FinalBlend', bMayFail));
	
	Return FB;
}

// DynamicLoad Font specified in the Ref string
simulated static final function Font LoadFont( string Ref, optional out Font F, optional bool bMayFail )
{
	if ( Ref != "" )
		F = Font(DynamicLoadObject(Ref, class'Font', bMayFail));
	
	Return F;
}

// DynamicLoad Material specified in the Ref string
simulated static final function Material LoadMaterial( string Ref, optional out Material M, optional bool bMayFail )
{
	if ( Ref != "" )
		M = Material(DynamicLoadObject(Ref, class'Material', bMayFail));
	
	Return M;
}

// DynamicLoad Mesh specified in the Ref string
simulated static final function Mesh LoadMesh( string Ref, optional out Mesh M, optional bool bMayFail )
{
	if ( Ref != "" )
		M = Mesh(DynamicLoadObject(Ref, class'Mesh', bMayFail));
	
	Return M;
}

// DynamicLoad SkeletalMesh specified in the Ref string
simulated static final function SkeletalMesh LoadSkeletalMesh( string Ref, optional out SkeletalMesh SM, optional bool bMayFail )
{
	if ( Ref != "" )
		SM = SkeletalMesh(DynamicLoadObject(Ref, class'SkeletalMesh', bMayFail));
	
	Return SM;
}

// DynamicLoad StaticMesh specified in the Ref string
simulated static final function StaticMesh LoadStaticMesh( string Ref, optional out StaticMesh SM, optional bool bMayFail )
{
	if ( Ref != "" )
		SM = StaticMesh(DynamicLoadObject(Ref, class'StaticMesh', bMayFail));
	
	Return SM;
}

// DynamicLoad ScriptedTexture specified in the Ref string
simulated static final function ScriptedTexture LoadScriptedTexture( string Ref, optional out ScriptedTexture ST, optional bool bMayFail )
{
	if ( Ref != "" )
		ST = ScriptedTexture(DynamicLoadObject(Ref, class'ScriptedTexture', bMayFail));
	
	Return ST;
}

// DynamicLoad Sound specified in the Ref string
simulated static final function Sound LoadSound( string Ref, optional out Sound S, optional bool bMayFail )
{
	if ( Ref != "" )
		S = Sound(DynamicLoadObject(Ref, class'Sound', bMayFail));
	
	Return S;
}

// DynamicLoad Texture specified in the Ref string
simulated static final function Texture LoadTexture( string Ref, optional out Texture T, optional bool bMayFail )
{
	if ( Ref != "" )
		T = Texture(DynamicLoadObject(Ref, class'Texture', bMayFail));
	
	Return T;
}


//[end] Functions
//====================================================================


defaultproperties
{
}
