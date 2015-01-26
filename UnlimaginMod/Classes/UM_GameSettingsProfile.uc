/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_GameSettingsProfile
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
	Comment:		 This is a base game settings profile class. 
	You can create as many game settings profiles as you want and switches between them. 
==================================================================================*/
class UM_GameSettingsProfile extends UM_BaseObject
	DependsOn(UM_InvasionGame)
	Abstract;

//========================================================================
//[block] Variables

var		int											MaxHumanPlayers;

var		array<UM_InvasionGame.WaveMonsterData>		WaveMonsters;
var		array<UM_InvasionGame.GameWaveData>			GameWaves;

var		array<UM_InvasionGame.BossWaveMonsterData>	BossWaveMonsters;
var		string										BossMonsterClassName;

var		array<UM_InvasionGame.DramaticKillData>		DramaticKills;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
}
