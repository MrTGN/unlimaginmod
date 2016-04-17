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
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_InvasionGame extends UM_BaseGameInfo
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

// Begin Match With Shopping
var		config		bool						bBeginMatchWithShopping;
var					range						InitialShoppingTime;

// Normal Wave Data
var					int							InitialWaveNum;
var					array<IRange>				WaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					array<IRandRange>			WaveMonsterSquadSize;	// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty).  RandMin and RandMax also sets the random +/- squad size modifier.
var					array<FRandRange>			WaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty). RandMin and RandMax also sets the random +/- spawn period modifier.
var					array<int>					WaveSquadsSpawnEndTime;	// Time when level will stop to spawn new squads at the end of this wave (in seconds)
var					array<float>				WaveDifficulty;		// Used for the Bot Difficulty
var					array<int>					WaveStartDelay;		// This wave start time out in seconds
var					array<FRandRange>			WaveDuration;		// Wave duration in minutes (all) (Min and RandMin - MinGameDifficulty, Max and RandMax - MaxGameDifficulty)
var					array<range>				WaveBreakTime;			// Shopping time after this wave in seconds
var					array<range>				WaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
var					array<IRange>				WaveStartingCash;		// Random starting cash on this wave
var					array<IRange>				WaveMinRespawnCash;		// Random min respawn cash on this wave
var					array<range>				WaveDeathCashModifier;	// Death cash penalty on this wave (Min - MinGameDifficulty, Max - MaxGameDifficulty)

// Boss Wave Data
var					int							BossWaveNum;
var					IRange						BossWaveAliveMonsters;		// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers or MaxGameDifficulty)
var					IRandRange					BossWaveMonsterSquadSize;	// (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty).  RandMin and RandMax also sets the random +/- squad size modifier.
var					FRandRange					BossWaveSquadsSpawnPeriod;	// Squads Spawn Period in seconds (Min - MinHumanPlayer and MinGameDifficulty, Max - MaxHumanPlayers and MaxGameDifficulty). RandMin and RandMax also sets the random +/- spawn period modifier.
var					float						BossWaveDifficulty;		// Used for the Bot Difficulty
var					int							BossWaveStartDelay;		// This wave start time out in seconds
var					range						BossWaveDoorsRepairChance;	// Chance to repair some of the doors on this wave (0.0 - no repair, 1.0 - repair all doors) (Min - MinGameDifficulty, Max - MaxGameDifficulty)
var					IRange						BossWaveStartingCash;		// Random starting cash on this wave
var					IRange						BossWaveMinRespawnCash;		// Random min respawn cash on this wave

// Monsters
var		export	array<UM_InvasionMonsterData>	Monsters;
// BossMonsterClass
var()				string						BossMonsterClassName;
var()				class<UM_BaseMonster>			BossMonsterClass;
var		transient	UM_BaseMonster					BossMonster;

var		config		bool						bShowBossGrandEntry;
var		config		bool						bShowBossDeath;
var		transient	bool						bNeedToSpawnBoss;
var		transient	bool						bBossKilled;

// Spawned monster list
var		transient	array<UM_BaseMonster>			AliveMonsterList;

var					int							BulidSquadIterationLimit;

var					Class<UM_ActorPool>			ActorPoolClass;

var		transient	int							NextWaveNum;

var		transient	ShopVolume					CurrentShop;
var					float						ShopListUpdateDelay;
var		transient	float						NextShopListUpdateTime;

// Dynamic Parameters	
var					int							MaxAliveMonsters;
var					float						MinSquadSpawnCheckDelay;
var		transient	int							CurrentMonsterSquadSize;
var		transient	float						CurrentMonsterSquadRandSize;
var		transient	float						CurrentSquadsSpawnPeriod,  CurrentSquadsSpawnRandPeriod;
var		transient	float						NextMonsterSquadSpawnTime;
var		transient	int							NextMonsterSquadSize;
var		transient	int							CurrentWaveDuration, WaveElapsedTime;
var		transient	float						CurrentDoorsRepairChance;

// ZedSpawnListUpdate
var					float						ZedSpawnListUpdateDelay;
var		transient	float						NextZedSpawnListUpdateTime;

// JammedMonstersCheck
var		transient	float						NextJammedMonstersCheckTime;
var					float						JammedMonstersCheckDelay;

// SpawningVolumeUpdate
var					float						SpawningVolumeUpdateDelay;
var		transient	float						NextSpawningVolumeUpdateTime;

// Lerp Modifiers
var					float						LerpNumPlayersModifier;
var					float						LerpGameDifficultyModifier;

var					float						ZEDTimeKillSlowMoChargeBonus;

var		transient	string						CurrentMapName;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

protected function bool LoadGamePreset( string NewPresetName )
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
	
	// Normal GameWaves settings
	InitialWaveNum = InvasionPreset.InitialWaveNum;
	WaveAliveMonsters = InvasionPreset.WaveAliveMonsters;
	WaveMonsterSquadSize = InvasionPreset.WaveMonsterSquadSize;
	WaveSquadsSpawnPeriod = InvasionPreset.WaveSquadsSpawnPeriod;
	WaveSquadsSpawnEndTime = InvasionPreset.WaveSquadsSpawnEndTime;
	WaveDifficulty = InvasionPreset.WaveDifficulty;
	WaveStartDelay = InvasionPreset.WaveStartDelay;
	WaveDuration = InvasionPreset.WaveDuration;
	WaveBreakTime = InvasionPreset.WaveBreakTime;
	WaveDoorsRepairChance = InvasionPreset.WaveDoorsRepairChance;
	WaveStartingCash = InvasionPreset.WaveStartingCash;
	WaveMinRespawnCash = InvasionPreset.WaveMinRespawnCash;
	WaveDeathCashModifier = InvasionPreset.WaveDeathCashModifier;
	
	// Boss Wave settings
	BossWaveNum = InvasionPreset.BossWaveNum;
	BossWaveAliveMonsters = InvasionPreset.BossWaveAliveMonsters;
	BossWaveMonsterSquadSize = InvasionPreset.BossWaveMonsterSquadSize;
	BossWaveSquadsSpawnPeriod = InvasionPreset.BossWaveSquadsSpawnPeriod;
	BossWaveDifficulty = InvasionPreset.BossWaveDifficulty;
	BossWaveStartDelay = InvasionPreset.BossWaveStartDelay;
	BossWaveDoorsRepairChance = InvasionPreset.BossWaveDoorsRepairChance;
	BossWaveStartingCash = InvasionPreset.BossWaveStartingCash;
	BossWaveMinRespawnCash = InvasionPreset.BossWaveMinRespawnCash;
		
	// Monsters
	Monsters.Length = InvasionPreset.Monsters.Length;
	for ( i = 0; i < InvasionPreset.Monsters.Length; ++i )
		Monsters[i] = InvasionPreset.Monsters[i];
	
	// BossMonsterClassName
	BossMonsterClassName = InvasionPreset.BossMonsterClassName;
	
	BulidSquadIterationLimit = InvasionPreset.BulidSquadIterationLimit;
	
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

