/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_InvasionGame
	Creation date:	 06.10.2012 13:12
----------------------------------------------------------------------------------
	Copyright © 2012 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

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
class UM_InvasionGame extends UM_BaseGameType
	DependsOn(UM_BaseActor)
	config;

#exec OBJ LOAD FILE=KillingFloorTextures.utx
#exec OBJ LOAD FILE=KillingFloorWeapons.utx
//#exec OBJ LOAD FILE=KillingFloorManorTextures.utx
#exec OBJ LOAD FILE=KillingFloorHUD.utx
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KFMaterials.utx
#exec OBJ LOAD FILE=KillingFloorLabTextures.utx
#exec OBJ LOAD FILE=KillingFloorStatics.usx
//#exec OBJ LOAD FILE=KillingFloorManorStatics.usx
//#exec OBJ LOAD FILE=KillingFloorLabStatics.usx
#exec OBJ LOAD FILE=EffectsSM.usx
#exec OBJ LOAD FILE=PatchStatics.usx
#exec OBJ LOAD FILE=KF_pickups2_Trip.usx
#exec OBJ LOAD FILE=KF_generic_sm.usx
#exec OBJ LOAD FILE=KF_Weapons_Trip_T.utx
#exec OBJ LOAD FILE=KF_Weapons2_Trip_T.utx
#exec OBJ LOAD FILE=KF_Weapons3rd_Trip_T.utx
#exec OBJ LOAD FILE=KF_Weapons3rd2_Trip_T.utx
#exec OBJ LOAD FILE=KFPortraits.utx
#exec OBJ LOAD FILE=KF_Soldier_Trip_T.utx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T_Two.utx
#exec OBJ LOAD FILE=kf_generic_t.utx
#exec OBJ LOAD FILE=kf_gore_trip_sm.usx
//#exec OBJ LOAD FILE=kf_fx_gore_T_Two.utx
#exec OBJ LOAD FILE=KF_PlayerGlobalSnd.uax
#exec OBJ LOAD FILE=KF_MAC10MPTex.utx
#exec OBJ LOAD FILE=KF_MAC10MPAnims.ukx
#exec OBJ LOAD FILE=KF_MAC10MPSnd.uax

//========================================================================
//[block] Variables

var		int								UM_TimeBetweenWaves;

// GameWaves
struct GameWaveData
{
	var()	config	int					MinMonsters;
	var()	config	int					MaxMonsters;
	var()	config	UM_BaseActor.IRange	MonstersAtOnce;
	var()	config	UM_BaseActor.IRange	MonsterSquadSize;
	var()	config	range				SquadsSpawnPeriod;
	var()	config	float				WaveDifficulty;
	var()	config	range				BreakTime;
};
var		array<GameWaveData>				GameWaves;

// WaveMonsters
struct WaveMonsterData
{
	var()	config	string				MonsterClassName;
	var()	config	class<UM_Monster>	MonsterClass;
	var()	config	array<int>			WaveMinLimits;	// -1 no limit at all
	var()	config	array<int>			WaveMaxLimits;	// -1 no limit at all
	var		transient	int				CurrentWaveLimit;
	var()	config	array<float>		WaveSpawnChances;
	var()	config	array<float>		WaveSpawnDelays;
	var		transient	float			NextSpawnTime;
};
var		array<WaveMonsterData>			WaveMonsters;

// BossWaveMonsters
struct BossWaveMonsterData
{
	var()	config	string				MonsterClassName;
	var()	config	class<UM_Monster>	MonsterClass;
	var()	config	int					WaveLimit;
	var()	config	float				WaveSpawnChance;
};
var		array<BossWaveMonsterData>		BossWaveMonsters;
// BossMonsterClass
var		string							BossMonsterClassName;
var		class<UM_Monster>				BossMonsterClass;

var		Class<UM_ActorPool>				ActorPoolClass;

var		class<KFMonstersCollection>		UM_MonsterCollection;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

protected function bool LoadGameSettingsProfile()
{
	local	int		i, j;
	local	class<UM_DefaultInvasionGameProfile>	IGP;
	
	if ( !Super.LoadGameSettingsProfile() )
		Return False;
	
	IGP = class<UM_DefaultInvasionGameProfile>(GameSettingsProfileClass);
	if ( IGP == None )
		Return False;
	
	// WaveMonsters
	default.WaveMonsters.Length = IGP.default.WaveMonsters.Length;
	WaveMonsters.Length = default.WaveMonsters.Length;
	for ( i = 0; i < IGP.default.WaveMonsters.Length; ++i )  {
		// MonsterClassName
		default.WaveMonsters[i].MonsterClassName = IGP.default.WaveMonsters[i].MonsterClassName;
		WaveMonsters[i].MonsterClassName = default.WaveMonsters[i].MonsterClassName;
		// WaveLimits
		default.WaveMonsters[i].WaveLimits.Length = IGP.default.WaveMonsters[i].WaveLimits.Length;
		WaveMonsters[i].WaveLimits.Length = default.WaveMonsters[i].WaveLimits.Length;
		for ( j = 0; j < IGP.default.WaveMonsters[i].WaveLimits.Length; ++j )  {
			default.WaveMonsters[i].WaveLimits[j] = IGP.default.WaveMonsters[i].WaveLimits[j];
			WaveMonsters[i].WaveLimits[j] = default.WaveMonsters[i].WaveLimits[j];
		}
		// WaveSpawnChances
		default.WaveMonsters[i].WaveSpawnChances.Length = IGP.default.WaveMonsters[i].WaveSpawnChances.Length;
		WaveMonsters[i].WaveSpawnChances.Length = default.WaveMonsters[i].WaveSpawnChances.Length;
		for ( j = 0; j < IGP.default.WaveMonsters[i].WaveSpawnChances.Length; ++j )  {
			default.WaveMonsters[i].WaveSpawnChances[j] = IGP.default.WaveMonsters[i].WaveSpawnChances[j];
			WaveMonsters[i].WaveSpawnChances[j] = default.WaveMonsters[i].WaveSpawnChances[j];
		}
		// WaveSpawnDelays
		default.WaveMonsters[i].WaveSpawnDelays.Length = IGP.default.WaveMonsters[i].WaveSpawnDelays.Length;
		WaveMonsters[i].WaveSpawnDelays.Length = default.WaveMonsters[i].WaveSpawnDelays.Length;
		for ( j = 0; j < IGP.default.WaveMonsters[i].WaveSpawnDelays.Length; ++j )  {
			default.WaveMonsters[i].WaveSpawnDelays[j] = IGP.default.WaveMonsters[i].WaveSpawnDelays[j];
			WaveMonsters[i].WaveSpawnDelays[j] = default.WaveMonsters[i].WaveSpawnDelays[j];
		}
	}
	
	// GameWaves
	default.GameWaves.Length = IGP.default.GameWaves.Length;
	GameWaves.Length = default.GameWaves.Length;
	for ( i = 0; i < IGP.default.GameWaves.Length; ++i )  {
		// MinMonsters
		default.GameWaves[i].MinMonsters = IGP.default.GameWaves[i].MinMonsters;
		GameWaves[i].MinMonsters = default.GameWaves[i].MinMonsters;
		// MaxMonsters
		default.GameWaves[i].MaxMonsters = IGP.default.GameWaves[i].MaxMonsters;
		GameWaves[i].MaxMonsters = default.GameWaves[i].MaxMonsters;
		// MinMonstersAtOnce
		default.GameWaves[i].MinMonstersAtOnce = IGP.default.GameWaves[i].MinMonstersAtOnce;
		GameWaves[i].MinMonstersAtOnce = default.GameWaves[i].MinMonstersAtOnce;
		// MaxMonstersAtOnce
		default.GameWaves[i].MaxMonstersAtOnce = IGP.default.GameWaves[i].MaxMonstersAtOnce;
		GameWaves[i].MaxMonstersAtOnce = default.GameWaves[i].MaxMonstersAtOnce;
		// MinMonsterSquad
		default.GameWaves[i].MinMonsterSquad = IGP.default.GameWaves[i].MinMonsterSquad;
		GameWaves[i].MinMonsterSquad = default.GameWaves[i].MinMonsterSquad;
		// MaxMonsterSquad
		default.GameWaves[i].MaxMonsterSquad = IGP.default.GameWaves[i].MaxMonsterSquad;
		GameWaves[i].MaxMonsterSquad = default.GameWaves[i].MaxMonsterSquad;
		// SquadsSpawnPeriod
		default.GameWaves[i].SquadsSpawnPeriod = IGP.default.GameWaves[i].SquadsSpawnPeriod;
		GameWaves[i].SquadsSpawnPeriod = default.GameWaves[i].SquadsSpawnPeriod;
		// WaveDifficulty
		default.GameWaves[i].WaveDifficulty = IGP.default.GameWaves[i].WaveDifficulty;
		GameWaves[i].WaveDifficulty = default.GameWaves[i].WaveDifficulty;
		// BreakTime
		default.GameWaves[i].BreakTime = IGP.default.GameWaves[i].BreakTime;
		GameWaves[i].BreakTime = default.GameWaves[i].BreakTime;
	}
	
	// BossMonsterClassName
	default.BossMonsterClassName = IGP.default.BossMonsterClassName;
	BossMonsterClassName = default.BossMonsterClassName;
	
	// BossWaveMonsters
	default.BossWaveMonsters.Length = IGP.default.BossWaveMonsters.Length;
	BossWaveMonsters.Length = default.BossWaveMonsters.Length;
	for ( i = 0; i < IGP.default.BossWaveMonsters.Length; ++i )  {
		// MonsterClassName
		default.BossWaveMonsters[i].MonsterClassName = IGP.default.BossWaveMonsters[i].MonsterClassName;
		BossWaveMonsters[i].MonsterClassName = default.BossWaveMonsters[i].MonsterClassName;
		// WaveLimit
		default.BossWaveMonsters[i].WaveLimit = IGP.default.BossWaveMonsters[i].WaveLimit;
		BossWaveMonsters[i].WaveLimit = default.BossWaveMonsters[i].WaveLimit;
		// WaveSpawnChance
		default.BossWaveMonsters[i].WaveSpawnChance = IGP.default.BossWaveMonsters[i].WaveSpawnChance;
		BossWaveMonsters[i].WaveSpawnChance = default.BossWaveMonsters[i].WaveSpawnChance;
	}
	
	Return True;
}

