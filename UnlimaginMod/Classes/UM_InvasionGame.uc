/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_InvasionGame
	Creation date:	 06.10.2012 13:12
----------------------------------------------------------------------------------
	Copyright � 2012 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright � 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright � 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_InvasionGame extends UM_BaseGameInfo
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

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';
const	Maths = Class'UnlimaginMod.UnlimaginMaths';

var		int								UM_TimeBetweenWaves;

var		bool							bDefaultPropertiesCalculated;

// GameWaves
struct GameWaveData
{
	var()	config	UM_BaseActor.IntRange	AliveMonsters;
	var()	config	UM_BaseActor.IntRange	MonsterSquadSize;
	var()	config	range					SquadsSpawnPeriod;
	var()	config	float					SquadsSpawnEndTime;
	var()	config	float					WaveDifficulty;
	var()	config	int						WaveStartDelay;
	var()	config	UM_BaseActor.IntRange	WaveDuration;
	var()	config	UM_BaseActor.IntRange	BreakTime;
	var()	config	UM_BaseActor.IntRange	StartingCash;
	var()	config	int						MinRespawnCash;
	var()	config	float					RespawnCashModifier;
};
var		array<GameWaveData>				GameWaves;

// Monsters
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
var		array<WaveMonsterData>			Monsters;

// BossMonsters
struct BossWaveMonsterData
{
	var()	config	string				MonsterClassName;
	var()	config	class<UM_Monster>	MonsterClass;
	var()	config	int					WaveLimit;
	var()	config	float				WaveSpawnChance;
};
var		array<BossWaveMonsterData>		BossMonsters;
// BossMonsterClass
var		string							BossMonsterClassName;
var		class<UM_Monster>				BossMonsterClass;

var		UM_BaseActor.IntRange			BossWaveStartingCash;
var		int								BossWaveMinRespawnCash;
var		float							BossWaveRespawnCashModifier;
var		int								BossWaveStartDelay;

var		Class<UM_ActorPool>				ActorPoolClass;

var		class<KFMonstersCollection>		UM_MonsterCollection;

var		int								InitialWaveNum;
var		transient	int					NextWaveNum;

var		ShopVolume						CurrentShop;
var		float							ShopListUpdateDelay;
var		transient	float				NextShopListUpdateTime;

var		config		bool				bStartMatchWithShopping;
var		UM_BaseActor.IntRange			StartShoppingTime;

var		float							ZedSpawnListUpdateDelay;
var		transient	float				NextZedSpawnListUpdateTime;

var		transient	int					WaveRemainingTime;
var		int								MaxAliveMonsters;
var		transient	float				NextMonsterSquadSpawnTime;
var		transient	int					NextMonsterSquadSize;

var		transient	float				NextJammedMonstersCheckTime;
var					float				JammedMonstersCheckDelay;

var		float							SpawningVolumeUpdateDelay;
var		transient	float				NextSpawningVolumeUpdateTime;

var		float							NumPlayersModifier;

var		transient	array<UM_HumanPawn>	HumanList;
var		transient	array<UM_Monster>	MonsterList;

var		transient	array< KFMonster >	JammedMonsters;

var		float							ZEDTimeKillSlowMoChargeBonus;

var		transient	string				CurrentMapName;

var		class<UM_BaseInvasionPreset>	InvasionPreset;

var		config		bool				bRepairDoorsBeforeNewWave;
var		config		bool				bRepairDoorsBeforeBossWave;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated static function CalcDefaultProperties()
{
	default.bDefaultPropertiesCalculated = True;
	
	default.MonsterSpawnSafeRange *= Maths.static.GetMeterInUU();
}

simulated function ResetToDefaultProperties()
{
	MonsterSpawnSafeRange = default.MonsterSpawnSafeRange;
}

/*Todo: ������� ������� ����� ���������������������.
	����������� ���������� ����� �������������� ������� ����������� ������� �� GamePreset ������.
*/
protected function bool LoadGamePreset( optional string NewPresetName )
{
	local	int		i, j;
	
	if ( !Super.LoadGamePreset( NewPresetName ) )
		Return False;
	
	InvasionPreset = class<UM_BaseInvasionPreset>(GamePreset);
	if ( InvasionPreset == None )
		Return False;	// Preset wasn't found
	
	// Monsters
	default.Monsters.Length = InvasionPreset.default.Monsters.Length;
	Monsters.Length = default.Monsters.Length;
	for ( i = 0; i < InvasionPreset.default.Monsters.Length; ++i )  {
		// MonsterClassName
		default.Monsters[i].MonsterClassName = InvasionPreset.default.Monsters[i].MonsterClassName;
		Monsters[i].MonsterClassName = default.Monsters[i].MonsterClassName;
		// WaveLimits
		default.Monsters[i].WaveLimits.Length = InvasionPreset.default.Monsters[i].WaveLimits.Length;
		Monsters[i].WaveLimits.Length = default.Monsters[i].WaveLimits.Length;
		for ( j = 0; j < InvasionPreset.default.Monsters[i].WaveLimits.Length; ++j )  {
			default.Monsters[i].WaveLimits[j] = InvasionPreset.default.Monsters[i].WaveLimits[j];
			Monsters[i].WaveLimits[j] = default.Monsters[i].WaveLimits[j];
		}
		// WaveSpawnChances
		default.Monsters[i].WaveSpawnChances.Length = InvasionPreset.default.Monsters[i].WaveSpawnChances.Length;
		Monsters[i].WaveSpawnChances.Length = default.Monsters[i].WaveSpawnChances.Length;
		for ( j = 0; j < InvasionPreset.default.Monsters[i].WaveSpawnChances.Length; ++j )  {
			default.Monsters[i].WaveSpawnChances[j] = InvasionPreset.default.Monsters[i].WaveSpawnChances[j];
			Monsters[i].WaveSpawnChances[j] = default.Monsters[i].WaveSpawnChances[j];
		}
		// WaveSpawnDelays
		default.Monsters[i].WaveSpawnDelays.Length = InvasionPreset.default.Monsters[i].WaveSpawnDelays.Length;
		Monsters[i].WaveSpawnDelays.Length = default.Monsters[i].WaveSpawnDelays.Length;
		for ( j = 0; j < InvasionPreset.default.Monsters[i].WaveSpawnDelays.Length; ++j )  {
			default.Monsters[i].WaveSpawnDelays[j] = InvasionPreset.default.Monsters[i].WaveSpawnDelays[j];
			Monsters[i].WaveSpawnDelays[j] = default.Monsters[i].WaveSpawnDelays[j];
		}
	}
	
	// GameWaves
	default.GameWaves.Length = InvasionPreset.default.GameWaves.Length;
	GameWaves.Length = default.GameWaves.Length;
	for ( i = 0; i < InvasionPreset.default.GameWaves.Length; ++i )  {
		// MinMonsters
		default.GameWaves[i].MinMonsters = InvasionPreset.default.GameWaves[i].MinMonsters;
		GameWaves[i].MinMonsters = default.GameWaves[i].MinMonsters;
		// MaxMonsters
		default.GameWaves[i].MaxMonsters = InvasionPreset.default.GameWaves[i].MaxMonsters;
		GameWaves[i].MaxMonsters = default.GameWaves[i].MaxMonsters;
		// MinMonstersAtOnce
		default.GameWaves[i].MinMonstersAtOnce = InvasionPreset.default.GameWaves[i].MinMonstersAtOnce;
		GameWaves[i].MinMonstersAtOnce = default.GameWaves[i].MinMonstersAtOnce;
		// MinMonsterSquad
		default.GameWaves[i].MinMonsterSquad = InvasionPreset.default.GameWaves[i].MinMonsterSquad;
		GameWaves[i].MinMonsterSquad = default.GameWaves[i].MinMonsterSquad;
		// MaxMonsterSquad
		default.GameWaves[i].MaxMonsterSquad = InvasionPreset.default.GameWaves[i].MaxMonsterSquad;
		GameWaves[i].MaxMonsterSquad = default.GameWaves[i].MaxMonsterSquad;
		// SquadsSpawnPeriod
		default.GameWaves[i].SquadsSpawnPeriod = InvasionPreset.default.GameWaves[i].SquadsSpawnPeriod;
		GameWaves[i].SquadsSpawnPeriod = default.GameWaves[i].SquadsSpawnPeriod;
		// WaveDifficulty
		default.GameWaves[i].WaveDifficulty = InvasionPreset.default.GameWaves[i].WaveDifficulty;
		GameWaves[i].WaveDifficulty = default.GameWaves[i].WaveDifficulty;
		// BreakTime
		default.GameWaves[i].BreakTime = InvasionPreset.default.GameWaves[i].BreakTime;
		GameWaves[i].BreakTime = default.GameWaves[i].BreakTime;
	}
	
	// BossMonsterClassName
	default.BossMonsterClassName = InvasionPreset.default.BossMonsterClassName;
	BossMonsterClassName = default.BossMonsterClassName;
	
	// BossMonsters
	default.BossMonsters.Length = InvasionPreset.default.BossMonsters.Length;
	BossMonsters.Length = default.BossMonsters.Length;
	for ( i = 0; i < InvasionPreset.default.BossMonsters.Length; ++i )  {
		// MonsterClassName
		default.BossMonsters[i].MonsterClassName = InvasionPreset.default.BossMonsters[i].MonsterClassName;
		BossMonsters[i].MonsterClassName = default.BossMonsters[i].MonsterClassName;
		// WaveLimit
		default.BossMonsters[i].WaveLimit = InvasionPreset.default.BossMonsters[i].WaveLimit;
		BossMonsters[i].WaveLimit = default.BossMonsters[i].WaveLimit;
		// WaveSpawnChance
		default.BossMonsters[i].WaveSpawnChance = InvasionPreset.default.BossMonsters[i].WaveSpawnChance;
		BossMonsters[i].WaveSpawnChance = default.BossMonsters[i].WaveSpawnChance;
	}
	
	Return True;
}

