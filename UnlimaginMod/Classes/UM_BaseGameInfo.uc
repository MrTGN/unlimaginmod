/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseGameInfo
	Creation date:	 28.01.2015 03:23
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
	Comment:		 
==================================================================================*/
class UM_BaseGameInfo extends KFGameType
	CacheExempt
	HideDropdown
	NotPlaceable
	Abstract;

//========================================================================
//[block] Variables

// Constants
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';
const	Maths = Class'UnlimaginMod.UnlimaginMaths';

// Int Range
struct IRange
{
	var()	config	int		Min;
	var()	config	int		Max;
};

struct IRandRange
{
	var()	config	int		Min;
	var()	config	int		RandMin;
	var()	config	int		Max;
	var()	config	int		RandMax;
};

struct FRandRange
{
	var()	config	float	Min;
	var()	config	float	RandMin;
	var()	config	float	Max;
	var()	config	float	RandMax;
};

// Do slomo event when was killed a specified number of victims
struct DramaticKillData
{
	var()	config	int		MinKilled;
	var()	config	float	EventChance;
	var()	config	float	EventDuration;
};
var					array<DramaticKillData>	DramaticKills;

var					class<Bot>				BotClass;

var					string					GameReplicationInfoClassName;

var					Class<KFLevelRules>		DefaultLevelRulesClass;
var					string					LoginMenuClassName;

var					float					SpeedingBackZEDTime;
var					float					BotAtHumanFriendlyFireScale;

// Will be config string at release version
var					string					GamePresetClassName;
var					UM_BaseGamePreset		GamePreset;

var		transient	float					DefaultGameSpeed;	// Sets in the InitGame event

var					float					MinGameDifficulty, MaxGameDifficulty;
var		transient	float					LastGameDifficulty;	// For the Unauthorized Changes Check
var					int						MinHumanPlayers, MaxHumanPlayers;

var					float					MaxFriendlyFireScale;	// Min FriendlyFireScale = 0.0
var		transient	float					LastFriendlyFireScale;	// For the Unauthorized Changes Check

var					UM_HumanPawn			SlowMoInstigator;
var		transient	float					SlowMoDeltaTime;
var		const		float					DelayBetweenSlowMoToggle;
var		transient	float					NextSlowMoToggleTime;
var					float					MinToggleSlowMoCharge;

var		transient	bool					bSlowMoStartedByHuman;

var					bool					bSaveSpectatorScores, bSaveSpectatorTeam;

// Starting Cash lottery
var					float					ExtraStartingCashChance, ExtraStartingCashModifier;
var					float					DeathCashModifier;
var		transient	bool					bAllowPlayerSpawn;

// Controllers Lists
var		transient	array<UM_PlayerController>	PlayerList;
var		transient	array<UM_PlayerController>	SpectatorList;
var		transient	array<Bot>				BotList;
var		transient	int						NumActivePlayers;

var					float					UnauthorizedChangesCheckDelay;
var					float					NextUnauthorizedChangesCheckTime;

var					name					MatchStateName;
var		config		bool					bAllowImpressiveKillEvents;
var		config		bool					bShowImpressiveKillEvents;
var		config		bool					bAllowDramaticEvents;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Cleanup old functions
function Bot MySpawnBot( optional string BotName );
event PostNetBeginPlay();
function StartMatch();
exec function KillZeds();
function DoBossDeath();
function array<IMClassList> LoadUpMonsterListFromGameType();
function array<IMClassList> LoadUpMonsterListFromCollection();
function LoadUpMonsterList();
simulated function PrepareSpecialSquadsFromGameType();
simulated function PrepareSpecialSquadsFromCollection();
simulated function PrepareSpecialSquads();
function UpdateGameLength();
function AddMonster();
function SetupWaveBot(Inventory BotsInv);
function WarningTimer();
function UpdateViews();
function bool BootShopPlayers();
state MatchInProgress
{
	event BeginState();
	function bool UpdateMonsterCount();
	function bool BootShopPlayers();
	function SelectShop();
	function OpenShops();
	function CloseShops();
	function Timer();
	function float CalcNextSquadSpawnTime();
	function DoWaveEnd();
	function InitMapWaveCfg();
	function StartWaveBoss();
	function UpdateViews();
	function SetupPickups();
	event EndState();
}
function PlayEndOfMatchMessage();
function PlayStartupMessage();
function SetupWave();
function BuildNextSquad();
function AddSpecialSquadFromGameType();
function AddSpecialSquadFromCollection();
function AddSpecialSquad();
function bool AddSquad();
function bool AddBoss();
function AddBossBuddySquad();
function AddSpecialPatriarchSquadFromGameType();
function AddSpecialPatriarchSquadFromCollection();
function AddSpecialPatriarchSquad();
function CheckHarchierAchievement();
static event class<GameInfo> SetGameType( string MapName )
{
	Return default.Class;
}
function string GetEventClotClassName();
function string GetEventCrawlerClassName();
function string GetEventGoreFastClassName();
function string GetEventStalkerClassName();
function string GetEventScrakeClassName();
function string GetEventFleshpoundClassName();
function string GetEventBloatClassName();
function string GetEventSirenClassName();
function string GetEventHuskClassName();
exec function DumpZedSquads(int MyKFGameLength);

//[end] Cleanup old functions
//====================================================================

//========================================================================
//[block] Functions

function NotifyNumPlayersChanged();

//[block] PlayerList
protected function CheckPlayerList()
{
	local	byte	i, j;
	
	for ( i = 0; i < PlayerList.Length; ++i )  {
		// Check for broken reference
		if ( PlayerList[i] == None )  {
			PlayerList.Remove(i, 1);
			--i;
		}
		else if ( PlayerList[i].bIsActivePlayer )
			++j;
	}
	NumPlayers = PlayerList.Length;
	// Check for changes
	if ( NumActivePlayers != j )  {
		NumActivePlayers = j;
		NotifyNumPlayersChanged();
	}
}

protected function AddToPlayerList( PlayerController PC )
{
	if ( UM_PlayerController(PC) == None )
		Return;
	
	PlayerList[PlayerList.Length] = UM_PlayerController(PC);
	// Check for broken reference
	CheckPlayerList();
}

protected function RemoveFromPlayerList( PlayerController PC )
{
	local	byte	i;
	
	if ( PC != None )  {
		// Find PlayerController
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i] == PC )  {
				PlayerList.Remove(i, 1);
				Break;
			}
		}
	}
	// Check for broken reference
	CheckPlayerList();
}
//[end] PlayerList

//[block] SpectatorList
protected function CheckSpectatorList()
{
	local	byte	i;
	
	// Check for broken reference
	for ( i = 0; i < SpectatorList.Length; ++i )  {
		if ( SpectatorList[i] == None )  {
			SpectatorList.Remove(i, 1);
			--i;
		}
	}
	NumSpectators = SpectatorList.Length;
}

protected function AddToSpectatorList( PlayerController PC )
{
	if ( UM_PlayerController(PC) == None )
		Return;
	
	SpectatorList[SpectatorList.Length] = UM_PlayerController(PC);
	// Check for broken reference
	CheckSpectatorList();
}

protected function RemoveFromSpectatorList( PlayerController PC )
{
	local	byte	i;
	
	if ( PC != None )  {
		// Find PlayerController
		for ( i = 0; i < SpectatorList.Length; ++i )  {
			if ( SpectatorList[i] == PC )  {
				SpectatorList.Remove(i, 1);
				Break;
			}
		}
	}
	// Check for broken reference
	CheckSpectatorList();
}
//[end] SpectatorList

//[block] BotList
protected function CheckBotList()
{
	local	byte	i;
	
	// Check for broken reference
	for ( i = 0; i < BotList.Length; ++i )  {
		if ( BotList[i] == None )  {
			BotList.Remove(i, 1);
			--i;
		}
	}
	// Check for changes
	if ( NumBots != BotList.Length )  {
		NumBots = BotList.Length;
		NotifyNumPlayersChanged();
	}
}

protected function AddToBotList( Bot B )
{
	if ( B == None )
		Return;
	
	BotList[BotList.Length] = B;
	// Check for broken reference
	CheckBotList();
}

protected function RemoveFromBotList( Bot B )
{
	local	byte	i;
	
	if ( B != None )  {
		// Find Bot
		for ( i = 0; i < BotList.Length; ++i )  {
			if ( BotList[i] == B )  {
				BotList.Remove(i, 1);
				Break;
			}
		}
	}
	// Check for broken reference
	CheckBotList();
}
//[end] BotList

function UseCheats( bool bUseCheats )
{
	local	byte	i;
	
	// PlayerList
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i].SteamStatsAndAchievements != None )
			PlayerList[i].SteamStatsAndAchievements.bUsedCheats = bUseCheats;
	}
	
	// SpectatorList
	CheckSpectatorList();
	for ( i = 0; i < SpectatorList.Length; ++i )  {
		if ( SpectatorList[i].SteamStatsAndAchievements != None )
			SpectatorList[i].SteamStatsAndAchievements.bUsedCheats = bUseCheats;
	}
}

function NotifyGameDifficultyChanged();

exec function SetGameDifficulty( float NewGameDifficulty )
{
	GameDifficulty = FClamp( NewGameDifficulty, MinGameDifficulty, MaxGameDifficulty );
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )
		UM_GameReplicationInfo(GameReplicationInfo).GameDifficulty = GameDifficulty;
	// Check for changes
	if ( GameDifficulty != LastGameDifficulty )  {
		LastGameDifficulty = GameDifficulty;
		NotifyGameDifficultyChanged();
	}
}

