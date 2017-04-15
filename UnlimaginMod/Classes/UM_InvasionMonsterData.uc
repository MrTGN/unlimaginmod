/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_InvasionMonsterData
	Creation date:	 27.09.2015 13:17
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
	Comment:		 Template class. This object contains all data about monster 
					 spawn time, wave limits and restrictions.
==================================================================================*/
class UM_InvasionMonsterData extends UM_BaseObject
	DependsOn(UM_BaseObject);

//========================================================================
//[block] Variables

struct DeltaData
{
	var()	config	int		Min;
	var()	config	float	MinTime;
	var()	config	int		Max;
	var()	config	float	MaxTime;
};

var					bool							bDisabled;			//

var()				array<string>					MonsterClassNames;	// Dynamic MonsterClasses Load
var					array< class<UM_BaseMonster> >	MonsterClasses;		// Class of the current Monster

var					bool							bNoSpecialMonsters;
var					float							SpecialMonsterChance;
var()				array<string>					SpecialMonsterClassNames;	// Dynamic MonsterClasses Load
var					array< class<UM_BaseMonster> >	SpecialMonsterClasses;		// Class of the current Monster

// Normal wave limits
var()				bool							bNoWaveRestrictions;
var()				array<Range>					WaveSpawnChance;	// N wave spawn Chance (Min - , Max - )
var()				array<UM_BaseObject.IRange>		WaveSquadLimit;	// N wave limit per squad (Min - , Max - )
var()				array<DeltaData>				WaveDeltaLimit;		// N wave Limit per DeltaTime
var()				bool							bNoWaveDeltaLimit;

// Boss wave limits
var()				bool							bNoBossWaveRestrictions;
var()				Range							BossWaveSpawnChance;
var()				UM_BaseObject.IRange			BossWaveSquadLimit;
var()				DeltaData						BossWaveDeltaLimit;
var()				bool							bNoBossWaveDeltaLimit;


var		transient	UM_InvasionGame				InvasionGame;
var		transient	LevelInfo					Level;

// Spawn Counters
var		transient	int							NumInCurrentSquad;
var		transient	int							DeltaCounter;

// Temporary variables
var		transient	bool						bNoRestrictions;
var		transient	bool						bNoDeltaLimit;
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
	local	int		i;
	
	if ( IG == None || bDisabled )
		Return False;
	
	InvasionGame = IG;
	Level = InvasionGame.Level;
	if ( Level == None )  {
		Log( "Error: Level variable is None!", Name );
		Return False;
	}
	
	if ( MonsterClasses.Length < 1 && MonsterClassNames.Length > 0 )  {
		for ( i = 0; i < MonsterClassNames.Length; ++i )  {
			if ( MonsterClassNames[i] != "" )
				MonsterClasses[MonsterClasses.Length] = Class<UM_BaseMonster>( DynamicLoadObject(MonsterClassNames[i], Class'Class') );
		}
	}
	
	for ( i = 0; i < MonsterClasses.Length; ++i )  {
		if ( MonsterClasses[i] != None )
			MonsterClasses[i].static.PreCacheAssets( Level );
		else
			MonsterClasses.Remove(i, 1);
	}
	
	if ( MonsterClasses.Length < 1 )  {
		Log( "Error: No Monster Classes to load!", Name );
		Return False;
	}
	
	if ( SpecialMonsterClasses.Length < 1 && SpecialMonsterClassNames.Length > 0 )  {
		for ( i = 0; i < SpecialMonsterClassNames.Length; ++i )  {
			if ( SpecialMonsterClassNames[i] != "" )
				SpecialMonsterClasses[SpecialMonsterClasses.Length] = Class<UM_BaseMonster>( DynamicLoadObject(SpecialMonsterClassNames[i], Class'Class') );
		}
	}
	
	for ( i = 0; i < SpecialMonsterClasses.Length; ++i )  {
		if ( SpecialMonsterClasses[i] != None )
			SpecialMonsterClasses[i].static.PreCacheAssets( Level );
		else
			SpecialMonsterClasses.Remove(i, 1);
	}
	
	bNoSpecialMonsters = SpecialMonsterClasses.Length < 1;
	
	//Log( "GameData Object for the Monster Class"@MonsterClassNames@"initialized.", Name );
	Log( string(Name) @"initialized.", Name );
	Return True;
}

function Class<UM_BaseMonster> GetMonsterClass()
{
	if ( !bNoSpecialMonsters && FRand() <= SpecialMonsterChance )  {
		//if ( SpecialMonsterClasses.Length < 2 )
			//Return SpecialMonsterClasses[0];
		
		Return SpecialMonsterClasses[ Rand(SpecialMonsterClasses.Length) ];
	}
	
	//if ( MonsterClasses.Length < 2 )
		//Return MonsterClasses[0];
	
	Return MonsterClasses[ Rand(MonsterClasses.Length) ];
}

function UpdateDynamicParameters()
{
	local	float	GameModif;
	
	GameModif = (InvasionGame.LerpNumPlayersModifier + InvasionGame.LerpGameDifficultyModifier) * 0.5;
	
	// Normal Wave
	if ( InvasionGame.WaveNum < InvasionGame.FinalWave )  {
		bNoRestrictions = bNoWaveRestrictions;
		if ( bNoRestrictions )
			Return;
		
		// CurrentSpawnChance
		CurrentSpawnChance = Lerp( InvasionGame.LerpGameDifficultyModifier, WaveSpawnChance[InvasionGame.WaveNum].Min, WaveSpawnChance[InvasionGame.WaveNum].Max );
		
		// CurrentSquadLimit
		CurrentSquadLimit = Round( Lerp(GameModif, float(WaveSquadLimit[InvasionGame.WaveNum].Min), float(WaveSquadLimit[InvasionGame.WaveNum].Max)) );
		
		bNoDeltaLimit = bNoWaveDeltaLimit;
		if ( bNoDeltaLimit )
			Return;
		
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
		
		// CurrentSpawnChance
		CurrentSpawnChance = Lerp( InvasionGame.LerpGameDifficultyModifier, BossWaveSpawnChance.Min, BossWaveSpawnChance.Max );
		
		// CurrentSquadLimit
		CurrentSquadLimit = Round( Lerp(GameModif, float(BossWaveSquadLimit.Min), float(BossWaveSquadLimit.Max)) );
		
		bNoDeltaLimit = bNoBossWaveDeltaLimit;
		if ( bNoDeltaLimit )
			Return;
		
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
	
	if ( !bNoDeltaLimit && Level.TimeSeconds >= NextDeltaLimitResetTime )  {
		DeltaCounter = 0;
		NextDeltaLimitResetTime = Level.TimeSeconds + CurrentDeltaLimitTime;
	}
	
	Return NumInCurrentSquad < CurrentSquadLimit && (bNoDeltaLimit || DeltaCounter < CurrentDeltaLimit) && (CurrentSpawnChance >= 1.0 || FRand() <= CurrentSpawnChance);
}

//[end] Functions
//====================================================================

defaultproperties
{
     SpecialMonsterChance=0.15
}