function LoadUpMonsterList()
{
	local	int		i;
	
	if ( BossMonsterClassName != "" )
		BossMonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(BossMonsterClassName) );
	else
		Warn("BossMonsterClassName not specified!", Class.Outer.Name);
	
	// Monsters
	for ( i = 0; i < default.Monsters.Length; ++i )  {
		if ( default.Monsters[i].MonsterClassName != "" )  {
			default.Monsters[i].MonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(default.Monsters[i].MonsterClassName) );
			Monsters[i].MonsterClass = default.Monsters[i].MonsterClass;
		}
	}
	
	// BossMonsters
	for ( i = 0; i < default.BossMonsters.Length; ++i )  {
		if ( default.BossMonsters[i].MonsterClassName != "" )  {
			default.BossMonsters[i].MonsterClass = Class<UM_Monster>( BaseActor.static.LoadClass(default.BossMonsters[i].MonsterClassName) );
			BossMonsters[i].MonsterClass = default.BossMonsters[i].MonsterClass;
		}
	}
}

function UpdateShopList()
{
	local	ShopVolume	SH;
	
	if ( Level.TimeSeconds < NextShopListUpdateTime )
		Return;
	
	NextShopListUpdateTime = Level.TimeSeconds + ShopListUpdateDelay;
	ShopList.Length = 0;
	// New ShopList
	foreach AllActors(class'ShopVolume', SH)  {
		if ( SH != None && !SH.bAlwaysClosed )
			ShopList[ShopList.Length] = SH;
	}
}

