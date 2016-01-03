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
	DependsOn(UM_BaseObject)
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

// GameWaves
struct GameWaveData
{
	var()	config	UM_BaseObject.IRange		AliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
	var()	config	UM_BaseObject.IRandRange	MonsterSquadSize;	// Randomly selected value from Min to Max
	var()	config	UM_BaseObject.FRandRange	SquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty)
	var()	config	int							SquadsSpawnEndTime;	// Time when level will stop to spawn new squads at the end of this wave (in seconds)
	var()	config	float						WaveDifficulty;		// Used for the Bot Difficulty
	var()	config	int							StartDelay;		// This wave start time out in seconds
	var()	config	UM_BaseObject.FRandRange	Duration;		// Wave duration in minutes (all) (Min and RandMin - MinGameDifficulty, Max and RandMax - MaxGameDifficulty)
	var()	config	UM_BaseObject.IRange		BreakTime;			// Shopping time after this wave in seconds
	var()	config	range						DoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
	var()	config	UM_BaseObject.IRange		StartingCash;		// Random starting cash on this wave
	var()	config	UM_BaseObject.IRange		MinRespawnCash;		// Random min respawn cash on this wave
	var()	config	range						DeathCashModifier;	// Death cash penalty on this wave (Min - MinGameDifficulty, Max - MaxGameDifficulty)
};

// Begin Match With Shopping
var		config		bool					bBeginMatchWithShopping;
var					UM_BaseObject.IRange	InitialShoppingTime;

// Normal Wave Data
var					array<GameWaveData>		GameWaves;
var					int						InitialWaveNum;

// Boss Wave Data
var					UM_BaseObject.IRange		BossWaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					UM_BaseObject.IRandRange	BossWaveMonsterSquadSize;	// Randomly selected value from Min to Max
var					UM_BaseObject.FRandRange	BossWaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty)
var					float						BossWaveDifficulty;		// Used for the Bot Difficulty
var					int							BossWaveStartDelay;		// This wave start time out in seconds
var					range						BossWaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)

// Monsters
var	export	array<UM_InvasionMonsterData>	Monsters;
// BossMonsterClass
var()				string					BossMonsterClassName;
var()				class<UM_Monster>		BossMonsterClass;


var					Class<UM_ActorPool>		ActorPoolClass;

var		transient	int						NextWaveNum;

var					ShopVolume				CurrentShop;
var					float					ShopListUpdateDelay;
var		transient	float					NextShopListUpdateTime;

// Dynamic Parameters	
var					int						MaxAliveMonsters;
var					float					MinSquadSpawnCheckDelay;
var		transient	int						CurrentMonsterSquadSize;
var		transient	float					CurrentMonsterSquadRandSize;
var		transient	float					CurrentSquadsSpawnPeriod,  CurrentSquadsSpawnRandPeriod;
var		transient	float					NextMonsterSquadSpawnTime;
var		transient	int						NextMonsterSquadSize;
var		transient	int						CurrentWaveDuration, WaveElapsedTime;
var		transient	float					CurrentDoorsRepairChance;

// ZedSpawnListUpdate
var					float					ZedSpawnListUpdateDelay;
var		transient	float					NextZedSpawnListUpdateTime;

// JammedMonstersCheck
var		transient	float					NextJammedMonstersCheckTime;
var					float					JammedMonstersCheckDelay;

// SpawningVolumeUpdate
var					float					SpawningVolumeUpdateDelay;
var		transient	float					NextSpawningVolumeUpdateTime;

// Lerp Modifiers
var					float					LerpNumPlayersModifier;
var					float					LerpGameDifficultyModifier;

// Spawned monster list
var		transient	array<UM_Monster>		MonsterList;

var					float					ZEDTimeKillSlowMoChargeBonus;

var		transient	string					CurrentMapName;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//ToDo: Issue #304
protected function bool LoadGamePreset( optional string NewPresetName )
{
	local	UM_BaseInvasionPreset	InvasionPreset;	
	local	int						i;
	
	if ( !Super.LoadGamePreset( NewPresetName ) )
		Return False;
	
	InvasionPreset = UM_BaseInvasionPreset(GamePreset);
	if ( InvasionPreset == None )
		Return False;	// Preset wasn't found
	
	// InitialShoppingTime
	InitialShoppingTime = InvasionPreset.InitialShoppingTime;
	
	// GameWaves
	InitialWave = InvasionPreset.InitialWaveNum;
	FinalWave = InvasionPreset.GameWaves.Length;
	GameWaves.Length = InvasionPreset.GameWaves.Length;
	for ( i = 0; i < InvasionPreset.GameWaves.Length; ++i )
		GameWaves[i] = InvasionPreset.GameWaves[i];
	
	// Monsters
	Monsters.Length = InvasionPreset.Monsters.Length;
	for ( i = 0; i < InvasionPreset.Monsters.Length; ++i )
		Monsters[i] = InvasionPreset.Monsters[i];
	
	Return True;
}

function UpdateShopList()
{
	local	ShopVolume	SH;
	
	if ( Level.TimeSeconds < NextShopListUpdateTime )
		Return;
	
	NextShopListUpdateTime = Level.TimeSeconds + ShopListUpdateDelay;
	ShopList.Length = 0;
	// New ShopList
	foreach AllActors( class'ShopVolume', SH )  {
		if ( SH != None && !SH.bAlwaysClosed )
			ShopList[ShopList.Length] = SH;
	}
}

function UpdateZedSpawnList()
{
	local	ZombieVolume	ZV;
	
	if ( Level.TimeSeconds < NextZedSpawnListUpdateTime )
		Return;
	
	NextZedSpawnListUpdateTime = Level.TimeSeconds + ZedSpawnListUpdateDelay;
	ZedSpawnList.Length = 0;
	// New ZedSpawnList
	foreach DynamicActors( class'ZombieVolume', ZV )  {
		if ( ZV != None && ZV.bVolumeIsEnabled && Level.TimeSeconds >= ZV.LastCheckTime )
			ZedSpawnList[ZedSpawnList.Length] = ZV;
	}
}

function UpdateGameLength()
{
	local Controller C;

	for ( C = Level.ControllerList; C != None; C = C.NextController )  {
		if ( PlayerController(C) != None && PlayerController(C).SteamStatsAndAchievements != None )
			PlayerController(C).SteamStatsAndAchievements.bUsedCheats = PlayerController(C).SteamStatsAndAchievements.bUsedCheats || bCustomGameLength;
	}
}

function LoadUpMonsterList() 
{
	local	int		i;
	
	for ( i = 0; i < Monsters.Length; ++i )  {
		// Check out and init monsters data objects
		if ( Monsters[i] == None || !Monsters[i].InitDataFor(Self) )  {
			Monsters.Remove(i, 1);
			--i;
		}
	}
}

