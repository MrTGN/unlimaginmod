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
var()				array<IntRange>				WaveLimits;			// This wave overal spawn limit (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
var()				array<Range>				WaveSpawnChances;	// This wave spawn Chance (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
var()				array<IntRange>				WaveSquadLimits;	// This wave limit of the current monster in squad (Min - 1 HumanPlayer, Max - MaxHumanPlayers)
//ToDo:#LimitPerMinute	var()				array<Range>				WaveSquadDelays;	// Will delay next spawn if reached this wave Squad limit (Min - 1 HumanPlayer, Max - MaxHumanPlayers)

var		transient	UM_InvasionGame				InvasionGame;		//
var		transient	LevelInfo					Level;

var		transient	float						LastSquadSpawnTime;	//
var		transient	float						NextSquadSpawnTime;	// Freezing spawn up to this time

var		transient	int							NumSpawnedThisWave;
var		transient	int							NumSpawnedLastSquad;

var		transient	int							CurrentWaveLimit;
var		transient	float						CurrentSpawnChance;
var		transient	int							CurrentSquadLimit;
var		transient	float						CurrentSquadDelay;

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
	// CurrentWaveLimit
	CurrentWaveLimit = Round( Lerp(InvasionGame.LerpNumPlayersModifier, float(WaveLimits[InvasionGame.WaveNum].Min), float(WaveLimits[InvasionGame.WaveNum].Max) , True) );
	// CurrentSpawnChance
	CurrentSpawnChance = Lerp( InvasionGame.LerpNumPlayersModifier, WaveSpawnChances[InvasionGame.WaveNum].Min, WaveSpawnChances[InvasionGame.WaveNum].Max, True );
	// CurrentSquadLimit
	CurrentSquadLimit = Round( Lerp(InvasionGame.LerpNumPlayersModifier, float(WaveSquadLimits[InvasionGame.WaveNum].Min), float(WaveSquadLimits[InvasionGame.WaveNum].Max) , True) );
	// CurrentSquadDelay
	CurrentSquadDelay = Lerp( InvasionGame.LerpNumPlayersModifier, WaveSquadDelays[InvasionGame.WaveNum].Min, WaveSquadDelays[InvasionGame.WaveNum].Max, True );
	
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
