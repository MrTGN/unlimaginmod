/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseGamePreset
	Creation date:	 24.01.2015 01:17
----------------------------------------------------------------------------------
	Copyright © 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 This is a base game settings profile class. 
	You can create as many game settings profiles as you want and switches between them. 
==================================================================================*/
class UM_BaseGamePreset extends UM_BaseObject
	//Config
	//ParseConfig
	Abstract;

//========================================================================
//[block] Variables

var					float					MinGameDifficulty, MaxGameDifficulty;
var					int						MinHumanPlayers, MaxHumanPlayers;

// Do slomo event when was killed a specified number of victims
struct DramaticKillData
{
	var()	config	int		MinKilled;
	var()	config	float	EventChance;
	var()	config	float	EventDuration;
};

var		array<DramaticKillData>				DramaticKills;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
     MinGameDifficulty=1.0
	 MaxGameDifficulty=7.0
	 MinHumanPlayers=1
	 MaxHumanPlayers=10
}