// For the GUI buy menu
simulated function float GetDifficulty()
{
	Return GameDifficulty;
}

exec function SetFriendlyFireScale( float NewFriendlyFireScale )
{
	FriendlyFireScale = FClamp( NewFriendlyFireScale, 0.0, MaxFriendlyFireScale );
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )
		UM_GameReplicationInfo(GameReplicationInfo).FriendlyFireScale = FriendlyFireScale;
}

function bool AllowGameSpeedChange()
{
	if ( Level.NetMode == NM_Standalone )
		Return True;
	
	Return bAllowMPGameSpeed;
}

protected function bool LoadGamePreset( string NewPresetName )
{
	local	Class<UM_BaseGamePreset>	GamePresetClass;
	
	if ( NewPresetName == "" )  {
		Log( "Can't load new GamePreset. NewPresetName is not specified!", Class.Outer.Name );
		Return False;
	}
	
	GamePresetClass = Class<UM_BaseGamePreset>( DynamicLoadObject(NewPresetName, Class'Class') );
	if ( GamePresetClass == None )  {
		Warn( "GamePreset wasn't found!");
		Return False;
	}
	
	GamePresetClassName = NewPresetName;
	GamePreset = new(Self) GamePresetClass;
	
	if ( GamePreset == None )
		Return False;
	
	// HumanPlayers Limit
	MinHumanPlayers = GamePreset.MinHumanPlayers;
	MaxHumanPlayers = GamePreset.MaxHumanPlayers;
	// GameDifficulty Limit
	MinGameDifficulty = GamePreset.MinGameDifficulty;
	MaxGameDifficulty = GamePreset.MaxGameDifficulty;
	
	Log("GamePreset" @string(GamePreset.Name) @"loaded", Class.Outer.Name);
	
	Return True;
}

function SetupLevelRules()
{
	local	KFLevelRules	KFLR;
	
	// LevelRules
	foreach DynamicActors( class'KFLevelRules', KFLR )  {
		if ( KFLRules == None )
			KFLRules = KFLR;
		else 
			Warn("MULTIPLE KFLEVELRULES FOUND!!!!!");
	}
	
	// Provide default rules if mapper did not need custom one
	if ( KFLRules == None )
		KFLRules = Spawn(DefaultLevelRulesClass);
	
	Log("KFLRules = "$KFLRules, Name);
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
	
	Super(xTeamGame).InitGame(Options, Error);
	
	InOpt = ParseOption(Options, "GamePresetClassName");
	// Try to load GamePresetClassName from command option first
	if ( InOpt != "" )
		LoadGamePreset( InOpt );
	// Load default GamePresetClassName if specified
	else if ( GamePresetClassName != "" )
		LoadGamePreset( GamePresetClassName );
	
	SetupLevelRules();
	DefaultGameSpeed = default.GameSpeed;
	// Clamping MaxPlayers
	MaxPlayers = Clamp( MaxHumanPlayers, MinHumanPlayers, 32 );
}

// Spawn GameReplicationInfo and setup replicated variables
function InitGameReplicationInfo()
{
	if ( GameReplicationInfoClass == None )
		GameReplicationInfoClass = Class<GameReplicationInfo>( DynamicLoadObject(GameReplicationInfoClassName, Class'Class') );
	
	if ( GameReplicationInfoClass == None )  {
		Warn("GameReplicationInfoClass wasn't found!!!");
		Return;
	}
	
	GameReplicationInfo = Spawn( GameReplicationInfoClass, self );
	if ( GameReplicationInfo == None )  {
		Warn("GameReplicationInfo has not created!!!");
		Return;
	}
	
	Level.GRI = GameReplicationInfo;
	// Clamping GameDifficulty wich was read from the config file
	SetGameDifficulty( GameDifficulty );
	// Clamping FriendlyFireScale wich was read from the config file
	SetFriendlyFireScale( FriendlyFireScale );
	
	//[block] From Invasion.uc class
	// WaveNumbers sets in the InitGame() function
	if ( InvasionGameReplicationInfo(GameReplicationInfo) != None )  {
		InvasionGameReplicationInfo(GameReplicationInfo).WaveNumber = WaveNum;
		InvasionGameReplicationInfo(GameReplicationInfo).BaseDifficulty = int(GameDifficulty);
		InvasionGameReplicationInfo(GameReplicationInfo).FinalWave = FinalWave;
	}
	GameReplicationInfo.bNoTeamSkins = True;
	GameReplicationInfo.bForceNoPlayerLights = True;
	GameReplicationInfo.bNoTeamChanges = True;
	//[end]
	
	if ( KFGameReplicationInfo(GameReplicationInfo) != None )  {
		KFGameReplicationInfo(GameReplicationInfo).bNoBots = bNoBots;
		KFGameReplicationInfo(GameReplicationInfo).PendingBots = 0;
		KFGameReplicationInfo(GameReplicationInfo).GameDiff = GameDifficulty;	// Left this var for compatibility with the old code
		KFGameReplicationInfo(GameReplicationInfo).bEnemyHealthBars = bEnemyHealthBars;
	}
}

// Called immediately before gameplay begins but after the InitGame() function
event PreBeginPlay()
{
	StartTime = 0;
	// Create GameReplicationInfo actor.
	InitGameReplicationInfo();
	InitVoiceReplicationInfo();
	// Create stat logging actor.
	InitLogging();
}

event Timer()
{
	Super(Invasion).Timer();
	
	if ( ElapsedTime % 10 == 0 )
		UpdateSteamUserData();
}

function bool NeedPlayers()
{
	if ( Level.NetMode == NM_Standalone )
		Return RemainingBots > 0;
		
	if ( bMustJoinBeforeStart )
		Return False;
	
	if ( bPlayersVsBots )
		Return NumBots < Min((MaxPlayers / 2), (BotRatio * NumPlayers));
	
	Return (NumActivePlayers + NumBots) < MinPlayers;
}

function bool ChangeTeam( Controller Other, int num, bool bNewTeam )
{
	if ( Other == None || Other.PlayerReplicationInfo == None )
		Return False;
	
	if ( PlayerController(Other) != None && Other.PlayerReplicationInfo.bOnlySpectator )  {
		Other.PlayerReplicationInfo.Team = None;
		Return True;
	}
	
	// check if already on this team
	if ( Other.PlayerReplicationInfo.Team == Teams[0] )
		Return False;
	
	Other.StartSpot = None;
	if ( PlayerController(Other) != None && Teams[0].AddToTeam(Other) && bNewTeam )
		GameEvent( "TeamChange", ""$num, Other.PlayerReplicationInfo );

	Return True;
}

function UnrealTeamInfo GetBotTeam( optional int TeamBots )
{
	if ( bPlayersVsBots && Level.NetMode != NM_Standalone )
		Return Teams[0];
	
	// Human Team
	Return Teams[1];
}

static function string GetValidCharacter( string S )
{
	local	int		i;

	if ( S != "" )  {
		for( i = 0; i < Default.AvailableChars.Length; ++i )  {
			if ( Default.AvailableChars[i] ~= S )
				Return Default.AvailableChars[i];
		}
	}
	
	Return Default.AvailableChars[ Rand( Default.AvailableChars.Length ) ];
}

function Bot SpawnBot( optional string BotName )
{
	local	Bot				NewBot;
	local	RosterEntry		Chosen;
	local	UnrealTeamInfo	BotTeam;

	BotTeam = GetBotTeam();
	Chosen = BotTeam.ChooseBotClass( BotName );

	if ( Chosen.PawnClass == None )
		Chosen.Init(); //amb
	
	NewBot = Spawn( BotClass );
	if ( NewBot != None )
		InitializeBot( NewBot, BotTeam, Chosen );

	// Bot should be a veteran.
	if ( LoadedSkills.Length > 0 && KFPlayerReplicationInfo(NewBot.PlayerReplicationInfo) != None )
		KFPlayerReplicationInfo(NewBot.PlayerReplicationInfo).ClientVeteranSkill = LoadedSkills[Rand(LoadedSkills.Length)];
	// StartingCash
	CheckStartingCash( NewBot );

	Return NewBot;
}

function bool AddBot( optional string BotName )
{
	local	Bot		NewBot;
	
	if ( bNoBots )
		Return False;
	
	NewBot = SpawnBot( BotName );
	if ( NewBot == None )  {
		Warn("Failed to spawn bot.");
		Return False;
	}

	NewBot.PlayerReplicationInfo.PlayerID = CurrentID++;
	AddToBotList( NewBot );
	
	if ( Level.NetMode == NM_Standalone )
		RestartPlayer(NewBot);
	else
		NewBot.GotoState('Dead','MPStart');
	
	Return True;
}

exec function MyForceAddBot()
{
	AddBot();
}

exec function AddNamedBot( string BotName )
{
	UseCheats( True );

	if ( Level.NetMode != NM_Standalone )
		MinPlayers = Max( (MinPlayers + 1), (NumPlayers + NumBots + 1 ) );
	
	AddBot( BotName );
}

exec function AddBots( int num )
{
	UseCheats( True );

	for ( num = Clamp(num, 0, (MaxPlayers - (NumPlayers + NumBots))); num > 0; --num )  {
		if ( Level.NetMode != NM_Standalone )
			MinPlayers = Max( (MinPlayers + 1), (NumPlayers + NumBots + 1 ) );
		
		AddBot();
	}
}