// Random starting cash for the each wave. Must be called before the new wave has begun.
function UpdateStartingCash()
{
	// Normal wave
	if ( WaveNum < FinalWave )  {
		StartingCash = Round( Lerp(FRand(), float(WaveStartingCash[WaveNum].Min), float(WaveStartingCash[WaveNum].Max)) );
		MinRespawnCash = Round( Lerp(FRand(), float(WaveMinRespawnCash[WaveNum].Min), float(WaveMinRespawnCash[WaveNum].Max)) );
	}
	// Boss Wave
	else  {
		StartingCash = Round( Lerp(FRand(), float(BossWaveStartingCash.Min), float(BossWaveStartingCash.Max)) );
		MinRespawnCash = Round( Lerp(FRand(), float(BossWaveMinRespawnCash.Min), float(BossWaveMinRespawnCash.Max)) );
	}
}

function LoadUpMonsterList() 
{
	local	int		i;
	
	if ( BossMonsterClassName != "" )  {
		BossMonsterClass = class<UM_BaseMonster>( DynamicLoadObject(BossMonsterClassName, Class'class') );
		if ( BossMonsterClass == None )
			Log( "Error: Failed to load Boss Monster Class"@BossMonsterClassName$"!", Name );
	}
	else
		Log( "Error: BossMonsterClassName not specified!", Name );
	
	for ( i = 0; i < Monsters.Length; ++i )  {
		// Check out and init monsters data objects
		if ( Monsters[i] == None || !Monsters[i].InitDataFor(Self) )  {
			Monsters.Remove(i, 1);
			--i;
		}
	}
	
	if ( Monsters.Length < 1 )
		Log( "Error: No MonsterData Objects to load!", Name );
}

/* Initialize the game.
 The GameInfo's InitGame() function is called before any other scripts (including
 PreBeginPlay() ), and is used by the GameInfo to initialize parameters and spawn
 its helper classes.
 Warning: this is called before actors' PreBeginPlay.
*/
event InitGame( string Options, out string Error )
{
	local	string	InOpt;

	// LoadGamePreset() call in the parent class
	Super.InitGame(Options, Error);
	
	UpdateShopList();
	UpdateZedSpawnList();

	InOpt = ParseOption(Options, "UseBots");
	if ( InOpt != "" )
		bNoBots = bool(InOpt);

	// #SetupWaveNumbers
	InitialWave = InitialWaveNum;
	FinalWave = BossWaveNum;
	NextWaveNum = InitialWave;
	WaveNum = NextWaveNum;
	UpdateStartingCash();
	bCustomGameLength = True; // Can't use Steam Stats in Mod
	UseCheats( True ); // Can't use Steam Stats in Mod
	LoadUpMonsterList();

	//Spawning ActorPool
	if ( ActorPoolClass != None && Class'UM_GlobalData'.default.ActorPool == None )  {
		log("-------- Creating ActorPool --------",Class.Outer.Name);
		Spawn(ActorPoolClass);
	}
}