function UpdateZedSpawnList()
{
	local	ZombieVolume	ZZ;
	
	if ( Level.TimeSeconds < NextZedSpawnListUpdateTime )
		Return;
	
	NextZedSpawnListUpdateTime = Level.TimeSeconds + ZedSpawnListUpdateDelay;
	ZedSpawnList.Length = 0;
	// New ZedSpawnList
	foreach DynamicActors(class'ZombieVolume', ZZ)  {
		if ( ZZ != None && ZZ.bVolumeIsEnabled && Level.TimeSeconds >= ZZ.LastCheckTime )
			ZedSpawnList[ZedSpawnList.Length] = ZZ;
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
	local	KFLevelRules	KFLRit;
	local	string			InOpt;

	Super(xTeamGame).InitGame(Options, Error);
	
	InOpt = ParseOption(Options, "GamePresetClassName");
	LoadGamePreset( InOpt );
	
	//ToDo: Issue #290
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
	
	UpdateShopList();
	UpdateZedSpawnList();

	//provide default rules if mapper did not need custom one
	if ( KFLRules == None )
		KFLRules = Spawn(DefaultLevelRulesClass);

	log("KFLRules = "$KFLRules);

	InOpt = ParseOption(Options, "UseBots");
	if ( InOpt != "" )
		bNoBots = bool(InOpt);

	log("Game length = "$KFGameLength);
	
	if ( InvasionPreset != None )  {
		InitialWave = InvasionPreset.default.InitialWaveNum;
		FinalWave = InvasionPreset.default.GameWaves.Length;
	}
	else  {
		InitialWave = InitialWaveNum;
		FinalWave = GameWaves.Length;
	}
	WaveNum = InitialWave;
	NextWaveNum = InitialWave;
	UpdateStartingCash();
	/*	ToDo: �����! ��� ������ ���� ��������� ��� ��������� �������
		��� ���������� �����-������ ������������ ����������, ��������� �� ������ �����.
		������ ��������, ������, ����� ����� � �.�, 
		�� ������ ���� ��� �� ���� ������� � state 'BeginNewWave'.
	*/
	
	bCustomGameLength = True;	// We can't use Steam Stats with Unlimagin Mod
	UpdateGameLength();

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
	
	// Monsters
	Monsters.Length = default.Monsters.Length;
	for ( i = 0; i < default.Monsters.Length; ++i )  {
		// MonsterClass
		Monsters[i].MonsterClass = default.Monsters[i].MonsterClass;
		// WaveLimits
		Monsters[i].WaveLimits.Length = default.Monsters[i].WaveLimits.Length;
		for ( j = 0; j < default.Monsters[i].WaveLimits.Length; ++j )
			Monsters[i].WaveLimits[j] = default.Monsters[i].WavesLimit[j];
		// WaveSpawnChances
		Monsters[i].WaveSpawnChances.Length = default.Monsters[i].WaveSpawnChances.Length;
		for ( j = 0; j < default.Monsters[i].WaveSpawnChances.Length; ++j )
			Monsters[i].WaveSpawnChances[j] = default.Monsters[i].WaveSpawnChances[j];
		// WaveSpawnDelays
		Monsters[i].WaveSpawnDelays.Length = default.Monsters[i].WaveSpawnDelays.Length;
		for ( j = 0; j < default.Monsters[i].WaveSpawnDelays.Length; ++j )
			Monsters[i].WaveSpawnDelays[j] = default.Monsters[i].WaveSpawnDelays[j];
	}
}

function float GetDifficultyModifier()
{
	local	float	f;
	
	// WaveDifficulty Modifier
	f = GameWaves[WaveNum].WaveDifficulty;
	
	// Hell on Earth
	if ( GameDifficulty >= 7.0 )
		f *= 1.75;
	// Suicidal
	else if ( GameDifficulty >= 5.0 )
		f *= 1.5;
	// Hard
	else if ( GameDifficulty >= 4.0 )
		f *= 1.25;
	// Normal
	else if ( GameDifficulty >= 2.0 )
		f *= 1.0;
	// Beginner
	else
		f *= 0.75;
	
	Return f;
}

function float GetNumPlayersModifier()
{
	local	int		CurrentNumPlayers;
	
	CurrentNumPlayers = FMin( (NumPlayers + NumBots), MaxHumanPlayers);
	switch ( CurrentNumPlayers )  {
		case 1:
		case 2:
			Return float(CurrentNumPlayers);
			Break;
		
		case 3:
			Return 2.75;
			Break;
		
		case 4:
			Return 3.5;
			Break;
		
		case 5:
			Return 4.0;
			Break;
	}
	
	Return float(CurrentNumPlayers) - float(CurrentNumPlayers) * 0.25;
}

// Todo: #282
function UpdateNumPlayersModifier()
{
	if ( InvasionPreset != None )
		NumPlayersModifier = InvasionPreset.default.NumPlayersModifiers[ Min((NumPlayers + NumBots), (InvasionPreset.default.NumPlayersModifiers.Length - 1)) ];
	else
		NumPlayersModifier = GetNumPlayersModifier();
}

//Todo: #275
function UpdateMaxAliveMonsters()
{
	if ( InvasionPreset != None )
		MaxAliveMonsters = Min( Round(float(InvasionPreset.default.GameWaves[WaveNum].AliveMonsters.Min) * NumPlayersModifier), InvasionPreset.default.GameWaves[WaveNum].AliveMonsters.Max );
}

function ModifyMonsterListByDifficulty()
{
	local	int		i, j;
	local	float	DifficultyMod;
	
	DifficultyMod = GetDifficultyModifier();
	
	// scale Monster WaveLimits by difficulty
	for ( i = 0; i < Monsters.Length; ++i )  {
		for ( j = 0; j < Monsters[i].WaveLimits.Length; ++j )
			Monsters[i].WaveLimits[j] = Round( float(Monsters[i].WaveLimits[j]) * DifficultyMod );
	}
}

function ModifyMonsterListByNumPlayers()
{
	local	int		i, j;
	
	// scale Monster WaveLimits by number of Players
	for ( i = 0; i < Monsters.Length; ++i )  {
		for ( j = 0; j < Monsters[i].WaveLimits.Length; ++j )
			Monsters[i].WaveLimits[j] = Round( float(Monsters[i].WaveLimits[j]) * NumPlayersModifier );
	}
}

//[block] HumanList functions
function UpdateHumanList()
{
	local	int		i;
	
	for ( i = 0; i < HumanList.Length; ++i )  {
		if ( HumanList[i] == None || HumanList[i].bDeleteMe || HumanList[i].Health < 1 )
			HumanList.Remove(i, 1);
	}
}

// Called from the UM_HumanPawn in PostBeginPlay() function
function AddNewHumanToTheList( UM_HumanPawn H )
{
	HumanList[HumanList.Length] = H;
}

function ClearHumanList()
{
	while( HumanList.Length > 0 )
		Remove( (HumanList.Length - 1), 1 );
}
//[end] HumanList functions

//[block] MonsterList functions
function UpdateMonsterList()
{
	local	int		i;
	
	for ( i = 0; i < MonsterList.Length; ++i )  {
		if ( MonsterList[i] == None || MonsterList[i].bDeleteMe || MonsterList[i].Health < 1 )
			MonsterList.Remove(i, 1);
	}
	NumMonsters = MonsterList.Length;
}

// Called from the UM_Monster in PostBeginPlay() function
function AddNewMonsterToTheList( UM_Monster M )
{
	MonsterList[MonsterList.Length] = M;
}

function ClearMonsterList()
{
	while( MonsterList.Length > 0 )
		Remove( (MonsterList.Length - 1), 1 );
}
//[end] MonsterList functions

function UpdateCurrentMapName()
{
	local	string	Ret;
    local	int		i, j;
	
	// Get the MapName out of the URL
	Ret = Level.GetLocalURL();
	
	i = InStr(Ret, "/") + 1;
	if ( i < 0 || i > 16 )
		i = 0;
	
	j = InStr(Ret, "?");
	if ( j < 0 )
		j = Len(Ret);
	
	if ( Mid(Ret, (j - 3), 3) ~= "rom" )
		j -= 4;
	
	Ret = Mid(Ret, i, (j - i));
	
	CurrentMapName = Ret;
}

// Start the game - inform all actors that the match is starting, and spawn player pawns
function StartMatch()
{
	Super.StartMatch();
	
	if ( bStartMatchWithShopping )  {
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
		SetupPickups();
		GoToState('Shopping');
	}
	else
		GotoState('BeginNewWave');
}

function EndMatch()
{
	local	Controller	C;
	local	int			i;
	
	// Tell all players to stop showing the path to the trader
	for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
		++i;	// To prevent runaway loop
		// Find the Pawn of this controller
		if ( C.Pawn != None && C.Pawn.Health > 0 )  {
			// Enable pawn collision
			C.Pawn.bBlockActors = C.Pawn.default.bBlockActors;
			// Trader Hints
			if ( KFPlayerController(C) != None )  {
				KFPlayerController(C).SetShowPathToTrader(False);
				KFPlayerController(C).ClientForceCollectGarbage();
			}
		}
	}
}