// Random starting cash for the each wave. Must be called before the new wave has begun.
function UpdateStartingCash()
{
	if ( WaveNum < FinalWave )  {
		StartingCash = Round( Lerp(FRand(), float(GameWaves[WaveNum].StartingCash.Min), float(GameWaves[WaveNum].StartingCash.Max)) );
		MinRespawnCash = Round( Lerp(FRand(), float(GameWaves[WaveNum].MinRespawnCash.Min), float(GameWaves[WaveNum].MinRespawnCash.Max)) );
		DeathCashModifier = GameWaves[WaveNum].DeathCashModifier;
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
	local	string			InOpt;

	// LoadGamePreset() call in the parent class
	Super.InitGame(Options, Error);
	
	UpdateShopList();
	UpdateZedSpawnList();

	InOpt = ParseOption(Options, "UseBots");
	if ( InOpt != "" )
		bNoBots = bool(InOpt);

	log("Game length = "$KFGameLength);
	
	// #SetupWaveNumbers
	InitialWave = InitialWaveNum;
	FinalWave = GameWaves.Length;
	WaveNum = InitialWave;
	NextWaveNum = InitialWave;
	UpdateStartingCash();

	bCustomGameLength = True;	// We can't use Steam Stats with Unlimagin Mod
	UpdateGameLength();
	LoadUpMonsterList();

	//Spawning ActorPool
	if ( ActorPoolClass != None && Class'UM_GlobalData'.default.ActorPool == None )  {
		log("-------- Creating ActorPool --------",Class.Outer.Name);
		Spawn(ActorPoolClass);
	}
}

simulated function PrepareSpecialSquadsFromCollection() { }
simulated function PrepareSpecialSquads() { }

//[block] Monster Spawn List


//[end]

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
	local	byte	CurrentNumPlayers;
	
	CurrentNumPlayers = Min( (NumPlayers + NumBots), MaxHumanPlayers );
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


function UpdateDynamicParameters()
{
	local	int		i;
	local	float	MidModif;
	
	MidModif = (LerpNumPlayersModifier + LerpGameDifficultyModifier) * 0.5;
	
	// Normal Wave
	if ( WaveNum < FinalWave )  {
		// MaxAliveMonsters
		MaxAliveMonsters = Round( Lerp(FMin((LerpNumPlayersModifier + LerpGameDifficultyModifier), 1.0), float(GameWaves[WaveNum].AliveMonsters.Min), float(GameWaves[WaveNum].AliveMonsters.Max)) );
		// CurrentMonsterSquadSize
		CurrentMonsterSquadSize = Round( Lerp(MidModif, float(GameWaves[WaveNum].MonsterSquadSize.Min), float(GameWaves[WaveNum].MonsterSquadSize.Max)) );
		CurrentMonsterSquadRandSize = Lerp( MidModif, float(GameWaves[WaveNum].MonsterSquadSize.RandMin), float(GameWaves[WaveNum].MonsterSquadSize.RandMax) );
		// CurrentSquadsSpawnPeriod
		CurrentSquadsSpawnPeriod = Lerp( MidModif, GameWaves[WaveNum].SquadsSpawnPeriod.Min, GameWaves[WaveNum].SquadsSpawnPeriod.Max );
		CurrentSquadsSpawnRandPeriod = Lerp( MidModif, GameWaves[WaveNum].SquadsSpawnPeriod.RandMin, GameWaves[WaveNum].SquadsSpawnPeriod.RandMax );
		// AdjustedDifficulty
		AdjustedDifficulty = GameDifficulty * GameWaves[WaveNum].WaveDifficulty;
		// CurrentWaveDuration
		CurrentWaveDuration = Round( Lerp(LerpGameDifficultyModifier, GameWaves[WaveNum].Duration.Min, GameWaves[WaveNum].Duration.Max) * 60.0 + Lerp(LerpGameDifficultyModifier, GameWaves[WaveNum].Duration.RandMin, GameWaves[WaveNum].Duration.RandMax) * (120.0 * FRand() - 60.0) );
		// CurrentDoorsRepairChance
		CurrentDoorsRepairChance = Lerp( LerpGameDifficultyModifier, GameWaves[WaveNum].DoorsRepairChance.Min, GameWaves[WaveNum].DoorsRepairChance.Max );
	}
	// BossWave
	else  {
		// MaxAliveMonsters
		MaxAliveMonsters = Round( Lerp(FMin((LerpNumPlayersModifier + LerpGameDifficultyModifier), 1.0), float(BossWaveAliveMonsters.Min), float(BossWaveAliveMonsters.Max)) );
		// CurrentMonsterSquadSize
		CurrentMonsterSquadSize = Round( Lerp(MidModif, float(BossWaveMonsterSquadSize.Min), float(BossWaveMonsterSquadSize.Max)) );
		CurrentMonsterSquadRandSize = Lerp( MidModif, float(BossWaveMonsterSquadSize.RandMin), float(BossWaveMonsterSquadSize.RandMax) );
		// CurrentSquadsSpawnPeriod
		CurrentSquadsSpawnPeriod = Lerp( MidModif, BossWaveSquadsSpawnPeriod.Min, BossWaveSquadsSpawnPeriod.Max );
		CurrentSquadsSpawnRandPeriod = Lerp( MidModif, BossWaveSquadsSpawnPeriod.RandMin, BossWaveSquadsSpawnPeriod.RandMax );
		// AdjustedDifficulty
		AdjustedDifficulty = GameDifficulty * BossWaveDifficulty;
		// CurrentDoorsRepairChance
		CurrentDoorsRepairChance = Lerp( LerpGameDifficultyModifier, BossWaveDoorsRepairChance.Min, BossWaveDoorsRepairChance.DoorsRepairChance.Max );
	}
	
	// NextMonsterSquadSize
	NextMonsterSquadSize = CurrentMonsterSquadSize + Round( Lerp(FRand(), -CurrentMonsterSquadRandSize, CurrentMonsterSquadRandSize) );
	
	// Monster DynamicParameters
	for ( i = 0; i < Monsters.Length; ++i )
		Monsters[i].UpdateDynamicParameters();
}

function NotifyGameDifficultyChanged()
{
	// Modifier for the Lerp function (0.0 - 1.0)
	LerpGameDifficultyModifier = (GameDifficulty - MinGameDifficulty) / (MaxGameDifficulty - MinGameDifficulty);
	UpdateDynamicParameters();
}

function NotifyNumPlayersChanged()
{
	// Modifier for the Lerp function (0.0 - 1.0)
	LerpNumPlayersModifier = float(NumActivePlayers + NumBots - MinHumanPlayers) / float(MaxHumanPlayers - MinHumanPlayers);
	UpdateDynamicParameters();
}

//[block] MonsterList functions
function CheckMonsterList()
{
	local	int		i;
	
	for ( i = 0; i < MonsterList.Length; ++i )  {
		if ( MonsterList[i] == None || MonsterList[i].bDeleteMe || MonsterList[i].Health < 1 )  {
			MonsterList.Remove(i, 1);
			--i;
		}
	}
	NumMonsters = MonsterList.Length;
}

// Called from the UM_Monster in PostBeginPlay() function
function bool AddToMonsterList( UM_Monster M )
{
	if ( M == None )
		Return False;
	
	MonsterList[MonsterList.Length] = M;
	Return True;
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
state StartingMatch
{
	function BeginMatch()
	{
		if ( bBeginMatchWithShopping )  {
			SetupPickups();
			GoToState('Shopping');
		}
		else
			GoToState('BeginNewWave');
	}
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
	
	// Find already spawned weapon
	for ( i = 0; i < WeaponPickups.Length; ++i )  {
		if ( WeaponPickups[i] == None )  {
			WeaponPickups.Remove(i, 1);
			--i;
		}
		else if ( WeaponPickups[i].bIsEnabledNow )
			++j;
	}
	i = Min( Round(float(WeaponPickups.Length) * 0.5 / GetDifficultyModifier()), (WeaponPickups.Length - 1) ) - j;
	// Ramdomly select which WeaponPickups to spawn
	j = 0;
	while ( i > 0 && j < 10000 )  {
		++j; // Prevents runaway loop
		r = Rand( WeaponPickups.Length );
		// Enable if it wasn't enabled
		if ( !WeaponPickups[r].bIsEnabledNow )  {
			WeaponPickups[r].EnableMe();
			--i;
		}
	}
	
	// Find already spawned ammo
	for ( i = 0; i < AmmoPickups.Length; ++i )  {
		if ( AmmoPickups[i] == None )  {
			AmmoPickups.Remove(i, 1);
			--i;
		}
		else if ( !AmmoPickups[i].bSleeping )
			++j;
	}
	i = Min( Round(float(AmmoPickups.Length) * 0.6 / GetDifficultyModifier()), (AmmoPickups.Length - 1) ) - j;
	// Ramdomly select which AmmoPickups to spawn
	j = 0;
	while ( i > 0 && j < 10000 )  {
		++j; // Prevents runaway loop
		r = Rand( AmmoPickups.Length );
		if ( AmmoPickups[r].bSleeping )  {
			AmmoPickups[r].GoToState('Pickup');
			--i;
		}
	}
}

function RepairDoors()
{
	local	KFDoorMover		DoorMover;
	
	if ( CurrentDoorsRepairChance <= 0.0 )
		Return;
		
	foreach DynamicActors( class'KFDoorMover', DoorMover )  {
		if ( DoorMover != None && FRand() <= CurrentDoorsRepairChance )
			DoorMover.RespawnDoor();
	}
}

// Overal game ElapsedTime
function IncreaseElapsedTime()
{
	++ElapsedTime;
	if ( GameReplicationInfo != None )
		GameReplicationInfo.ElapsedTime = ElapsedTime;
}

function DecreaseWaveCountDown()
{
	WaveCountDown = Max( (WaveCountDown - 1), 0 );
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
			WaveCountDown = GameWaves[WaveNum].StartDelay + Min( Round(TimerCounter), 1 );
			// AdjustedDifficulty
			AdjustedDifficulty = GameDifficulty * GameWaves[WaveNum].WaveDifficulty;
		}
		else  {
			WaveCountDown = BossWaveStartDelay + Min( Round(TimerCounter), 1 );
			// AdjustedDifficulty
			AdjustedDifficulty = GameDifficulty * BossWaveDifficulty;
		}
		// GameReplicationInfo
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
			KFGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		}
		// Check CurrentShop
		if ( CurrentShop == None )
			SelectNewShop();
		
		UpdateDynamicParameters();
		UpdateStartingCash();
		NotifyNewWave();
		SetupPickups();
		RepairDoors();
	}
	
	event Timer()
	{
		Global.Timer();
		// Overal game ElapsedTime
		IncreaseElapsedTime();
		DecreaseWaveCountDown();
		if ( WaveCountDown > 0 )
			Return;
		
		if ( WaveNum < FinalWave )
			GoToState('WaveInProgress');
		else if ( bUseEndGameBoss )
			GoToState('BossWaveInProgress');
		else
			EndGame(None,"TimeLimit");
	}
	
	event EndState()
	{
		bNotifiedLastManStanding = False; // Used in CheckMaxLives() function
	}
}
//[end] BeginNewWave code

