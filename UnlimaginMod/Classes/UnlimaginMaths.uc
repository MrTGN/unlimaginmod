//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UnlimaginMaths
//	Parent class:	 Object
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.08.2013 16:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UnlimaginMaths extends Object
	Abstract
	hidecategories(Object)
	NotPlaceable;


//========================================================================
//[block] Variables

// Constants
// 1 meter = 60.352 Unreal Units in Killing Floor
// Info from http://forums.tripwireinteractive.com/showthread.php?t=1149 
const	MeterInUU = 60.352000;
const	SquareMeterInUU = 3642.363904;

// From UT3
const	DegToRad = 0.017453292519943296;	// Pi / 180
const	RadToDeg = 57.295779513082321600;	// 180 / Pi
const	UnrRotToRad = 0.00009587379924285;	// Pi / 32768
const 	RadToUnrRot = 10430.3783504704527;	// 32768 / Pi
const 	DegToUnrRot = 182.0444;
const 	UnrRotToDeg = 0.00549316540360483;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Functions

// Cosine of the angle between two vectors
final simulated static function float CosBetweenVectors(Vector VectA, Vector VectB)
{
	local	float	CosBV;
	
	CosBV = Normal(VectA) Dot Normal(VectB);
	
	Return CosBV;
}

// The angle in degrees between two vectors
final simulated static function float DegBetweenVectors(Vector VectA, Vector VectB)
{
	local	float	DegAngle;
	
	DegAngle = ACos(Normal(VectA) Dot Normal(VectB)) * RadToDeg;
	
	Return DegAngle;
}

// The angle in radians between two vectors
final simulated static function float RadBetweenVectors(Vector VectA, Vector VectB)
{
	local	float	RadAngle;
	
	RadAngle = ACos(Normal(VectA) Dot Normal(VectB));
	
	Return RadAngle;
}

//[end] Functions
//====================================================================


defaultproperties
{
}