function CheckStartingCash( Controller C )
{
	if ( C == None || C.PlayerReplicationInfo == None )
		Return;
	
	// StartingCash lottery
	if ( FRand() <= ExtraStartingCashChance )
		C.PlayerReplicationInfo.Score += float(StartingCash) * ExtraStartingCashModifier;
	else if ( C.PlayerReplicationInfo.Score < float(StartingCash) )
		C.PlayerReplicationInfo.Score = float(StartingCash);
}

function RespawnWaitingPlayers()
{
	local	byte	i;
	
	for ( i = 0; i < PlayerList.Length; ++i )  {
		if ( PlayerList[i] == None || PlayerList[i].PlayerReplicationInfo == None || !PlayerList[i].CanRestartPlayer() )
			Continue; // Skip this player

		// Player will be respawned after the death
		if ( PlayerList[i].PlayerReplicationInfo.Deaths > 0 )
			PlayerList[i].PlayerReplicationInfo.Score = FMax( float(MinRespawnCash), PlayerList[i].PlayerReplicationInfo.Score );
		// Spawn a new waiting player
		else
			CheckStartingCash( PlayerList[i] );
		
		PlayerList[i].GotoState('PlayerWaiting');
		// Respawn a pawn and it as set view target
		PlayerList[i].ServerReStartPlayer();
		PlayerList[i].ClientResetViewTarget();
		PlayerList[i].ServerResetViewTarget();
	}
	CheckPlayerList();
}

// Active player wants to become a spectator
function bool BecomeSpectator( PlayerController P )
{
	if ( P == None || P.PlayerReplicationInfo == None )
		Return False;
	
	if ( P.PlayerReplicationInfo.bOnlySpectator || NumSpectators >= MaxSpectators
		 || P.IsInState('GameEnded') || P.IsInState('RoundEnded') )  {
		P.ReceiveLocalizedMessage(GameMessageClass, 12);
		Return False;
	}

	P.PlayerReplicationInfo.bOnlySpectator = True;
	if ( !bSaveSpectatorScores )
		P.PlayerReplicationInfo.Reset();
	if ( P.PlayerReplicationInfo.Team != None )
		P.PlayerReplicationInfo.Team.RemoveFromTeam(P);
	if ( !bSaveSpectatorTeam )
		P.PlayerReplicationInfo.Team = None;
	
	AddToSpectatorList( P );
	RemoveFromPlayerList( P );
		
	if ( !bKillBots )
		++RemainingBots;
	
	if ( !NeedPlayers() || AddBot() )
		--RemainingBots;

	Return True;
}

function bool AllowBecomeActivePlayer( PlayerController P )
{
	if ( P == None || P.PlayerReplicationInfo == None )
		Return False;
	
	if ( !P.PlayerReplicationInfo.bOnlySpectator || !GameReplicationInfo.bMatchHasBegun
		 || bMustJoinBeforeStart || NumPlayers >= MaxPlayers || MaxLives > 0
		 || P.IsInState('GameEnded') || P.IsInState('RoundEnded') )  {
		P.ReceiveLocalizedMessage(GameMessageClass, 13);
		Return False;
	}
	
	if ( Level.NetMode == NM_Standalone && NumBots > InitialBots )  {
		--RemainingBots;
		bPlayerBecameActive = True;
	}
	
	Return True;
}

// Spectating player become active and join the game
function BecomeActivePlayer( PlayerController P )
{
	AddToPlayerList( P );
	RemoveFromSpectatorList( P );
	
	if ( !bSaveSpectatorScores )
		P.PlayerReplicationInfo.Reset();
	
	CheckStartingCash( P );
	
	P.PlayerReplicationInfo.bOnlySpectator = False;
	if ( bTeamGame )  {
		if ( P.PlayerReplicationInfo.Team != None )
			ChangeTeam(P, P.PlayerReplicationInfo.Team.TeamIndex, false);
		else
			ChangeTeam(P, PickTeam(int(GetURLOption("Team")), None), false);
	}
}

// Return True if player slots are fill
function bool AtCapacity( bool bSpectator )
{
	if ( Level.NetMode == NM_Standalone )
		Return False;

	if ( bSpectator )
		Return ( NumSpectators >= MaxSpectators && (Level.NetMode != NM_ListenServer || NumPlayers > 0) );
	else
		Return ( MaxPlayers > 0 && NumPlayers >= MaxPlayers );
}

function SendPlayer( PlayerController aPlayer, string URL )
{
	if ( bGameEnded || aPlayer == None || aPlayer.PlayerReplicationInfo == None )
		Return;
	
	Broadcast( Self, aPlayer.PlayerReplicationInfo.PlayerName@"has ended the level." );
	
	if ( Left(URL, 4) ~= "NULL" )  {
		WaveNum = FinalWave;
		EndGame(None,"TimeLimit");
		Return;
	}
	bGameEnded = True;
	Level.ServerTravel(URL, False);
}

// Player Can be restarted
function bool PlayerCanRestart( PlayerController aPlayer )
{
	Return bAllowPlayerSpawn;
}

// Mod this to include the choices made in the GUIClassMenu
function RestartPlayer( Controller aPlayer )
{
	if ( aPlayer == None || aPlayer.PlayerReplicationInfo.bOutOfLives || (aPlayer.Pawn != None && !aPlayer.Pawn.bDeleteMe) )
		Return;

	if ( PlayerController(aPlayer) != None && !PlayerCanRestart(PlayerController(aPlayer)) )  {
		aPlayer.PlayerReplicationInfo.bOutOfLives = True;
		aPlayer.PlayerReplicationInfo.NumLives = MaxLives;
		aPlayer.GoToState('Spectating');
		Return;
	}

	// Spawn Player
	Super(GameInfo).RestartPlayer(aPlayer);
	
	if ( UM_PlayerController(aPlayer) != None && !UM_PlayerController(aPlayer).bIsActivePlayer )
		UM_PlayerController(aPlayer).bIsActivePlayer = True;

	// Notifying that the Veterancy info has changed
	if ( UM_PlayerReplicationInfo(aPlayer.PlayerReplicationInfo) != None )
		UM_PlayerReplicationInfo(aPlayer.PlayerReplicationInfo).NotifyVeterancyChanged();
	
	// Disable pawn collision during trader time
	if ( bTradingDoorsOpen && aPlayer.bIsPlayer )
		aPlayer.Pawn.bBlockActors = False;
}

/*	Log a player in.
	Fails login if you set the Error string.
	PreLogin is called before Login, but significant game time may pass before
	Login is called, especially if content is downloaded.	*/