//[block] BeginNewWave code
function SelectNewShop()
{
	local	int		NewShopNum;
	
	UpdateShopList();
	// No shops
	if ( ShopList.Length < 1 )
		Return;
	
	// Always random shop
	NewShopNum = Rand( ShopList.Length );
	if ( ShopList[NewShopNum] != CurrentShop )  {
		CurrentShop = ShopList[NewShopNum];
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).CurrentShop = CurrentShop;
	}
}

function NotifyNewWave()
{
	local	int				i;
	local	KFRandomSpawn	RS;
	
	UpdateZedSpawnList();
	for ( i = 0; i < ZedSpawnList.Length; ++i )  {
		if ( ZedSpawnList[i] != None )
			ZedSpawnList[i].NotifyNewWave(WaveNum);
	}
	
	foreach DynamicActors(Class'KFRandomSpawn', RS)  {
		if ( RS != None )
			RS.NotifyNewWave(WaveNum, (FinalWave - 1));
	}
}

// Randomize Available Pickups
function SetupPickups()
{
	local	int		i, r, j;
	
	/*
	// Reset all the of the WeaponPickups
	for ( i = 0; i < WeaponPickups.Length; ++i )
		WeaponPickups[i].DisableMe();
		
	// Reset all the of the AmmoPickups
	for ( i = 0; i < AmmoPickups.Length; ++i )
		AmmoPickups[i].GotoState('Sleeping', 'Begin');
	*/
	
	// Ramdomly select which WeaponPickups to spawn
	i = Min( Round(float(WeaponPickups.Length) * 0.5 / GetDifficultyModifier()), (WeaponPickups.Length - 1) );
	j = 0;
	while ( i > 0 && j < 10000 )  {
		++j; // Prevents runaway loop
		r = Rand( WeaponPickups.Length );
		// Enable if it wasn't enabled
		if ( !WeaponPickups[r].bIsEnabledNow )
			WeaponPickups[r].EnableMe();
		--i;
	}
	
	// Ramdomly select which AmmoPickups to spawn
	i = Min( Round(float(AmmoPickups.Length) * 0.6 / GetDifficultyModifier()), (AmmoPickups.Length - 1) );
	j = 0;
	while ( i > 0 && j < 10000 )  {
		++j; // Prevents runaway loop
		r = Rand( AmmoPickups.Length );
		if ( AmmoPickups[r].bSleeping )
			AmmoPickups[r].GotoState('Pickup');
		--i;
	}
}

// Must be called before the new wave has begun
function UpdateStartingCash()
{
	if ( InvasionPreset != None )  {
		if ( WaveNum < FinalWave )  {
			StartingCash = BaseActor.static.GetRandRangeInt( InvasionPreset.default.GameWaves[WaveNum].StartingCash );
			MinRespawnCash = InvasionPreset.default.GameWaves[WaveNum].MinRespawnCash;
			RespawnCashModifier = InvasionPreset.default.GameWaves[WaveNum].RespawnCashModifier;
		}
		else  {
			StartingCash = InvasionPreset.default.BossWaveStartingCash;
			MinRespawnCash = InvasionPreset.default.BossWaveMinRespawnCash;
			RespawnCashModifier = InvasionPreset.default.BossWaveRespawnCashModifier;
		}
	}
	else if ( WaveNum < FinalWave )  {
		StartingCash = BaseActor.static.GetRandRangeInt( GameWaves[WaveNum].StartingCash );
		MinRespawnCash = GameWaves[WaveNum].MinRespawnCash;
		RespawnCashModifier = GameWaves[WaveNum].RespawnCashModifier;
	}
	else  {
		StartingCash = BossWaveStartingCash;
		MinRespawnCash = BossWaveMinRespawnCash;
		RespawnCashModifier = BossWaveRespawnCashModifier;
	}
}

function RepairDoors()
{
	local	KFDoorMover		DoorMover;
	
	foreach DynamicActors(class'KFDoorMover', DoorMover)  {
		if ( DoorMover != None )
			DoorMover.RespawnDoor();
	}
}

function DecreaseWaveCountDown()
{
	--WaveCountDown;
	if ( KFGameReplicationInfo(GameReplicationInfo) != None )
		KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
}

state BeginNewWave
{
	event BeginState()
	{
		WaveNum = NextWaveNum;
		if ( WaveNum < FinalWave )  {
			++NextWaveNum;
			if ( InvasionPreset != None )
				WaveCountDown = InvasionPreset.default.GameWaves[WaveNum].WaveStartDelay;
			else
				WaveCountDown = GameWaves[WaveNum].WaveStartDelay;
		}
		// BossWave
		else if ( InvasionPreset != None )
			WaveCountDown = InvasionPreset.default.BossWaveStartDelay;
		else
			WaveCountDown = BossWaveStartDelay;
		
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
		
		if ( CurrentShop == None )
			SelectNewShop();
		
		UpdateStartingCash();
		NotifyNewWave();
		SetupPickups();
		
		// Repair Doors (Repair bool vars are config)
		if ( (WaveNum < FinalWave && bRepairDoorsBeforeNewWave ) || (WaveNum == FinalWave && bRepairDoorsBeforeBossWave) )
			RepairDoors();
	}
	
	event Timer()
	{
		Global.Timer();
		
		if ( WaveCountDown > 0 )
			DecreaseWaveCountDown();
		else if ( WaveNum < FinalWave )
			GotoState('WaveInProgress');
		else if ( bUseEndGameBoss )
			GotoState('BossWaveInProgress');
		else
			EndGame(None,"TimeLimit");
	}
}
//[end] BeginNewWave code

//[block] Shopping code
// Teleport Players from the shops
function bool BootShopPlayers()
{
	local	int		i;
	local	bool	bResult;
	
	UpdateShopList();
	for ( i = 0; i < ShopList.Length; ++i )  {
		if ( ShopList[i].BootPlayers() )
			bResult = True;
	}
	
	Return bResult;
}

function RespawnWaitingPlayers()
{
	local	Controller	C;
	local	int			i;
	
	// ControllerList
	for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
		++i;	// To prevent runaway loop
		// Respawn Player
		if ( C.PlayerReplicationInfo != None && C.Pawn == None && C.CanRestartPlayer() )
			RespawnPlayer( C );
	}
}