protected function LogGameSettingsProfileLoaded()
{
	Log("GameSettingsProfile:" @string(GameSettingsProfileClass.default.Name) @"Loaded", Class.Outer.Name);
}

function LoadUpMonsterList()
{
	local	int		i;
	
	if ( BossMonsterClassName != "" )
		BossMonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(BossMonsterClassName) );
	else
		Warn("BossMonsterClassName not specified!", Class.Outer.Name);
	
	// WaveMonsters
	for ( i = 0; i < default.WaveMonsters.Length; ++i )  {
		if ( default.WaveMonsters[i].MonsterClassName != "" )  {
			default.WaveMonsters[i].MonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(default.WaveMonsters[i].MonsterClassName) );
			WaveMonsters[i].MonsterClass = default.WaveMonsters[i].MonsterClass;
		}
	}
	
	// BossWaveMonsters
	for ( i = 0; i < default.BossWaveMonsters.Length; ++i )  {
		if ( default.BossWaveMonsters[i].MonsterClassName != "" )  {
			default.BossWaveMonsters[i].MonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(default.BossWaveMonsters[i].MonsterClassName) );
			BossWaveMonsters[i].MonsterClass = default.BossWaveMonsters[i].MonsterClass;
		}
	}
}

/* Initialize the game.
 The GameInfo's InitGame() function is called before any other scripts (including
 PreBeginPlay() ), and is used by the GameInfo to initialize parameters and spawn
 its helper classes.
 Warning: this is called before actors' PreBeginPlay.
*/
event InitGame( string Options, out string Error )
{
//	local int i,j;
	local KFLevelRules KFLRit;
	local ShopVolume SH;
	local ZombieVolume ZZ;
	local string InOpt;
	//local int i;

	Super(xTeamGame).InitGame(Options, Error);
	
	if ( LoadGameSettingsProfile() )
		LogGameSettingsProfileLoaded();
	
	MaxLives = 1;
	bForceRespawn = True;
	
	DefaultGameSpeed = default.GameSpeed;
	MaxPlayers = Clamp( MaxHumanPlayers, 1, 32);
	
	FriendlyFireScale = FClamp(FriendlyFireScale, 0.0, 1.0);
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )
		UM_GameReplicationInfo(GameReplicationInfo).FriendlyFireScale = FriendlyFireScale;
	
	// LevelRules
	foreach DynamicActors( class'KFLevelRules', KFLRit)  {
		if ( KFLRules == None )
			KFLRules = KFLRit;
		else 
			Warn("MULTIPLE KFLEVELRULES FOUND!!!!!");
	}
	// ShopList
	foreach AllActors(class'ShopVolume', SH)
		ShopList[ShopList.Length] = SH;
	// ZedSpawnList
	foreach AllActors(class'ZombieVolume',ZZ)
		ZedSpawnList[ZedSpawnList.Length] = ZZ;

	//provide default rules if mapper did not need custom one
	if ( KFLRules == None )
		KFLRules = Spawn(DefaultLevelRulesClass);

	log("KFLRules = "$KFLRules);

	InOpt = ParseOption(Options, "UseBots");
	if ( InOpt != "" )
		bNoBots = bool(InOpt);

	log("Game length = "$KFGameLength);

	// Set up the Unlimagin game type settings
	bUseEndGameBoss = true;
	bRespawnOnBoss = true;
	MonsterClasses = UM_MonsterClasses;
	MonsterSquad = UM_MonsterSquads;
	MaxZombiesOnce = UM_MaxZombiesOnce;
	bCustomGameLength = false;
	EndGameBossClass = UM_EndGameBossClass;
	MonsterCollection = UM_MonsterCollection;
	UpdateGameLength();

	// Set difficulty based values
	if ( GameDifficulty >= 7.0 )  {
		// Hell on Earth
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashHell;
		MinRespawnCash = MinRespawnCashHell;
	}
	else if ( GameDifficulty >= 5.0 )  {
		// Suicidal
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashSuicidal;
		MinRespawnCash = MinRespawnCashSuicidal;
	}
	else if ( GameDifficulty >= 4.0 )  {
		// Hard
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashHard;
		MinRespawnCash = MinRespawnCashHard;
	}
	else if ( GameDifficulty >= 2.0 )  {
		// Normal
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashNormal;
		MinRespawnCash = MinRespawnCashNormal;
	}
	else  {
		// Beginner
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashBeginner;
		MinRespawnCash = MinRespawnCashBeginner;
	}

	InitialWave = 0;
	
	FinalWave = Clamp(UM_FinalWave,5,15);
	
	LoadUpMonsterList();
	
	//Spawning ActorPool
	if ( ActorPoolClass != None && Class'UM_GlobalData'.default.ActorPool == None )  {
		log("-------- Creating ActorPool --------",Class.Outer.Name);
		Spawn(ActorPoolClass);
	}
}

function NotifyGameEvent( int EventNumIn )
{
    LoadUpMonsterList();
}

simulated function PrepareSpecialSquadsFromCollection() { }
simulated function PrepareSpecialSquads() { }

function UpdateGameLength()
{
	local Controller C;

	for ( C = Level.ControllerList; C != None; C = C.NextController )  {
		if ( PlayerController(C) != None && PlayerController(C).SteamStatsAndAchievements != None )
			PlayerController(C).SteamStatsAndAchievements.bUsedCheats = PlayerController(C).SteamStatsAndAchievements.bUsedCheats || bCustomGameLength;
	}
}

function ResetToDefaultMonsterList()
{
	local	int		i, j;
	
	// WaveMonsters
	WaveMonsters.Length = default.WaveMonsters.Length;
	for ( i = 0; i < default.WaveMonsters.Length; ++i )  {
		// MonsterClass
		WaveMonsters[i].MonsterClass = default.WaveMonsters[i].MonsterClass;
		// WaveLimits
		WaveMonsters[i].WaveLimits.Length = default.WaveMonsters[i].WaveLimits.Length;
		for ( j = 0; j < default.WaveMonsters[i].WaveLimits.Length; ++j )
			WaveMonsters[i].WaveLimits[j] = default.WaveMonsters[i].WavesLimit[j];
		// WaveSpawnChances
		WaveMonsters[i].WaveSpawnChances.Length = default.WaveMonsters[i].WaveSpawnChances.Length;
		for ( j = 0; j < default.WaveMonsters[i].WaveSpawnChances.Length; ++j )
			WaveMonsters[i].WaveSpawnChances[j] = default.WaveMonsters[i].WaveSpawnChances[j];
		// WaveSpawnDelays
		WaveMonsters[i].WaveSpawnDelays.Length = default.WaveMonsters[i].WaveSpawnDelays.Length;
		for ( j = 0; j < default.WaveMonsters[i].WaveSpawnDelays.Length; ++j )
			WaveMonsters[i].WaveSpawnDelays[j] = default.WaveMonsters[i].WaveSpawnDelays[j];
	}
}