event PlayerController Login( string Portal, string Options, out string Error )
{
	local	NavigationPoint		StartSpot;
	local	PlayerController	NewPlayer, TestPlayer;
	local	string				InName, InAdminName, InPassword, InChecksum, InCharacter,InSex;
	local	byte				InTeam;
	local	bool				bSpectator, bAdmin;
	local	class<Security>		MySecurityClass;
	local	Pawn				TestPawn;
	local	Controller			C;

	Options = StripColor(Options);  // Strip out color Codes

	BaseMutator.ModifyLogin(Portal, Options);

	// Get URL options.
	InName     = Left(ParseOption ( Options, "Name"), 20);
	InTeam     = GetIntOption( Options, "Team", 255 ); // default to "no team"
	InAdminName= ParseOption ( Options, "AdminName");
	InPassword = ParseOption ( Options, "Password" );
	InChecksum = ParseOption ( Options, "Checksum" );

	if ( HasOption(Options, "Load") )  {
		log("Loading Savegame");
		InitSavedLevel();
		bIsSaveGame = True;

		// Try to match up to existing unoccupied player in level,
		// for savegames - also needed coop level switching.
		ForEach DynamicActors( class'PlayerController', TestPlayer )  {
			if ( TestPlayer.Player == None && TestPlayer.PlayerOwnerName ~= InName )  {
				TestPawn = TestPlayer.Pawn;
				if ( TestPawn != None )
					TestPawn.SetRotation(TestPawn.Controller.Rotation);
				log("FOUND "$TestPlayer@TestPlayer.PlayerReplicationInfo.PlayerName);
				Return TestPlayer;
			}
		}
	}
	
	//[block] From DeathMatch class
	// check that game isn't too far along
	if ( MaxLives > 0 )  {
		for ( C = Level.ControllerList; C != None; C = C.NextController )  {
			if ( C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.NumLives > LateEntryLives )  {
				Options = "?SpectatorOnly=1"$Options;
				Break;
			}
		}
	}
	//[end]

	bSpectator = ( ParseOption( Options, "SpectatorOnly" ) ~= "1" );
	if ( AccessControl != None )
		bAdmin = AccessControl.CheckOptionsAdmin(Options);

	// Make sure there is capacity except for admins. (This might have changed since the PreLogin call).
	if ( !bAdmin && AtCapacity(bSpectator) )  {
		Error = GameMessageClass.Default.MaxedOutMessage;
		Return None;
	}
	// If admin, force spectate mode if the server already full of reg. players
	else if ( bAdmin && AtCapacity(false) )
		bSpectator = True;

	// Pick a team (if need teams)
	InTeam = PickTeam(InTeam,None);

	// Find a start spot.
	StartSpot = FindPlayerStart( None, InTeam, Portal );

	if ( StartSpot == None )  {
		Error = GameMessageClass.Default.FailedPlaceMessage;
		Return None;
	}

	if ( PlayerControllerClass == None )
		PlayerControllerClass = class<PlayerController>(DynamicLoadObject(PlayerControllerClassName, class'Class'));

	// Forcing to use only UnlimaginMod PlayerControllerClass and sub-classes
	if ( Class<UM_PlayerController>(PlayerControllerClass) != None )
		NewPlayer = Spawn(PlayerControllerClass,,,StartSpot.Location,StartSpot.Rotation);

	// Handle spawn failure.
	if ( NewPlayer == None )  {
		log("Couldn't spawn player controller of class "$PlayerControllerClass);
		Error = GameMessageClass.Default.FailedSpawnMessage;
		Return None;
	}

	NewPlayer.StartSpot = StartSpot;
	// Init player's replication info
	NewPlayer.GameReplicationInfo = GameReplicationInfo;

	// Apply security to this controller
	MySecurityClass = class<Security>(DynamicLoadObject(SecurityClass,class'class'));
	if ( MySecurityClass != None )  {
		NewPlayer.PlayerSecurity = Spawn( MySecurityClass, NewPlayer );
		if ( NewPlayer.PlayerSecurity == None )
			log("Could not spawn security for player "$NewPlayer,'Security');
	}
	else if ( SecurityClass == "" )
		log("No value for Engine.GameInfo.SecurityClass -- System is not secure.",'Security');
	else
		log("Unknown security class ["$SecurityClass$"] -- System is not secure.",'Security');

	if ( bAttractCam )
		NewPlayer.GotoState('AttractMode');
	else
		NewPlayer.GotoState('Spectating');

	// Init player's name
	if ( InName == "" )
		InName = DefaultPlayerName;
	
	if ( Level.NetMode != NM_Standalone || NewPlayer.PlayerReplicationInfo.PlayerName == DefaultPlayerName )
		ChangeName( NewPlayer, InName, false );

	// custom voicepack
	NewPlayer.PlayerReplicationInfo.VoiceTypeName = ParseOption ( Options, "Voice");

	InCharacter = ParseOption(Options, "Character");
	NewPlayer.SetPawnClass(DefaultPlayerClassName, InCharacter);
	InSex = ParseOption(Options, "Sex");
	if ( Left(InSex,3) ~= "F" )
		NewPlayer.SetPawnFemale();  // only effective if character not valid

	// Set the player's ID.
	NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

	if ( bSpectator || NewPlayer.PlayerReplicationInfo.bOnlySpectator || !ChangeTeam(NewPlayer, InTeam, false) )  {
		NewPlayer.PlayerReplicationInfo.bOnlySpectator = True;
		NewPlayer.PlayerReplicationInfo.bIsSpectator = True;
		NewPlayer.PlayerReplicationInfo.bOutOfLives = True;
		AddToSpectatorList( NewPlayer );

		Return NewPlayer;
	}

	NewPlayer.StartSpot = StartSpot;

	// Init player's administrative privileges and log it
	if ( AccessControl != None && AccessControl.AdminLogin(NewPlayer, InAdminName, InPassword) )
		AccessControl.AdminEntered(NewPlayer, InAdminName);

	AddToPlayerList( NewPlayer );
	if ( NumPlayers > 20 )
		bLargeGameVOIP = True;
	
	bWelcomePending = True;

	if ( bTestMode )
		TestLevel();

	//[block] From UnrealMPGameInfo class
	if ( Level.NetMode == NM_ListenServer )  {
		NewPlayer.VoiceReplicationInfo = VoiceReplicationInfo;
		if ( NewPlayer == Level.GetLocalPlayerController() )
			NewPlayer.InitializeVoiceChat();
	}
	else if ( Level.NetMode == NM_DedicatedServer )
		NewPlayer.VoiceReplicationInfo = VoiceReplicationInfo;
	//[end]
	
	//[block] From DeathMatch class
	if ( bMustJoinBeforeStart && GameReplicationInfo.bMatchHasBegun )
		UnrealPlayer(NewPlayer).bLatecomer = True;

	if ( Level.NetMode == NM_Standalone )  {
		if ( !NewPlayer.PlayerReplicationInfo.bOnlySpectator )
			StandalonePlayer = NewPlayer;
		// Compensate for the space left for the player
		else if ( !bCustomBots && (bAutoNumBots || (bTeamGame && (InitialBots%2 == 1))) )
			InitialBots++;
	}
	//[end]
	
	//[block] From KFGameType Class
	if ( !NewPlayer.PlayerReplicationInfo.bOnlySpectator )
		CheckStartingCash( NewPlayer );
	
	if ( !GameReplicationInfo.bMatchHasBegun )  {
		for ( C = Level.ControllerList; C != None; C = C.NextController )  {
			if ( C.PlayerReplicationInfo != None && C.PlayerReplicationInfo.bOutOfLives && !C.PlayerReplicationInfo.bOnlySpectator )  {
				NewPlayer.PlayerReplicationInfo.bOutOfLives = True;
				NewPlayer.PlayerReplicationInfo.NumLives = MaxLives;
				Break;
			}
		}
	}
	//[end]
	
	// if delayed start, don't give a pawn to the player yet
	// Normal for multiplayer games
	if ( bDelayedStart )
		NewPlayer.GotoState('PlayerWaiting');
	
	Return NewPlayer;
}

/*	Called after a successful login. This is the first place
	it is safe to call replicated functions on the PlayerController.	*/
event PostLogin( PlayerController NewPlayer )
{
	local	class<HUD>			HUDClass;
	local	class<Scoreboard>	ScoreboardClass;
	
	if ( NewPlayer == None || NewPlayer.PlayerReplicationInfo == None )
		Return;
	
	NewPlayer.SetGRI(GameReplicationInfo);
	
	if ( !bIsSaveGame )  {
		// Log player's login.
		if ( GameStats != None )  {
			GameStats.ConnectEvent(NewPlayer.PlayerReplicationInfo);
			GameStats.GameEvent("NameChange", NewPlayer.PlayerReplicationInfo.PlayerName, NewPlayer.PlayerReplicationInfo );
		}

		if ( !bDelayedStart )  {
			// start match, or let player enter, immediately
			bRestartLevel = False;  // let player spawn once in levels that must be restarted after every death
			if ( bWaitingToStartMatch )
				StartMatch();
			else
				RestartPlayer(NewPlayer);
			bRestartLevel = default.bRestartLevel;
		}
	}
	
	// tell client what hud and scoreboard to use
	if ( HUDType == "" )
		log( "No HUDType specified in GameInfo", 'Log' );
	else  {
		HUDClass = Class<HUD>( DynamicLoadObject(HUDType, Class'Class') );
		if ( HUDClass == None )
			log( "Can't find HUD class "$HUDType, 'Error' );
	}
	
	if ( ScoreBoardType == "" )
		log( "No ScoreboardClass specified in GameInfo", 'Log' );
	else  {
		ScoreboardClass = Class<Scoreboard>( DynamicLoadObject(ScoreBoardType, Class'Class') );
		if ( ScoreboardClass == None )
			log( "Can't find ScoreBoard class "$ScoreBoardType, 'Error' );
	}
	
	NewPlayer.ClientSetHUD( HUDClass, ScoreboardClass );
	SetWeaponViewShake( NewPlayer );
	
	if ( bIsSaveGame )
		Return;
	
	if ( NewPlayer.Pawn != None )
		NewPlayer.Pawn.ClientSetRotation( NewPlayer.Pawn.Rotation );
	
	if ( VotingHandler != None )
		VotingHandler.PlayerJoin( NewPlayer );
	
	if ( AccessControl != None )
		NewPlayer.LoginDelay = AccessControl.LoginDelaySeconds;
	
	NewPlayer.ClientCapBandwidth( NewPlayer.Player.CurrentNetSpeed );
	NotifyLogin( NewPlayer.PlayerReplicationInfo.PlayerID );
	
	if ( UM_PlayerController(NewPlayer).SpawnStatObject() && !NewPlayer.SteamStatsAndAchievements.Initialize(NewPlayer) )
		UM_PlayerController(NewPlayer).DestroyStatObject();
	
	if ( NewPlayer.PlayerReplicationInfo.Team != None )
		GameEvent( "TeamChange", ""$NewPlayer.PlayerReplicationInfo.Team.TeamIndex, NewPlayer.PlayerReplicationInfo );

	if ( UnrealPlayer(NewPlayer) != None )  {
		UnrealPlayer(NewPlayer).ClientReceiveLoginMenu(LoginMenuClassName, bAlwaysShowLoginMenu);
		UnrealPlayer(NewPlayer).PlayStartUpMessage(StartupStage);
	}
	
	// Initialize the listen server hosts's VOIP. Had to add this here since the
	// Epic code to do this was calling GetLocalPlayerController() in event Login()
	// which of course will always fail, because the PC's "Player" variable
	// hasn't been set yet. - Ramm
	if ( Level.NetMode == NM_ListenServer && Level.GetLocalPlayerController() == NewPlayer )
		NewPlayer.InitializeVoiceChat();

	if ( NewPlayer.PlayerReplicationInfo.bOnlySpectator )
		KFPlayerController(NewPlayer).JoinedAsSpectatorOnly();
	// must not be a spectator
	else
		NewPlayer.GotoState('PlayerWaiting');

	StartInitGameMusic(KFPlayerController(NewPlayer));
	
	log( "New Player" @NewPlayer.PlayerReplicationInfo.PlayerName @"id=" $NewPlayer.GetPlayerIDHash() );
}

function CheckForUndestroyedWeapon( Pawn P )
{
	local	Inventory	Inv;
	local	int			i;
	
	if ( P == None )
		Return;
	
	for ( Inv = P.Inventory; Inv != None && i < 1000; Inv = Inv.Inventory )  {
		if ( Class<Weapon>(Inv.Class) != None )
			WeaponDestroyed( Class<Weapon>(Inv.Class) );
	}
}