state Shopping
{
	// Open Shops
	event BeginState()
	{
		local	int			i;
		local	Controller	C;
		
		bTradingDoorsOpen = True;
		
		if ( !CalmMusicPlaying )
			StartGameMusic(False);
		
		if ( CurrentShop == None )
			SelectNewShop();
		
		UpdateShopList();
		for ( i = 0; i < ShopList.Length; ++i )  {
			if ( ShopList[i].bAlwaysEnabled || ShopList[i] == CurrentShop )
				ShopList[i].OpenShop();
		}
		
		// Tell all players to start showing the path to the trader
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			// Find the Pawn
			if ( C.Pawn != None && C.Pawn.Health > 0 )  {
				// Disable pawn collision during trader time
				C.Pawn.bBlockActors = False;
				// Trader Hints
				if ( KFPlayerController(C) != None )  {
					KFPlayerController(C).SetShowPathToTrader(True);
					// Have Trader tell players that the Shop's Open
					if ( NextWaveNum < FinalWave )
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, None, 'TRADER', 2);
					// Boss Wave Next
					else
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 3);
				
					//Hints
					KFPlayerController(C).CheckForHint(31);
				}
			}
		}
		
		HintTime_1 = Level.TimeSeconds + 11.0;
		
		// Break Time
		if ( NextWaveNum > InitialWave )  {
			if ( InvasionPreset != None )
				WaveCountDown = BaseActor.static.GetRandRangeInt( InvasionPreset.default.GameWaves[WaveNum].BreakTime );
			else
				WaveCountDown = BaseActor.static.GetRandRangeInt( GameWaves[WaveNum].BreakTime );
		}
		// Start Match With Shopping
		else if ( InvasionPreset != None )
			WaveCountDown = BaseActor.static.GetRandRangeInt( InvasionPreset.default.StartShoppingTime );
		else
			WaveCountDown = BaseActor.static.GetRandRangeInt( StartShoppingTime );
	}
	
	function PlaySecondHint()
	{
		local	Controller	C;
		local	int			i;
		
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			if ( C.Pawn != None && C.Pawn.Health > 0 )
				KFPlayerController(C).CheckForHint(32);
		}
	}
	
	function PlayThirdHint()
	{
		local	Controller	C;
		local	int			i;
		
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			if ( C.Pawn != None && C.Pawn.Health > 0 )
				KFPlayerController(C).CheckForHint(33);
		}
	}
	
	function PlayTenSecondsLeftMessage()
	{
		local	Controller	C;
		local	int			i;
		
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			if ( KFPlayerController(C) != None )
				KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 5);
		}
	}
	
	function PlayThirtySecondsLeftMessage()
	{
		local	Controller	C;
		local	int			i;
		
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			if ( KFPlayerController(C) != None )
				KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 4);
		}
	}
	
	event Timer()
	{
		Global.Timer();
		
		// Out from the Shopping state
		if ( WaveCountDown < 1 )  {
			// Teleport players from the shops
			if ( BootShopPlayers() )
				WaveCountDown = 1;
			else
				GotoState('BeginNewWave');
			
			Return;
		}
		
		if ( bShowHint_2 && Level.TimeSeconds > HintTime_1 )  {
			bShowHint_2 = False;
			PlaySecondHint();
			HintTime_2 = Level.TimeSeconds + 11.0;
		}
		else if ( bShowHint_3 && Level.TimeSeconds > HintTime_2 )  {
			bShowHint_3 = False;
			PlayThirdHint();
		}
		
		DecreaseWaveCountDown();
		if ( WaveCountDown < 5 )  {
			// Broadcast Localized Message about next wave
			if ( NextWaveNum < FinalWave )
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 1);
			else if ( bUseEndGameBoss )
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 3);
		}
		else  {
			// Respawn died players if more than 5 seconds left
			RespawnWaitingPlayers();
			// Have Trader tell players that they've got 10 seconds
			if ( WaveCountDown == 10 )
				PlayTenSecondsLeftMessage();
			// Have Trader tell players that they've got 30 seconds
			else if ( WaveCountDown == 30 )
				PlayThirtySecondsLeftMessage();
		}
	}
	
	// Close Shops
	event EndState()
	{
		local	int			i;
		local	Controller	C;
		
		bTradingDoorsOpen = False;
		
		for ( i = 0; i < ShopList.Length; ++i )  {
			if ( ShopList[i] == None )  {
				ShopList.Remove(i, 1);
				Continue;
			}
			
			if ( ShopList[i].bCurrentlyOpen )
				ShopList[i].CloseShop();
		}
		
		// Tell all players to stop showing the path to the trader
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			// Find the Pawn of this controller
			if ( C.Pawn != None && C.Pawn.Health > 0 )  {
				// Enable pawn collision
				C.Pawn.bBlockActors = C.Pawn.default.bBlockActors;
				// Trader Hints
				if ( KFPlayerController(C) != None )  {
					KFPlayerController(C).SetShowPathToTrader(False);
					KFPlayerController(C).ClientForceCollectGarbage();
					// Have Trader tell players that the Shop's Closed
					if ( WaveNum < FinalWave )
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, None, 'TRADER', 2);
				}
			}
		}
		
		SelectNewShop();
	}
}
//[end] Shopping

//[block] WaveInProgress Code
function UpdateWaveRemainingTime()
{
	WaveRemainingTime = Min( Round(float(GameWaves[WaveNum].WaveDuration.Min) * GetDifficultyModifier()), GameWaves[WaveNum].WaveDuration.Max );
}

function CheckSelectedVeterancy( KFPlayerController PC )
{
	if ( PC == None || KFPlayerReplicationInfo(PC.PlayerReplicationInfo) == None )
		Return;
	
	PC.bChangedVeterancyThisWave = False;
	if ( PC.SelectedVeterancy != KFPlayerReplicationInfo(PC.PlayerReplicationInfo).ClientVeteranSkill )
		PC.SendSelectedVeterancyToServer();
}

function ZombieVolume FindSpawningVolume( optional bool bIgnoreFailedSpawnTime, optional bool bBossSpawning )
{
	local	ZombieVolume		BestZ;
	local	float				BestScore, tScore;
	local	int					i;
	local	Controller			C;
	
	UpdateHumanList();
	// First pass, pick a random player.
	if ( HumanList.Length > 0 )
		C = HumanList[ Rand(HumanList.Length) ].Controller;
	
	if ( C == None )
		Return None; // Shouldnt get to this case, but just to be sure...
	
	UpdateZedSpawnList();
	// Second pass, figure out best spawning point.
	for ( i = 0; i < ZedSpawnList.Length; ++i )  {
		tScore = ZedSpawnList[i].RateZombieVolume( Self, LastSpawningVolume, C, bIgnoreFailedSpawnTime, bBossSpawning );
		if ( tScore < 0 )
			Continue;
		
		if ( BestZ == None || tScore > BestScore )  {
			BestScore = tScore;
			BestZ = ZedSpawnList[i];
		}
	}
	
	Return BestZ;
}

// Clear old functions
function SetupWave() { }
function AddSpecialSquad() { }
function bool AddSquad() { }