function ModifyMonsterListByDifficulty()
{
	local	int		i, j;
	local	float	DifficultyMod;
	
	// Hell on Earth
	if ( GameDifficulty >= 7.0 )
		DifficultyMod = 1.75;
	// Suicidal
	else if ( GameDifficulty >= 5.0 )
		DifficultyMod = 1.5;
	// Hard
	else if ( GameDifficulty >= 4.0 )
		DifficultyMod = 1.25;
	// Normal
	else if ( GameDifficulty >= 2.0 )
		DifficultyMod = 1.0;
	// Beginner
	else
		DifficultyMod = 0.75;
	
	// scale Monster WaveLimits by difficulty
	for ( i = 0; i < WaveMonsters.Length; ++i )  {
		for ( j = 0; j < WaveMonsters[i].WaveLimits.Length; ++j )
			WaveMonsters[i].WaveLimits[j] = Round( float(WaveMonsters[i].WaveLimits[j]) * DifficultyMod );
	}
}

function ModifyMonsterListByNumPlayers()
{
	local	int		i, j, CurrentNumPlayers;
	local	float	NumPlayersMod;
	
	CurrentNumPlayers = FMin( (NumPlayers + NumBots), 12);
	switch ( CurrentNumPlayers )  {
		case 1:
		case 2:
			NumPlayersMod = float(CurrentNumPlayers);
			Break;
		
		case 3:
			NumPlayersMod = 2.75;
			Break;
		
		case 4:
			NumPlayersMod = 3.5;
			Break;
		
		case 5:
			NumPlayersMod = 4.0;
			Break;
		
		default:
			NumPlayersMod = float(CurrentNumPlayers) - float(CurrentNumPlayers) * 0.25;
	}
	
	// scale Monster WaveLimits by number of Players
	for ( i = 0; i < WaveMonsters.Length; ++i )  {
		for ( j = 0; j < WaveMonsters[i].WaveLimits.Length; ++j )
			WaveMonsters[i].WaveLimits[j] = Round( float(WaveMonsters[i].WaveLimits[j]) * NumPlayersMod );
	}
}

//ToDo: issue #42
function SetupWave()
{
	local int i,j;
	local float NewMaxMonsters;
	//local int m;
	local float DifficultyMod, NumPlayersMod;
	local int UsedNumPlayers;

	if ( WaveNum > 15 )
	{
		SetupRandomWave();
		return;
	}

	TraderProblemLevel = 0;
	rewardFlag=false;
	ZombiesKilled=0;
	WaveMonsters = 0;
	WaveNumClasses = 0;
	NewMaxMonsters = Waves[WaveNum].WaveMaxMonsters;

	// scale number of zombies by difficulty
	if ( GameDifficulty >= 7.0 ) // Hell on Earth
	{
		DifficultyMod=1.7;
	}
	else if ( GameDifficulty >= 5.0 ) // Suicidal
	{
		DifficultyMod=1.5;
	}
	else if ( GameDifficulty >= 4.0 ) // Hard
	{
		DifficultyMod=1.3;
	}
	else if ( GameDifficulty >= 2.0 ) // Normal
	{
		DifficultyMod=1.0;
	}
	else //if ( GameDifficulty == 1.0 ) // Beginner
	{
		DifficultyMod=0.7;
	}

	UsedNumPlayers = NumPlayers + NumBots;

	// Scale the number of zombies by the number of players. Don't want to
	// do this exactly linear, or it just gets to be too many zombies and too
	// long of waves at higher levels - Ramm
	switch ( UsedNumPlayers )
	{
		case 1:
			NumPlayersMod=1;
			break;
		case 2:
			NumPlayersMod=2;
			break;
		case 3:
			NumPlayersMod=2.75;
			break;
		case 4:
			NumPlayersMod=3.5;
			break;
		case 5:
			NumPlayersMod=4;
			break;
		case 6:
			NumPlayersMod=4.5;
			break;
        default:
            NumPlayersMod=UsedNumPlayers*0.8; // in case someone makes a mutator with > 6 players
	}

	NewMaxMonsters = NewMaxMonsters * DifficultyMod * NumPlayersMod;
	
	if ( UM_WaveTotalMaxMonsters <= 5)
		UM_WaveTotalMaxMonsters = 20;

	TotalMaxMonsters = Clamp(NewMaxMonsters,5,UM_WaveTotalMaxMonsters);  //11, MAX=UM_WaveTotalMaxMonsters, MIN 5

	MaxMonsters = Clamp(TotalMaxMonsters,5,MaxZombiesOnce);
	//log("****** "$MaxMonsters$" Max at once!");

	KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters = TotalMaxMonsters;
	KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonstersOn = True;
	WaveEndTime = Level.TimeSeconds + Waves[WaveNum].WaveDuration;
	AdjustedDifficulty = GameDifficulty + Waves[WaveNum].WaveDifficulty;

	j = ZedSpawnList.Length;
	for( i=0; i<j; i++ )
		ZedSpawnList[i].Reset();
	j = 1;
	SquadsToUse.Length = 0;

	for ( i=0; i<InitSquads.Length; i++ )
	{
		if ( (j & Waves[WaveNum].WaveMask) != 0 )
		{
			SquadsToUse.Insert(0,1);
			SquadsToUse[0] = i;

			// Ramm ZombieSpawn debugging
			/*for ( m=0; m<InitSquads[i].MSquad.Length; m++ )
			{
				log("Wave "$WaveNum$" Squad "$SquadsToUse.Length$" Monster "$m$" "$InitSquads[i].MSquad[m]);
			}
			log("****** "$TotalMaxMonsters);*/
		}
		j *= 2;
	}

	// Save this for use elsewhere
	InitialSquadsToUseSize = SquadsToUse.Length;
	bUsedSpecialSquad=false;
	SpecialListCounter=1;

	//Now build the first squad to use
	BuildNextSquad();
}

