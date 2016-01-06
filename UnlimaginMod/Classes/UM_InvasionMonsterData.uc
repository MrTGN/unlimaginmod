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

struct DeltaData
{
	var()	config	int		Min;
	var()	config	float	MinTime;
	var()	config	int		Max;
	var()	config	float	MaxTime;
};

var					bool						bDisabled;			//

var()				string						MonsterClassName;	// Dynamic MonsterClass Load
var()				class<UM_Monster>			MonsterClass;		// Class of the current Monster

// Normal wave limits
var()				bool						bNoWaveRestrictions;
var()				array<IRange>				WaveLimit;			// N wave overal spawn limit (Min - , Max - )
var()				array<Range>				WaveSpawnChance;	// N wave spawn Chance (Min - , Max - )
var()				array<IRange>				WaveSquadLimit;	// N wave limit per squad (Min - , Max - )
var()				array<DeltaData>			WaveDeltaLimit;		// N wave Limit per DeltaTime

// Boss wave limits
var()				bool						bNoBossWaveRestrictions;
var()				IRange						BossWaveLimit;
var()				Range						BossWaveSpawnChance;
var()				IRange						BossWaveSquadLimit;
var()				DeltaData					BossWaveDeltaLimit;


var		transient	UM_InvasionGame				InvasionGame;
var		transient	LevelInfo					Level;

// Spawn Counters
var		transient	int							NumSpawnedThisWave;
var		transient	int							NumInCurrentSquad;
var		transient	int							DeltaCounter;

// Temporary variables
var		transient	bool						bNoRestrictions;
var		transient	int							CurrentWaveLimit;
var		transient	float						CurrentSpawnChance;
var		transient	int							CurrentSquadLimit;
var		transient	int							CurrentDeltaLimit;
var		transient	float						CurrentDeltaLimitTime;
var		transient	float						NextDeltaLimitResetTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

function bool InitDataFor( UM_InvasionGame IG )
{
	if ( IG == None || MonsterClassName == "" || bDisabled )
		Return False;
	
	MonsterClass = Class<UM_Monster>( DynamicLoadObject(MonsterClassName, Class'Class') );
	if ( MonsterClass == None )
		Return False;
	
	InvasionGame = IG;
	Level = InvasionGame.Level;
	if ( InvasionGame == None || Level == None )
		Return False;
}

//ToDo: Дописать логику для волны босса.
function UpdateDynamicParameters()
{
	local	float	GameModif;
	
	GameModif = (InvasionGame.LerpNumPlayersModifier + InvasionGame.LerpGameDifficultyModifier) * 0.5;
	
	// Normal Wave
	if ( InvasionGame.WaveNum < InvasionGame.FinalWave )  {
		bNoRestrictions = bNoWaveRestrictions;
		if ( bNoRestrictions )
			Return;
		
		// CurrentWaveLimit
		CurrentWaveLimit = Round( Lerp(GameModif, float(WaveLimit[InvasionGame.WaveNum].Min), float(WaveLimit[InvasionGame.WaveNum].Max)) );
		
		// CurrentSpawnChance
		CurrentSpawnChance = Lerp( GameModif, WaveSpawnChance[InvasionGame.WaveNum].Min, WaveSpawnChance[InvasionGame.WaveNum].Max );
		
		// CurrentSquadLimit
		CurrentSquadLimit = Round( Lerp(GameModif, float(WaveSquadLimit[InvasionGame.WaveNum].Min), float(WaveSquadLimit[InvasionGame.WaveNum].Max)) );
		
		// CurrentDeltaLimit
		CurrentDeltaLimit = Round( Lerp(GameModif, float(WaveDeltaLimit[InvasionGame.WaveNum].Min), float(WaveDeltaLimit[InvasionGame.WaveNum].Max)) );
		
		// CurrentDeltaLimitTime
		CurrentDeltaLimitTime = Lerp( GameModif, WaveDeltaLimit[InvasionGame.WaveNum].MinTime, WaveDeltaLimit[InvasionGame.WaveNum].MaxTime );
	}
	// Boss Wave
	else  {
		bNoRestrictions = bNoBossWaveRestrictions;
		if ( bNoRestrictions )
			Return;
		
		// CurrentWaveLimit
		CurrentWaveLimit = Round( Lerp(GameModif, float(BossWaveLimit.Min), float(BossWaveLimit.Max)) );
		
		// CurrentSpawnChance
		CurrentSpawnChance = Lerp( GameModif, BossWaveSpawnChance.Min, BossWaveSpawnChance.Max );
		
		// CurrentSquadLimit
		CurrentSquadLimit = Round( Lerp(GameModif, float(BossWaveSquadLimit.Min), float(BossWaveSquadLimit.Max)) );
		
		// CurrentDeltaLimit
		CurrentDeltaLimit = Round( Lerp(GameModif, float(BossWaveDeltaLimit.Min), float(BossWaveDeltaLimit.Max)) );
		
		// CurrentDeltaLimitTime
		CurrentDeltaLimitTime = Lerp( GameModif, BossWaveDeltaLimit.MinTime, BossWaveDeltaLimit.MaxTime );
	}
}

function bool CanSpawn()
{
	if ( bDisabled )
		Return False;
	
	if ( bNoRestrictions )
		Return True;
	
	if ( CurrentSpawnChance <= 0.0 )
		Return False;
	
	if ( Level.TimeSeconds >= NextDeltaCounterResetTime )  {
		DeltaCounter = 0;
		NextDeltaCounterResetTime = Level.TimeSeconds + CurrentDeltaLimitTime;
	}
	
	Return NumSpawnedThisWave < CurrentWaveLimit && NumInCurrentSquad < CurrentSquadLimit && DeltaCounter < CurrentDeltaLimit && (CurrentSpawnChance >= 1.0 || FRand() <= CurrentSpawnChance);
}

//[end] Functions
//====================================================================

defaultproperties
{
}
