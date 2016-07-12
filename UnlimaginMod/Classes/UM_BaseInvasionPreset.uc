/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseInvasionPreset
	Creation date:	 01.09.2015 17:41
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
	Comment:		 
==================================================================================*/
class UM_BaseInvasionPreset extends UM_BaseGamePreset
	DependsOn(UM_InvasionGame)
	DependsOn(UM_BaseGameInfo)
	Abstract;

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var					range								InitialShoppingTime; // Begin Match With Shopping

// Normal Wave Data
var					int									InitialWaveNum;
var					array<UM_BaseGameInfo.IRange>		WaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					array<UM_BaseGameInfo.IRandRange>	WaveMonsterSquadSize;	// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty).  RandMin and RandMax also sets the random +/- squad size modifier.
var					array<UM_BaseGameInfo.FRandRange>	WaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty). RandMin and RandMax also sets the random +/- spawn period modifier.
var					array<int>							WaveSquadsSpawnEndTime;	// Time when level will stop to spawn new squads at the end of this wave (in seconds)
var					array<float>						WaveDifficulty;		// Used for the Bot Difficulty
var					array<int>							WaveStartDelay;		// This wave start time out in seconds
var					array<UM_BaseGameInfo.FRandRange>	WaveDuration;		// Wave duration in minutes (all) (Min and RandMin - MinGameDifficulty, Max and RandMax - MaxGameDifficulty)
var					array<range>						WaveBreakTime;			// Shopping time after this wave in seconds
var					array<range>						WaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
var					array<UM_BaseGameInfo.IRange>		WaveStartingCash;		// Random starting cash on this wave
var					array<UM_BaseGameInfo.IRange>		WaveMinRespawnCash;		// Random min respawn cash on this wave
var					array<range>						WaveDeathCashModifier;	// Death cash penalty on this wave (Min - MinGameDifficulty, Max - MaxGameDifficulty)

// Boss Wave Data
var					int									BossWaveNum;
var					UM_BaseGameInfo.IRange				BossWaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					UM_BaseGameInfo.IRandRange			BossWaveMonsterSquadSize;	// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty).  RandMin and RandMax also sets the random +/- squad size modifier.
var					UM_BaseGameInfo.FRandRange			BossWaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty). RandMin and RandMax also sets the random +/- spawn period modifier.
var					float								BossWaveDifficulty;		// Used for the Bot Difficulty
var					int									BossWaveStartDelay;		// This wave start time out in seconds
var					range								BossWaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
var					UM_BaseGameInfo.IRange				BossWaveStartingCash;		// Random starting cash on this wave
var					UM_BaseGameInfo.IRange				BossWaveMinRespawnCash;		// Random min respawn cash on this wave

// Monsters
var		export		array<UM_InvasionMonsterData>		Monsters;
var					string								BossMonsterClassName;

var					int									BulidSquadIterationLimit;

//[end] Varibles
//====================================================================

defaultproperties
{
	 BulidSquadIterationLimit=400
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
