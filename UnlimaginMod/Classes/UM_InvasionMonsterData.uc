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

var()				array<IRange>				WaveLimit;			// This wave overal spawn limit (Min - , Max - )
var()				array<Range>				WaveSpawnChance;	// This wave spawn Chance (Min - , Max - )
var()				array<IRange>				WaveSquadLimit;	// This wave limit per squad (Min - , Max - )
var()				array<IRange>				WaveDeltaLimit;		// Limit per DeltaTime
var()				array<float>				WaveDeltaTime;		// DeltaLimit Time in seconds

var		transient	UM_InvasionGame				InvasionGame;		//
var		transient	LevelInfo					Level;

var		transient	int							NumSpawnedThisWave;
var		transient	int							NumInCurrentSquad;
var		transient	int							DeltaCounter;

var		transient	int							CurrentWaveLimit;
var		transient	float						CurrentSpawnChance;
var		transient	int							CurrentSquadLimit;
var		transient	int							CurrentDeltaLimit;
var		transient	float						CurrentDeltaTime;
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

//ToDo: Дописать логику для волны босса.
function UpdateDynamicParameters()
{
	local	float	GameModif;
	
	GameModif = (InvasionGame.LerpNumPlayersModifier + InvasionGame.LerpGameDifficultyModifier) * 0.5;
	
	// Normal Wave
	if ( InvasionGame.WaveNum < InvasionGame.FinalWave )  {
		// CurrentWaveLimit
		CurrentWaveLimit = Round( Lerp(GameModif, float(WaveLimit[InvasionGame.WaveNum].Min), float(WaveLimit[InvasionGame.WaveNum].Max) ) );
		
		// CurrentSpawnChance
		CurrentSpawnChance = Lerp( GameModif, WaveSpawnChance[InvasionGame.WaveNum].Min, WaveSpawnChance[InvasionGame.WaveNum].Max );
		
		// CurrentSquadLimit
		CurrentSquadLimit = Round( Lerp(GameModif, float(WaveSquadLimit[InvasionGame.WaveNum].Min), float(WaveSquadLimit[InvasionGame.WaveNum].Max) ) );
		
		// CurrentDeltaLimit
		CurrentDeltaLimit = Round( Lerp(GameModif, float(WaveDeltaLimit[InvasionGame.WaveNum].Min), float(WaveDeltaLimit[InvasionGame.WaveNum].Max) ) );
		
		// CurrentDeltaTime
		CurrentDeltaTime = WaveDeltaTime[InvasionGame.WaveNum];
	}
	// Boss Wave
	else  {
		
	}
}

//[block] ToDo: вообще в этих функциях нет необходимости, ибо они состоят из одной строки.
// Меньше лишних вызовов однострочных функций!
function IncrementWaveSpawnCounter()
{
	++NumSpawnedThisWave;
}

function ResetWaveSpawnCounter()
{
	NumSpawnedThisWave = 0;
}

function IncrementSquadCounter()
{
	++NumInCurrentSquad;
}

function ResetSquadCounter()
{
	NumInCurrentSquad = 0;
}
//[end]

function ResetDeltaCounter()
{
	DeltaCounter = 0;
	NextDeltaCounterResetTime = Level.TimeSeconds + CurrentDeltaTime;
}

function bool CanSpawn()
{
	if ( bDisabled )
		Return False;
	
	if ( bNoSpawnRestrictions )
		Return True;
	
	if ( CurrentSpawnChance <= 0.0 )
		Return False;
	
	if ( Level.TimeSeconds >= NextDeltaCounterResetTime )
		ResetDeltaCounter();
	
	Return NumSpawnedThisWave < CurrentWaveLimit && NumInCurrentSquad < CurrentSquadLimit && DeltaCounter < CurrentDeltaLimit && (CurrentSpawnChance >= 1.0 || FRand() <= CurrentSpawnChance);
}

//[end] Functions
//====================================================================

defaultproperties
{
}
