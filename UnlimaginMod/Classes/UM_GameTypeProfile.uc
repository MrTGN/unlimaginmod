/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_GameTypeProfile
	Creation date:	 24.01.2015 01:17
----------------------------------------------------------------------------------
	Copyright © 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 This is a base game type profile class. 
	It allows you to create configurable game profiles (subclasses). 
	You can create as many game profiles as you want and switches between them. 
	This means that you don't need to fully reconfigure game type class, 
	just change game profile.
==================================================================================*/
class UM_GameTypeProfile extends UM_BaseObject
	DependsOn(UnlimaginGameType)
	Abstract;

//========================================================================
//[block] Variables

var		int												MaxHumanPlayers;

var		array<UnlimaginGameType.WaveMonsterData>		WaveMonsters;
var		array<UnlimaginGameType.WaveData>				GameWaves;

var		array<UnlimaginGameType.BossWaveMonsterData>	BossWaveMonsters;
var		string											BossMonsterClassName;

var		array<UnlimaginGameType.DramaticKillData>		DramaticKills;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
}