function BuildNextSquad()
{
	local	int				c, r,
	
	NextSpawnSquad.Length = 0;
	while ( NextSpawnSquad.Length < NextMonsterSquadSize && c < 250 )  {
		++c;
		r = Rand(Monsters.Length);
		if ( Monsters[r].MonsterClass != None && (Monsters[r].WaveLimits.Length <= WaveNum || Monsters[r].WaveLimits[WaveNum] != 0) 
			 && (Monsters[r].WaveSpawnChances.Length <= WaveNum || FRand() <= Monsters[r].WaveSpawnChances[WaveNum]) )  {
			NextSpawnSquad[ NextSpawnSquad.Length ] = Monsters[r].MonsterClass;
			// NextSpawnTime
			if ( Monsters[r].WaveSpawnDelays.Length > WaveNum && Monsters[r].WaveSpawnDelays[WaveNum] > 0.0 )
				Monsters[r].NextSpawnTime = Level.TimeSeconds + Monsters[r].WaveSpawnDelays[WaveNum];
			// WavesLimit
			if ( Monsters[r].WavesLimit.Length > WaveNum && Monsters[r].WavesLimit[WaveNum] > 0 )  {
				--Monsters[r].WavesLimit[WaveNum];
				// Remove this WaveMonster
				if ( Monsters[r].WavesLimit[WaveNum] < 1 )
					Monsters.Remove(r, 1);
			}
		}
	}
	// Next Monster Squad Size
	NextMonsterSquadSize = BaseActor.static.GetRandRangeInt( GameWaves[WaveNum].MonsterSquadSize );
}

function SelectNewSpawningVolume( optional bool bForceSelection )
{
	if ( !bForceSelection && Level.TimeSeconds < NextSpawningVolumeUpdateTime )
		Return;
	
	NextSpawningVolumeUpdateTime = Level.TimeSeconds + SpawningVolumeUpdateDelay;
	LastSpawningVolume = FindSpawningVolume();
}

function SpawnNewMonsterSquad( optional bool bForceSpawn )
{
	local	int		NumSpawned;
	
	// NextSpawnTime
	if ( !bForceSpawn )
		NextMonsterSquadSpawnTime = Level.TimeSeconds + BaseActor.static.GetRandRangeFloat( GameWaves[WaveNum].SquadsSpawnPeriod ) / GetDifficultyModifier();
	
	// NewMonsterSquad
	if ( NextSpawnSquad.Length < 1 )
		BuildNextSquad();
	
	// NewSpawningVolume
	if ( LastSpawningVolume == None )
		SelectNewSpawningVolume(True);
	else
		SelectNewSpawningVolume();
	
	if ( LastSpawningVolume == None )
		Return;
	
	if ( LastSpawningVolume.SpawnInHere( NextSpawnSquad,, NumSpawned, MaxMonsters, (MaxAliveMonsters - NumMonsters) ) )  {
		MaxMonsters = default.MaxMonsters;
		NumMonsters += NumSpawned;
		WaveMonsters += NumSpawned;
		NextSpawnSquad.Length = 0;
	}
	else  {
		SelectNewSpawningVolume(True);
		NextMonsterSquadSpawnTime = Level.TimeSeconds + 1.0;
	}
}

function bool CheckForJammedMonsters()
{
	local	int			i;
	local	Controller	C;
	
	NextJammedMonstersCheckTime = JammedMonstersCheckDelay + Level.TimeSeconds;
	
	for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
		++i;	// To prevent runaway loop
		if ( KFMonsterController(C) != None && KFMonsterController(C).CanKillMeYet() && KFMonster(C.Pawn) != None )
			JammedMonsters[JammedMonsters.Length] = KFMonster(C.Pawn);
	}
	
	Return JammedMonsters.Length > 0;
}

function RespawnJammedMonsters()
{
	local	int		i;
	
	while ( JammedMonsters.Length > 0 )  {
		i = JammedMonsters.Length - 1;
		if ( Class<KFMonster>(JammedMonsters[i].Class) != None )
			NextSpawnSquad[NextSpawnSquad.Length] = Class<KFMonster>(JammedMonsters[i].Class);
		JammedMonsters[i].Suicide();
		JammedMonsters.Remove(i, 1);
	}
	
	NumMonsters -= NextSpawnSquad.Length;
	WaveMonster -= NextSpawnSquad.Length;
	//MaxMonsters += NextSpawnSquad.Length;
	
	SpawnNewMonsterSquad(True);
}

function DoWaveEnd()
{
	local	Controller			C;
	local	PlayerController	Survivor;
	local	int					i, SurvivorCount;
	
	if ( !rewardFlag )
		RewardSurvivingPlayers();
	
	// Clear Trader Message status
	bDidTraderMovingMessage = False;
	bDidMoveTowardTraderMessage = False;

	bWaveInProgress = False;
	bWaveBossInProgress = False;
	bNotifiedLastManStanding = False;
	if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
		KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = False;
		//KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = False;
	}
	
	// ControllerList
	for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
		++i;	// To prevent runaway loop
		if ( C.PlayerReplicationInfo == None )
			Continue; // skip this controller
		
		C.PlayerReplicationInfo.bOutOfLives = False;
		C.PlayerReplicationInfo.NumLives = 0;
	
		if ( KFPlayerController(C) != None )  {
			CheckSelectedVeterancy( KFPlayerController(C) );
			if ( PlayerController(C).SteamStatsAndAchievements != None && KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements) != None )
				KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements).WaveEnded();

			// Don't broadcast this message AFTER the final wave!
			if ( NextWaveNum < FinalWave )  {
				KFPlayerController(C).bSpawnedThisWave = False;
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 2);
			}
			// Next Wave will be a Final Wave
			else if ( NextWaveNum == FinalWave )
				KFPlayerController(C).bSpawnedThisWave = False;
			// End of the game
			else
				KFPlayerController(C).bSpawnedThisWave = True;
		}
		
		// Survivor
		if ( C.Pawn != None )  {
			if ( C.Pawn.Health > 0 && PlayerController(C) != None )  {
				Survivor = PlayerController(C);
				++SurvivorCount;
			}
		}
		// Respawn Player
		else if ( C.CanRestartPlayer() )
			RespawnPlayer( C );
	}
	
	if ( Level.NetMode != NM_StandAlone && NumPlayers > 1 && SurvivorCount == 1 
		 && Survivor != None && KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements) != none )
		KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements).AddOnlySurvivorOfWave();

	bUpdateViewTargs = True;
}

function CheckForGameEnd()
{
	UpdateHumanList();
	UpdateMonsterList();
	
	if ( HumanList.Length < 1 )
		EndGame(None, "TimeLimit");
}