function Logout( Controller Exiting )
{
	local	bool	bNoMessage;
	
	CheckForUndestroyedWeapon( Exiting.Pawn );
	
	// From DeathMatch class
	if ( Bot(Exiting) != None )
		RemoveFromBotList( Bot(Exiting) );
	//[block] From GameInfo class
	else if ( PlayerController(Exiting) != None )  {
		if ( AccessControl != None && AccessControl.AdminLogout(PlayerController(Exiting)) )
			AccessControl.AdminExited( PlayerController(Exiting) );
		
		if ( Exiting.PlayerReplicationInfo.bOnlySpectator )  {
			bNoMessage = True;
			RemoveFromSpectatorList( PlayerController(Exiting) );
		}
		else
			RemoveFromPlayerList( PlayerController(Exiting) );
		
		if ( PlayerController(Exiting).SteamStatsAndAchievements != None )
			PlayerController(Exiting).SteamStatsAndAchievements.Destroy();
	}
	
	if ( !bNoMessage && (Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer) )
		BroadcastLocalizedMessage( GameMessageClass, 4, Exiting.PlayerReplicationInfo );
	
	if ( VotingHandler != None )
		VotingHandler.PlayerExit( Exiting );
	
	if ( GameStats != None )
		GameStats.DisconnectEvent(Exiting.PlayerReplicationInfo);
	
	//notify mutators that a player exited
	NotifyLogout(Exiting);
	//[end]
	
	// Next code from DeathMatch class
	// Adding a bot request
	if ( !bKillBots )
		RemainingBots++;
	// Removing bot request if no need or after add a Bot
	if ( !NeedPlayers() || AddBot() )
		--RemainingBots;
	// Check for the game end
	if ( MaxLives > 0 )
		CheckMaxLives(None);
}

function GetServerDetails( out ServerResponseLine ServerState )
{
	local	int		l;

	Super(Invasion).GetServerDetails( ServerState );
	
	l = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Starting cash";
	ServerState.ServerInfo[l].Value = string(StartingCash);
	
	l = ServerState.ServerInfo.Length;
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Min Respawn cash";
	ServerState.ServerInfo[l].Value = string(MinRespawnCash);
}

static function string GetCurrentMapName( LevelInfo TheLevel )
{
	local	string	Ret;
	local	int		i, j;
	
	// Get the MapName out of the URL
	Ret = TheLevel.GetLocalURL();

	i = InStr(Ret, "/") + 1;
	if ( i < 0 || i > 16 )
		i = 0;

	j = InStr(Ret, "?");
	if ( j < 0 )
		j = Len(Ret);

	if ( Mid(Ret, (j - 3), 3) ~= "rom" )
		j -= 4;

	Ret = Mid(Ret, i, j - i);

	Return Ret;
}

//[Block] ToDo: issue #317
static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super(Invasion).FillPlayInfo(PlayInfo);  // Always begin with calling parent
}

static event string GetDisplayText( string PropName )
{
	Return Super(Invasion).GetDisplayText( PropName );
}

static event string GetDescriptionText(string PropName)
{
	Return Super(Invasion).GetDisplayText( PropName );
}
//[End]

auto state PendingMatch
{
	event BeginState()
	{
		bWaitingToStartMatch = True;
		StartupStage = 0;
		NetWait = Max(NetWait, 0);
		if ( LobbyTimeout > 0 )
			CountDown = LobbyTimeout;
		else
			CountDown = -1;	// No lobby timeout
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).LobbyTimeout = -1;
	}
	
	function bool AddBot( optional string botName )
	{
		if ( Level.NetMode == NM_Standalone )
			++InitialBots;
		
		if ( botName != "" )
			PreLoadNamedBot(botName);
		else
			PreLoadBot();
		
		Return True;
	}
	
	function RestartPlayer( Controller aPlayer );
	/*
	function RestartPlayer( Controller aPlayer )
	{
		if ( CountDown <= 0 )
			Global.RestartPlayer( aPlayer );
	}	*/
	
	function StartMatch()
	{
		GotoState('StartingMatch');
	}

	event Timer()
	{
		local	int		i, ReadyCount;

		Global.Timer();

		// Spectating only.
		if ( Level.NetMode == NM_StandAlone && NumSpectators > 0 )  {
			StartMatch();
			PlayStartupMessage();
			Return;
		}

		/* First check if there are enough net players, and enough time has elapsed 
			to give people a chance to join */
		if ( NumPlayers == 0 )
			bWaitForNetPlayers = True;

		if ( Level.NetMode != NM_Standalone )  {
			// Check bWaitForNetPlayers
			if ( bWaitForNetPlayers )  {
				if ( NumPlayers >= MinNetPlayers )
					++ElapsedTime;
				else
					ElapsedTime = 0;
				if ( NumPlayers == MaxPlayers || ElapsedTime > NetWait )
					bWaitForNetPlayers = False;
			}
			// PlayStartupMessage
			if ( bWaitForNetPlayers || (bTournament && NumPlayers < MaxPlayers) )  {
				PlayStartupMessage();
				Return;
			}
		}
		
		// check if players are ready
		StartupStage = 1;
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )  {
			// Count Ready players
			if ( PlayerList[i].PlayerReplicationInfo != None && PlayerList[i].PlayerReplicationInfo.bWaitingPlayer && PlayerList[i].PlayerReplicationInfo.bReadyToPlay )
				++ReadyCount;
		}
		NumPlayers = PlayerList.Length;
		// Do not start the game if players is not enough
		if ( NumPlayers < MinHumanPlayers || ReadyCount < MinHumanPlayers )
			Return;
		
		// StartMatch
		if ( ReadyCount >= NumPlayers && !bReviewingJumpspots )  {
			CountDown = 0;
			StartMatch();
			Return;
		}
		
		// Lobby Timeout
		if ( CountDown > 0 && NumPlayers > 1 )  {
			++ElapsedTime;
			if ( CountDown == 1 )  {
				CountDown = 0;
				StartMatch();
			}
			// Start Count Down if 65% of players are ready or after 2 minutes
			else if ( ReadyCount >= int(float(NumPlayers) * 0.65) || ElapsedTime > 120 )
				KFGameReplicationInfo(GameReplicationInfo).LobbyTimeout = --CountDown;
		}
	}

	event EndState()
	{
		if ( KFGameReplicationInfo(GameReplicationInfo) != None )
			KFGameReplicationInfo(GameReplicationInfo).LobbyTimeout = -1;
	}

Begin:
	if ( bQuickStart )
		StartMatch();
}

function CheckForPlayersDeficit()
{
	local	byte	Num;
	
	Num = MaxPlayers / 2;
	while ( NeedPlayers() && Num > 0 )  {
		if ( AddBot() && RemainingBots > 0 )
			--RemainingBots;
		--Num;
	}
}

function SetAllowPlayerSpawn( bool bNewAllowPlayerSpawn )
{
	bAllowPlayerSpawn = bNewAllowPlayerSpawn;
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )
		UM_GameReplicationInfo(GameReplicationInfo).bAllowPlayerSpawn = bAllowPlayerSpawn;
}

// Start the game - inform all actors that the match is starting, and spawn player pawns
state StartingMatch
{
	function SpawnPlayers()
	{
		local	Controller	P;
		local	int			i;
		
		// Allow to spawn Players
		SetAllowPlayerSpawn( True );
		// start human players first
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i] == None )  {
				PlayerList.Remove(i, 1);
				--i;
			}
			else if ( PlayerList[i].Pawn == None )  {
				if ( bGameEnded )
					Return; // telefrag ended the game with ridiculous frag limit
				else if ( PlayerList[i].CanRestartPlayer() )
					RestartPlayer( PlayerList[i] );
			}
		}
		// start AI players
		for ( P = Level.ControllerList; P != None; P = P.nextController )  {
			if ( P.bIsPlayer && !P.IsA('PlayerController') )  {
				if ( Level.NetMode == NM_Standalone )
					RestartPlayer( P );
				else
					P.GotoState('Dead','MPStart');
			}
		}
		bMustJoinBeforeStart = False;
		CheckForPlayersDeficit();
		bMustJoinBeforeStart = default.bMustJoinBeforeStart;
		// Disallow to spawn Players
		SetAllowPlayerSpawn( False );
	}
	
	function BeginMatch()
	{
		GotoState(MatchStateName);
	}
	
	event BeginState()
	{
		local	PlayerReplicationInfo	PRI;
		local	Actor					A;
		
		bWaitingToStartMatch = False;
		// From GameInfo.uc
		if ( GameStats != None )
			GameStats.StartGame();
		
		// tell all actors the game is starting
		ForEach AllActors( class'Actor', A )
			A.MatchStarting();
		
		//[block] From DeathMatch.uc State'MatchInProgress' (BeginState() function)
		ForEach DynamicActors( class'PlayerReplicationInfo', PRI )
			PRI.StartTime = 0;
		
		ElapsedTime = 0;
		StartupStage = 5;
		PlayStartupMessage();
		StartupStage = 6;
		//[end]
		
		if ( Level.NetMode == NM_Standalone )
			RemainingBots = InitialBots;
		else
			RemainingBots = 0;
		
		GameReplicationInfo.RemainingMinute = RemainingTime;
		SpawnPlayers();
		log("START MATCH");
		GameReplicationInfo.bMatchHasBegun = True;
		BeginMatch();
	}
}

