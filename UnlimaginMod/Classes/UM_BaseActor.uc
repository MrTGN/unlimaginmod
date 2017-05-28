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
	DependsOn(UM_BaseObject)
	Abstract;


//========================================================================
//[block] Variables

// Constants
const	Maths = Class'UnlimaginMod.UnlimaginMaths';
const	bTestBuild = True; // Unlocking dlc weapons and other stuff for testing

// Read http://udn.epicgames.com/Two/ActorFunctions.html#PlayAnim for more info
struct	AnimData
{
	var	name	Anim;
	var	float	Rate;
	var	float	StartFrame;		// The frame number at which start to playing animation
	var	float	TweenTime;
	var	int		Channel;
};

// Read http://udn.epicgames.com/Two/SoundReference.html for more info
struct	SoundData
{
	var	string		Ref;
	var	sound		Snd;
	var	ESoundSlot	Slot;
	var	float		Vol;
	var	bool		bNoOverride;
	var	float		Radius;
	var	Range		PitchRange;	// Random pitching within this range
	var	bool		bUse3D;	// Use (Ture) or not (False) 3D sound positioning in the world from the actor location
};

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

// RandPitch
simulated static final function float GetRandPitch( range PitchRange )
{
	if ( PitchRange.Min > 0.0 && PitchRange.Max > 0.0 )
		Return Lerp( FRand(), PitchRange.Min, PitchRange.Max );
	else
		Return 1.0; // Return default pitch
}

//[block] Animation functions
// Play the animation once
simulated final function PlayAnimData( AnimData AD, optional float RateMult )
{
	// Rate
	if ( AD.Rate <= 0.0 )
		AD.Rate = 1.0;
	// RateMult
	if ( RateMult > 0.0 )
		AD.Rate *= RateMult;
	// PlayAnim
	PlayAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
	// StartFrame
	if ( AD.StartFrame > 0.0 )
		SetAnimFrame(AD.StartFrame, AD.Channel, 1);
}

// Loop the animation playback
simulated final function LoopAnimData( AnimData AD, optional float RateMult )
{
	// Rate
	if ( AD.Rate <= 0.0 )
		AD.Rate = 1.0;
	// RateMult
	if ( RateMult > 0.0 )
		AD.Rate *= RateMult;
	// LoopAnim
	LoopAnim(AD.Anim, AD.Rate, AD.TweenTime, AD.Channel);
}
//[end]

//[block] DynamicLoad functions
// DynamicLoad Combiner specified in the Ref string
simulated static final function Combiner LoadCombiner( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Combiner(DynamicLoadObject(Ref, Class'Combiner', bMayFail));
	
	Return None;
}

// DynamicLoad FinalBlend specified in the Ref string
simulated static final function FinalBlend LoadFinalBlend( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return FinalBlend(DynamicLoadObject(Ref, Class'FinalBlend', bMayFail));
	
	Return None;
}

// DynamicLoad Font specified in the Ref string
simulated static final function Font LoadFont( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Font(DynamicLoadObject(Ref, Class'Font', bMayFail));
	
	Return None;
}

// DynamicLoad Material specified in the Ref string
simulated static final function Material LoadMaterial( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Material(DynamicLoadObject(Ref, Class'Material', bMayFail));
	
	Return None;
}

// DynamicLoad ScriptedTexture specified in the Ref string
simulated static final function ScriptedTexture LoadScriptedTexture( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return ScriptedTexture(DynamicLoadObject(Ref, Class'ScriptedTexture', bMayFail));
	
	Return None;
}

// DynamicLoad Sound specified in the Ref string
simulated static final function Sound LoadSound( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Sound(DynamicLoadObject(Ref, Class'Sound', bMayFail));
	
	Return None;
}

// DynamicLoad Texture specified in the Ref string
simulated static final function Texture LoadTexture( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Texture(DynamicLoadObject(Ref, Class'Texture', bMayFail));
	
	Return None;
}

// DynamicLoad Mesh specified in the Ref string
simulated static final function Mesh LoadMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return Mesh(DynamicLoadObject(Ref, Class'Mesh', bMayFail));
	
	Return None;
}

// DynamicLoad SkeletalMesh specified in the Ref string
simulated static final function SkeletalMesh LoadSkeletalMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return SkeletalMesh(DynamicLoadObject(Ref, Class'SkeletalMesh', bMayFail));
	
	Return None;
}

// DynamicLoad StaticMesh specified in the Ref string
simulated static final function StaticMesh LoadStaticMesh( string Ref, optional bool bMayFail )
{
	if ( Ref != "" )
		Return StaticMesh(DynamicLoadObject(Ref, Class'StaticMesh', bMayFail));
	
	Return None;
}

// Actor Meshs DynamicLoad
// DynamicLoad Actor Mesh specified in the Ref string
simulated static final function bool LoadActorMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultMesh( Mesh(DynamicLoadObject(Ref, Class'Mesh', bMayFail)) );
		if ( A.default.Mesh != None )
			A.LinkMesh( A.default.Mesh );
		
		Return True;
	}
	
	Return False;
}

// DynamicLoad Actor SkeletalMesh specified in the Ref string
simulated static final function bool LoadActorSkeletalMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultMesh( SkeletalMesh(DynamicLoadObject(Ref, Class'SkeletalMesh', bMayFail)) );
		if ( A.default.Mesh != None )
			A.LinkMesh( A.default.Mesh );
		
		Return True;
	}
	
	Return False;
}

// DynamicLoad Actor StaticMesh specified in the Ref string
simulated static final function bool LoadActorStaticMesh( string Ref, Actor A, optional bool bMayFail )
{
	if ( Ref != "" && A != None )  {
		A.UpdateDefaultStaticMesh( StaticMesh(DynamicLoadObject(Ref, Class'StaticMesh', bMayFail)) );
		if ( A.default.StaticMesh != None )
			A.SetStaticMesh( A.default.StaticMesh );
		
		Return True;
	}
	
	Return False;
}
//[end]

//[end] Functions
//====================================================================


defaultproperties
{
     TransientSoundVolume=1.000000
     TransientSoundRadius=300.000000
}