state WaveInProgress
{
	/* ToDo: ������ ��� ������� � ���������� � ���. 
	����� ��������� �� �������, � �� �� ���������� ��������. */
	function UpdateMaxMonsters()
	{
		// Total max number of monsters at this wave
		TotalMaxMonsters = Min( Round(float(BaseActor.static.GetRandRangeInt(GameWaves[WaveNum].NumMonsters)) * GetDifficultyModifier() * NumPlayersModifier), GameWaves[WaveNum].MaxMonsters );
		// Monsters left to spawn in this wave
		MaxMonsters = Max( (TotalMaxMonsters - WaveMonsters), 0 );
	}
	
	event BeginState()
	{
		rewardFlag = False;
		ZombiesKilled = 0;
		WaveMonsters = 0;
		NumMonsters = 0;
		CurrentWaveDuration = 0;
		UpdateWaveRemainingTime();
		
		NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
		
		// Monsters
		UpdateMaxMonsters();
		
		AdjustedDifficulty = GameDifficulty * GameWaves[WaveNum].WaveDifficulty;
		
		if ( !MusicPlaying )
			StartGameMusic( True );
		
		bWaveInProgress = True;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
			KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = MaxMonsters;
			//KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = True;
			KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = True;
		}
	}
	
	event Timer()
	{
		Global.Timer();

		--WaveRemainingTime;
		
		if ( !bFinalStartup )  {
			bFinalStartup = True;
			PlayStartupMessage();
		}
		
		if ( NeedPlayers() && AddBot() && (RemainingBots > 0) )
			RemainingBots--;
		
		ElapsedTime++;
		if ( GameReplicationInfo != None )
			GameReplicationInfo.ElapsedTime = ElapsedTime;
		
		CheckForGameEnd();
		
		if ( Level.TimeSeconds >= NextJammedMonstersCheckTime && CheckForJammedMonsters() )
			RespawnJammedMonsters();
		
		if ( WaveRemainingTime < 1 )  {
			if ( NextWaveNum < FinalWave || bUseEndGameBoss )
				GoToState('Shopping');
			else
				EndGame(None, "TimeLimit");
		}
		// Spawn New Monster Squad
		else if ( Level.TimeSeconds >= NextMonsterSquadSpawnTime && WaveRemainingTime > GameWaves[WaveNum].SquadsSpawnEndTime && (MaxAliveMonsters - NumMonsters) >= NextMonsterSquadSize )
			SpawnNewMonsterSquad();
	}
	
	event EndState()
	{
		DoWaveEnd();
	}
}
//[end] WaveInProgress Code


//[block] BossWaveInProgress Code
state BossWaveInProgress
{
	event BeginState()
	{
		bWaveBossInProgress = True;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = True;
	}
}
//[end] BossWaveInProgress code