// Set gameplay speed.
function SetGameSpeed( float T )
{
	local	float	OldSpeed;

	if ( AllowGameSpeedChange() )  {
		OldSpeed = GameSpeed;
		GameSpeed = FMax(T, 0.1);
		Level.TimeDilation = Level.default.TimeDilation * GameSpeed;
		if ( !bZEDTimeActive && GameSpeed != OldSpeed )  {
			default.GameSpeed = GameSpeed;
			class'GameInfo'.static.StaticSaveConfig();
		}
	}
	else  {
		Level.TimeDilation = Level.default.TimeDilation;
		GameSpeed = 1.0;
		default.GameSpeed = GameSpeed;
	}
	
	SetTimer((Level.TimeDilation / GameSpeed), True);
}

function bool DoZedTime( float DesiredZedTimeDuration )
{
	local	byte	i;
	
	if ( DesiredZedTimeDuration < CurrentZEDTimeDuration )
		Return False;	// Already in longer zed time
	
	bZEDTimeActive = True;
	bSpeedingBackUp = False;
	LastZedTimeEvent = Level.TimeSeconds;
	CurrentZEDTimeDuration = DesiredZedTimeDuration;
	SetGameSpeed(ZedTimeSlomoScale);
	
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )
		PlayerList[i].ClientEnterZedTime();
	
	CheckSpectatorList();
	for ( i = 0; i < SpectatorList.Length; ++i )
		SpectatorList[i].ClientEnterZedTime();
	
	Return True;
}

function ResetSlowMoInstigator()
{
	// Reduce Last Instigator SlowMoCharge
	if ( SlowMoInstigator != None && SlowMoInstigator.Health > 0 && SlowMoDeltaTime > 0.0 )
		SlowMoInstigator.ReduceSlowMoCharge( SlowMoDeltaTime );
	// Reset
	bSlowMoStartedByHuman = False;
	SlowMoDeltaTime = 0.0;
	SlowMoInstigator = None;
}

function ToggledSlowMoBy( UM_HumanPawn Human )
{
	if ( Level.TimeSeconds < NextSlowMoToggleTime || Human == None || Human.bDeleteMe || Human.Health < 1 )
		Return;
	
	NextSlowMoToggleTime = Level.TimeSeconds + DelayBetweenSlowMoToggle;
	// Start to exit from SlowMo
	if ( Human == SlowMoInstigator )
		CurrentZEDTimeDuration = FMin( CurrentZEDTimeDuration, SpeedingBackZEDTime );
	// Do SlowMo
	else if ( Human.SlowMoCharge > (CurrentZEDTimeDuration + MinToggleSlowMoCharge) && DoZedTime(Human.SlowMoCharge) )  {
		ResetSlowMoInstigator();
		// Setting Up new SlowMoInstigator
		SlowMoInstigator = Human;
		bSlowMoStartedByHuman = True;
	}
}

function ExtendZEDTime( UM_HumanPawn Human )
{
	if ( Human == None || Human.bDeleteMe || Human.Health < 1 || Human.SlowMoCharge < ZEDTimeDuration )
		Return;
	
	if ( DoZedTime( ZEDTimeDuration ) )  {
		ResetSlowMoInstigator();
		// Setting Up new SlowMoInstigator
		SlowMoInstigator = Human;
		bSlowMoStartedByHuman = True;
	}
}

function CheckForUnauthorizedChanges()
{
	NextUnauthorizedChangesCheckTime = Level.TimeSeconds + UnauthorizedChangesCheckDelay;
	
	if ( UM_GameReplicationInfo(GameReplicationInfo) == None )
		Return;
	
	// Checking FriendlyFireScale for the unauthorized changes (not from the SetFriendlyFireScale() function)
	if ( FriendlyFireScale != LastFriendlyFireScale )
		SetFriendlyFireScale( FriendlyFireScale );
	// Checking GameDifficulty for the unauthorized changes (not from the SetGameDifficulty() function)
	if ( GameDifficulty != LastGameDifficulty )
		SetGameDifficulty( GameDifficulty );
}

function DoSpeedingBack()
{
	local	byte	i;
	
	bSpeedingBackUp = True;
	CheckPlayerList();
	for ( i = 0; i < PlayerList.Length; ++i )
		PlayerList[i].ClientExitZedTime();
	
	CheckSpectatorList();
	for ( i = 0; i < SpectatorList.Length; ++i )
		SpectatorList[i].ClientExitZedTime();
}

event Tick( float DeltaTime )
{
	local	float	TrueDeltaTime;
	
	if ( Level.TimeSeconds >= NextUnauthorizedChangesCheckTime )
		CheckForUnauthorizedChanges();
	
	if ( bZEDTimeActive )  {
		TrueDeltaTime = DeltaTime * Level.default.TimeDilation / Level.TimeDilation;
		CurrentZEDTimeDuration -= TrueDeltaTime;
		if ( bSlowMoStartedByHuman )
			SlowMoDeltaTime += TrueDeltaTime;
		// ZEDTimeDuration
		if ( CurrentZEDTimeDuration > 0.0 )  {
			// SlowMo Started By a Human
			if ( bSlowMoStartedByHuman )  {
				// Stop SlowMo
				if ( SlowMoInstigator == None || SlowMoInstigator.Health < 1 || SlowMoInstigator.bDeleteMe )  {
					bSlowMoStartedByHuman = False;
					SlowMoInstigator = None;
					CurrentZEDTimeDuration = FMin( CurrentZEDTimeDuration, SpeedingBackZEDTime );
				}
				// Reduce SlowMoInstigator SlowMoCharge
				else if ( SlowMoDeltaTime >= SlowMoInstigator.SlowMoChargeUpdateAmount )  {
					SlowMoInstigator.ReduceSlowMoCharge( SlowMoDeltaTime );
					SlowMoDeltaTime = 0.0;
					//CurrentZEDTimeDuration = SlowMoInstigator.SlowMoCharge;
				}
			}
			// Smooth exit from the ZedTime
			if ( CurrentZEDTimeDuration < SpeedingBackZEDTime )  {
				if ( !bSpeedingBackUp )
					DoSpeedingBack();
				// Smoothly change game speed back to default
				SetGameSpeed( Lerp((CurrentZEDTimeDuration / SpeedingBackZEDTime), DefaultGameSpeed, ZedTimeSlomoScale) );
			}
		}
		// Exit from the ZedTime
		else  {
			ResetSlowMoInstigator();
			CurrentZEDTimeDuration = 0.0;
			SetGameSpeed( DefaultGameSpeed );
			bZEDTimeActive = False;
			bSpeedingBackUp = False;
		}
	}
}

function bool AllowImpressiveKillEvent( float EventChance )
{
	local	float	TimeSinceLastEvent;
	
	if ( !bAllowImpressiveKillEvents || EventChance <= 0.0 )
		Return False;
	
	if ( EventChance < 1.0 )  {
		TimeSinceLastEvent = Level.TimeSeconds - LastZedTimeEvent;
		// Don't allow slomo event if we were just IN slomo
		if ( TimeSinceLastEvent < 10.0 )
			Return False;
		
		// Increase chance by the time
		if ( EventChance > 15.0 )
			EventChance *= FMin( TimeSinceLastEvent, 60.0 ) / 15.0;		
		// More than a minute ago
		if ( TimeSinceLastEvent > 60.0 )
			EventChance *= 4.0;
		// More than a half-minute ago
		else if( TimeSinceLastEvent > 30.0 )
			EventChance *= 2.0;
		
		Return FRand() <= EventChance;
	}
	
	Return True;
}


// Called when a dramatic event happens that might cause slomo
// BaseZedTimePossibility - the attempted probability of doing a slomo event
function DramaticEvent( float BaseZedTimePossibility, optional float DesiredZedTimeDuration )
{
	local	float	TimeSinceLastEvent;
	local	bool	bDoZedTime;

	if ( !bAllowDramaticEvents || BaseZedTimePossibility <= 0.0 )
			Return;
	
	if ( BaseZedTimePossibility < 1.0 )  {
		TimeSinceLastEvent = Level.TimeSeconds - LastZedTimeEvent;
		// Don't go in slomo if we were just IN slomo
		if ( TimeSinceLastEvent < 10.0 )
			Return;
		
		// More than a minute ago
		if ( TimeSinceLastEvent > 60.0 )
			BaseZedTimePossibility *= 4.0;
		// More than a half-minute ago
		else if( TimeSinceLastEvent > 30.0 )
			BaseZedTimePossibility *= 2.0;
		
		bDoZedTime = FRand() <= BaseZedTimePossibility;
	}
	else
		bDoZedTime = True;
	
	// if we getting a chance for slomo event
	if ( bDoZedTime )  {
		if ( DesiredZedTimeDuration <= 0.0 )
			DesiredZedTimeDuration = ZEDTimeDuration;
		
		DoZedTime( DesiredZedTimeDuration );
	}
}

function CheckForDramaticKill( int NumKilled )
{
	local	int		i;
	
	// Minimal number of killed
	if ( NumKilled < 2 )
		Return;
	
	for ( i = DramaticKills.Length - 1; i >= 0; --i )  {
		if ( NumKilled >= DramaticKills[i].MinKilled )  {
			DramaticEvent( DramaticKills[i].EventChance, DramaticKills[i].EventDuration );
			Return;
		}
	}
}