function UM_Monster SpawnRandWaveMonster()
{
	local	UM_Monster		M;
	local	int				r, t;
	local	NavigationPoint	StartSpot;
	
	while ( M == None && t < 100 )  {
		++t;
		r = Rand(WaveMonsters.Length);
		if ( WaveMonsters[r].MonsterClass != None && (WaveMonsters[r].WaveLimits.Length <= WaveNum || WaveMonsters[r].WaveLimits[WaveNum] != 0)
			 && (WaveMonsters[r].WaveSpawnChances.Length <= WaveNum || FRand() <= WaveMonsters[r].WaveSpawnChances[WaveNum]) 
			 && Level.TimeSeconds >= WaveMonsters[r].NextSpawnTime )  {
			// Spawn New Monster
			StartSpot = FindPlayerStart(None, 1);
			if ( StartSpot == None )
				Return None;
			M = Spawn( WaveMonsters[r].MonsterClass,,, (StartSpot.Location + Vect(0.0, 0.0, 1.0) * (WaveMonsters[r].MonsterClass.Default.CollisionHeight - StartSpot.CollisionHeight), StartSpot.Rotation );
			if ( M != None && M.bDeleteMe )  {
				M = None;
				Continue;
			}
			// NextSpawnTime
			if ( WaveMonsters[r].WaveSpawnDelays.Length > WaveNum && WaveMonsters[r].WaveSpawnDelays[WaveNum] > 0.0 )
				WaveMonsters[r].NextSpawnTime = Level.TimeSeconds + WaveMonsters[r].WaveSpawnDelays[WaveNum];
			// WavesLimit
			if ( WaveMonsters[r].WavesLimit.Length > WaveNum && WaveMonsters[r].WavesLimit[WaveNum] > 0 )  {
				--WaveMonsters[r].WavesLimit[WaveNum];
				// Remove this WaveMonster until next wave.
				if ( WaveMonsters[r].WavesLimit[WaveNum] < 1 )
					WaveMonsters.Remove(r, 1);
			}
		}
	}
	
	Return M;
}

State MatchInProgress
{
	function bool UpdateMonsterCount() // To avoid invasion errors.
	{
		local Controller C;
		local int i,j;

		For( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if( C.Pawn!=None && C.Pawn.Health>0 )
			{
				if( Monster(C.Pawn)!=None )
					i++;
				else j++;
			}
		}
		NumMonsters = i;
		Return (j>0);
	}

	function bool BootShopPlayers()
	{
		local int i,j;
		local bool bRes;

		j = ShopList.Length;
		for( i=0; i<j; i++ )
		{
			if( ShopList[i].BootPlayers() )
				bRes = True;
		}
		Return bRes;
	}

	function SelectShop()
	{
		local array<ShopVolume> TempShopList;
		local int i;
		local int SelectedShop;

		// Can't select a shop if there aren't any
		if ( ShopList.Length < 1 )
		{
			return;
		}

		for ( i = 0; i < ShopList.Length; i++ )
		{
			if ( ShopList[i].bAlwaysClosed )
				continue;

			TempShopList[TempShopList.Length] = ShopList[i];
		}

		SelectedShop = Rand(TempShopList.Length);

        if ( TempShopList[SelectedShop] != KFGameReplicationInfo(GameReplicationInfo).CurrentShop )
        {
        	KFGameReplicationInfo(GameReplicationInfo).CurrentShop = TempShopList[SelectedShop];
        }
        else if ( SelectedShop + 1 < TempShopList.Length )
        {
        	KFGameReplicationInfo(GameReplicationInfo).CurrentShop = TempShopList[SelectedShop + 1];
        }
        else
        {
        	KFGameReplicationInfo(GameReplicationInfo).CurrentShop = TempShopList[0];
        }
	}

	function OpenShops()
	{
		local int i;
		local Controller C;

		bTradingDoorsOpen = True;

		for( i=0; i<ShopList.Length; i++ )
		{
			if( ShopList[i].bAlwaysClosed )
				continue;
			if( ShopList[i].bAlwaysEnabled )
			{
				ShopList[i].OpenShop();
			}
		}

        if ( KFGameReplicationInfo(GameReplicationInfo).CurrentShop == none )
        {
            SelectShop();
        }

		KFGameReplicationInfo(GameReplicationInfo).CurrentShop.OpenShop();

		// Tell all players to start showing the path to the trader
		For( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if( C.Pawn!=None && C.Pawn.Health>0 )
			{
				// Disable pawn collision during trader time
				C.Pawn.bBlockActors = false;
				
				if( KFPlayerController(C) !=None )
				{
					KFPlayerController(C).SetShowPathToTrader(true);

					// Have Trader tell players that the Shop's Open
					if ( WaveNum < FinalWave )
					{
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 2);
					}
					else
					{
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 3);
					}

					//Hints
					KFPlayerController(C).CheckForHint(31);
					HintTime_1 = Level.TimeSeconds + 11;
				}
			}
		}
	}

	function CloseShops()
	{
		local int i;
		local Controller C;
		//local Pickup Pickup;

		bTradingDoorsOpen = False;
		for( i=0; i<ShopList.Length; i++ )
		{
			if( ShopList[i].bCurrentlyOpen )
				ShopList[i].CloseShop();
		}

		SelectShop();
		//Fix by TGN
		//Do not Destroy Weapons on the ground =)
		/*
		foreach AllActors(class'Pickup', Pickup)
		{
			if ( Pickup.bDropped )
			{
				Pickup.Destroy();
			}
		} */

		// Tell all players to stop showing the path to the trader
		for ( C = Level.ControllerList; C != none; C = C.NextController )
		{
			if ( C.Pawn != none && C.Pawn.Health > 0 )
			{
				// Restore pawn collision during trader time
				C.Pawn.bBlockActors = C.Pawn.default.bBlockActors;
				
				if ( KFPlayerController(C) != none )
				{
					KFPlayerController(C).SetShowPathToTrader(false);
					KFPlayerController(C).ClientForceCollectGarbage();

					if ( WaveNum < FinalWave - 1 )
					{
						// Have Trader tell players that the Shop's Closed
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 6);
					}
				}
			}
		}
	}

	// ToDo: переписать тут спавн монстров.
	event Timer()
	{
		local Controller C;
		local bool bOneMessage;
		local Bot B;

		Global.Timer();

		if ( Level.TimeSeconds > HintTime_1 && bTradingDoorsOpen && bShowHint_2 )
		{
			for ( C = Level.ControllerList; C != None; C = C.NextController )
			{
				if( C.Pawn != none && C.Pawn.Health > 0 )
				{
					KFPlayerController(C).CheckForHint(32);
					HintTime_2 = Level.TimeSeconds + 11;
				}
			}

			bShowHint_2 = false;
		}

		if ( Level.TimeSeconds > HintTime_2 && bTradingDoorsOpen && bShowHint_3 )
		{
			for ( C = Level.ControllerList; C != None; C = C.NextController )
			{
				if( C.Pawn != None && C.Pawn.Health > 0 )
				{
					KFPlayerController(C).CheckForHint(33);
				}
			}

			bShowHint_3 = false;
		}

		if ( !bFinalStartup )
		{
			bFinalStartup = true;
			PlayStartupMessage();
		}
		if ( NeedPlayers() && AddBot() && (RemainingBots > 0) )
			RemainingBots--;
		ElapsedTime++;
		GameReplicationInfo.ElapsedTime = ElapsedTime;
		if( !UpdateMonsterCount() )
		{
			EndGame(None,"TimeLimit");
			Return;
		}

		if( bUpdateViewTargs )
			UpdateViews();

		if (!bNoBots && !bBotsAdded)
		{
			//if(KFGameReplicationInfo(GameReplicationInfo) != none)

			if((NumPlayers + NumBots) < MaxPlayers && KFGameReplicationInfo(GameReplicationInfo).PendingBots > 0 )
			{
				AddBots(1);
				KFGameReplicationInfo(GameReplicationInfo).PendingBots --;
			}

			if (KFGameReplicationInfo(GameReplicationInfo).PendingBots == 0)
			{
				bBotsAdded = true;
				return;
			}
		}

		if( bWaveBossInProgress )
		{
			// Close Trader doors
			if( bTradingDoorsOpen )
			{
				CloseShops();
				TraderProblemLevel = 0;
			}
			if( TraderProblemLevel<4 )
			{
				if( BootShopPlayers() )
					TraderProblemLevel = 0;
				else TraderProblemLevel++;
			}
			if( !bHasSetViewYet && TotalMaxMonsters<=0 && NumMonsters>0 )
			{
				bHasSetViewYet = True;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if ( C.Pawn!=None && KFMonster(C.Pawn)!=None && KFMonster(C.Pawn).MakeGrandEntry() )
					{
						ViewingBoss = KFMonster(C.Pawn);
						Break;
					}
				if( ViewingBoss!=None )
				{
					ViewingBoss.bAlwaysRelevant = True;
					for ( C = Level.ControllerList; C != None; C = C.NextController )
					{
						if( PlayerController(C)!=None )
						{
							PlayerController(C).SetViewTarget(ViewingBoss);
							PlayerController(C).ClientSetViewTarget(ViewingBoss);
							PlayerController(C).bBehindView = True;
							PlayerController(C).ClientSetBehindView(True);
							PlayerController(C).ClientSetMusic(BossBattleSong,MTRAN_FastFade);
						}
						if ( C.PlayerReplicationInfo!=None && bRespawnOnBoss )
						{
							C.PlayerReplicationInfo.bOutOfLives = false;
							C.PlayerReplicationInfo.NumLives = 0;
							if ( (C.Pawn == None) && !C.PlayerReplicationInfo.bOnlySpectator && PlayerController(C)!=None )
								C.GotoState('PlayerWaiting');
						}
					}
				}
			}
			else if( ViewingBoss!=None && !ViewingBoss.bShotAnim )
			{
				ViewingBoss = None;
				for ( C = Level.ControllerList; C != None; C = C.NextController )
					if( PlayerController(C)!=None )
					{
						if( C.Pawn==None && !C.PlayerReplicationInfo.bOnlySpectator && bRespawnOnBoss )
							C.ServerReStartPlayer();
						if( C.Pawn!=None )
						{
							PlayerController(C).SetViewTarget(C.Pawn);
							PlayerController(C).ClientSetViewTarget(C.Pawn);
						}
						else
						{
							PlayerController(C).SetViewTarget(C);
							PlayerController(C).ClientSetViewTarget(C);
						}
						PlayerController(C).bBehindView = False;
						PlayerController(C).ClientSetBehindView(False);
					}
			}
			if( TotalMaxMonsters<=0 || (Level.TimeSeconds>WaveEndTime) )
			{
				// if everyone's spawned and they're all dead
				if ( NumMonsters <= 0 )
					DoWaveEnd();
			}
			else AddBoss();
		}
		else if(bWaveInProgress)
		{
			WaveTimeElapsed += 1.0;

			// Close Trader doors
			if (bTradingDoorsOpen)
			{
				CloseShops();
				TraderProblemLevel = 0;
			}
			if( TraderProblemLevel<4 )
			{
				if( BootShopPlayers() )
					TraderProblemLevel = 0;
				else TraderProblemLevel++;
			}
			if(!MusicPlaying)
				StartGameMusic(True);

			if( TotalMaxMonsters<=0 )
			{
				if ( NumMonsters <= 5 /*|| Level.TimeSeconds>WaveEndTime*/ )
				{
					for ( C = Level.ControllerList; C != None; C = C.NextController )
					{
						if ( UM_KFMonsterController(C)!=None && UM_KFMonsterController(C).CanKillMeYet() )
						{
							C.Pawn.KilledBy( C.Pawn );
							Break;
						}
						else if ( KFMonsterController(C)!=None && KFMonsterController(C).CanKillMeYet() )
						{
							C.Pawn.KilledBy( C.Pawn );
							Break;
						}
					}
				}
				// if everyone's spawned and they're all dead
				if ( NumMonsters <= 0 )
				{
                    DoWaveEnd();
				}
			} // all monsters spawned
			else if ( (Level.TimeSeconds > NextMonsterTime) && (NumMonsters+NextSpawnSquad.Length <= MaxMonsters) )
			{
				WaveEndTime = Level.TimeSeconds+160;
				if( !bDisableZedSpawning )
				{
                    AddSquad(); // Comment this out to prevent zed spawning
                }

				if(nextSpawnSquad.length>0)
				{
                	NextMonsterTime = Level.TimeSeconds + 0.2;
				}
				else
                {
                    NextMonsterTime = Level.TimeSeconds + CalcNextSquadSpawnTime();
                }
  			}
		}
		else if ( NumMonsters <= 0 )
		{
			if ( WaveNum == FinalWave && !bUseEndGameBoss )
			{
				if( bDebugMoney )
				{
					log("$$$$$$$$$$$$$$$$ Final TotalPossibleMatchMoney = "$TotalPossibleMatchMoney,'Debug');
				}

				EndGame(None,"TimeLimit");
				return;
			}
			else if( WaveNum == (FinalWave + 1) && bUseEndGameBoss )
			{
				if( bDebugMoney )
				{
					log("$$$$$$$$$$$$$$$$ Final TotalPossibleMatchMoney = "$TotalPossibleMatchMoney,'Debug');
				}

				EndGame(None,"TimeLimit");
				return;
			}

			WaveCountDown--;
			if ( !CalmMusicPlaying )
			{
				InitMapWaveCfg();
				StartGameMusic(False);
			}

			// Open Trader doors
			if ( WaveNum != InitialWave && !bTradingDoorsOpen )
			{
            	OpenShops();
			}

			// Select a shop if one isn't open
            if (	KFGameReplicationInfo(GameReplicationInfo).CurrentShop == none )
            {
                SelectShop();
            }

			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
			if ( WaveCountDown == 30 )
			{
				for ( C = Level.ControllerList; C != None; C = C.NextController )
				{
					if ( KFPlayerController(C) != None )
					{
						// Have Trader tell players that they've got 30 seconds
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 4);
					}
				}
			}
			else if ( WaveCountDown == 10 )
			{
				for ( C = Level.ControllerList; C != None; C = C.NextController )
				{
					if ( KFPlayerController(C) != None )
					{
						// Have Trader tell players that they've got 10 seconds
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 5);
					}
				}
			}
			else if ( WaveCountDown == 5 )
			{
				KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonstersOn=false;
				InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
			}
			else if ( (WaveCountDown > 0) && (WaveCountDown < 5) )
			{
				if( WaveNum == FinalWave && bUseEndGameBoss )
				{
				    BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 3);
				}
				else
				{
                    BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 1);
                }
			}
			else if ( WaveCountDown <= 1 )
			{
				bWaveInProgress = true;
				KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = true;

				// Randomize the ammo pickups again
				if( WaveNum > 0 )
				{
					SetupPickups();
				}

				if( WaveNum == FinalWave && bUseEndGameBoss )
				{
				    StartWaveBoss();
				}
				else
				{
					SetupWave();

					for ( C = Level.ControllerList; C != none; C = C.NextController )
					{
						if ( PlayerController(C) != none )
						{
							PlayerController(C).LastPlaySpeech = 0;

							if ( KFPlayerController(C) != none )
							{
								KFPlayerController(C).bHasHeardTraderWelcomeMessage = false;
							}
						}

						if ( Bot(C) != none )
						{
							B = Bot(C);
							InvasionBot(B).bDamagedMessage = false;
							B.bInitLifeMessage = false;

							if ( !bOneMessage && (FRand() < 0.65) )
							{
								bOneMessage = true;

								if ( (B.Squad.SquadLeader != None) && B.Squad.CloseToLeader(C.Pawn) )
								{
									B.SendMessage(B.Squad.SquadLeader.PlayerReplicationInfo, 'OTHER', B.GetMessageIndex('INPOSITION'), 20, 'TEAM');
									B.bInitLifeMessage = false;
								}
							}
						}
					}
			    }
		    }
		}
	}

	// Use a sine wave to somewhat randomly increase/decrease the frequency (and
	// also the intensity) of zombie squad spawning. This will give "peaks and valleys"
	// the the intensity of the zombie attacks
	function float CalcNextSquadSpawnTime()
	{
		local float NextSpawnTime;
		local float SineMod;

		SineMod = 1.0 - Abs(sin(WaveTimeElapsed * SineWaveFreq));

		NextSpawnTime = KFLRules.WaveSpawnPeriod;

        if( KFGameLength != GL_Custom )
        {
            if( KFGameLength == GL_Short )
            {
                // Make the zeds come faster in the earlier waves
                if( WaveNum < 2 )
                {
                    if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.3;
                    }
                }
                // Give a slightly bigger breather in the later waves
                else if( WaveNum >= 2 )
                {
                    if( NumPlayers <= 3 )
                    {
                        NextSpawnTime *= 1.1;
                    }
                    else if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 1.0;//0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.75;//0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.60;//0.3;
                    }
                }
            }
            else if( KFGameLength == GL_Normal )
            {
                // Make the zeds come faster in the earlier waves
                if( WaveNum < 4 )
                {
                    if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.3;
                    }
                }
                // Give a slightly bigger breather in the later waves
                else if( WaveNum >= 4 )
                {
                    if( NumPlayers <= 3 )
                    {
                        NextSpawnTime *= 1.1;
                    }
                    else if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 1.0;//0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.75;//0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.6;//0.3;
                    }
                }
            }
            else if( KFGameLength == GL_Long )
            {
                // Make the zeds come faster in the earlier waves
                if( WaveNum < 7 )
                {
                    if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.3;
                    }
                }
                // Give a slightly bigger breather in the later waves
                else if( WaveNum >= 7 )
                {
                    if( NumPlayers <= 3 )
                    {
                        NextSpawnTime *= 1.1;
                    }
                    else if( NumPlayers == 4 )
                    {
                        NextSpawnTime *= 1.0;//0.85;
                    }
                    else if( NumPlayers == 5 )
                    {
                        NextSpawnTime *= 0.75;//0.65;
                    }
                    else if( NumPlayers >= 6 )
                    {
                        NextSpawnTime *= 0.60;//0.3;
                    }
                }
            }
        }
        else
        {
            if( NumPlayers == 4 )
            {
                NextSpawnTime *= 0.85;
            }
            else if( NumPlayers == 5 )
            {
                NextSpawnTime *= 0.65;
            }
            else if( NumPlayers >= 6 )
            {
                NextSpawnTime *= 0.3;
            }
        }

        // Make the zeds come a little faster at all times on harder and above
        if ( GameDifficulty >= 4.0 ) // Hard
        {
            NextSpawnTime *= 0.85;
        }

		NextSpawnTime += SineMod * (NextSpawnTime * 2);

		return NextSpawnTime;
	}

	function DoWaveEnd()
	{
		local Controller C;
		local KFDoorMover KFDM;
		local PlayerController Survivor;
		local int SurvivorCount;

        // Only reset this at the end of wave 0. That way the sine wave that scales
        // the intensity up/down will be somewhat random per wave
        if( WaveNum < 1 )
        {
            WaveTimeElapsed = 0;
        }

		if ( !rewardFlag )
			RewardSurvivingPlayers();

		if( bDebugMoney )
		{
			log("$$$$$$$$$$$$$$$$ Wave "$WaveNum$" TotalPossibleWaveMoney = "$TotalPossibleWaveMoney,'Debug');
			log("$$$$$$$$$$$$$$$$ TotalPossibleMatchMoney = "$TotalPossibleMatchMoney,'Debug');
			TotalPossibleWaveMoney=0;
		}

		// Clear Trader Message status
		bDidTraderMovingMessage = false;
		bDidMoveTowardTraderMessage = false;

		bWaveInProgress = false;
		bWaveBossInProgress = false;
		bNotifiedLastManStanding = false;
		KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = false;

		WaveCountDown = Max(TimeBetweenWaves,1);
		KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		WaveNum++;

		for ( C = Level.ControllerList; C != none; C = C.NextController )
		{
			if ( C.PlayerReplicationInfo != none )
			{
				C.PlayerReplicationInfo.bOutOfLives = false;
				C.PlayerReplicationInfo.NumLives = 0;

				if ( KFPlayerController(C) != None && KFPlayerReplicationInfo(C.PlayerReplicationInfo) != None )  {
					KFPlayerController(C).bChangedVeterancyThisWave = False;
					if ( KFPlayerReplicationInfo(C.PlayerReplicationInfo).ClientVeteranSkill != KFPlayerController(C).SelectedVeterancy )
						KFPlayerController(C).SendSelectedVeterancyToServer();
				}

				if ( C.Pawn != none )
				{
					if ( PlayerController(C) != none )
					{
						Survivor = PlayerController(C);
						SurvivorCount++;
					}
				}
				else if ( !C.PlayerReplicationInfo.bOnlySpectator )
				{
					C.PlayerReplicationInfo.Score = Max(MinRespawnCash,int(C.PlayerReplicationInfo.Score));

					if( PlayerController(C) != none )
					{
						PlayerController(C).GotoState('PlayerWaiting');
						PlayerController(C).SetViewTarget(C);
						PlayerController(C).ClientSetBehindView(false);
						PlayerController(C).bBehindView = False;
						PlayerController(C).ClientSetViewTarget(C.Pawn);
					}

					C.ServerReStartPlayer();
				}

				if ( KFPlayerController(C) != None )  {
					if ( PlayerController(C).SteamStatsAndAchievements != None && KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements) != None )
						KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements).WaveEnded();

                    // Don't broadcast this message AFTER the final wave!
                    if ( WaveNum < FinalWave )  {
						KFPlayerController(C).bSpawnedThisWave = false;
						BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 2);
					}
					else if ( WaveNum == FinalWave )
						KFPlayerController(C).bSpawnedThisWave = false;
					else
						KFPlayerController(C).bSpawnedThisWave = true;
				}
			}
		}

		if ( Level.NetMode != NM_StandAlone && Level.Game.NumPlayers > 1 && SurvivorCount == 1 
			 && Survivor != None && Survivor.SteamStatsAndAchievements != None
			 && KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements) != none )
			KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements).AddOnlySurvivorOfWave();

		bUpdateViewTargs = True;

		//respawn doors
		foreach DynamicActors(class'KFDoorMover', KFDM)
			KFDM.RespawnDoor();
	}
	function InitMapWaveCfg()
	{
		local int i,l;
		local KFRandomSpawn RS;

		l = ZedSpawnList.Length;
		for( i=0; i<l; i++ )
			ZedSpawnList[i].NotifyNewWave(WaveNum);
		foreach DynamicActors(Class'KFRandomSpawn',RS)
			RS.NotifyNewWave(WaveNum,FinalWave-1);
	}
	function StartWaveBoss()
	{
		local int i,l;

		l = ZedSpawnList.Length;
		for( i=0; i<l; i++ )
			ZedSpawnList[i].Reset();
		bHasSetViewYet = False;
		WaveEndTime = Level.TimeSeconds+60;
		NextSpawnSquad.Length = 1;

		if( KFGameLength != GL_Custom )
		{
  		    NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(MonsterCollection.default.EndGameBossClass,Class'Class'));
  		    NextspawnSquad[0].static.PreCacheAssets(Level);
        }
        else
        {
            NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(EndGameBossClass,Class'Class'));
  		    NextspawnSquad[0].static.PreCacheAssets(Level);
        }

		if( NextSpawnSquad[0]==None )
			NextSpawnSquad[0] = Class<KFMonster>(FallbackMonster);
		KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters = 1;
		TotalMaxMonsters = 1;
		bWaveBossInProgress = True;
	}
	function UpdateViews() // To fix camera stuck on ur spec target
	{
		local Controller C;

		bUpdateViewTargs = False;
		for ( C = Level.ControllerList; C != None; C = C.NextController )
		{
			if ( PlayerController(C) != None && C.Pawn!=None )
				PlayerController(C).ClientSetViewTarget(C.Pawn);
		}
	}

	// Setup the random ammo pickups
	function SetupPickups()
	{
		local int NumWeaponPickups, NumAmmoPickups, Random, i, j;
		local int m;

		// Randomize Available Ammo Pickups
		if ( GameDifficulty >= 5.0 ) // Suicidal and Hell on Earth
		{
			NumWeaponPickups = WeaponPickups.Length * 0.1;
			NumAmmoPickups = AmmoPickups.Length * 0.1;
		}
		else if ( GameDifficulty >= 4.0 ) // Hard
		{
			NumWeaponPickups = WeaponPickups.Length * 0.2;
			NumAmmoPickups = AmmoPickups.Length * 0.35;
		}
		else if ( GameDifficulty >= 2.0 ) // Normal
		{
			NumWeaponPickups = WeaponPickups.Length * 0.3;
			NumAmmoPickups = AmmoPickups.Length * 0.5;
		}
		else // Beginner
		{
			NumWeaponPickups = WeaponPickups.Length * 0.5;
			NumAmmoPickups = AmmoPickups.Length * 0.65;
		}

        // reset all the of the pickups
        for ( m = 0; m < WeaponPickups.Length ; m++ )
        {
       		WeaponPickups[m].DisableMe();
        }

        for ( m = 0; m < AmmoPickups.Length ; m++ )
        {
       		AmmoPickups[m].GotoState('Sleeping', 'Begin');
        }

        // Ramdomly select which pickups to spawn
        for ( i = 0; i < NumWeaponPickups && j < 10000; i++ )
        {
        	Random = Rand(WeaponPickups.Length);

        	if ( !WeaponPickups[Random].bIsEnabledNow )
        	{
        		WeaponPickups[Random].EnableMe();
        	}
        	else
        	{
        		i--;
        	}

        	j++;
        }

        for ( i = 0; i < NumAmmoPickups && j < 10000; i++ )
        {
        	Random = Rand(AmmoPickups.Length);

        	if ( AmmoPickups[Random].bSleeping )
        	{
        		AmmoPickups[Random].GotoState('Pickup');
        	}
        	else
        	{
        		i--;
        	}

        	j++;
        }
    }

	event BeginState()
	{
		Super.BeginState();

		WaveNum = InitialWave;
		InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;

		// Ten second initial countdown
		WaveCountDown = 10;// Modify this if we want to make it take long for zeds to spawn initially

		SetupPickups();
	}

	event EndState()
	{
		local Controller C;

		Super.EndState();

		// Tell all players to stop showing the path to the trader
		For( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if( C.Pawn!=None && C.Pawn.Health>0 )
			{
				if( KFPlayerController(C) !=None )
				{
					KFPlayerController(C).SetShowPathToTrader(false);
				}
			}
		}
	}
}