function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType )
{
	if ( MonsterController(Killed) != None || Monster(KilledPawn) != None )  {
		--NumMonsters;
		++ZombiesKilled;		
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = Max( (MaxMonsters + NumMonsters) , 0 );
		
		if ( PlayerController(Killer) != None )  {
			if ( !bDidTraderMovingMessage )  {
				if ( (float(TotalMaxMonsters) / float(ZombiesKilled)) >= 0.2 )  {
					// Have Trader tell players that the Shop's Moving
					if ( WaveNum < FinalWave )
						PlayerController(Killer).ServerSpeech('TRADER', 0, "");
					
					bDidTraderMovingMessage = True;
				}
			}
			else if ( !bDidMoveTowardTraderMessage )  {
				if ( (float(TotalMaxMonsters) / float(ZombiesKilled)) >= 0.8 )  {
					// Have Trader tell players that the Shop's Almost Open
					if ( WaveNum < FinalWave && Level.NetMode != NM_Standalone && Killer.Pawn != None 
						 && CurrentShop != None && VSizeSquared(Killer.Pawn.Location - CurrentShop.Location) >= 2250000.0 ) // 30 meters
						PlayerController(Killer).Speech('TRADER', 1, "");
					
					bDidMoveTowardTraderMessage = True;
				}
			}
			
			if ( Killed != Killer )  {
				// ZEDTimeActive
				if ( bZEDTimeActive )  {
					// Human Extend ZEDTime
					if ( UM_HumanPawn(Killer.Pawn) != None )  {
						UM_HumanPawn(Killer.Pawn).AddSlowMoCharge( ZEDTimeKillSlowMoChargeBonus );
						ExtendZEDTime( UM_HumanPawn(Killer.Pawn) );
					}
					// Monster has killed another monster
					else if ( Monster(Killer.Pawn) != None )  {
						ResetSlowMoInstigator();
						DramaticEvent(1.00);
					}
				}
				// Chance to start Random ZEDTime
				else if ( (Level.TimeSeconds - LastZedTimeEvent) > 0.1 )  {
					// Possibly do a slomo event when a zombie dies, with a higher chance if the zombie is closer to a player
					if ( Killer.Pawn != None && VSizeSquared(Killer.Pawn.Location - KilledPawn.Location) < 22500 ) // 3 meters
						DramaticEvent(0.05);
					else
						DramaticEvent(0.025);
				}
				// All Killed Achievements Moved to the UM_ServerStats
				if ( PlayerController(Killer) != None && UM_BaseServerStats(PlayerController(Killer).SteamStatsAndAchievements) != None )
					UM_BaseServerStats(PlayerController(Killer).SteamStatsAndAchievements).NotifyKilled( Killed, KilledPawn, DamageType );
			}
		}
		
		if ( Class<Monster>(KilledPawn.Class) != None )
			LastKilledMonsterClass = Class<Monster>(KilledPawn.Class);
	}
	
	Super(DeathMatch).Killed( Killer, Killed, KilledPawn, DamageType );
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
	 bUseEndGameBoss=True
	 bRespawnOnBoss=True
	 
	 bSaveSpectatorScores=True
	 
	 bRepairDoorsBeforeNewWave=False
	 bRepairDoorsBeforeBossWave=True
	 
	 MaxAliveMonsters=40
	 NumPlayersModifier=1.0
	 JammedMonstersCheckDelay=20
	 ShopListUpdateDelay=1.0
	 ZedSpawnListUpdateDelay=5.0
	 SpawningVolumeUpdateDelay=4.0
	 GamePresetClassName="UnlimaginMod.UM_DefaultInvasionPreset"
	 
	 ZEDTimeKillSlowMoChargeBonus=0.4
	 
	 ActorPoolClass=Class'UnlimaginMod.UM_ActorPool'
	 BotAtHumanFriendlyFireScale=0.5

     MaxHumanPlayers=12
	 
	 bStartMatchWithShopping=True
	 StartShoppingTime=(Min=120,Max=140)
	 
	 // Monsters
	 Monsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveMinLimits=(4,6,8,8,10,12,12),WaveMaxLimits=(40,60,80,80,100,120,120),WaveSpawnChances=(0.25,0.3,0.35,0.4,0.4,0.45,0.45),WaveSpawnDelays=(24.0,22.0,20.0,18.0,16.0,14.0,12.0))
	 Monsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 Monsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveMinLimits=(2,2,4,6,8,8,8),WaveMaxLimits=(16,18,36,48,54,54,54),WaveSpawnChances=(0.1,0.15,0.2,0.25,0.3,0.35,0.4),WaveSpawnDelays=(28.0,26.0,24.0,22.0,20.0,18.0,16.0))
	 Monsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieFleshPound",WaveMinLimits=(0,0,1,1,1,2,2),WaveMaxLimits=(0,0,4,6,8,12,12),WaveSpawnChances=(0.0,0.0,0.05,0.1,0.15,0.2,0.25),WaveSpawnDelays=(0.0,0.0,360.0,300.0,240.0,180.0,120.0))
	 Monsters(4)=(MonsterClassName="UnlimaginMod.UM_ZombieGoreFast",WaveMinLimits=(6,8,10,12,14,16,18),WaveMaxLimits=(60,80,100,120,140,160,180),WaveSpawnChances=(0.35,0.4,0.45,0.5,0.55,0.6,0.6))
	 Monsters(5)=(MonsterClassName="UnlimaginMod.UM_ZombieHusk",WaveMinLimits=(0,1,1,2,2,3,3),WaveMaxLimits=(2,8,10,),WaveSpawnChances=(0.0,0.1,0.15,0.15,0.2,0.25,0.3),WaveSpawnDelays=(0.0,300.0,240.0,180.0,120.0,90.0,60.0))
	 Monsters(6)=(MonsterClassName="UnlimaginMod.UM_ZombieScrake",WaveLimits=(0,0,2,4,4,6,6),WaveSpawnChances=(0.0,0.0,0.1,0.15,0.2,0.25,0.25),WaveSpawnDelays=(0.0,0.0,300.0,240.0,180.0,120.0,90.0))
	 Monsters(7)=(MonsterClassName="UnlimaginMod.UM_ZombieSiren",WaveLimits=(0,1,2,2,4,4,6),WaveSpawnChances=(0.0,0.15,0.15,0.2,0.2,0.25,0.25),WaveSpawnDelays=(0.0,240.0,210.0,180.0,120.0,90.0,60.0))
	 Monsters(8)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimits=(6,8,10,12,14,16,18),WaveSpawnChances=(0.45,0.45,0.5,0.55,0.55,0.5,0.5))
	 
	 InitialWaveNum=0
	 // GameWaves - 7 waves
	 GameWaves(0)=(NumMonsters=(Min=16,Max=20),MaxMonsters=270,MonstersAtOnce=(Min=16,Max=42),MonsterSquadSize=(Min=2,Max=6),SquadsSpawnPeriod=(Min=2.0,Max=4.0),SquadsSpawnEndTime=15,WaveDifficulty=0.7,WaveDuration=(Min=480,Max=2400),BreakTime=(Min=90,Max=100),StartingCash=(Min=240,Max=280),WaveDelay=10)
	 GameWaves(1)=(NumMonsters=(Min=22,Max=26),MaxMonsters=360,MonstersAtOnce=(Min=18,Max=44),MonsterSquadSize=(Min=4,Max=6),SquadsSpawnPeriod=(Min=2.5,Max=4.5),SquadsSpawnEndTime=15,WaveDifficulty=0.8,WaveDuration=(Min=600,Max=3000),BreakTime=(Min=90,Max=110),StartingCash=(Min=260,Max=300))
	 GameWaves(2)=(NumMonsters=(Min=28,Max=32),MaxMonsters=450,MonstersAtOnce=(Min=20,Max=46),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=2.5,Max=5.0),SquadsSpawnEndTime=15,WaveDifficulty=0.9,WaveDuration=(Min=720,Max=3600),BreakTime=(Min=100,Max=110),StartingCash=(Min=280,Max=320))
	 GameWaves(3)=(NumMonsters=(Min=34,Max=38),MaxMonsters=540,MonstersAtOnce=(Min=22,Max=48),MonsterSquadSize=(Min=4,Max=8),SquadsSpawnPeriod=(Min=3.0,Max=5.5),SquadsSpawnEndTime=20,WaveDifficulty=1.0,WaveDuration=(Min=840,Max=4200),BreakTime=(Min=100,Max=120),StartingCash=(Min=300,Max=340))
	 GameWaves(4)=(NumMonsters=(Min=40,Max=44),MaxMonsters=630,MonstersAtOnce=(Min=24,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.0),SquadsSpawnEndTime=20,WaveDifficulty=1.1,WaveDuration=(Min=960,Max=4800),BreakTime=(Min=110,Max=120),StartingCash=(Min=320,Max=360))
	 GameWaves(5)=(NumMonsters=(Min=46,Max=50),MaxMonsters=720,MonstersAtOnce=(Min=26,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=6.5),SquadsSpawnEndTime=20,WaveDifficulty=1.2,WaveDuration=(Min=1080,Max=5400),BreakTime=(Min=110,Max=130),StartingCash=(Min=340,Max=380))
	 GameWaves(6)=(NumMonsters=(Min=52,Max=56),MaxMonsters=810,MonstersAtOnce=(Min=26,Max=50),MonsterSquadSize=(Min=6,Max=10),SquadsSpawnPeriod=(Min=4.0,Max=7.0),SquadsSpawnEndTime=25,WaveDifficulty=1.3,WaveDuration=(Min=1200,Max=6000),BreakTime=(Min=120,Max=130),StartingCash=(Min=360,Max=400))
	 // Boss
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 // BossMonsters
	 BossMonsters(0)=(MonsterClassName="UnlimaginMod.UM_ZombieBloat",WaveLimit=4,WaveSpawnChance=0.2)
	 BossMonsters(1)=(MonsterClassName="UnlimaginMod.UM_ZombieClot")
	 BossMonsters(2)=(MonsterClassName="UnlimaginMod.UM_ZombieCrawler",WaveLimit=2,WaveSpawnChance=0.2)
	 BossMonsters(3)=(MonsterClassName="UnlimaginMod.UM_ZombieStalker",WaveLimit=4,WaveSpawnChance=0.4)
 
	 ZEDTimeDuration=3.000000
	 ExitZedTime=0.500000
	  
	 MutatorClass="UnlimaginServer.UnlimaginMutator"
	 
	 LoginMenuClassName="UnlimaginMod.UM_SRInvasionLoginMenu"
	 DefaultPlayerClassName="UnlimaginMod.UM_HumanPawn"
	 ScoreBoardType="UnlimaginMod.UM_SRScoreBoard"
	 HUDType="UnlimaginMod.UM_HUD"
	 MapListType="KFMod.KFMapList"
	 
	 PlayerControllerClass=Class'UnlimaginMod.UM_PlayerController'
	 PlayerControllerClassName="UnlimaginMod.UM_PlayerController"
	 DefaultLevelRulesClass=Class'UnlimaginMod.UM_SRGameRules'
	 GameReplicationInfoClass=Class'UnlimaginMod.UM_GameReplicationInfo'
	 
	 GameName="Unlimagin Monster Invasion"
	 Description="The premise is simple: you (and, hopefully, your team) have been flown in to 'cleanse' this area of specimens. The only things moving are specimens. They will launch at you in waves. Kill them. All of them. Any and every way you can. We'll even pay you a bounty for it! Between waves, you should be able to find the merc Trader lurking in some safe spot. She'll trade your bounty for ammo, equipment and Bigger Guns. Trust me - you're going to need them! If you can survive all the waves, you'll have to top the so-called Patriarch to finish the job. Don't worry about finding him - HE will come looking for YOU!"
}