function int ReduceDamage( int Damage, Pawn Injured, Pawn InstigatedBy, vector HitLocation, out vector Momentum, class<DamageType> DamageType )
{
	local	bool		bDamageByWeaponOrVehicle;
	local	Controller	InjuredController, InstigatorController;
	local	int			InjuredTeamNum, InstigatorTeamNum;
	
	// GodMode check
	if ( Injured == None || Injured.InGodMode() || Injured.PhysicsVolume.bNeutralZone )  {
		Momentum = vect(0.0, 0.0, 0.0);
		Return 0;
	}
	
	InjuredController = Injured.Controller;
	if ( InstigatedBy != None )
		InstigatorController = InstigatedBy.Controller;
	
	if ( InstigatorController == None )  {
		InstigatorController = Injured.DelayedDamageInstigatorController;
		if ( InstigatorController == None )
			Return Damage; // Nothing to do in this case. Just return a Damage.
		else
			InstigatedBy = InstigatorController.Pawn;
	}
	
	// Not a self damaging
	if ( Injured != InstigatedBy || InjuredController != InstigatorController )  {
		bDamageByWeaponOrVehicle = (Class<WeaponDamageType>(DamageType) != None || Class<VehicleDamageType>(DamageType) != None);
		// SpawnProtection
		if ( bDamageByWeaponOrVehicle && (Level.TimeSeconds - Injured.SpawnTime) < SpawnProtectionTime )  {
			Momentum = vect(0.0, 0.0, 0.0);
			Return 0;
		}
		
		if ( InstigatedBy == None )  {
			InjuredTeamNum = InjuredController.GetTeamNum();
			InstigatorTeamNum = InstigatorController.GetTeamNum();
		}
		else  {
			InjuredTeamNum = Injured.GetTeamNum();
			InstigatorTeamNum = InstigatedBy.GetTeamNum();
		}
		
		// Friendly Fire
		if ( InjuredTeamNum == InstigatorTeamNum )  {
			// FriendlyFire is not allowed
			if ( FriendlyFireScale <= 0.0 )  {
				Momentum = vect(0.0, 0.0, 0.0);
				Return 0;
			}
			
			// Injured is a Bot. Yell about friendly fire.
			if ( Bot(InjuredController) != None && InstigatedBy != None )
				Bot(InjuredController).YellAt( InstigatedBy );
			// Human player Controller
			else if ( PlayerController(InjuredController) != None && InstigatorController != None ) {
				// AutoTaunt
				if ( InjuredController.AutoTaunt() )
					InjuredController.SendMessage(InstigatorController.PlayerReplicationInfo, 'FRIENDLYFIRE', Rand(3), 5, 'TEAM');
				// Human player is under the friendly Bot fire.
				if ( KFFriendSoldierController(InstigatorController) != None || KFFriendlyAI(InstigatorController) != None
							 || FriendlyMonsterController(InstigatorController) != None || FriendlyMonsterAI(InstigatorController) != None )  {
					Damage *= BotAtHumanFriendlyFireScale;
					if ( bDamageByWeaponOrVehicle )
						Momentum *= BotAtHumanFriendlyFireScale;
				}
			}
			Damage *= FriendlyFireScale;
			if ( bDamageByWeaponOrVehicle )
				Momentum *= FriendlyFireScale;
		}
		// HasFlag
		else if ( InjuredController != None && !Injured.IsHumanControlled()
				 && InjuredController.PlayerReplicationInfo != None && InjuredController.PlayerReplicationInfo.HasFlag != None )
			InjuredController.SendMessage(None, 'OTHER', InjuredController.GetMessageIndex('INJURED'), 15, 'TEAM');
		
		// If Injured is a Monster. StatsAndAchievements.
		if ( Monster(Injured) != None && KFPlayerController(InstigatorController) != None && Class<KFWeaponDamageType>(DamageType) != None )
			Class<KFWeaponDamageType>(DamageType).static.AwardDamage( KFSteamStatsAndAchievements(KFPlayerController(InstigatorController).SteamStatsAndAchievements), Clamp(Damage, 1, Injured.Health) );
	}
	// Half damage caused by self on the StandAlone server
	else if ( Level.NetMode == NM_StandAlone && GameDifficulty <= 3.0 && Injured.IsPlayerPawn() )
		Damage *= 0.5;
	
	// InvasionBot DamagedMessage
	if ( InvasionBot(InjuredController) != None )  {
		if ( !InvasionBot(InjuredController).bDamagedMessage && (Injured.Health - Damage) < 50 )  {
			InvasionBot(InjuredController).bDamagedMessage = True;
			if ( FRand() <= 0.5 )
				InjuredController.SendMessage(None, 'OTHER', 4, 12, 'TEAM');
			else
				InjuredController.SendMessage(None, 'OTHER', 13, 12, 'TEAM');
		}
	}
	
	if ( InstigatedBy != None )  {
		Momentum *= InstigatedBy.DamageScaling;
		Return Damage * InstigatedBy.DamageScaling;
	}
	else
		Return Damage;
}

function bool CheckMaxLives( PlayerReplicationInfo Scorer )
{
	local	PlayerController	Living;
	local	byte				i, AliveCount;

	if ( MaxLives > 0 )  {
		// Respawn is allowed.
		if ( bAllowPlayerSpawn )  {
			// PlayerList
			for ( i = 0; i < PlayerList.Length; ++i )  {
				if ( PlayerList[i].PlayerReplicationInfo != None && !PlayerList[i].PlayerReplicationInfo.bOutOfLives )  {
					++AliveCount;
					if ( Living == None )
						Living = PlayerList[i];
				}
			}
			// BotList
			for ( i = 0; i < BotList.Length; ++i )  {
				if ( BotList[i].PlayerReplicationInfo != None && !BotList[i].PlayerReplicationInfo.bOutOfLives )
					++AliveCount;
			}
		}
		// Respawn is not allowed. Check only for alive Pawns.
		else  {
			// PlayerList
			for ( i = 0; i < PlayerList.Length; ++i )  {
				if ( PlayerList[i].Pawn != None && PlayerList[i].Pawn.Health > 0 )  {
					++AliveCount;
					if ( Living == None )
						Living = PlayerList[i];
				}
			}
			// BotList
			for ( i = 0; i < BotList.Length; ++i )  {
				if ( BotList[i].Pawn != None && BotList[i].Pawn.Health > 0 )
					++AliveCount;
			}
		}
		
		if ( AliveCount == 0 )  {
			EndGame(Scorer,"LastMan");
			Return True;
		}
		else if ( !bNotifiedLastManStanding && AliveCount == 1 && Living != None )  {
			bNotifiedLastManStanding = True;
			Living.ReceiveLocalizedMessage(Class'KFLastManStandingMsg');
		}
	}
	
	Return False;
}

// See if this score means the game ends
function CheckScore(PlayerReplicationInfo Scorer)
{
	if ( CheckMaxLives(Scorer) )
		Return;

	if ( GameRulesModifiers != None && GameRulesModifiers.CheckScore(Scorer) )
		Return;

	if ( (!bOverTime && GoalScore == 0) || Scorer == None )
		Return;
	
	if ( Scorer.Team != None && Scorer.Team.Score >= GoalScore )
		EndGame(Scorer,"teamscorelimit");

	if ( bOverTime )
		EndGame(Scorer,"timelimit");
}

function ScoreKillAssists( float Score, Controller Victim, Controller Killer )
{
	local	int						i;
	local	float					GrossDamage, ScoreMultiplier, KillScore;
	local	KFMonsterController		MyVictim;
	local	KFPlayerReplicationInfo	KFPRI;

	MyVictim = KFMonsterController(Victim);
	if ( MyVictim == None || MyVictim.KillAssistants.Length < 1 )
		Return;

	for ( i = 0; i < MyVictim.KillAssistants.Length; ++i )
		GrossDamage += MyVictim.KillAssistants[i].Damage;

	ScoreMultiplier = Score / GrossDamage;

	for ( i = 0; i < MyVictim.KillAssistants.Length; ++i )  {
		if ( MyVictim.KillAssistants[i].PC != None && MyVictim.KillAssistants[i].PC.PlayerReplicationInfo != None )  {
			KillScore = ScoreMultiplier * MyVictim.KillAssistants[i].Damage;
			MyVictim.KillAssistants[i].PC.PlayerReplicationInfo.Score += KillScore;

			KFPRI = KFPlayerReplicationInfo(MyVictim.KillAssistants[i].PC.PlayerReplicationInfo);
			if ( KFPRI != None )  {
				if ( MyVictim.KillAssistants[i].PC != Killer )
					++KFPRI.KillAssists;
				KFPRI.ThreeSecondScore += KillScore;
			}
		}
	}
}

