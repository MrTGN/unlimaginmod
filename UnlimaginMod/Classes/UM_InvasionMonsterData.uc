/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_InvasionMonsterData
	Creation date:	 27.09.2015 13:17
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
	Comment:		 Template class. This object contains all data about monster 
					 spawn time, wave limits and restrictions.
==================================================================================*/
class UM_InvasionMonsterData extends UM_BaseObject
	Instanced;

//========================================================================
//[block] Variables

var					bool						bDisabled;			//

var					bool						bNoSpawnRestrictions;

var()				string						MonsterClassName;	// Dynamic MonsterClass Load
var()				class<UM_Monster>			MonsterClass;		// Class of the current Monster

var()				array<IRange>				WaveLimit;			// This wave overal spawn limit (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
var()				array<Range>				WaveSpawnChance;	// This wave spawn Chance (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
var()				array<IRange>				WaveSquadLimit;	// This wave limit of the current monster in squad (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
//ToDo:#LimitPerMinute	var()				array<Range>				WaveSquadDelays;	// Will delay next spawn if reached this wave Squad limit (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
var()				array<Range>				WaveLimitPerMinute;		// Limit Per Minute

var		transient	UM_InvasionGame				InvasionGame;		//
var		transient	LevelInfo					Level;

var		transient	float						LastSquadSpawnTime;	//
var		transient	float						NextSquadSpawnTime;	// Freezing spawn up to this time

var		transient	int							NumSpawnedThisWave;
var		transient	int							NumSpawnedLastSquad;

var		transient	int							CurrentWaveLimit;
var		transient	float						CurrentSpawnChance;
var		transient	int							CurrentSquadLimit;
var		transient	int							CurrentDeltaLimit;
var		transient	float						CurrentDeltaDuration;
var		transient	float						NextDeltaLimitResetTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

function bool InitDataFor( UM_InvasionGame IG )
{
	if ( IG == None || MonsterClassName == "" || bDisabled )
		Return False;
	
	MonsterClass = Class<UM_Monster>( LoadClass( MonsterClassName ) );
	if ( MonsterClass == None )
		Return False;
	
	InvasionGame = IG;
	Level = InvasionGame.Level;
}

//ToDo: доработать. Перенести нужнные переменные еще и на работу со сложностью.
function UpdateDynamicParameters()
{
	local	float	GameModif;
	
	GameModif = (InvasionGame.LerpNumPlayersModifier + InvasionGame.LerpGameDifficultyModifier) * 0.5;
	
	if ( InvasionGame.WaveNum < InvasionGame.FinalWave )  {
		// CurrentWaveLimit
		// Зависит от сложности и количества игроков
		CurrentWaveLimit = Round( Lerp(GameModif, float(WaveLimit[InvasionGame.WaveNum].Min), float(WaveLimit[InvasionGame.WaveNum].Max) ) );
		
		// CurrentSpawnChance
		// Зависит от сложности и количества игроков
		CurrentSpawnChance = Lerp( GameModif, WaveSpawnChance[InvasionGame.WaveNum].Min, WaveSpawnChance[InvasionGame.WaveNum].Max );
		
		// CurrentSquadLimit
		// Зависит от сложности и количества игроков
		CurrentSquadLimit = Round( Lerp(GameModif, float(WaveSquadLimit[InvasionGame.WaveNum].Min), float(WaveSquadLimit[InvasionGame.WaveNum].Max) ) );
		
		// CurrentSquadDelay
		// Зависит от сложности и количества игроков
		CurrentLimitPerMinute = Lerp( GameModif, WaveLimitPerMinute[InvasionGame.WaveNum].Min, WaveLimitPerMinute[InvasionGame.WaveNum].Max );
		if ( CurrentLimitPerMinute < 1.0 )  {
			CurrentDeltaLimit = 1;
			CurrentDeltaDuration = 60.0 / CurrentLimitPerMinute;
		}
		else  {
			CurrentDeltaLimit = int(CurrentLimitPerMinute);
			CurrentDeltaDuration = 60.0 * (float(CurrentDeltaLimit) / CurrentLimitPerMinute);
		}
	}
	
	// Check CurrentSquadLimit
	if ( Level.TimeSeconds < NextSquadSpawnTime )
		NextSquadSpawnTime = LastSquadSpawnTime + CurrentSquadDelay;
}

function IncrementWaveSpawnCounter()
{
	++NumSpawnedThisWave;
}

function bool CheckCurrentWaveLimit()
{
	Return CurrentWaveLimit < 0 || NumSpawnedThisWave < CurrentWaveLimit;
}

function bool CheckCurrentSpawnChance()
{
	Return CurrentSpawnChance > 0.0 && FRand() <= CurrentSpawnChance;
}

function IncrementSquadCounter()
{
	++NumSpawnedLastSquad;
	if ( CurrentSquadLimit > 0 && NumSpawnedLastSquad >= CurrentSquadLimit )  {
		LastSquadSpawnTime = Level.TimeSeconds;
		NextSquadSpawnTime = LastSquadSpawnTime + CurrentSquadDelay;
	}
}

function ResetLastSquadCounter()
{
	NumSpawnedLastSquad = 0;
}

function bool CheckCurrentSquadLimit()
{
	Return CurrentSquadLimit < 0 || Level.TimeSeconds >= NextSquadSpawnTime;
}

function bool CanSpawn()
{
	if ( bNoSpawnRestrictions )
		Return True;
	
	Return CheckCurrentWaveLimit() && CheckCurrentSpawnChance() && CheckCurrentSquadLimit();
}

//[end] Functions
//====================================================================

defaultproperties
{
}