function AddSpecialSquad()
{
	AddSpecialSquadFromCollection();
}

function bool AddBoss()
{
	local int ZombiesAtOnceLeft;
	local int numspawned;

	FinalSquadNum = 0;

    // Force this to the final boss class
	NextSpawnSquad.Length = 1;
	/*if( KFGameLength != GL_Custom)
	{
 	    NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(MonsterCollection.default.EndGameBossClass,Class'Class'));
    }
    else
    {
        NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(EndGameBossClass,Class'Class'));
        //override the monster with its event version
        if(NextSpawnSquad[0].default.EventClasses.Length > eventNum)
        {
            NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(NextSpawnSquad[0].default.EventClasses[eventNum],Class'Class'));
        }
    }*/
	
	NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(MonsterCollection.default.EndGameBossClass,Class'Class'));

	if( LastZVol==none )
	{
		LastZVol = FindSpawningVolume(false, true);
		if(LastZVol!=None)
			LastSpawningVolume = LastZVol;
	}

	if(LastZVol == None)
	{
		LastZVol = FindSpawningVolume(true, true);
		if( LastZVol!=None )
			LastSpawningVolume = LastZVol;

		if( LastZVol == none )
		{
            //log("Error!!! Couldn't find a place for the Patriarch after 2 tries, trying again later!!!");
            TryToSpawnInAnotherVolume(true);
            return false;
		}
	}

    // How many zombies can we have left to spawn at once
    ZombiesAtOnceLeft = MaxMonsters - NumMonsters;

    //log("Patrarich spawn, MaxMonsters = "$MaxMonsters$" NumMonsters = "$NumMonsters$" ZombiesAtOnceLeft = "$ZombiesAtOnceLeft$" TotalMaxMonsters = "$TotalMaxMonsters);

	if(LastZVol.SpawnInHere(NextSpawnSquad,,numspawned,TotalMaxMonsters,32/*ZombiesAtOnceLeft*/,,true))
	{
        //log("Spawned Patriarch - numspawned = "$numspawned);

        NumMonsters+=numspawned;
        WaveMonsters+=numspawned;

        return true;
	}
    else
    {
        //log("Failed Spawned Patriarch - numspawned = "$numspawned);

        TryToSpawnInAnotherVolume(true);
        return false;
    }

}