function float GetDifficultyModifier()
{
	local	float	f;
	
	// WaveDifficulty Modifier
	f = WaveDifficulty[WaveNum];
	
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

function UpdateDynamicParameters()
{
	local	int		i;
	local	float	MidModif;
	
	MidModif = (LerpNumPlayersModifier + LerpGameDifficultyModifier) * 0.5;
	
	// Normal Wave
	if ( WaveNum < FinalWave )  {
		// MaxAliveMonsters
		MaxAliveMonsters = Round( Lerp(FMin((LerpNumPlayersModifier + LerpGameDifficultyModifier), 1.0), float(WaveAliveMonsters[WaveNum].Min), float(WaveAliveMonsters[WaveNum].Max)) );
		// CurrentMonsterSquadSize
		CurrentMonsterSquadSize = Round( Lerp(MidModif, float(WaveMonsterSquadSize[WaveNum].Min), float(WaveMonsterSquadSize[WaveNum].Max)) );
		CurrentMonsterSquadRandSize = Lerp( MidModif, float(WaveMonsterSquadSize[WaveNum].RandMin), float(WaveMonsterSquadSize[WaveNum].RandMax) );
		// CurrentSquadsSpawnPeriod
		CurrentSquadsSpawnPeriod = Lerp( MidModif, WaveSquadsSpawnPeriod[WaveNum].Min, WaveSquadsSpawnPeriod[WaveNum].Max );
		CurrentSquadsSpawnRandPeriod = Lerp( MidModif, WaveSquadsSpawnPeriod[WaveNum].RandMin, WaveSquadsSpawnPeriod[WaveNum].RandMax );
		// AdjustedDifficulty
		AdjustedDifficulty = GameDifficulty * WaveDifficulty[WaveNum];
		// CurrentWaveDuration
		CurrentWaveDuration = Round( Lerp(LerpGameDifficultyModifier, WaveDuration[WaveNum].Min, WaveDuration[WaveNum].Max) * 60.0 + Lerp(LerpGameDifficultyModifier, WaveDuration[WaveNum].RandMin, WaveDuration[WaveNum].RandMax) * (120.0 * FRand() - 60.0) );
		// CurrentDoorsRepairChance
		CurrentDoorsRepairChance = Lerp( LerpGameDifficultyModifier, WaveDoorsRepairChance[WaveNum].Min, WaveDoorsRepairChance[WaveNum].Max );
		// DeathCashModifier
		DeathCashModifier = Lerp( LerpGameDifficultyModifier, WaveDeathCashModifier[WaveNum].Min, WaveDeathCashModifier[WaveNum].Max );
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
		CurrentDoorsRepairChance = Lerp( LerpGameDifficultyModifier, BossWaveDoorsRepairChance.Min, BossWaveDoorsRepairChance.Max );
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

//[block] AliveMonsterList functions
function CheckAliveMonsterList()
{
	local	int		i;
	
	for ( i = 0; i < AliveMonsterList.Length; ++i )  {
		if ( AliveMonsterList[i] == None || AliveMonsterList[i].bDeleteMe || AliveMonsterList[i].Health < 1 )  {
			AliveMonsterList.Remove(i, 1);
			--i;
		}
	}
	NumMonsters = AliveMonsterList.Length;
}

// Called from the UM_BaseMonster in PostBeginPlay() function
function bool AddToMonsterList( UM_BaseMonster M )
{
	if ( M == None )
		Return False;
	
	AliveMonsterList[AliveMonsterList.Length] = M;
	Return True;
}

function ClearMonsterList()
{
	while( AliveMonsterList.Length > 0 )
		AliveMonsterList.Remove( (AliveMonsterList.Length - 1), 1 );
	
	NumMonsters = AliveMonsterList.Length;
}

exec function KillZeds()
{
	local	int		i;
	
	UseCheats( True );	
	CheckAliveMonsterList();
	for ( i = 0; i < AliveMonsterList.Length; ++i )
		AliveMonsterList[i].Suicide();
	ClearMonsterList();
}
//[end] AliveMonsterList functions

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

function int GetCurrentWaveNum()
{
	Return KFGameReplicationInfo( GameReplicationInfo ).WaveNumber + 1;
}

function int GetFinalWaveNum()
{
	Return KFGameReplicationInfo( GameReplicationInfo ).FinalWave;
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
		local	int		i;
		
		WaveNum = NextWaveNum;
		if ( WaveNum < FinalWave )  {
			++NextWaveNum;
			WaveCountDown = WaveStartDelay[WaveNum] + Min( Round(TimerCounter), 1 );
		}
		else
			WaveCountDown = BossWaveStartDelay + Min( Round(TimerCounter), 1 );
		
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
		
		WaveElapsedTime = 0;
		// Reset monster spawn counters
		for ( i = 0; i < Monsters.Length; ++i )  {
			Monsters[i].DeltaCounter = 0;
			Monsters[i].NumInCurrentSquad = 0;
		}
	}
	
	event Timer()
	{
		Global.Timer();

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
		local	int		i;
		
		// Allow to spawn Players
		SetAllowPlayerSpawn( True );
		
		if ( !CalmMusicPlaying )
			StartGameMusic(False);
		
		if ( CurrentShop == None )
			SelectNewShop();
		
		UpdateShopList();
		for ( i = 0; i < ShopList.Length; ++i )  {
			if ( ShopList[i].bAlwaysEnabled || ShopList[i] == CurrentShop )
				ShopList[i].OpenShop();
		}
		
		CheckPlayerList();
		// Tell all players to start showing the path to the trader
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None )  {
				// Disable pawn collision during trader time
				PlayerList[i].Pawn.bBlockActors = False;
				if ( PlayerList[i].Pawn.Health > 0 )  {
					PlayerList[i].SetShowPathToTrader(True);
					// Have Trader tell players that the Shop's Open
					if ( NextWaveNum < FinalWave )
						PlayerList[i].ClientLocationalVoiceMessage(PlayerList[i].PlayerReplicationInfo, None, 'TRADER', 2);
					// Boss Wave Next
					else
						PlayerList[i].ClientLocationalVoiceMessage(PlayerList[i].PlayerReplicationInfo, None, 'TRADER', 3);
					
					//Hint_1
					PlayerList[i].CheckForHint(31);
				}
			}
		}
		
		// Second Hint time
		if ( bShowHint_2 )
			HintTime_1 = Level.TimeSeconds + 11.0;
		
		// Third Hint Time
		if ( bShowHint_3 )
			HintTime_2 = Level.TimeSeconds + 22.0;
		
		// Break Time
		if ( NextWaveNum > InitialWave )
			WaveCountDown = Round( Lerp(FRand(), WaveBreakTime[WaveNum].Min, WaveBreakTime[WaveNum].Max) + FMin(TimerCounter, 1.0) );
		// Begin Match With Shopping
		else
			WaveCountDown = Round( Lerp(FRand(), InitialShoppingTime.Min, InitialShoppingTime.Max) + FMin(TimerCounter, 1.0) );
		
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		
		bTradingDoorsOpen = True;
	}
	
	function CloseShops()
	{
		local	int		i;
		
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
		
		CheckPlayerList();
		// Tell all players to stop showing the path to the trader
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None )  {
				// Disable pawn collision during trader time
				PlayerList[i].Pawn.bBlockActors = PlayerList[i].Pawn.default.bBlockActors;
				PlayerList[i].SetShowPathToTrader(False);
				// Have Trader tell players that the Shop's Open
				if ( PlayerList[i].Pawn.Health > 0 )  {
					PlayerList[i].ClientForceCollectGarbage();
					if ( NextWaveNum < FinalWave )
						PlayerList[i].ClientLocationalVoiceMessage(PlayerList[i].PlayerReplicationInfo, None, 'TRADER', 2);
				}
			}
		}
	}
	
	
	function TeleportPlayersFromClosedShops()
	{
		local	int		i, j;
		
		UpdateShopList();
		// Do 4 iterations to teleport all players from closed shops.
		for ( j = 0; j < 4; ++j )  {
			for ( i = 0; i < ShopList.Length; ++i )
				ShopList[i].BootPlayers();
		}
	}
	
	function PlaySecondHint()
	{
		local	byte	i;
		
		bShowHint_2 = False; // Turn off this hint
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
				PlayerList[i].CheckForHint(32);
		}
	}
	
	function PlayThirdHint()
	{
		local	byte	i;
		
		bShowHint_3 = False; // Turn off this hint
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
				PlayerList[i].CheckForHint(33);
		}
	}
	
	function PlayTenSecondsLeftMessage()
	{
		local	byte	i;
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
				PlayerList[i].ClientLocationalVoiceMessage( PlayerList[i].PlayerReplicationInfo, None, 'TRADER', 5 );
		}
	}
	
	function PlayThirtySecondsLeftMessage()
	{
		local	byte	i;
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
				PlayerList[i].ClientLocationalVoiceMessage( PlayerList[i].PlayerReplicationInfo, None, 'TRADER', 4 );
		}
	}
	
	event Timer()
	{
		Global.Timer();
		
		// Out from the Shopping state
		if ( WaveCountDown < 1 )  {
			CloseShops();
			TeleportPlayersFromClosedShops();
			GoToState('BeginNewWave');
			Return; // Exit from this Timer
		}
		
		IncreaseElapsedTime();
		DecreaseWaveCountDown();
		
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
		CheckForPlayersDeficit();
		// Disallow to spawn Players
		SetAllowPlayerSpawn( False );
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
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )
			AlivePlayers[ AlivePlayers.Length ] = PlayerList[i];
	}
	// BotList
	CheckBotList();
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

