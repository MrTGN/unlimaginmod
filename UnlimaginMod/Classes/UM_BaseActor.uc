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
	var	float	StartFrame;		// The frame number at which start to playing animation
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

//[block] Sound functions
// Play a sound effect from SoundData struct.
simulated final function PlaySoundData( SoundData SD )
{
	if (  SD.Snd != None )  {
		// Volume
		if ( SD.Vol > 0.0 )
			SD.Vol = FClamp(SD.Vol, 0.0, 1.0);
		else
			SD.Vol = 1.0;
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		// PlaySound
		PlaySound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
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
		// Pitch
		if ( SD.Pitch > 0.0 )
			SD.Pitch = FClamp(SD.Pitch, 0.5, 2.0);
		else
			SD.Pitch = 1.0;
		// PlayOwnedSound
		PlayOwnedSound(SD.Snd, SD.Slot, SD.Vol, SD.bNoOverride, SD.Radius, SD.Pitch, SD.Attenuate);
	}
}
//[end]

//[block] Animation functions
// Play the animation once
simulated final function PlayAnimData( AnimData AD )
{
	if ( AD.Anim != '' && HasAnim(AD.Anim) )  {
		// Rate
		if ( AD.Rate <= 0.0 )
			AD.Rate = 1.0;
		// PlayAnim
		PlayAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
		// StartFrame
		if ( AD.StartFrame > 0.0 )
			SetAnimFrame(AD.StartFrame, AD.Channel, 1);
	}
}

// Loop the animation playback
simulated final function LoopAnimData( AnimData AD )
{
	if ( AD.Anim != '' && HasAnim(AD.Anim) )  {
		// Rate
		if ( AD.Rate <= 0.0 )
			AD.Rate = 1.0;
		// LoopAnim
		LoopAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
	}
}
//[end]

//[block] DynamicLoad functions
// DynamicLoad Class specified in the Ref string
simulated static final function LoadClass( string Ref, out Class C, optional bool bMayFail )
{
	if ( Ref != "" )
		C = Class(DynamicLoadObject(Ref, class'Class', bMayFail));
}

// DynamicLoad Combiner specified in the Ref string
simulated static final function LoadCombiner( string Ref, out Combiner C, optional bool bMayFail )
{
	if ( Ref != "" )
		C = Combiner(DynamicLoadObject(Ref, class'Combiner', bMayFail));
}

// DynamicLoad FinalBlend specified in the Ref string
simulated static final function LoadFinalBlend( string Ref, out FinalBlend FB, optional bool bMayFail )
{
	if ( Ref != "" )
		FB = FinalBlend(DynamicLoadObject(Ref, class'FinalBlend', bMayFail));
}

// DynamicLoad Font specified in the Ref string
simulated static final function LoadFont( string Ref, out Font F, optional bool bMayFail )
{
	if ( Ref != "" )
		F = Font(DynamicLoadObject(Ref, class'Font', bMayFail));
}

// DynamicLoad Material specified in the Ref string
simulated static final function LoadMaterial( string Ref, out Material M, optional bool bMayFail )
{
	if ( Ref != "" )
		M = Material(DynamicLoadObject(Ref, class'Material', bMayFail));
}

// DynamicLoad ScriptedTexture specified in the Ref string
simulated static final function LoadScriptedTexture( string Ref, out ScriptedTexture ST, optional bool bMayFail )
{
	if ( Ref != "" )
		ST = ScriptedTexture(DynamicLoadObject(Ref, class'ScriptedTexture', bMayFail));
}

// DynamicLoad Sound specified in the Ref string
simulated static final function LoadSound( string Ref, out Sound S, optional bool bMayFail )
{
	if ( Ref != "" )
		S = Sound(DynamicLoadObject(Ref, class'Sound', bMayFail));
}

// DynamicLoad Texture specified in the Ref string
simulated static final function LoadTexture( string Ref, out Texture T, optional bool bMayFail )
{
	if ( Ref != "" )
		T = Texture(DynamicLoadObject(Ref, class'Texture', bMayFail));
}

// DynamicLoad Mesh specified in the Ref string
simulated static final function Mesh LoadMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Mesh(DynamicLoadObject(Ref, class'Mesh', bMayFail));
	else
		Return None;
}

// DynamicLoad SkeletalMesh specified in the Ref string
simulated static final function SkeletalMesh LoadSkeletalMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return SkeletalMesh(DynamicLoadObject(Ref, class'SkeletalMesh', bMayFail));
	else
		Return None;
}

// DynamicLoad StaticMesh specified in the Ref string
simulated static final function StaticMesh LoadStaticMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return StaticMesh(DynamicLoadObject(Ref, class'StaticMesh', bMayFail));
	else
		Return None;
}

// Actor Meshs DynamicLoad
// DynamicLoad Actor Mesh specified in the Ref string
simulated static final function LoadActorMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultMesh( Mesh(DynamicLoadObject(Ref, class'Mesh', bMayFail)) );
		if ( A.default.Mesh != None )
			A.LinkMesh( A.default.Mesh );
	}
}

// DynamicLoad Actor SkeletalMesh specified in the Ref string
simulated static final function LoadActorSkeletalMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultMesh( SkeletalMesh(DynamicLoadObject(Ref, class'SkeletalMesh', bMayFail)) );
		if ( A.default.Mesh != None )
			A.LinkMesh( A.default.Mesh );
	}
}

// DynamicLoad Actor StaticMesh specified in the Ref string
simulated static final function LoadActorStaticMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultStaticMesh( StaticMesh(DynamicLoadObject(Ref, class'StaticMesh', bMayFail)) );
		if ( A.default.StaticMesh != None )
			A.SetStaticMesh( A.default.StaticMesh );
	}
}
//[end]

//[end] Functions
//====================================================================


defaultproperties
{
}