function AddSpecialPatriarchSquad()
{
	AddSpecialPatriarchSquadFromCollection();
}

/*
event GameEnding()
{
	if ( ActorPool != None )
	{
		log("---- Creating and destroying ActorPool. ----");
		ActorPool.Clear();
		ActorPool.Destroy();
	}
	Super.GameEnding();
} */

// Mod this to include the choices made in the GUIClassMenu
function RestartPlayer( Controller aPlayer )
{
	if ( aPlayer == None || aPlayer.PlayerReplicationInfo.bOutOfLives || aPlayer.Pawn != None )
		Return;

	if ( bWaveInProgress && PlayerController(aPlayer) != None )  {
		aPlayer.PlayerReplicationInfo.bOutOfLives = True;
		aPlayer.PlayerReplicationInfo.NumLives = 1;
		aPlayer.GoToState('Spectating');
		Return;
	}

	Super(GameInfo).RestartPlayer(aPlayer);

	// Notifying that the Veterancy info has changed
	if ( UM_PlayerReplicationInfo(aPlayer.PlayerReplicationInfo) != None )
		UM_PlayerReplicationInfo(aPlayer.PlayerReplicationInfo).NotifyVeterancyChanged();
	
	// Disable pawn collision during trader time
	if ( bTradingDoorsOpen && aPlayer.bIsPlayer )
		aPlayer.Pawn.bBlockActors = False;
}