function StartGameMusic( bool bCombat )
{
	local	byte	i;
	local	string	S;

	if ( MapSongHandler == None )
		Return;
	
	if ( bCombat )  {
		if ( MapSongHandler.WaveBasedSongs.Length <= WaveNum || MapSongHandler.WaveBasedSongs[WaveNum].CombatSong == "" )
			S = MapSongHandler.CombatSong;
		else
			S = MapSongHandler.WaveBasedSongs[WaveNum].CombatSong;
		MusicPlaying = True;
		CalmMusicPlaying = False;
	}
	else  {
		if ( MapSongHandler.WaveBasedSongs.Length <= WaveNum || MapSongHandler.WaveBasedSongs[WaveNum].CalmSong == "" )
			S = MapSongHandler.Song;
		else
			S = MapSongHandler.WaveBasedSongs[WaveNum].CalmSong;
		MusicPlaying = False;
		CalmMusicPlaying = True;
	}
	
	// PlayerList
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )
		PlayerList[i].NetPlayMusic(S, MapSongHandler.FadeInTime,MapSongHandler.FadeOutTime);

	// SpectatorList
	CheckSpectatorList();
	for ( i = 0; i < SpectatorList.Length; ++i )
		SpectatorList[i].NetPlayMusic(S, MapSongHandler.FadeInTime,MapSongHandler.FadeOutTime);
}

function StopGameMusic()
{
	local	byte	i;
	local	float	SongFadeOutTime;

	if ( MapSongHandler != None )
		SongFadeOutTime = MapSongHandler.FadeOutTime;
	else
		SongFadeOutTime = 1.0;

	// PlayerList
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )
		PlayerList[i].NetStopMusic( SongFadeOutTime );
	
	// SpectatorList
	CheckSpectatorList();
	for ( i = 0; i < SpectatorList.Length; ++i )
		SpectatorList[i].NetStopMusic( SongFadeOutTime );
	
	MusicPlaying = False;
	CalmMusicPlaying = False;
}