function ScoreKill( Controller Killer, Controller Other )
{
	local	PlayerReplicationInfo	OtherPRI;
	local	float					KillScore;
	local	int						i;

	OtherPRI = Other.PlayerReplicationInfo;
	if ( OtherPRI != None )  {
		++OtherPRI.NumLives;
		
		OtherPRI.Team.Score = FMax( (OtherPRI.Team.Score - (OtherPRI.Score - (OtherPRI.Score * DeathCashModifier))), 0.0 );
		OtherPRI.Score = FMax( (OtherPRI.Score * DeathCashModifier), 0.0 );

		OtherPRI.Team.NetUpdateTime = Level.TimeSeconds - 1.0;
		if ( MaxLives > 0 )
			OtherPRI.bOutOfLives = OtherPRI.NumLives >= MaxLives;
		
		if ( Killer != None && Killer.PlayerReplicationInfo != None && Killer.bIsPlayer )
			BroadcastLocalizedMessage( class'KFInvasionMessage', 1, OtherPRI, Killer.PlayerReplicationInfo );
		else if( Killer == None || Monster(Killer.Pawn) == None )
			BroadcastLocalizedMessage( class'KFInvasionMessage', 1, OtherPRI );
		else 
			BroadcastLocalizedMessage( class'KFInvasionMessage', 1, OtherPRI,, Killer.Pawn.Class );
		
		CheckScore(None);
	}

	if ( GameRulesModifiers != None )
		GameRulesModifiers.ScoreKill(Killer, Other);

	if ( MonsterController(Killer) != None )
		Return;

	if ( (killer == Other || killer == None) && Other.PlayerReplicationInfo != None )  {
		Other.PlayerReplicationInfo.Score -= 1;
		Other.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
		ScoreEvent(Other.PlayerReplicationInfo,-1,"self_frag");
	}

	if ( Killer == None || !Killer.bIsPlayer || Killer == Other )
		Return;

	if ( Other.bIsPlayer )  {
		Killer.PlayerReplicationInfo.Score -= 5;
		Killer.PlayerReplicationInfo.Team.Score -= 2;
		Killer.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
		Killer.PlayerReplicationInfo.Team.NetUpdateTime = Level.TimeSeconds - 1;
		ScoreEvent(Killer.PlayerReplicationInfo, -5, "team_frag");
		Return;
	}
	
	if ( LastKilledMonsterClass == None )
		KillScore = 1;
	else if ( Killer.PlayerReplicationInfo != None )  {
		KillScore = LastKilledMonsterClass.Default.ScoringValue;
		// Scale killscore by difficulty
		if ( GameDifficulty >= 5.0 ) // Suicidal and Hell on Earth
			KillScore *= 0.65;
		else if ( GameDifficulty >= 4.0 ) // Hard
			KillScore *= 0.85;
		else if ( GameDifficulty >= 2.0 ) // Normal
			KillScore *= 1.0;
		else //if ( GameDifficulty == 1.0 ) // Beginner
			KillScore *= 2.0;

		// Increase score in a short game, so the player can afford to buy cool stuff by the end
		if( KFGameLength == GL_Short )
			KillScore *= 1.75;

		KillScore = Max( 1, int(KillScore) );
		Killer.PlayerReplicationInfo.Kills++;

		ScoreKillAssists(KillScore, Other, Killer);

		Killer.PlayerReplicationInfo.Team.Score += KillScore;
		Killer.PlayerReplicationInfo.NetUpdateTime = Level.TimeSeconds - 1;
		Killer.PlayerReplicationInfo.Team.NetUpdateTime = Level.TimeSeconds - 1;
		TeamScoreEvent(Killer.PlayerReplicationInfo.Team.TeamIndex, 1, "tdm_frag");
	}

	if ( Killer.PlayerReplicationInfo != None && Killer.PlayerReplicationInfo.Score < 0 )
		Killer.PlayerReplicationInfo.Score = 0;

	//[block] Marco's Kill Messages
	if ( Class'HUDKillingFloor'.Default.MessageHealthLimit <= Other.Pawn.Default.Health
		 || Class'HUDKillingFloor'.Default.MessageMassLimit <= Other.Pawn.Default.Mass )  {
		for ( i = 0; i < PlayerList.Length; ++i )  {
			if ( PlayerList[i] != None )
				PlayerList[i].ReceiveLocalizedMessage( Class'KillsMessage', 1, Killer.PlayerReplicationInfo,, Other.Pawn.Class );
		}
	}
	else if ( xPlayer(Killer) != None )
		xPlayer(Killer).ReceiveLocalizedMessage( Class'KillsMessage',,,, Other.Pawn.Class );
	//[end] Marco's Kill Messages
}

function Killed( Controller Killer, Controller Killed, Pawn KilledPawn, class<DamageType> DamageType )
{
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

function RestartGame()
{
	local	string		NextMap;
	local	MapList		MyList;
	
	if ( bGameRestarted || (GameRulesModifiers != None && GameRulesModifiers.HandleRestartGame()) )
		Return;
	
	bGameRestarted = True;
	
	if ( CurrentGameProfile != None )  {
		CurrentGameProfile.ContinueSinglePlayerGame(Level);
		Return;
	}
	
	// still showing end screen or
	// allow voting handler to stop travel to next map
	if ( EndTime > Level.TimeSeconds || (VotingHandler != None && !VotingHandler.HandleRestartGame()) )
		Return;
	
	// these server travels should all be relative to the current URL
	if ( bChangeLevels && !bAlreadyChanged && MapListType != "" )  {
		bAlreadyChanged = True;
		// open a the nextmap actor for this game type and get the next map
		MyList = GetMapList( MapListType );
		if ( MyList != None )  {
			NextMap = MyList.GetNextMap();
			MyList.Destroy();
		}
		// Check NextMap
		if ( NextMap == "" )
			NextMap = GetMapName( MapPrefix, NextMap, 1 );
		// Change map if NextMap is specified
		if ( NextMap != "" )  {
			Level.ServerTravel( NextMap, False );
			Return;
		}
	}
	
	Level.ServerTravel( "?Restart", False );
}

state MatchOver
{
	event BeginState()
	{
		local	Pawn	P;
		local	byte	i;
		
		ForEach DynamicActors( class'Pawn', P )  {
			if ( P.Role == ROLE_Authority )
				P.RemoteRole = ROLE_DumbProxy;
			P.TurnOff();
		}
		
		GameReplicationInfo.bStopCountDown = True;
		if ( CurrentGameProfile != None ) {
			EndTime = Level.TimeSeconds + SinglePlayerWait;
			CheckPlayerList();
			for ( i = 0; i < PlayerList.Length; ++i )
				PlayerList[i].myHUD.bShowScoreboard = True;
			
			// Register last player in the list
			CurrentGameProfile.RegisterGame( self, PlayerList[i].PlayerReplicationInfo );
			SavePackage(CurrentGameProfile.PackageName);
		}
	}
	
	function BossLaughtIt(); // Cleanup old function
	
	function RestartGame()
	{
		Global.RestartGame();
	}
	
	function PlayEndOfMatchMessage()
	{
		local	name	EndSound;
		local	byte	i;

		if ( WaveNum >= FinalWave )
			EndSound = EndGameSoundName[0];
		else if ( (WaveNum - InitialWave) == 0 )
			EndSound = AltEndGameSoundName[1];
		else
			EndSound = InvasionEnd[ Min( ((WaveNum - InitialWave) / 3), 5 ) ];
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )
			PlayerList[i].PlayRewardAnnouncement( EndSound, 1, True );
	}
	
	function ShowLocalStatsToPlayers()
	{
		local	byte	i;
		
		CheckPlayerList();
		for ( i = 0; i < PlayerList.Length; ++i )
			PlayerList[i].myHUD.bShowLocalStats = True;
	}
	
	event Timer()
	{
		Global.Timer();
		
		if ( !bGameRestarted && Level.TimeSeconds > (EndTime + RestartWait) )
			RestartGame();
		
		// play end-of-match message for winner/losers (for single and muli-player)
		++EndMessageCounter;
		if ( EndMessageCounter == EndMessageWait )
			PlayEndOfMatchMessage();
		
		if ( CurrentGameProfile != None && Level.TimeSeconds > (EndTime + RestartWait * 0.5) )
			ShowLocalStatsToPlayers();
	}
	
	function bool NeedPlayers()
	{
		Return False;
	}
	
	function bool ChangeTeam( Controller Other, int num, bool bNewTeam )
	{
		// prevents DeathMatch.ChangeTeam from being called so that players aren't
		// blocked from joining a server that is in this state
		if ( Other.PlayerReplicationInfo != None && Other.PlayerReplicationInfo.Team == None )
			Return Global.ChangeTeam( Other, num, bNewTeam );
		else
			Return Super(Invasion).ChangeTeam( Other, num, bNewTeam );
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 DefaultMaxLives=3
	 MaxLives=3
	 
	 InitialState="PendingMatch"
	 
	 bAllowImpressiveKillEvents=True
	 bShowImpressiveKillEvents=True
	 bAllowDramaticEvents=True
	 
	 UnauthorizedChangesCheckDelay=0.05
	 // Do not check first 2 seconds
	 NextUnauthorizedChangesCheckTime=2.0
	 
	 bDelayedStart=True
	 MaxFriendlyFireScale=1.0
	 
	 MinGameDifficulty=1.0
	 MaxGameDifficulty=7.0
	 
	 ExtraStartingCashChance=0.05
	 ExtraStartingCashModifier=4.0
	 DeathCashModifier=0.9
	 
	 bSaveSpectatorScores=False
	 BotAtHumanFriendlyFireScale=0.5
	 ZedTimeSlomoScale=0.2
	 ZEDTimeDuration=3.0
	 SpeedingBackZEDTime=0.5
	 
	 DelayBetweenSlowMoToggle=0.25
	 MinToggleSlowMoCharge=2.0
	 
	 MinHumanPlayers=1
	 MaxHumanPlayers=10
	 
	 // Kills for DramaticEvent
	 DramaticKills(0)=(MinKilled=2,EventChance=0.03,EventDuration=3.0)
	 DramaticKills(1)=(MinKilled=5,EventChance=0.05,EventDuration=3.0)
	 DramaticKills(2)=(MinKilled=10,EventChance=0.2,EventDuration=4.0)
	 DramaticKills(3)=(MinKilled=15,EventChance=0.4,EventDuration=4.0)
	 DramaticKills(4)=(MinKilled=20,EventChance=0.8,EventDuration=5.0)
	 DramaticKills(5)=(MinKilled=25,EventChance=1.0,EventDuration=5.0)
	 
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
	 GameName="Base Unlimagin Game (Abstract class)"
	 Description="Do not choose this game. It's an abstract class and it will always fail to spawn and start the game."
}
