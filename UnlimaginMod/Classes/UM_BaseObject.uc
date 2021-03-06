/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseObject
	Creation date:	 24.01.2015 00:12
----------------------------------------------------------------------------------
	Copyright � 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright � 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright � 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 Base object class
==================================================================================*/
class UM_BaseObject extends Object
	Abstract;

//========================================================================
//[block] Variables

// Int Range
struct IRange
{
	var()	config	int		Min;
	var()	config	int		Max;
};

struct IRandRange
{
	var()	config	int		Min;
	var()	config	int		RandMin;
	var()	config	int		Max;
	var()	config	int		RandMax;
};

struct FRandRange
{
	var()	config	float	Min;
	var()	config	float	RandMin;
	var()	config	float	Max;
	var()	config	float	RandMax;
};

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================


defaultproperties
{
}