//[block] Shopping code
state Shopping
{
	// Open Shops
	event BeginState()
	{
		local	int			i;
		local	Controller	C;
		
		// Allow to spawn Players
		bAllowPlayerSpawn = True;
		
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
			if ( C.bIsPlayer && C.Pawn != None )  {
				// Disable pawn collision during trader time
				C.Pawn.bBlockActors = False;
				// Trader Hints
				if ( KFPlayerController(C) != None && C.Pawn.Health > 0 )  {
					KFPlayerController(C).SetShowPathToTrader(True);
					// Have Trader tell players that the Shop's Open
					if ( NextWaveNum < FinalWave )
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, None, 'TRADER', 2);
					// Boss Wave Next
					else
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, none, 'TRADER', 3);
					//Hint_1
					KFPlayerController(C).CheckForHint(31);
				}
			}
		}
		
		// Next Hints time
		if ( bShowHint_2 || bShowHint_3 )  {
			HintTime_1 = Level.TimeSeconds + 11.0;
			HintTime_2 = HintTime_1 + 11.0;
		}
		
		// Break Time
		if ( NextWaveNum > InitialWave )
			WaveCountDown = Round( Lerp(FRand(), float(GameWaves[WaveNum].BreakTime.Min), float(GameWaves[WaveNum].BreakTime.Max)) + FMin(TimerCounter, 1.0) );
		// Begin Match With Shopping
		else
			WaveCountDown = Round( Lerp(FRand(), float(InitialShoppingTime.Min), float(InitialShoppingTime.Max)) + FMin(TimerCounter, 1.0) );
		
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		
		bTradingDoorsOpen = True;
	}
	
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
	
	function PlaySecondHint()
	{
		local	Controller	C;
		local	int			i;
		
		bShowHint_2 = False; // Turn off this hint
		
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
		
		bShowHint_3 = False; // Turn off this hint
		
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
		if ( !bTradingDoorsOpen )
			Return;
		
		// Overal game ElapsedTime
		IncreaseElapsedTime();
		DecreaseWaveCountDown();
		// Out from the Shopping state
		if ( WaveCountDown < 1 )  {
			// Teleport players from the shops
			if ( !BootShopPlayers() )
				GoToState('BeginNewWave');
			// Exit from this Timer
			Return;
		}
		
		// Respawn died or just joined players
		if ( bAllowPlayerSpawn )
			RespawnWaitingPlayers();
		
		if ( bShowHint_2 && Level.TimeSeconds > HintTime_1 )
			PlaySecondHint();
		else if ( bShowHint_3 && Level.TimeSeconds > HintTime_2 )
			PlayThirdHint();
		
		if ( WaveCountDown < 5 )  {
			// Broadcast Localized Message about next wave
			if ( NextWaveNum < FinalWave )
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 1);
			else if ( bUseEndGameBoss )
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 3);
		}
		// Have Trader tell players that they've got 10 seconds
		else if ( WaveCountDown == 10 )
			PlayTenSecondsLeftMessage();
		// Have Trader tell players that they've got 30 seconds
		else if ( WaveCountDown == 30 )
			PlayThirtySecondsLeftMessage();
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
				--i;
				Continue;
			}
			
			if ( ShopList[i].bCurrentlyOpen )
				ShopList[i].CloseShop();
		}
		
		// Tell all players to stop showing the path to the trader
		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;	// To prevent runaway loop
			// Find the Pawn of this controller
			if ( C.bIsPlayer && C.Pawn != None )  {
				// Enable pawn collision
				C.Pawn.bBlockActors = C.Pawn.default.bBlockActors;
				// Trader Hints
				if ( KFPlayerController(C) != None && C.Pawn.Health > 0 )  {
					KFPlayerController(C).SetShowPathToTrader(False);
					KFPlayerController(C).ClientForceCollectGarbage();
					// Have Trader tell players that the Shop's Closed
					if ( WaveNum < FinalWave )
						KFPlayerController(C).ClientLocationalVoiceMessage(C.PlayerReplicationInfo, None, 'TRADER', 2);
				}
			}
		}
		
		CheckForPlayersDeficit();
		// Disallow to spawn Players
		bAllowPlayerSpawn = False;
		SelectNewShop();
	}
}
//[end] Shopping

//[block] WaveInProgress Code
function CheckSelectedVeterancy( KFPlayerController PC )
{
	if ( PC == None || KFPlayerReplicationInfo(PC.PlayerReplicationInfo) == None )
		Return;
	
	PC.bChangedVeterancyThisWave = False;
	if ( PC.SelectedVeterancy != KFPlayerReplicationInfo(PC.PlayerReplicationInfo).ClientVeteranSkill )
		PC.SendSelectedVeterancyToServer();
}

// Returns reference to the random player or bot controller
function Controller GetRandomPlayerController()
{
	local	array<Controller>	AlivePlayers;
	local	byte				i;
	
	// PlayerList
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
			AlivePlayers[ AlivePlayers.Length ] = PlayerList[i];
	}
	// BotList
	for ( i = 0; i < BotList.Length; ++i )  {
		if ( BotList[i].Pawn != None && BotList[i].Pawn.Health > 0 )
			AlivePlayers[ AlivePlayers.Length ] = BotList[i];
	}
	
	if ( AlivePlayers.Length < 1 )
		Return None; // No one alived. They're all dead!
	
	Return AlivePlayers[ Rand(AlivePlayers.Length) ];
}

function ZombieVolume FindSpawningVolume( optional bool bIgnoreFailedSpawnTime, optional bool bBossSpawning )
{
	local	ZombieVolume		BestZ;
	local	float				BestScore, tScore;
	local	int					i;
	local	Controller			C;
	
	C = GetRandomPlayerController();
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
	local	int		c, i;
	
	// Reset monster squad counters
	NextSpawnSquad.Length = 0;
	for ( i = 0; i < Monster.Length; ++i )
		Monster[i].NumInCurrentSquad = 0;

	// Building squad monster list
	while ( NextSpawnSquad.Length < NextMonsterSquadSize && c < 250 )  {
		++c;
		i = Rand(Monsters.Length);
		if ( Monsters[i].CanSpawn() )  {
			// Increment spawn counters
			++Monster[i].NumSpawnedThisWave;
			++Monster[i].NumInCurrentSquad;
			++Monster[i].DeltaCounter;
			// Add to the monster list
			NextSpawnSquad[NextSpawnSquad.Length] = Monster[i].MonsterClass;
		}
	}
	
	// NextMonsterSquadSize
	NextMonsterSquadSize = CurrentMonsterSquadSize + Round( Lerp(FRand(), -CurrentMonsterSquadRandSize, CurrentMonsterSquadRandSize) );
}

function SpawnNextMonsterSquad()
{
	local	int		NumSpawned;

	// NewSpawningVolume
	if ( LastSpawningVolume == None || Level.TimeSeconds >= NextSpawningVolumeUpdateTime )  {
		NextSpawningVolumeUpdateTime = Level.TimeSeconds + SpawningVolumeUpdateDelay;
		LastSpawningVolume = FindSpawningVolume();
		// Check for FindSpawningVolume Error
		if ( LastSpawningVolume == None )
			Return;
	}
	
	if ( LastSpawningVolume.SpawnInHere( NextSpawnSquad,, NumSpawned, MaxMonsters, (MaxAliveMonsters - NumMonsters) ) )  {
		MaxMonsters = default.MaxMonsters;
		WaveMonsters += NumSpawned;
		NextSpawnSquad.Length = 0;
	}
	// Spawn has failed
	else  {
		NextMonsterSquadSpawnTime = Level.TimeSeconds + 1.0;
		NextSpawningVolumeUpdateTime = Level.TimeSeconds + SpawningVolumeUpdateDelay;
		LastSpawningVolume = FindSpawningVolume();
	}
}

function CheckForJammedMonsters()
{
	local	int		i;
	
	NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
	
	CheckMonsterList();
	// Search for Jammed Monsters
	for ( i = 0; i < MonsterList.Length; ++i )  {
		if ( UM_MonsterController(MonsterList[i].Controller) != None && UM_MonsterController(MonsterList[i].Controller).CanKillMeYet() )  {
			NextSpawnSquad[NextSpawnSquad.Length] = Class<KFMonster>(MonsterList[i].Class);
			MonsterList[i].Suicide();
			MonsterList.Remove(i, 1);
			--WaveMonster;
			--i;
		}
	}
	// Respawn Jammed Monsters
	SpawnNextMonsterSquad();
}