function BuildNextSquad()
{
	local	int		i, r;
	
	// Reset monster squad counters
	NextSpawnSquad.Length = 0;
	for ( i = 0; i < Monsters.Length; ++i )
		Monsters[i].NumInCurrentSquad = 0;
	
	// Building squad Monster list
	// i limit of tries to fill the squad slots
	for ( i = 0; NextSpawnSquad.Length < NextMonsterSquadSize && i < BulidSquadIterationLimit; ++i )  {
		r = Rand(Monsters.Length);
		if ( Monsters[r].CanSpawn() )  {
			// Increment spawn counters
			++Monsters[r].NumInCurrentSquad;
			++Monsters[r].DeltaCounter;
			// Add to the monster list
			NextSpawnSquad[NextSpawnSquad.Length] = Monsters[r].GetMonsterClass();
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
	
	if ( LastSpawningVolume.SpawnInHere( NextSpawnSquad, False, NumSpawned, MaxMonsters, (MaxAliveMonsters - NumMonsters) ) )  {
		MaxMonsters = default.MaxMonsters;
		WaveMonsters += NumSpawned;
		NextSpawnSquad.Length = 0;
	}
	// Spawn has failed
	else  {
		NextMonsterSquadSpawnTime = Level.TimeSeconds + 0.5;
		NextSpawningVolumeUpdateTime = Level.TimeSeconds + SpawningVolumeUpdateDelay;
		LastSpawningVolume = FindSpawningVolume();
	}
}

function RespawnJammedMonsters()
{
	local	int		i;
	
	NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
	
	CheckAliveMonsterList();
	// Search for Jammed Monsters
	for ( i = 0; i < AliveMonsterList.Length; ++i )  {
		if ( AliveMonsterList[i].NotRelevantMoreThan(45.0) )  {
			NextSpawnSquad[NextSpawnSquad.Length] = AliveMonsterList[i].Class;
			AliveMonsterList[i].Suicide();
			AliveMonsterList.Remove(i, 1);
			--WaveMonsters;
			--i;
		}
	}
	// Respawn Jammed Monsters
	SpawnNextMonsterSquad();
}

function KillJammedMonsters()
{
	local	int		i;
	
	NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
	
	CheckAliveMonsterList();
	// Search for Jammed Monsters
	for ( i = 0; i < AliveMonsterList.Length; ++i )  {
		if ( AliveMonsterList[i].NotRelevantMoreThan(5.0) )  {
			AliveMonsterList[i].Suicide();
			AliveMonsterList.Remove(i, 1);
			--WaveMonsters;
			--i;
		}
		else
			AliveMonsterList[i].LifeSpan = FClamp( AliveMonsterList[i].LifeSpan, 5.0, 30.0 );
	}
	// Updating NumMonsters
	NumMonsters = AliveMonsterList.Length;
	if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
		KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = NumMonsters;
		KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = True;
	}
}

function DoWaveEnd()
{
	local	PlayerController	Survivor;
	local	byte				i, SurvivorCount;
	
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
		KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = False;
	}
	
	// PlayerList
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i].PlayerReplicationInfo == None )
			Continue; // skip this controller
		// Reset Lives Limit
		PlayerList[i].PlayerReplicationInfo.NumLives = 0;
		PlayerList[i].PlayerReplicationInfo.bOutOfLives = False;
		CheckSelectedVeterancy( PlayerList[i] );
		// Wave End event
		if ( KFSteamStatsAndAchievements(PlayerList[i].SteamStatsAndAchievements) != None )
			KFSteamStatsAndAchievements(PlayerList[i].SteamStatsAndAchievements).WaveEnded();
		// Count survivors
		if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )  {
			Survivor = PlayerList[i];
			++SurvivorCount;
		}
	}
	
	// Don't broadcast this message AFTER the final wave!
	if ( NextWaveNum < FinalWave && SurvivorCount > 0 )
		BroadcastLocalizedMessage(class'KFMod.WaitingMessage', 2);
	
	// One Survivor Achievement
	if ( Level.NetMode != NM_StandAlone && NumPlayers > 1 && SurvivorCount == 1 
		 && Survivor != None && KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements) != None )
		KFSteamStatsAndAchievements(Survivor.SteamStatsAndAchievements).AddOnlySurvivorOfWave();
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
		// Begin Normal Wave
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
		
		CheckAliveMonsterList(); // update monster count (NumMonsters)
		// Add next squad spawn check delay. Prevents from checks at every tick.
		if ( (MaxAliveMonsters - NumMonsters) < NextMonsterSquadSize )  {
			NextMonsterSquadSpawnTime = Level.TimeSeconds + MinSquadSpawnCheckDelay;
			Return False;
		}
		
		Return True;
	}
	
	event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		// Check spawn end time
		if ( WaveCountDown <= WaveSquadsSpawnEndTime[WaveNum] )
			Return;
		
		// Respawn Jammed Monsters First
		if ( Level.TimeSeconds >= NextJammedMonstersCheckTime )
			RespawnJammedMonsters();
		// Spawn New Monster Squad
		if ( CanSpawnNextMonsterSquad() )  {
			// NextSpawnTime
			NextMonsterSquadSpawnTime = Level.TimeSeconds + CurrentSquadsSpawnPeriod + Lerp( FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod );
			// NewMonsterSquad
			BuildNextSquad();
			SpawnNextMonsterSquad();
		}
	}
	
	event Timer()
	{
		Global.Timer();
		// EndGame if no one alive.
		if ( !CheckForAlivePlayers() )  {
			EndGame(None, "LastMan");
			Return;
		}
		
		IncreaseElapsedTime();
		++WaveElapsedTime;
		if ( WaveCountDown > 0 )
			DecreaseWaveCountDown();
		// End Wave
		if ( WaveCountDown < 1 )  {
			// Kill Jammed Monsters
			KillJammedMonsters();
			if ( NumMonsters > 0 )
				Return;
			
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
function ShowActorToPlayers( Actor A, optional float ShowingTime )
{
	local	byte	i;
	
	if ( A == None )
		Return;
	
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )
		PlayerList[i].ShowActor( A , ShowingTime );
}

state BossWaveInProgress
{
	event BeginState()
	{
		NextJammedMonstersCheckTime = Level.TimeSeconds + JammedMonstersCheckDelay;
		// Reset wave parameters
		rewardFlag = False;
		ZombiesKilled = 0;
		WaveMonsters = 0;
		// Time to spawn next squad
		WaveCountDown = Round( CurrentSquadsSpawnPeriod + Lerp(FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod) );
		// GameMusic
		if ( !MusicPlaying )
			StartGameMusic(True);
		// Begin Boss Wave
		bWaveBossInProgress = True;
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
			KFGameReplicationInfo(GameReplicationInfo).MaxMonsters = MaxMonsters;
			//KFGameReplicationInfo(GameReplicationInfo).MaxMonstersOn = True;
			KFGameReplicationInfo(GameReplicationInfo).bWaveInProgress = True;
			KFGameReplicationInfo(GameReplicationInfo).TimeToNextWave = WaveCountDown;
		}
		bNeedToSpawnBoss = True;
	}
	
	function bool AddBoss()
	{
		local	ZombieVolume	BossSpawningVolume;
		local	int				Num;
		
		NextSpawnSquad.Length = 1;
		NextSpawnSquad[0] = BossMonsterClass;
		BossSpawningVolume = FindSpawningVolume( False, True );
		// if FindSpawningVolume has failed
		if ( BossSpawningVolume == None )  {
			// Force to try up to 5 times to find another BossSpawningVolume
			for ( Num = 0; BossSpawningVolume == None && Num < 5; ++Num )
				BossSpawningVolume = FindSpawningVolume( True, True );
			// Filed to find another BossSpawningVolume
			if ( BossSpawningVolume == None )
				Return False;
			// Reset Num
			Num = 0;
		}
		
		if ( BossSpawningVolume.SpawnInHere(NextSpawnSquad,, Num, MaxMonsters, (MaxAliveMonsters - NumMonsters)) )  {
			MaxMonsters = default.MaxMonsters;
			WaveMonsters += Num;
			NextSpawnSquad.Length = 0;
			bNeedToSpawnBoss = False;
			Return True;
		}
		
		Return False;
	}
	
	function AddBossBuddySquad()
	{
		local	int		HelpSquadSize;
		
		if ( WaveCountDown < 1 )
			Return;
		
		CheckAliveMonsterList(); // update monster count (NumMonsters)
		HelpSquadSize = MaxAliveMonsters - NumMonsters;
		if ( HelpSquadSize < 2 )
			Return;
		
		NextMonsterSquadSize = HelpSquadSize;
		// NextSpawnTime
		WaveCountDown = Round( CurrentSquadsSpawnPeriod + Lerp(FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod) );
		// NewMonsterSquad
		BuildNextSquad();
		SpawnNextMonsterSquad();
	}
	
	function bool CanSpawnNextMonsterSquad()
	{
		if ( WaveCountDown > 0 )
			Return False;
		
		CheckAliveMonsterList(); // update monster count (NumMonsters)
		Return (MaxAliveMonsters - NumMonsters) >= NextMonsterSquadSize;
	}
	
	event Timer()
	{
		Global.Timer();
		// EndGame if no one alive.
		if ( !CheckForAlivePlayers() )  {
			EndGame(None, "LastMan");
			Return;
		}

		IncreaseElapsedTime();
		++WaveElapsedTime;
		DecreaseWaveCountDown();
		
		// SpawnBoss Check
		if ( bNeedToSpawnBoss )
			AddBoss();
		else if ( bBossKilled )  {
			EndGame(None,"TimeLimit");
			Return;
		}
		else if ( bShowBossGrandEntry && BossMonster != None && BossMonster.MakeGrandEntry() )  {
			bShowBossGrandEntry = False;
			ShowActorToPlayers( BossMonster );
		}
		
		// Respawn Jammed Monsters First
		if ( Level.TimeSeconds >= NextJammedMonstersCheckTime )
			RespawnJammedMonsters();
		// Spawn New Monster Squad
		if ( CanSpawnNextMonsterSquad() )  {
			// NextSpawnTime
			WaveCountDown = Round( CurrentSquadsSpawnPeriod + Lerp(FRand(), -CurrentSquadsSpawnRandPeriod, CurrentSquadsSpawnRandPeriod) );
			// NewMonsterSquad
			BuildNextSquad();
			SpawnNextMonsterSquad();
		}
	}
	
	// Force slomo for a longer period of time when the boss dies
	function DoBossDeath()
	{
		local	int		i;

		DoZedTime(10.0);
		if ( bShowBossDeath && BossMonster != None )
			ShowActorToPlayers( BossMonster, 10.0 );
		
		// Kill all alive monsters
		CheckAliveMonsterList();
		for ( i = 0; i < AliveMonsterList.Length; ++i )
			AliveMonsterList[i].Suicide();
		
		// End Wave
		DoWaveEnd();
		bBossKilled = True;
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
						DoZedTime( ZEDTimeDuration );
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

function bool CheckEndGame( PlayerReplicationInfo Winner, string Reason )
{
	local	Controller	C;

	EndTime = Level.TimeSeconds + EndTimeDelay;
	if ( WaveNum < FinalWave )
		KFGameReplicationInfo(GameReplicationInfo).EndGameType = 1;
	else  {
		GameReplicationInfo.Winner = Teams[0];
		KFGameReplicationInfo(GameReplicationInfo).EndGameType = 2;
	}

	if ( GameRulesModifiers != None && !GameRulesModifiers.CheckEndGame(Winner, Reason) ) {
		KFGameReplicationInfo(GameReplicationInfo).EndGameType = 0;
		Return False;
	}
	
	// Notify all controllers
	for ( C = Level.ControllerList; C != None; C = C.nextController )  {
		C.GameHasEnded();
		C.ClientGameEnded();
	}
	
	// From Invasion class
	if ( CurrentGameProfile != None )
		CurrentGameProfile.bWonMatch = GameReplicationInfo.Winner == Teams[0]; // Monsters were defeated

	Return True;
}

function EndGame( PlayerReplicationInfo Winner, string Reason )
{
	if ( Class'UM_GlobalData'.default.ActorPool != None )  {
		log("------ Clearing and destroying ActorPool ------", Class.Outer.Name);
		Class'UM_GlobalData'.default.ActorPool.Clear();
		Class'UM_GlobalData'.default.ActorPool.Destroy();
	}
	
	if ( Reason ~= "triggered" || Reason ~= "LastMan" || Reason ~= "TimeLimit" ||
		 Reason ~= "FragLimit" || Reason ~= "TeamScoreLimit" )  {
		// don't end game if not really ready
		if ( !CheckEndGame(Winner, Reason) )  {
			bOverTime = True;
			Return;
		}

		bGameEnded = True;
		TriggerEvent('EndGame', self, None);
		EndLogging(Reason);
		GotoState('MatchOver');
	}
}

state MatchOver
{
	event Timer()
	{
		if ( !bBossHasSaidWord )  {
			bBossHasSaidWord = True;
			if ( BossMonster != None && BossMonster.SetBossLaught() )			
				ShowActorToPlayers( BossMonster, 5.0 );
		}
		Super.Timer();
	}
}

function GetServerDetails( out ServerResponseLine ServerState )
{
    local	int		l;

    Super.GetServerDetails( ServerState );
	
    l = ServerState.ServerInfo.Length;
    ServerState.ServerInfo.Length = l + 1;
    ServerState.ServerInfo[l].Key = "Max runtime zombies";
    ServerState.ServerInfo[l].Value = string(MaxZombiesOnce);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bShowHint_2=True
	 bShowHint_3=True
	 
	 bUseEndGameBoss=True
	 bRespawnOnBoss=True
	 
	 bShowBossGrandEntry=True
	 bShowBossDeath=True
	 
	 bSaveSpectatorScores=True
	 
	 //[block] Set Modifiers to default values here
	 LerpNumPlayersModifier=1.0
	 LerpGameDifficultyModifier=1.0
	 //[end]
	 
	 BulidSquadIterationLimit=400
	 MinSquadSpawnCheckDelay=0.1
	 MaxMonsters=1000
	 MaxAliveMonsters=40
	 JammedMonstersCheckDelay=15.0
	 ShopListUpdateDelay=1.0
	 ZedSpawnListUpdateDelay=5.0
	 SpawningVolumeUpdateDelay=10.0
	 //GamePresetClassName="UnlimaginMod.UM_DefaultInvasionPreset"
	 
	 ZEDTimeKillSlowMoChargeBonus=0.4
	 
	 ActorPoolClass=Class'UnlimaginMod.UM_ActorPool'
	 BotAtHumanFriendlyFireScale=0.5

	 MinHumanPlayers=1
	 MaxHumanPlayers=12
	 
	 bBeginMatchWithShopping=True
	 InitialShoppingTime=(Min=90.0,Max=110.0)
	 
	 // GameWaves - 7 waves
	 InitialWaveNum=0
	 // WaveAliveMonsters
	 WaveAliveMonsters(0)=(Min=12,Max=46)
	 WaveAliveMonsters(1)=(Min=14,Max=48)
	 WaveAliveMonsters(2)=(Min=14,Max=48)
	 WaveAliveMonsters(3)=(Min=16,Max=50)
	 WaveAliveMonsters(4)=(Min=16,Max=50)
	 WaveAliveMonsters(5)=(Min=18,Max=52)
	 WaveAliveMonsters(6)=(Min=18,Max=52)
	 // WaveMonsterSquadSize
	 WaveMonsterSquadSize(0)=(Min=4,RandMin=2,Max=12,RandMax=6)
	 WaveMonsterSquadSize(1)=(Min=4,RandMin=2,Max=14,RandMax=7)
	 WaveMonsterSquadSize(2)=(Min=5,RandMin=2,Max=14,RandMax=8)
	 WaveMonsterSquadSize(3)=(Min=5,RandMin=3,Max=16,RandMax=8)
	 WaveMonsterSquadSize(4)=(Min=6,RandMin=3,Max=16,RandMax=10)
	 WaveMonsterSquadSize(5)=(Min=6,RandMin=3,Max=18,RandMax=10)
	 WaveMonsterSquadSize(6)=(Min=7,RandMin=3,Max=18,RandMax=12)
	 // WaveSquadsSpawnPeriod
	 WaveSquadsSpawnPeriod(0)=(Min=5.0,RandMin=1.0,Max=3.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(1)=(Min=4.5,RandMin=1.0,Max=3.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(2)=(Min=4.5,RandMin=1.0,Max=3.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(3)=(Min=4.0,RandMin=1.0,Max=2.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(4)=(Min=4.0,RandMin=1.0,Max=2.5,RandMax=1.5)
	 WaveSquadsSpawnPeriod(5)=(Min=3.5,RandMin=1.0,Max=2.0,RandMax=1.5)
	 WaveSquadsSpawnPeriod(6)=(Min=3.5,RandMin=1.0,Max=2.0,RandMax=1.5)
	 // WaveSquadsSpawnEndTime
	 WaveSquadsSpawnEndTime(0)=25
	 WaveSquadsSpawnEndTime(1)=26
	 WaveSquadsSpawnEndTime(2)=26
	 WaveSquadsSpawnEndTime(3)=28
	 WaveSquadsSpawnEndTime(4)=28
	 WaveSquadsSpawnEndTime(5)=30
	 WaveSquadsSpawnEndTime(6)=30
	 // WaveDifficulty
	 WaveDifficulty(0)=0.7
	 WaveDifficulty(1)=0.8
	 WaveDifficulty(2)=0.9
	 WaveDifficulty(3)=1.0
	 WaveDifficulty(4)=1.1
	 WaveDifficulty(5)=1.2
	 WaveDifficulty(6)=1.3
	 // WaveStartDelay
	 WaveStartDelay(0)=10
	 WaveStartDelay(1)=10
	 WaveStartDelay(2)=8
	 WaveStartDelay(3)=8
	 WaveStartDelay(4)=8
	 WaveStartDelay(5)=6
	 WaveStartDelay(6)=6
	 // WaveDuration
	 WaveDuration(0)=(Min=2.0,RandMin=0.5,Max=4.0,RandMax=1.0)
	 WaveDuration(1)=(Min=2.5,RandMin=0.5,Max=5.0,RandMax=1.0)
	 WaveDuration(2)=(Min=3.0,RandMin=0.6,Max=6.0,RandMax=1.2)
	 WaveDuration(3)=(Min=3.5,RandMin=0.7,Max=7.0,RandMax=1.4)
	 WaveDuration(4)=(Min=4.0,RandMin=0.8,Max=8.0,RandMax=1.6)
	 WaveDuration(5)=(Min=4.5,RandMin=0.9,Max=9.0,RandMax=1.8)
	 WaveDuration(6)=(Min=5.0,RandMin=1.0,Max=10.0,RandMax=2.0)
	 // WaveBreakTime
	 WaveBreakTime(0)=(Min=90.0,Max=100.0)
	 WaveBreakTime(1)=(Min=90.0,Max=110.0)
	 WaveBreakTime(2)=(Min=100.0,Max=110.0)
	 WaveBreakTime(3)=(Min=100.0,Max=120.0)
	 WaveBreakTime(4)=(Min=110.0,Max=120.0)
	 WaveBreakTime(5)=(Min=110.0,Max=130.0)
	 WaveBreakTime(6)=(Min=120.0,Max=130.0)
	 // WaveDoorsRepairChance
	 WaveDoorsRepairChance(0)=(Min=1.0,Max=0.6)
	 WaveDoorsRepairChance(1)=(Min=1.0,Max=0.55)
	 WaveDoorsRepairChance(2)=(Min=1.0,Max=0.5)
	 WaveDoorsRepairChance(3)=(Min=1.0,Max=0.45)
	 WaveDoorsRepairChance(4)=(Min=1.0,Max=0.4)
	 WaveDoorsRepairChance(5)=(Min=1.0,Max=0.35)
	 WaveDoorsRepairChance(6)=(Min=1.0,Max=0.3)
	 // WaveStartingCash
	 WaveStartingCash(0)=(Min=240,Max=280)
	 WaveStartingCash(1)=(Min=260,Max=300)
	 WaveStartingCash(2)=(Min=280,Max=320)
	 WaveStartingCash(3)=(Min=300,Max=340)
	 WaveStartingCash(4)=(Min=320,Max=360)
	 WaveStartingCash(5)=(Min=340,Max=380)
	 WaveStartingCash(6)=(Min=360,Max=400)
	 // WaveMinRespawnCash
	 WaveMinRespawnCash(0)=(Min=200,Max=220)
	 WaveMinRespawnCash(1)=(Min=220,Max=240)
	 WaveMinRespawnCash(2)=(Min=240,Max=260)
	 WaveMinRespawnCash(3)=(Min=260,Max=280)
	 WaveMinRespawnCash(4)=(Min=280,Max=300)
	 WaveMinRespawnCash(5)=(Min=300,Max=320)
	 WaveMinRespawnCash(6)=(Min=320,Max=340)
	 // WaveDeathCashModifier
	 WaveDeathCashModifier(0)=(Min=0.98,Max=0.86)
	 WaveDeathCashModifier(1)=(Min=0.97,Max=0.85)
	 WaveDeathCashModifier(2)=(Min=0.96,Max=0.84)
	 WaveDeathCashModifier(3)=(Min=0.95,Max=0.83)
	 WaveDeathCashModifier(4)=(Min=0.94,Max=0.82)
	 WaveDeathCashModifier(5)=(Min=0.93,Max=0.81)
	 WaveDeathCashModifier(6)=(Min=0.92,Max=0.8)
	 
	 // BossWave
	 BossWaveNum=7
	 BossMonsterClassName="UnlimaginMod.UM_Monster_Boss_Standard"
	 BossWaveAliveMonsters=(Min=16,Max=48)
	 BossWaveMonsterSquadSize=(Min=12,RandMin=4,Max=36,RandMax=12)
	 BossWaveSquadsSpawnPeriod=(Min=40.0,RandMin=5.0,Max=40.0,RandMax=10.0)
	 BossWaveDifficulty=1.4
	 BossWaveStartDelay=6
	 BossWaveDoorsRepairChance=(Min=1.0,Max=0.2)
	 BossWaveStartingCash=(Min=400,Max=450)
	 BossWaveMinRespawnCash=(Min=340,Max=380)
	 
	 // Bloat
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterBloatData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Bloat_Standard"
		 MonsterClassNames(1)="UnlimaginMod.UM_Monster_Bloat_XXSmall"
		 MonsterClassNames(2)="UnlimaginMod.UM_Monster_Bloat_XSmall"
		 MonsterClassNames(3)="UnlimaginMod.UM_Monster_Bloat_Small"
		 MonsterClassNames(4)="UnlimaginMod.UM_Monster_Bloat_Large"
		 MonsterClassNames(5)="UnlimaginMod.UM_Monster_Bloat_XLarge"
		 MonsterClassNames(6)="UnlimaginMod.UM_Monster_Bloat_XXLarge"
		 SpecialMonsterChance=0.15
		 SpecialMonsterClassNames(0)="UnlimaginMod.UM_Monster_Bloat_Midget"
		 SpecialMonsterClassNames(1)="UnlimaginMod.UM_Monster_Bloat_XXTiny"
		 SpecialMonsterClassNames(2)="UnlimaginMod.UM_Monster_Bloat_XTiny"
		 SpecialMonsterClassNames(3)="UnlimaginMod.UM_Monster_Bloat_Tiny"
		 SpecialMonsterClassNames(4)="UnlimaginMod.UM_Monster_Bloat_Huge"
		 SpecialMonsterClassNames(5)="UnlimaginMod.UM_Monster_Bloat_XHuge"
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
		 bNoWaveDeltaLimit=True
		 /*
		 WaveDeltaLimit(0)=(Min=6,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=54.0,Max=20,MaxTime=32.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=48.0,Max=22,MaxTime=34.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=42.0,Max=22,MaxTime=32.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=36.0,Max=24,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=32.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=30.0,Max=26,MaxTime=30.0)
		 */
		 // BossWave
		 BossWaveSpawnChance=(Min=0.25,Max=0.35)
		 BossWaveSquadLimit=(Min=2,Max=8)
		 BossWaveDeltaLimit=(Min=2,MinTime=30.0,Max=16,MaxTime=60.0)
	 End Object
	 Monsters(0)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterBloatData'
	 
	 // Clot
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterClotData
		 // MonsterClassNames
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Clot_Standard"
		 MonsterClassNames(1)="UnlimaginMod.UM_Monster_Clot_XXSmall"
		 MonsterClassNames(2)="UnlimaginMod.UM_Monster_Clot_XSmall"
		 MonsterClassNames(3)="UnlimaginMod.UM_Monster_Clot_Small"
		 MonsterClassNames(4)="UnlimaginMod.UM_Monster_Clot_Large"
		 MonsterClassNames(5)="UnlimaginMod.UM_Monster_Clot_XLarge"
		 MonsterClassNames(6)="UnlimaginMod.UM_Monster_Clot_XXLarge"
		 // SpecialMonsterChance
		 SpecialMonsterChance=0.15
		 SpecialMonsterClassNames(0)="UnlimaginMod.UM_Monster_Clot_Midget"
		 SpecialMonsterClassNames(1)="UnlimaginMod.UM_Monster_Clot_XXTiny"
		 SpecialMonsterClassNames(2)="UnlimaginMod.UM_Monster_Clot_XTiny"
		 SpecialMonsterClassNames(3)="UnlimaginMod.UM_Monster_Clot_Tiny"
		 SpecialMonsterClassNames(4)="UnlimaginMod.UM_Monster_Clot_Huge"
		 SpecialMonsterClassNames(5)="UnlimaginMod.UM_Monster_Clot_XHuge"
		 bNoWaveRestrictions=True
		 // BossWave
		 BossWaveSpawnChance=(Min=1.0,Max=1.0)
		 BossWaveSquadLimit=(Min=12,Max=48)
		 BossWaveDeltaLimit=(Min=12,MinTime=10.0,Max=48,MaxTime=20.0)
	 End Object
	 Monsters(1)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterClotData'
	 
	 // Crawler
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterCrawlerData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Crawler_Standard"
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
		 WaveDeltaLimit(2)=(Min=4,MinTime=48.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(3)=(Min=4,MinTime=42.0,Max=16,MaxTime=26.0)
		 WaveDeltaLimit(4)=(Min=6,MinTime=48.0,Max=24,MaxTime=32.0)
		 WaveDeltaLimit(5)=(Min=6,MinTime=42.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=6,MinTime=36.0,Max=24,MaxTime=28.0)
		 // BossWave
		 BossWaveSpawnChance=(Min=0.15,Max=0.25)
		 BossWaveSquadLimit=(Min=2,Max=6)
		 BossWaveDeltaLimit=(Min=2,MinTime=40.0,Max=6,MaxTime=30.0)
	 End Object
	 Monsters(2)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterCrawlerData'
	 
	 // FleshPound
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterFleshPoundData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_FleshPound_Standard"
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
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=0,MaxTime=120.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=120.0,Max=1,MaxTime=120.0)
		 WaveDeltaLimit(2)=(Min=0,MinTime=120.0,Max=2,MaxTime=120.0)
		 WaveDeltaLimit(3)=(Min=0,MinTime=120.0,Max=3,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=3,MaxTime=100.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=110.0,Max=4,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=100.0,Max=4,MaxTime=100.0)
		 // BossWave
		 BossWaveSpawnChance=(Min=0.0,Max=0.1)
		 BossWaveSquadLimit=(Min=1,Max=1)
		 BossWaveDeltaLimit=(Min=1,MinTime=120.0,Max=1,MaxTime=60.0)
	 End Object
	 Monsters(3)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterFleshPoundData'
	 
	 // GoreFast
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterGoreFastData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_GoreFast_Standard"
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
		 bNoWaveDeltaLimit=True
		 /*
		 WaveDeltaLimit(0)=(Min=4,MinTime=30.0,Max=16,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=30.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(2)=(Min=6,MinTime=24.0,Max=18,MaxTime=24.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=30.0,Max=24,MaxTime=30.0)
		 WaveDeltaLimit(4)=(Min=8,MinTime=24.0,Max=24,MaxTime=24.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=30.0,Max=30,MaxTime=30.0)
		 WaveDeltaLimit(6)=(Min=10,MinTime=24.0,Max=30,MaxTime=24.0)
		 */
		 // BossWave
		 BossWaveSpawnChance=(Min=0.35,Max=0.45)
		 BossWaveSquadLimit=(Min=3,Max=10)
		 BossWaveDeltaLimit=(Min=3,MinTime=20.0,Max=20,MaxTime=30.0)
	 End Object
	 Monsters(4)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterGoreFastData'
	 
	 // Husk
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterHuskData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_FireBallHusk_Standard"
		 MonsterClassNames(1)="UnlimaginMod.UM_Monster_RocketHusk_Standard"
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
		 WaveSquadLimit(2)=(Min=1,Max=3)
		 WaveSquadLimit(3)=(Min=1,Max=3)
		 WaveSquadLimit(4)=(Min=1,Max=4)
		 WaveSquadLimit(5)=(Min=1,Max=4)
		 WaveSquadLimit(6)=(Min=1,Max=4)
		 // WaveDeltaLimit
		 WaveDeltaLimit(0)=(Min=0,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(1)=(Min=1,MinTime=120.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=120.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=120.0,Max=6,MaxTime=120.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=90.0,Max=8,MaxTime=120.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=8,MaxTime=120.0)
		 WaveDeltaLimit(6)=(Min=1,MinTime=60.0,Max=8,MaxTime=120.0)
		 // BossWave
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=4,MaxTime=60.0)
	 End Object
	 Monsters(5)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterHuskData'
	 
	 // Scrake
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterScrakeData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Scrake_Standard"
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
		 WaveDeltaLimit(0)=(Min=0,MinTime=240.0,Max=1,MaxTime=60.0)
		 WaveDeltaLimit(1)=(Min=0,MinTime=240.0,Max=2,MaxTime=60.0)
		 WaveDeltaLimit(2)=(Min=1,MinTime=240.0,Max=3,MaxTime=60.0)
		 WaveDeltaLimit(3)=(Min=1,MinTime=180.0,Max=4,MaxTime=90.0)
		 WaveDeltaLimit(4)=(Min=1,MinTime=120.0,Max=4,MaxTime=80.0)
		 WaveDeltaLimit(5)=(Min=1,MinTime=90.0,Max=6,MaxTime=90.0)
		 WaveDeltaLimit(6)=(Min=2,MinTime=90.0,Max=8,MaxTime=120.0)
		 // BossWave
		 BossWaveSpawnChance=(Min=0.0,Max=0.15)
		 BossWaveSquadLimit=(Min=1,Max=2)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=2,MaxTime=60.0)
	 End Object
	 Monsters(6)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterScrakeData'
	 
	 // Siren
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterSirenData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Siren_Standard"
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
		 BossWaveSpawnChance=(Min=0.1,Max=0.2)
		 BossWaveSquadLimit=(Min=1,Max=3)
		 BossWaveDeltaLimit=(Min=1,MinTime=60.0,Max=3,MaxTime=60.0)
	 End Object
	 Monsters(7)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterSirenData'
	 
	 // Stalker
	 Begin Object Class=UM_InvasionMonsterData Name=UM_MonsterStalkerData
		 MonsterClassNames(0)="UnlimaginMod.UM_Monster_Stalker_Standard"
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
		 bNoWaveDeltaLimit=True
		 /*
		 WaveDeltaLimit(0)=(Min=4,MinTime=60.0,Max=18,MaxTime=30.0)
		 WaveDeltaLimit(1)=(Min=6,MinTime=60.0,Max=24,MaxTime=42.0)
		 WaveDeltaLimit(2)=(Min=8,MinTime=60.0,Max=24,MaxTime=36.0)
		 WaveDeltaLimit(3)=(Min=8,MinTime=56.0,Max=30,MaxTime=42.0)
		 WaveDeltaLimit(4)=(Min=10,MinTime=60.0,Max=30,MaxTime=36.0)
		 WaveDeltaLimit(5)=(Min=10,MinTime=56.0,Max=36,MaxTime=42.0)
		 WaveDeltaLimit(6)=(Min=12,MinTime=56.0,Max=36,MaxTime=36.0)
		 */
		 // BossWave
		 BossWaveSpawnChance=(Min=0.3,Max=0.4)
		 BossWaveSquadLimit=(Min=3,Max=8)
		 BossWaveDeltaLimit=(Min=6,MinTime=60.0,Max=12,MaxTime=30.0)
	 End Object
	 Monsters(8)=UM_InvasionMonsterData'UnlimaginMod.UM_InvasionGame.UM_MonsterStalkerData'
 
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