function EndGame( PlayerReplicationInfo Winner, string Reason )
{
	if ( Class'UM_GlobalData'.default.ActorPool != None )  {
		log("------ Clearing and destroying ActorPool ------", Class.Outer.Name);
		Class'UM_GlobalData'.default.ActorPool.Clear();
		Class'UM_GlobalData'.default.ActorPool.Destroy();
	}
	Super.EndGame(Winner, Reason);
}

//[end] Functions
//====================================================================

defaultproperties
{
     GameSettingsProfileClassName="UnlimaginMod.UM_DefaultInvasionGameProfile"
	 DramaticKills(0)=(MinKilled=2,EventChance=0.03,EventDuration=2.5)
	 DramaticKills(1)=(MinKilled=5,EventChance=0.05,EventDuration=3.0)
	 DramaticKills(2)=(MinKilled=10,EventChance=0.2,EventDuration=3.5)
	 DramaticKills(3)=(MinKilled=15,EventChance=0.4,EventDuration=4.0)
	 DramaticKills(4)=(MinKilled=20,EventChance=0.8,EventDuration=4.5)
	 DramaticKills(5)=(MinKilled=25,EventChance=1.0,EventDuration=5.0)
	 
	 ActorPoolClass=Class'UnlimaginMod.UM_ActorPool'
	 BotAtHumanFriendlyFireScale=0.5
	 //EndGameBossClass
	 UM_EndGameBossClass="UnlimaginMod.UM_ZombieBoss"
	 //UM_EndGameBossClass="UnlimaginMod.UM_ZombieBoss_HALLOWEEN"
	 //UM_EndGameBossClass="UnlimaginMod.UM_ZombieBoss_XMas"
	 
	 
	 //MonsterClasses
	 UM_MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot",Mid="A")
     UM_MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler",Mid="B")
     UM_MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast",Mid="C")
     UM_MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker",Mid="D")
     UM_MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake",Mid="E")
     UM_MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound",Mid="F")
     UM_MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat",Mid="G")
     UM_MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren",Mid="H")
     UM_MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk",Mid="I")
	 
	 /*
	 UM_MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_HALLOWEEN",Mid="A")
     UM_MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_HALLOWEEN",Mid="B")
     UM_MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN",Mid="C")
     UM_MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_HALLOWEEN",Mid="D")
     UM_MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_HALLOWEEN",Mid="E")
     UM_MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN",Mid="F")
     UM_MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_HALLOWEEN",Mid="G")
     UM_MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_HALLOWEEN",Mid="H")
     UM_MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_HALLOWEEN",Mid="I")
	 
	 UM_MonsterClasses(0)=(MClassName="UnlimaginMod.UM_ZombieClot_XMas",Mid="A")
     UM_MonsterClasses(1)=(MClassName="UnlimaginMod.UM_ZombieCrawler_XMas",Mid="B")
     UM_MonsterClasses(2)=(MClassName="UnlimaginMod.UM_ZombieGoreFast_XMas",Mid="C")
     UM_MonsterClasses(3)=(MClassName="UnlimaginMod.UM_ZombieStalker_XMas",Mid="D")
     UM_MonsterClasses(4)=(MClassName="UnlimaginMod.UM_ZombieScrake_XMas",Mid="E")
     UM_MonsterClasses(5)=(MClassName="UnlimaginMod.UM_ZombieFleshpound_XMas",Mid="F")
     UM_MonsterClasses(6)=(MClassName="UnlimaginMod.UM_ZombieBloat_XMas",Mid="G")
     UM_MonsterClasses(7)=(MClassName="UnlimaginMod.UM_ZombieSiren_XMas",Mid="H")
     UM_MonsterClasses(8)=(MClassName="UnlimaginMod.UM_ZombieHusk_XMas",Mid="I")
	 */
	 
     //FallbackMonsterClass
	 UM_FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker"
	 //UM_FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker_HALLOWEEN"
	 //UM_FallbackMonsterClass="UnlimaginMod.UM_ZombieStalker_XMas"
	  
	 //MonsterSquads
	 UM_MonsterSquads(0)="4A"
     UM_MonsterSquads(1)="2A1B1C"
     UM_MonsterSquads(2)="3A1G"
     UM_MonsterSquads(3)="4A1C"
     UM_MonsterSquads(4)="1A3D"
     UM_MonsterSquads(5)="3A1C1D1G"
     UM_MonsterSquads(6)="2A1B2C"
     UM_MonsterSquads(7)="3A2C1D"
     UM_MonsterSquads(8)="3A2C"
     UM_MonsterSquads(9)="3A1C1H"
     UM_MonsterSquads(10)="3A1C2D1G"
     UM_MonsterSquads(11)="4A2C1B"
     UM_MonsterSquads(12)="2A1B3C2D"
     UM_MonsterSquads(13)="3A2C1E"
     UM_MonsterSquads(14)="3A3D1G1H"
     UM_MonsterSquads(15)="4A1B2C1D"
     UM_MonsterSquads(16)="2A4D1E1G"
     UM_MonsterSquads(17)="4C1E"
     UM_MonsterSquads(18)="3A1D1E1G"
     UM_MonsterSquads(19)="3B2C3D"
     UM_MonsterSquads(20)="2A1B2C2D1I"
     UM_MonsterSquads(21)="2A1B2C1D1G"
     UM_MonsterSquads(22)="2C1D1E1G"
     UM_MonsterSquads(23)="3A2B3C1G"
     UM_MonsterSquads(24)="1F"
     UM_MonsterSquads(25)="3A2C4D2G"
     UM_MonsterSquads(26)="3A2C1D1G1H"
     UM_MonsterSquads(27)="2B4C2D1A"
     UM_MonsterSquads(28)="1B3C3D1G1A"
     UM_MonsterSquads(29)="3A2C1E1G1H"
	  
     //SpecialSquads
	 UM_SpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     UM_SpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1))
     UM_SpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,1))
	 UM_SpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieScrake","UnlimaginMod.UM_ZombieFleshPound"),NumZeds=(1,2,1,1))
	 UM_SpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(2,1,2))
	 /*
	 UM_SpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_HALLOWEEN","UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN"),NumZeds=(2,2,1,1))
     UM_SpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1))
     UM_SpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(1,1,1))
     UM_SpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieScrake_HALLOWEEN","UnlimaginMod.UM_ZombieFleshPound_HALLOWEEN"),NumZeds=(1,2,1,1))
	 UM_SpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_HALLOWEEN","UnlimaginMod.UM_ZombieSiren_HALLOWEEN","UnlimaginMod.UM_ZombieFleshpound_HALLOWEEN"),NumZeds=(2,1,2))
	 
	 UM_SpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler_XMas","UnlimaginMod.UM_ZombieGoreFast_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieScrake_XMas"),NumZeds=(2,2,1,1))
     UM_SpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1))
     UM_SpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(1,1,1))
     UM_SpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieScrake_XMas","UnlimaginMod.UM_ZombieFleshPound_XMas"),NumZeds=(1,2,1,1))
	 UM_SpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat_XMas","UnlimaginMod.UM_ZombieSiren_XMas","UnlimaginMod.UM_ZombieFleshpound_XMas"),NumZeds=(2,1,2))
	 */
	 
     ShortSpecialSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     ShortSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1))
     NormalSpecialSquads(3)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     NormalSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1))
     NormalSpecialSquads(5)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,1))
     NormalSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,2))
     LongSpecialSquads(4)=(ZedClass=("UnlimaginMod.UM_ZombieCrawler","UnlimaginMod.UM_ZombieGoreFast","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieScrake"),NumZeds=(2,2,1,1))
     LongSpecialSquads(6)=(ZedClass=("UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1))
     LongSpecialSquads(7)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,1,1))
     LongSpecialSquads(8)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieScrake","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1,1))
     LongSpecialSquads(9)=(ZedClass=("UnlimaginMod.UM_ZombieBloat","UnlimaginMod.UM_ZombieSiren","UnlimaginMod.UM_ZombieScrake","UnlimaginMod.UM_ZombieFleshpound"),NumZeds=(1,2,1,2))
	  
	 //FinalSquads
	 UM_FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot"),NumZeds=(6))
     UM_FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot","UnlimaginMod.UM_ZombieCrawler"),NumZeds=(5,1))
     UM_FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot","UnlimaginMod.UM_ZombieStalker","UnlimaginMod.UM_ZombieCrawler"),NumZeds=(4,1,1))
	 /*
	 UM_FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN"),NumZeds=(6))
     UM_FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN","UnlimaginMod.UM_ZombieCrawler_HALLOWEEN"),NumZeds=(5,1))
     UM_FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot_HALLOWEEN","UnlimaginMod.UM_ZombieStalker_HALLOWEEN","UnlimaginMod.UM_ZombieCrawler_HALLOWEEN"),NumZeds=(4,1,1))
	 
	 UM_FinalSquads(0)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas"),NumZeds=(6))
     UM_FinalSquads(1)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas","UnlimaginMod.UM_ZombieCrawler_XMas"),NumZeds=(5,1))
     UM_FinalSquads(2)=(ZedClass=("UnlimaginMod.UM_ZombieClot_XMas","UnlimaginMod.UM_ZombieStalker_XMas","UnlimaginMod.UM_ZombieCrawler_XMas"),NumZeds=(4,1,1))
	 */
	 
     //Waves
     UM_Waves(0)=(WaveMask=511,WaveMaxMonsters=40,WaveDuration=255,WaveDifficulty=0.200000)
     UM_Waves(1)=(WaveMask=21998,WaveMaxMonsters=70,WaveDuration=255,WaveDifficulty=0.400000)
     UM_Waves(2)=(WaveMask=33593056,WaveMaxMonsters=80,WaveDuration=255,WaveDifficulty=0.800000)
     UM_Waves(3)=(WaveMask=351288512,WaveMaxMonsters=90,WaveDuration=255,WaveDifficulty=1.000000)
     UM_Waves(4)=(WaveMask=301973120,WaveMaxMonsters=100,WaveDuration=180,WaveDifficulty=1.200000)
     UM_Waves(5)=(WaveMask=1040186368,WaveMaxMonsters=104,WaveDuration=180,WaveDifficulty=1.400000)
     UM_Waves(6)=(WaveMask=1073741312,WaveMaxMonsters=110,WaveDuration=180,WaveDifficulty=1.500000)
     UM_Waves(7)=(WaveMask=1073740800,WaveMaxMonsters=114,WaveDuration=180,WaveDifficulty=1.500000)
     UM_Waves(8)=(WaveMask=1073739776,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=1.600000)
     UM_Waves(9)=(WaveMask=1073739776,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=1.600000)
     UM_Waves(10)=(WaveMask=1073739776,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=1.700000)
     UM_Waves(11)=(WaveMask=1073740800,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=1.800000)
     UM_Waves(12)=(WaveMask=1073740800,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=1.900000)
     UM_Waves(13)=(WaveMask=1073740800,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=2.000000)
     UM_Waves(14)=(WaveMask=1073739776,WaveMaxMonsters=118,WaveDuration=180,WaveDifficulty=2.000000)
     UM_Waves(15)=(WaveMask=1073737728,WaveMaxMonsters=50,WaveDuration=255,WaveDifficulty=2.000000)

     //MonsterCollection
	 MonsterCollection=Class'UnlimaginMod.UM_KFMonstersCollection'
	 UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersCollection'
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersSummerCollection'
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersHalloweenCollection'
	 //MonsterCollection=Class'UnlimaginMod.UM_KFMonstersXMasCollection'
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersXMasCollection'
 
	 ZEDTimeDuration=3.000000
	 ExitZedTime=0.500000
	 //FinalWave
     UM_FinalWave=7
	  
     //MaxZombiesOnce
     UM_MaxZombiesOnce=48
	  
     UM_TimeBetweenWaves=100
	  
     UM_WaveTotalMaxMonsters=800
	  
     MutatorClass="UnlimaginServer.UnlimaginMutator"
	 
	 LoginMenuClassName="UnlimaginMod.UM_SRInvasionLoginMenu"
	 DefaultPlayerClassName="UnlimaginMod.UM_HumanPawn"
     ScoreBoardType="UnlimaginMod.UM_SRScoreBoard"
     HUDType="UnlimaginMod.UM_HUDKillingFloor"
     MapListType="KFMod.KFMapList"
	 
	 PlayerControllerClass=Class'UnlimaginMod.UM_PlayerController'
     PlayerControllerClassName="UnlimaginMod.UM_PlayerController"
	 DefaultLevelRulesClass=Class'UnlimaginMod.UM_SRGameRules'
	 GameReplicationInfoClass=Class'UnlimaginMod.UM_GameReplicationInfo'
	 
     GameName="Unlimagin Monster Invasion"
	 Description="The premise is simple: you (and, hopefully, your team) have been flown in to 'cleanse' this area of specimens. The only things moving are specimens. They will launch at you in waves. Kill them. All of them. Any and every way you can. We'll even pay you a bounty for it! Between waves, you should be able to find the merc Trader lurking in some safe spot. She'll trade your bounty for ammo, equipment and Bigger Guns. Trust me - you're going to need them! If you can survive all the waves, you'll have to top the so-called Patriarch to finish the job. Don't worry about finding him - HE will come looking for YOU!"
}