function DoWaveEnd()
{
	local	Controller			C;
	local	PlayerController	Survivor;
	local	int					i, SurvivorCount;
	
	if ( !rewardFlag )
		RewardSurvivingPlayers();
	
	WaveElapsedTime = 0;
	// Clear Trader Message status
	bDidTraderMovingMessage = False;
	bDidMoveTowardTraderMessage = False;

	bWaveInProgress = False;
	bWaveBossInProgress = False;
	if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
		KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = False;
		//KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = False;
	}
	
	// Reset monster spawn counters
	for ( i = 0; i < Monster.Length; ++i )  {
		Monster[i].NumSpawnedThisWave = 0;
		Monster[i].DeltaCounter = 0;
		Monster[i].NumInCurrentSquad = 0;
	}
	
	// ControllerList
	for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
		++i;	// To prevent runaway loop
		if ( C.PlayerReplicationInfo == None )
			Continue; // skip this controller
		
		// Reset Lives Limit
		C.PlayerReplicationInfo.bOutOfLives = False;
		C.PlayerReplicationInfo.NumLives = 0;
	
		if ( KFPlayerController(C) != None )  {
			CheckSelectedVeterancy( KFPlayerController(C) );
			if ( PlayerController(C).SteamStatsAndAchievements != None && KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements) != None )
				KFSteamStatsAndAchievements(PlayerController(C).SteamStatsAndAchievements).WaveEnded();

			// Don't broadcast this message AFTER the final wave!
			if ( NextWaveNum < FinalWave )
				BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 2);
		}
		
		// Survivor
		if ( C.Pawn != None && C.Pawn.Health > 0 && PlayerController(C) != None )  {
			Survivor = PlayerController(C);
			++SurvivorCount;
		}
	}
	
	if ( Level.NetMode != NM_StandAlone && NumPlayers > 1 && SurvivorCount == 1 
		 && Survivor != None && KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements) != None )
		KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements).AddOnlySurvivorOfWave();

	bUpdateViewTargs = True;
}

function bool CheckForAlivePlayers()
{
	local	byte	i, AliveCount;
	
	// PlayerList
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
			++AliveCount;
	}
	
	// BotList
	CheckBotList();
	for ( i = 0; i < BotList.Length; ++i )  {
		if ( BotList[i].Pawn != None && BotList[i].Pawn.Health > 0 )
			++AliveCount;
	}
	
	Return AliveCount > 0;
}

state WaveInProgress
{
	event BeginState()
	{
		NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
		// Reset wave parameters
		rewardFlag = False;
		ZombiesKilled = 0;
		WaveMonsters = 0;
		// Reset monster spawn counters
		for ( i = 0; i < Monster.Length; ++i )  {
			Monster[i].NumSpawnedThisWave = 0;
			Monster[i].DeltaCounter = 0;
			Monster[i].NumInCurrentSquad = 0;
		}
		
		// Setup wave parameters
		WaveCountDown = CurrentWaveDuration + Min( Round(TimerCounter), 1 );
		// First Startup Message
		if ( !bFinalStartup )  {
			bFinalStartup = True;
			PlayStartupMessage();
		}
		// GameMusic
		if ( !MusicPlaying )
			StartGameMusic(True);
		// Begin wave
		bWaveInProgress = True;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
			KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = MaxMonsters;
			//KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = True;
			KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = True;
			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		}
	}
	
	function UpdateDynamicParameters()
	{
		Global.UpdateDynamicParameters();
		WaveCountDown = Max( (CurrentWaveDuration - WaveElapsedTime), 0 );
	}
	
	function bool CanSpawnNextMonsterSquad()
	{
		if ( Level.TimeSeconds < NextMonsterSquadSpawnTime )
			Return False;
		
		CheckMonsterList(); // update monster count (NumMonsters)
		// Add next squad spawn check delay. Prevents from checks at every tick.
		if ( (MaxAliveMonsters - NumMonsters) < NextMonsterSquadSize )  {
			NextMonsterSquadSpawnTime = Level.TimeSeconds + MinSquadSpawnCheckDelay;
			Return False;
		}
		
		Return True;
	}
	
	function SpawnNextMonsterSquad()
	{
		if ( NextSpawnSquad.Length < 1 )  {
			// NextSpawnTime
			NextMonsterSquadSpawnTime = Level.TimeSeconds + CurrentSquadsSpawnPeriod + Lerp( FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod );
			// NewMonsterSquad
			BuildNextSquad();
		}
		Global.SpawnNextMonsterSquad();
	}
	
	event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		// Check spawn end time
		if ( WaveCountDown <= GameWaves[WaveNum].SquadsSpawnEndTime )
			Return;
		
		// Respawn Jammed Monsters First
		if ( Level.TimeSeconds >= NextJammedMonstersCheckTime )
			CheckForJammedMonsters();
		// Spawn New Monster Squad
		if ( CanSpawnNextMonsterSquad() )
			SpawnNextMonsterSquad();
	}
	
	event Timer()
	{
		Global.Timer();
		// EndGame if no one alive.
		if ( !CheckForAlivePlayers() )  {
			EndGame(None, "LastMan");
			Return;
		}
		// Overal game ElapsedTime
		IncreaseElapsedTime();
		++WaveElapsedTime;
		DecreaseWaveCountDown();
		// End Wave
		if ( WaveCountDown < 1 )  {
			DoWaveEnd();
			if ( NextWaveNum < FinalWave || bUseEndGameBoss )
				GoToState('Shopping');
			else
				EndGame(None, "TimeLimit");
		}
	}
}
//[end] WaveInProgress Code


//[block] BossWaveInProgress Code
state BossWaveInProgress
{
	event BeginState()
	{
		NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
		// Reset wave parameters
		rewardFlag = False;
		ZombiesKilled = 0;
		WaveMonsters = 0;
		
		WaveCountDown = Round( CurrentSquadsSpawnPeriod + Lerp(FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod) );
		
		bWaveBossInProgress = True;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = True;
	}
	
	function BuildNextSquad()
	{
		//ToDo: ��������!!!
	}
	
	function bool CanSpawnNextMonsterSquad()
	{
		if ( WaveCountDown > 0 )
			Return False;
		
		CheckMonsterList(); // update monster count (NumMonsters)
		Return (MaxAliveMonsters - NumMonsters) >= NextMonsterSquadSize;
	}
	
	function SpawnNextMonsterSquad()
	{
		if ( NextSpawnSquad.Length < 1 )  {
			// NextSpawnTime
			WaveCountDown = Round( CurrentSquadsSpawnPeriod + Lerp(FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod) );
			// NewMonsterSquad
			BuildNextSquad();
		}
		Global.SpawnNextMonsterSquad();
	}
	
	event Timer()
	{
		Global.Timer();
		// EndGame if no one alive.
		if ( !CheckForAlivePlayers() )  {
			EndGame(None, "LastMan");
			Return;
		}
		// Overal game ElapsedTime
		IncreaseElapsedTime();
		++WaveElapsedTime;
		DecreaseWaveCountDown();
		// Respawn Jammed Monsters First
		if ( Level.TimeSeconds >= NextJammedMonstersCheckTime )
			CheckForJammedMonsters();
		// Spawn New Monster Squad
		if ( CanSpawnNextMonsterSquad() )
			SpawnNextMonsterSquad();
	}
}
//[end] BossWaveInProgress code

