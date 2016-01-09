/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseInvasionPreset
	Creation date:	 01.09.2015 17:41
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
	Comment:		 
==================================================================================*/
class UM_BaseInvasionPreset extends UM_BaseGamePreset
	DependsOn(UM_InvasionGame)
	Abstract;

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var					range							InitialShoppingTime; // Begin Match With Shopping

var					int								InitialWaveNum;
var		array<UM_InvasionGame.GameWaveData>			GameWaves;

// Boss Wave Data
var					IRange							BossWaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					IRandRange						BossWaveMonsterSquadSize;	// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty).  RandMin and RandMax also sets the random +/- squad size modifier.
var					FRandRange						BossWaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty). RandMin and RandMax also sets the random +/- spawn period modifier.
var					float							BossWaveDifficulty;		// Used for the Bot Difficulty
var					int								BossWaveStartDelay;		// This wave start time out in seconds
var					range							BossWaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
var					IRange							BossWaveStartingCash;		// Random starting cash on this wave
var					IRange							BossWaveMinRespawnCash;		// Random min respawn cash on this wave

// Monsters
var		export		array<UM_InvasionMonsterData>	Monsters;
var					string							BossMonsterClassName;

var					int								BulidSquadIterationLimit;

//[end] Varibles
//====================================================================

defaultproperties
{
	 BulidSquadIterationLimit=500
	 InitialWaveNum=0
	 InitialShoppingTime=(Min=120.0,Max=140.0)
	 MinGameDifficulty=1.0
	 MaxGameDifficulty=7.0
	 MinHumanPlayers=1
	 MaxHumanPlayers=12
	 // Kills for DramaticEvent
	 DramaticKills(0)=(MinKilled=2,EventChance=0.03,EventDuration=2.5)
	 DramaticKills(1)=(MinKilled=5,EventChance=0.05,EventDuration=3.0)
	 DramaticKills(2)=(MinKilled=10,EventChance=0.2,EventDuration=3.5)
	 DramaticKills(3)=(MinKilled=15,EventChance=0.4,EventDuration=4.0)
	 DramaticKills(4)=(MinKilled=20,EventChance=0.8,EventDuration=4.5)
	 DramaticKills(5)=(MinKilled=25,EventChance=1.0,EventDuration=5.0)
}