function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType )
{
	if ( MonsterController(Killed) != None || Monster(KilledPawn) != None )  {
		--NumMonsters;
		++ZombiesKilled;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = NumMonsters;
			//KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = Max( (MaxMonsters + NumMonsters) , 0 );
		
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
	 bShowHint_2=True
	 bShowHint_3=True
	 
	 bUseEndGameBoss=True
	 bRespawnOnBoss=True
	 
	 bSaveSpectatorScores=True
	 
	 //[block] Set Modifiers to default values here
	 LerpNumPlayersModifier=1.0
	 LerpGameDifficultyModifier=1.0
	 //[end]
	 MinSquadSpawnCheckDelay=0.1
	 MaxMonsters=1000
	 MaxAliveMonsters=40
	 JammedMonstersCheckDelay=20.0
	 ShopListUpdateDelay=1.0
	 ZedSpawnListUpdateDelay=5.0
	 SpawningVolumeUpdateDelay=10.0
	 GamePresetClassName="UnlimaginMod.UM_DefaultInvasionPreset"
	 
	 ZEDTimeKillSlowMoChargeBonus=0.4
	 
	 ActorPoolClass=Class'UnlimaginMod.UM_ActorPool'
	 BotAtHumanFriendlyFireScale=0.5

	 MinHumanPlayers=1
	 MaxHumanPlayers=12
	 
	 bBeginMatchWithShopping=True
	 InitialShoppingTime=(Min=120,Max=140)
	 
	 InitialWaveNum=0
	 // GameWaves - 7 waves
	 GameWaves(0)=(AliveMonsters=(Min=12,Max=46),MonsterSquadSize=(Min=4,RandMin=2,Max=12,RandMax=6),SquadsSpawnPeriod=(Min=5.0,RandMin=1.0,Max=4.0,RandMax=1.5),SquadsSpawnEndTime=20,WaveDifficulty=0.7,StartDelay=10,Duration=(Min=3.0,RandMin=0.4,Max=8.0,RandMax=0.8),BreakTime=(Min=90,Max=100),DoorsRepairChance=(Min=1.0,Max=0.6),StartingCash=(Min=240,Max=280),MinRespawnCash=(Min=200,Max=220),DeathCashModifier=(Min=0.98,Max=0.86))
	 GameWaves(1)=(AliveMonsters=(Min=14,Max=48),MonsterSquadSize=(Min=4,RandMin=2,Max=14,RandMax=7),SquadsSpawnPeriod=(Min=4.5,RandMin=1.0,Max=3.5,RandMax=1.5),SquadsSpawnEndTime=20,WaveDifficulty=0.8,StartDelay=8,Duration=(Min=3.5,RandMin=0.5,Max=9.0,RandMax=1.0),BreakTime=(Min=90,Max=110),DoorsRepairChance=(Min=1.0,Max=0.55),StartingCash=(Min=260,Max=300),MinRespawnCash=(Min=220,Max=240),DeathCashModifier=(Min=0.97,Max=0.85))
	 GameWaves(2)=(AliveMonsters=(Min=16,Max=48),MonsterSquadSize=(Min=5,RandMin=2,Max=14,RandMax=8),SquadsSpawnPeriod=(Min=4.0,RandMin=1.0,Max=3.5,RandMax=1.5),SquadsSpawnEndTime=19,WaveDifficulty=0.9,StartDelay=8,Duration=(Min=4.0,RandMin=0.6,Max=10.0,RandMax=1.2),BreakTime=(Min=100,Max=110),DoorsRepairChance=(Min=1.0,Max=0.5),StartingCash=(Min=280,Max=320),MinRespawnCash=(Min=240,Max=260),DeathCashModifier=(Min=0.96,Max=0.84))
	 GameWaves(3)=(AliveMonsters=(Min=18,Max=50),MonsterSquadSize=(Min=5,RandMin=3,Max=16,RandMax=8),SquadsSpawnPeriod=(Min=3.5,RandMin=1.0,Max=3.0,RandMax=1.5),SquadsSpawnEndTime=18,WaveDifficulty=1.0,StartDelay=8,Duration=(Min=4.5,RandMin=0.7,Max=11.0,RandMax=1.4),BreakTime=(Min=100,Max=120),DoorsRepairChance=(Min=1.0,Max=0.45),StartingCash=(Min=300,Max=340),MinRespawnCash=(Min=260,Max=280),DeathCashModifier=(Min=0.95,Max=0.83))
	 GameWaves(4)=(AliveMonsters=(Min=20,Max=50),MonsterSquadSize=(Min=6,RandMin=3,Max=16,RandMax=10),SquadsSpawnPeriod=(Min=3.5,RandMin=1.0,Max=3.0,RandMax=1.5),SquadsSpawnEndTime=17,WaveDifficulty=1.1,StartDelay=6,Duration=(Min=5.0,RandMin=0.8,Max=12.0,RandMax=1.6),BreakTime=(Min=110,Max=120),DoorsRepairChance=(Min=1.0,Max=0.4),StartingCash=(Min=320,Max=360),MinRespawnCash=(Min=280,Max=300),DeathCashModifier=(Min=0.94,Max=0.82))
	 GameWaves(5)=(AliveMonsters=(Min=22,Max=52),MonsterSquadSize=(Min=6,RandMin=3,Max=18,RandMax=10),SquadsSpawnPeriod=(Min=3.0,RandMin=1.0,Max=2.5,RandMax=1.5),SquadsSpawnEndTime=16,WaveDifficulty=1.2,StartDelay=6,Duration=(Min=5.5,RandMin=0.9,Max=13.0,RandMax=1.8),BreakTime=(Min=110,Max=130),DoorsRepairChance=(Min=1.0,Max=0.35),StartingCash=(Min=340,Max=380),MinRespawnCash=(Min=300,Max=320),DeathCashModifier=(Min=0.93,Max=0.81))
	 GameWaves(6)=(AliveMonsters=(Min=22,Max=52),MonsterSquadSize=(Min=7,RandMin=3,Max=18,RandMax=12),SquadsSpawnPeriod=(Min=3.0,RandMin=1.0,Max=2.0,RandMax=1.5),SquadsSpawnEndTime=16,WaveDifficulty=1.3,StartDelay=6,Duration=(Min=6.0,RandMin=1.0,Max=14.0,RandMax=2.0),BreakTime=(Min=120,Max=130),DoorsRepairChance=(Min=1.0,Max=0.3),StartingCash=(Min=360,Max=400),MinRespawnCash=(Min=320,Max=340),DeathCashModifier=(Min=0.92,Max=0.8))
	 
	 // BossWave
	 BossMonsterClassName="UnlimaginMod.UM_ZombieBoss"
	 BossWaveAliveMonsters=(Min=16,Max=48)
	 BossWaveMonsterSquadSize=(Min=12,RandMin=4,Max=36,RandMax=12)
	 BossWaveSquadsSpawnPeriod=(Min=25.0,RandMin=5.0,Max=25.0,RandMax=10.0)
	 BossWaveDifficulty=1.4
	 BossWaveStartDelay=5
	 BossWaveDoorsRepairChance=(Min=1.0,Max=0.2)
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=(Min=340,Max=380)
	 
	 // UM_ZombieBloat
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieBloatData
		 MonsterClassName="UnlimaginMod.UM_ZombieBloat"
		 // WaveLimit
		 WaveLimit(0)=(Min=6,Max=48)
		 WaveLimit(1)=(Min=7,Max=56)
		 WaveLimit(2)=(Min=8,Max=64)
		 WaveLimit(3)=(Min=9,Max=72)
		 WaveLimit(4)=(Min=10,Max=80)
		 WaveLimit(5)=(Min=11,Max=88)
		 WaveLimit(6)=(Min=12,Max=96)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(1)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(2)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(3)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(4)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(5)=(Min=0.35,Max=0.45)
		 WaveSpawnChance(6)=(Min=0.35,Max=0.45)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=6)
		 WaveSquadLimit(1)=(Min=3,Max=7)
		 WaveSquadLimit(2)=(Min=4,Max=8)
		 WaveSquadLimit(3)=(Min=4,Max=9)
		 WaveSquadLimit(4)=(Min=4,Max=10)
		 WaveSquadLimit(5)=(Min=5,Max=10)
		 WaveSquadLimit(6)=(Min=5,Max=10)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=6,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=54.0,Max=20,MaxTime=32.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=48.0,Max=22,MaxTime=34.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=42.0,Max=22,MaxTime=32.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=36.0,Max=24,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=32.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=30.0,Max=26,MaxTime=30.0)
		 // BossWave
		 BossWaveLimit=(Min=6,Max=48)
		 BossWaveSpawnChance=(Min=0.25,Max=0.35)
		 BossWaveSquadLimit=(Min=2,Max=8)
		 BossWaveDeltaLimit=(Min=2,MinTime=30.0,Max=16,MaxTime=60.0)
	 End Object
	 Monsters(0)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieBloatData'
	 
	 // UM_ZombieClot
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieClotData
		 MonsterClassName="UnlimaginMod.UM_ZombieClot"
		 bNoWaveRestrictions=True
		 // BossWave
		 BossWaveLimit=(Min=32,Max=168)
		 BossWaveSpawnChance=(Min=1.0,Max=1.0)
		 BossWaveSquadLimit=(Min=12,Max=48)
		 BossWaveDeltaLimit=(Min=12,MinTime=10.0,Max=48,MaxTime=20.0)
	 End Object
	 Monsters(1)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieClotData'
	 
	 // UM_ZombieCrawler
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieCrawlerData
		 MonsterClassName="UnlimaginMod.UM_ZombieCrawler"
		 // WaveLimit
		 WaveLimit(0)=(Min=3,Max=20)
		 WaveLimit(1)=(Min=4,Max=26)
		 WaveLimit(2)=(Min=5,Max=32)
		 WaveLimit(3)=(Min=6,Max=38)
		 WaveLimit(4)=(Min=7,Max=44)
		 WaveLimit(5)=(Min=8,Max=50)
		 WaveLimit(6)=(Min=8,Max=56)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(1)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(2)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(3)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(4)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(5)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(6)=(Min=0.3,Max=0.4)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=4)
		 WaveSquadLimit(1)=(Min=2,Max=4)
		 WaveSquadLimit(2)=(Min=3,Max=5)
		 WaveSquadLimit(3)=(Min=3,Max=6)
		 WaveSquadLimit(4)=(Min=3,Max=7)
		 WaveSquadLimit(5)=(Min=4,Max=8)
		 WaveSquadLimit(6)=(Min=4,Max=8)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=2,MinTime=60.0,Max=8,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=2,MinTime=54.0,Max=8,MaxTime=26.0)
		 WaveDeltaLimit(2)=(Min=4,MinTime=48.0,Max=12,MaxTime=30.0)
		 WaveDeltaLimit(3)=(Min=4,MinTime=42.0,Max=12,MaxTime=26.0)
		 WaveDeltaLimit(4)=(Min=6,MinTime=48.0,Max=16,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=6,MinTime=42.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=6,MinTime=36.0,Max=16,MaxTime=28.0)
		 // BossWave
		 BossWaveLimit=(Min=4,Max=24)
		 BossWaveSpawnChance=(Min=0.15,Max=0.25)
		 BossWaveSquadLimit=(Min=2,Max=6)
		 BossWaveDeltaLimit=(Min=2,MinTime=40.0,Max=6,MaxTime=30.0)
	 End Object
	 Monsters(2)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieCrawlerData'
	 
	 // UM_ZombieFleshPound
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieFleshPoundData
		 MonsterClassName="UnlimaginMod.UM_ZombieFleshPound"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=0)
		 WaveLimit(1)=(Min=0,Max=2)
		 WaveLimit(2)=(Min=0,Max=4)
		 WaveLimit(3)=(Min=0,Max=6)
		 WaveLimit(4)=(Min=1,Max=8)
		 WaveLimit(5)=(Min=2,Max=10)
		 WaveLimit(6)=(Min=3,Max=12)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.0)
		 WaveSpawnChance(1)=(Min=0.0,Max=0.05)
		 WaveSpawnChance(2)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(3)=(Min=0.0,Max=0.15)
		 WaveSpawnChance(4)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=0)
		 WaveSquadLimit(1)=(Min=1,Max=1)
		 WaveSquadLimit(2)=(Min=1,Max=2)
		 WaveSquadLimit(3)=(Min=1,Max=3)
		 WaveSquadLimit(4)=(Min=1,Max=3)
		 WaveSquadLimit(5)=(Min=1,Max=4)
		 WaveSquadLimit(6)=(Min=1,Max=4)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=0,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=120.0,Max=1,MaxTime=120.0)
		 WaveDeltaLimit(2)=(Min=0,MinTime=120.0,Max=2,MaxTime=120.0)
		 WaveDeltaLimit(3)=(Min=0,MinTime=120.0,Max=3,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=3,MaxTime=90.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=4,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=60.0,Max=4,MaxTime=90.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=3)
		 BossWaveSpawnChance=(Min=0.0,Max=0.1)
		 BossWaveSquadLimit=(Min=1,Max=1)
		 BossWaveDeltaLimit=(Min=1,MinTime=120.0,Max=1,MaxTime=60.0)
	 End Object
	 Monsters(3)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieFleshPoundData'
	 
	 // UM_ZombieGoreFast
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieGoreFastData
		 MonsterClassName="UnlimaginMod.UM_ZombieGoreFast"
		 // WaveLimit
		 WaveLimit(0)=(Min=8,Max=64)
		 WaveLimit(1)=(Min=10,Max=80)
		 WaveLimit(2)=(Min=12,Max=96)
		 WaveLimit(3)=(Min=14,Max=112)
		 WaveLimit(4)=(Min=16,Max=128)
		 WaveLimit(5)=(Min=18,Max=144)
		 WaveLimit(6)=(Min=20,Max=160)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(1)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(2)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(3)=(Min=0.4,Max=0.5)
		 WaveSpawnChance(4)=(Min=0.4,Max=0.5)
		 WaveSpawnChance(5)=(Min=0.45,Max=0.55)
		 WaveSpawnChance(6)=(Min=0.45,Max=0.55)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=8)
		 WaveSquadLimit(1)=(Min=3,Max=9)
		 WaveSquadLimit(2)=(Min=3,Max=10)
		 WaveSquadLimit(3)=(Min=4,Max=11)
		 WaveSquadLimit(4)=(Min=4,Max=11)
		 WaveSquadLimit(5)=(Min=5,Max=12)
		 WaveSquadLimit(6)=(Min=5,Max=12)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=4,MinTime=30.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=30.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(2)=(Min=6,MinTime=24.0,Max=18,MaxTime=24.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=30.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(4)=(Min=8,MinTime=24.0,Max=24,MaxTime=24.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=30.0,Max=30,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=24.0,Max=30,MaxTime=24.0)
		 // BossWave
		 BossWaveLimit=(Min=8,Max=64)
		 BossWaveSpawnChance=(Min=0.35,Max=0.45)
		 BossWaveSquadLimit=(Min=3,Max=10)
		 BossWaveDeltaLimit=(Min=3,MinTime=20.0,Max=20,MaxTime=30.0)
	 End Object
	 Monsters(4)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieGoreFastData'
	 
	 // UM_ZombieHusk
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieHuskData
		 MonsterClassName="UnlimaginMod.UM_ZombieHusk"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=6)
		 WaveLimit(1)=(Min=1,Max=10)
		 WaveLimit(2)=(Min=1,Max=12)
		 WaveLimit(3)=(Min=2,Max=14)
		 WaveLimit(4)=(Min=2,Max=16)
		 WaveLimit(5)=(Min=3,Max=18)
		 WaveLimit(6)=(Min=3,Max=20)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(1)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(2)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=1,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=4)
		 WaveSquadLimit(3)=(Min=1,Max=4)
		 WaveSquadLimit(4)=(Min=1,Max=6)
		 WaveSquadLimit(5)=(Min=1,Max=6)
		 WaveSquadLimit(6)=(Min=1,Max=6)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(1)=(Min=1,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=120.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=120.0,Max=8,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=90.0,Max=10,MaxTime=120.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=12,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=60.0,Max=12,MaxTime=120.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=8)
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=4,MaxTime=60.0)
	 End Object
	 Monsters(5)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieHuskData'
	 
	 // UM_ZombieScrake
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieScrakeData
		 MonsterClassName="UnlimaginMod.UM_ZombieScrake"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=2)
		 WaveLimit(1)=(Min=0,Max=4)
		 WaveLimit(2)=(Min=1,Max=6)
		 WaveLimit(3)=(Min=1,Max=8)
		 WaveLimit(4)=(Min=2,Max=10)
		 WaveLimit(5)=(Min=2,Max=12)
		 WaveLimit(6)=(Min=3,Max=14)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.05)
		 WaveSpawnChance(1)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(2)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(5)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(6)=(Min=0.15,Max=0.25)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=0,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=2)
		 WaveSquadLimit(3)=(Min=1,Max=2)
		 WaveSquadLimit(4)=(Min=1,Max=2)
		 WaveSquadLimit(5)=(Min=2,Max=3)
		 WaveSquadLimit(6)=(Min=2,Max=3)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=240.0,Max=3,MaxTime=60.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=4,MaxTime=80.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=5,MaxTime=90.0)
		 WaveDeltaLimit(6)=(Min=2,MinTime=90.0,Max=6,MaxTime=120.0)
		 // BossWave
		 BossWaveLimit=(Min=0,Max=4)
		 BossWaveSpawnChance=(Min=0.0,Max=0.15)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=2,MaxTime=60.0)
	 End Object
	 Monsters(6)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieScrakeData'
	 
	 // UM_ZombieSiren
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieSirenData
		 MonsterClassName="UnlimaginMod.UM_ZombieSiren"
		 // WaveLimit
		 WaveLimit(0)=(Min=0,Max=8)
		 WaveLimit(1)=(Min=1,Max=12)
		 WaveLimit(2)=(Min=1,Max=14)
		 WaveLimit(3)=(Min=2,Max=16)
		 WaveLimit(4)=(Min=2,Max=18)
		 WaveLimit(5)=(Min=4,Max=20)
		 WaveLimit(6)=(Min=4,Max=22)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.0,Max=0.1)
		 WaveSpawnChance(1)=(Min=0.05,Max=0.15)
		 WaveSpawnChance(2)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(3)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(4)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(5)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(6)=(Min=0.2,Max=0.3)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=0,Max=2)
		 WaveSquadLimit(1)=(Min=1,Max=2)
		 WaveSquadLimit(2)=(Min=1,Max=4)
		 WaveSquadLimit(3)=(Min=1,Max=4)
		 WaveSquadLimit(4)=(Min=2,Max=6)
		 WaveSquadLimit(5)=(Min=2,Max=6)
		 WaveSquadLimit(6)=(Min=2,Max=6)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=1,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(5)=(Min=2,MinTime=120.0,Max=6,MaxTime=72.0)
		 WaveDeltaLimit(6)=(Min=2,MinTime=90.0,Max=6,MaxTime=60.0)
		 // BossWave
		 BossWaveLimit=(Min=1,Max=12)
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=3)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=3,MaxTime=60.0)
	 End Object
	 Monsters(7)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieSirenData'
	 
	 // UM_ZombieStalker
	 Begin Object Class=UM_InvasionMonsterData Name=ZombieStalkerData
		 MonsterClassName="UnlimaginMod.UM_ZombieStalker"
		 // WaveLimit
		 WaveLimit(0)=(Min=4,Max=32)
		 WaveLimit(1)=(Min=6,Max=40)
		 WaveLimit(2)=(Min=6,Max=48)
		 WaveLimit(3)=(Min=8,Max=56)
		 WaveLimit(4)=(Min=8,Max=64)
		 WaveLimit(5)=(Min=12,Max=72)
		 WaveLimit(6)=(Min=12,Max=80)
		 // WaveSpawnChance
		 WaveSpawnChance(0)=(Min=0.1,Max=0.2)
		 WaveSpawnChance(1)=(Min=0.15,Max=0.25)
		 WaveSpawnChance(2)=(Min=0.2,Max=0.3)
		 WaveSpawnChance(3)=(Min=0.25,Max=0.35)
		 WaveSpawnChance(4)=(Min=0.3,Max=0.4)
		 WaveSpawnChance(5)=(Min=0.35,Max=0.45)
		 WaveSpawnChance(6)=(Min=0.35,Max=0.45)
		 // WaveSquadLimit
		 WaveSquadLimit(0)=(Min=2,Max=6)
		 WaveSquadLimit(1)=(Min=3,Max=8)
		 WaveSquadLimit(2)=(Min=4,Max=8)
		 WaveSquadLimit(3)=(Min=4,Max=10)
		 WaveSquadLimit(4)=(Min=5,Max=10)
		 WaveSquadLimit(5)=(Min=5,Max=12)
		 WaveSquadLimit(6)=(Min=6,Max=12)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=4,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=60.0,Max=24,MaxTime=42.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=60.0,Max=24,MaxTime=36.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=56.0,Max=30,MaxTime=42.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=60.0,Max=30,MaxTime=36.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=56.0,Max=36,MaxTime=42.0)
		 WaveDeltaLimit(6)=(Min=12,MinTime=56.0,Max=36,MaxTime=36.0)
		 // BossWave
		 BossWaveLimit=(Min=8,Max=64)
		 BossWaveSpawnChance=(Min=0.3,Max=0.4)
		 BossWaveSquadLimit=(Min=3,Max=8)
		 BossWaveDeltaLimit=(Min=6,MinTime=60.0,Max=12,MaxTime=30.0)
	 End Object
	 Monsters(8)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.ZombieStalkerData'
 
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