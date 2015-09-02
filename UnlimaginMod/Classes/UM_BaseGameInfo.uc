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

// Do slomo event when was killed a specified number of victims
struct DramaticKillData
{
	var()	config	int		MinKilled;
	var()	config	float	EventChance;
	var()	config	float	EventDuration;
};
var		array<DramaticKillData>			DramaticKills;

var		Class<KFLevelRules>				DefaultLevelRulesClass;
var		string							LoginMenuClassName;

var		float							ExitZedTime;
var		float							BotAtHumanFriendlyFireScale;

// Will be config string at release version
var		string							GamePresetClassName;
var		class<UM_BaseGamePreset>		GamePreset;

var		transient	float				DefaultGameSpeed;	// Sets in the InitGame event

var		int								MaxHumanPlayers;

var		UM_HumanPawn					SlowMoInstigator;
var		transient	float				SlowMoDeltaTime;
var		const		float				DelayBetweenSlowMoToggle;
var		transient	float				NextSlowMoToggleTime;
var		float							MinToggleSlowMoCharge;

var		transient	bool				bSlowMoStartedByHuman;

var		bool							bSaveSpectatorScores, bSaveSpectatorTeam;

// StartingCash lottery
var		float							ExtraStartingCashChance, ExtraStartingCashModifier;
var		float							RespawnCashModifier;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

event PreBeginPlay()
{
	Super(Invasion).PreBeginPlay();

	KFGameReplicationInfo(GameReplicationInfo).bNoBots = bNoBots;
	KFGameReplicationInfo(GameReplicationInfo).PendingBots = 0;
	KFGameReplicationInfo(GameReplicationInfo).GameDiff = GameDifficulty;
	KFGameReplicationInfo(GameReplicationInfo).bEnemyHealthBars = bEnemyHealthBars;

	HintTime_1 = 99999999.00;
	HintTime_2 = 99999999.00;

	bShowHint_2 = true;
	bShowHint_3 = true;
}

// For the GUI buy menu
simulated function float GetDifficulty()
{
	Return GameDifficulty;
}

exec function SetFriendlyFireScale( float NewFriendlyFireScale )
{
	FriendlyFireScale = FClamp(NewFriendlyFireScale, 0.0, 1.0);
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )  {
		UM_GameReplicationInfo(GameReplicationInfo).FriendlyFireScale = FriendlyFireScale;
		UM_GameReplicationInfo(GameReplicationInfo).NetUpdateTime = Level.TimeSeconds - 1.0;
	}
}

function bool AllowGameSpeedChange()
{
	if ( Level.NetMode == NM_Standalone )
		Return True;
	
	Return bAllowMPGameSpeed;
}

protected function bool LoadGamePreset( optional string NewPresetName )
{
	local	int		i;
	
	// If NewPresetName not specified will be loaded default GamePreset
	if ( NewPresetName != "" )
		GamePresetClassName = NewPresetName;
	
	if ( GamePresetClassName != "" )
		GamePreset = Class<UM_BaseGamePreset>( BaseActor.static.LoadClass(GamePresetClassName) );
	else  {
		Warn("GamePresetClassName not specified!", Class.Outer.Name);
		GamePresetClassName = "UnlimaginMod.UM_BaseGamePreset";
		GamePreset = Class<UM_BaseGamePreset>( BaseActor.static.LoadClass(GamePresetClassName) );
	}
	
	if ( GamePreset == None )  {
		Warn("GamePreset wasn't found!", Class.Outer.Name);
		Return False;
	}
	
	// MaxHumanPlayers
	default.MaxHumanPlayers = GamePreset.default.MaxHumanPlayers;
	MaxHumanPlayers = default.MaxHumanPlayers;
	
	// DramaticKills
	default.DramaticKills.Length = GamePreset.default.DramaticKills.Length;
	DramaticKills.Length = default.DramaticKills.Length;
	for ( i = 0; i < GamePreset.default.DramaticKills.Length; ++i )  {
		// MinKilled
		default.DramaticKills[i].MinKilled = GamePreset.default.DramaticKills[i].MinKilled;
		DramaticKills[i].MinKilled = default.DramaticKills[i].MinKilled;
		// EventChance
		default.DramaticKills[i].EventChance = GamePreset.default.DramaticKills[i].EventChance;
		DramaticKills[i].EventChance = default.DramaticKills[i].EventChance;
		// EventDuration
		default.DramaticKills[i].EventDuration = GamePreset.default.DramaticKills[i].EventDuration;
		DramaticKills[i].EventDuration = default.DramaticKills[i].EventDuration;
	}
	
	Log("GamePreset" @string(GamePreset.default.Name) @"loaded", Class.Outer.Name);
	
	Return True;
}

function CheckStartingCash( PlayerController P )
{
	if ( P == None || P.PlayerReplicationInfo == None )
		Return;
	
	// StartingCash lottery
	if ( FRand() <= ExtraStartingCashChance )
		P.PlayerReplicationInfo.Score += float(StartingCash) * ExtraStartingCashModifier;
	else if ( P.PlayerReplicationInfo.Score < float(StartingCash) )
		P.PlayerReplicationInfo.Score = float(StartingCash);
}

function RespawnPlayer( PlayerController P )
{
	if ( P == None || P.PlayerReplicationInfo == None )
		Return;
	
	if ( P.Pawn != None )  {
		if ( !P.Pawn.bDeleteMe )
			P.Pawn.Suicide();
		P.Pawn = None;
	}
	
	P.PlayerReplicationInfo.bOutOfLives = False;
	P.PlayerReplicationInfo.Score = FMax( float(MinRespawnCash) , (P.PlayerReplicationInfo.Score * RespawnPenaltyCashModifier) );
	P.GotoState('PlayerWaiting');	// ServerReStartPlayer() will be called in this state
	P.SetViewTarget(C);
	P.ClientSetBehindView(False);
	P.bBehindView = False;
	P.ClientSetViewTarget(C.Pawn);
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
	
	++NumSpectators;
	--NumPlayers;
	
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

// Spectating player wants to become active and join the game
function BecomeActivePlayer( PlayerController P )
{
	--NumSpectators;
	++NumPlayers;
	
	if ( !bSaveSpectatorScores )
		P.PlayerReplicationInfo.Reset();
	
	CheckStartingCash( P );
	
	P.PlayerReplicationInfo.bOnlySpectator = False;
	if ( bTeamGame )  {
		if ( P.PlayerReplicationInfo.Team != None )
			ChangeTeam(P, P.PlayerReplicationInfo.Team.TeamIndex, None), false);
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

// Player Can be restarted
function bool PlayerCanRestart( PlayerController aPlayer )
{
	Return !bWaveInProgress && (!bWaveBossInProgress || (bRespawnOnBoss && !bHasSetViewYet));
}

// Mod this to include the choices made in the GUIClassMenu
function RestartPlayer( Controller aPlayer )
{
	if ( aPlayer == None || aPlayer.PlayerReplicationInfo.bOutOfLives || (aPlayer.Pawn != None && !aPlayer.Pawn.bDeleteMe) )
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
		NewPlayer.PlayerSecurity = spawn(MySecurityClass,NewPlayer);
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
		++NumSpectators;

		Return NewPlayer;
	}

	NewPlayer.StartSpot = StartSpot;

	// Init player's administrative privileges and log it
	if ( AccessControl != None && AccessControl.AdminLogin(NewPlayer, InAdminName, InPassword) )
		AccessControl.AdminEntered(NewPlayer, InAdminName);

	++NumPlayers;
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
		if ( !NewPlayer.PlayerReplicationInfo.bOnlySpectator )  {
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
				NewPlayer.PlayerReplicationInfo.NumLives = 1;
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
	NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;
	
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
		HUDClass = Class<HUD>( BaseActor.static.LoadClass(HUDType) );
		if ( HUDClass == None )
			log( "Can't find HUD class "$HUDType, 'Error' );
	}
	
	if ( ScoreBoardType == "" )
		log( "No ScoreboardClass specified in GameInfo", 'Log' );
	else  {
		ScoreboardClass = Class<Scoreboard>( BaseActor.static.LoadClass(ScoreBoardType) );
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
	
	if ( UM_PlayerController(NewPlayer) != None && UM_PlayerController(NewPlayer).SpawnStatObject() && !NewPlayer.SteamStatsAndAchievements.Initialize(NewPlayer) )
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

	if ( NewPlayer.PlayerReplicationInfo.bOnlySpectator ) // must not be a spectator
		KFPlayerController(NewPlayer).JoinedAsSpectatorOnly();
	else
		NewPlayer.GotoState('PlayerWaiting');

	if ( KFPlayerController(NewPlayer) != None )
		StartInitGameMusic(KFPlayerController(NewPlayer));
	
	log( "New Player" @NewPlayer.PlayerReplicationInfo.PlayerName @"id=" $NewPlayer.GetPlayerIDHash() );
}

function ResetSlowMoInstigator()
{
	if ( SlowMoInstigator != None && SlowMoInstigator.Health > 0 && SlowMoDeltaTime > 0.0 )
		SlowMoInstigator.ReduceSlowMoCharge( SlowMoDeltaTime );
	bSlowMoStartedByHuman = False;
	SlowMoInstigator = None;
	SlowMoDeltaTime = 0.0;
}

function ToggledSlowMoBy( UM_HumanPawn Human )
{
	if ( Human == None || Human.Health < 1 || Human.bDeleteMe || Level.TimeSeconds < NextSlowMoToggleTime || Human.SlowMoCharge < MinToggleSlowMoCharge )
		Return;
	
	NextSlowMoToggleTime = Level.TimeSeconds + DelayBetweenSlowMoToggle;
	
	// Stop SlowMo
	if ( SlowMoInstigator == Human )
		CurrentZEDTimeDuration = Min( CurrentZEDTimeDuration, ExitZedTime );
	// Start SlowMo
	else  {
		ResetSlowMoInstigator();
		// Setting Up new SlowMoInstigator
		bSlowMoStartedByHuman = True;
		SlowMoInstigator = Human;
		DramaticEvent(1.0, SlowMoInstigator.SlowMoCharge);
	}
}

function ExtendZEDTime( UM_HumanPawn Human )
{
	if ( Human == None || Human.Health < 1 || Human.bDeleteMe || Human.SlowMoCharge < ZEDTimeDuration )
		Return;
	
	ResetSlowMoInstigator();
	// Setting Up new SlowMoInstigator
	bSlowMoStartedByHuman = True;
	SlowMoInstigator = Human;
	DramaticEvent(1.0, ZEDTimeDuration);
}

event Tick( float DeltaTime )
{
	local	float		TrueDeltaTime;
	local	int			Count;
	local	Controller	C;
	
	if ( UM_GameReplicationInfo(GameReplicationInfo) != None )  {
		// FriendlyFireScale Replication
		if ( UM_GameReplicationInfo(GameReplicationInfo).FriendlyFireScale != FriendlyFireScale )  {
			FriendlyFireScale = FClamp(FriendlyFireScale, 0.0, 1.0); // FClamp FriendlyFireScale
			UM_GameReplicationInfo(GameReplicationInfo).FriendlyFireScale = FriendlyFireScale;
			UM_GameReplicationInfo(GameReplicationInfo).NetUpdateTime = Level.TimeSeconds - 1.0;
		}
		// GameDifficulty Replication
		if ( UM_GameReplicationInfo(GameReplicationInfo).GameDifficulty != GameDifficulty )  {
			UM_GameReplicationInfo(GameReplicationInfo).GameDifficulty = GameDifficulty;
			UM_GameReplicationInfo(GameReplicationInfo).NetUpdateTime = Level.TimeSeconds - 1.0;
		}
	}
	
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
					CurrentZEDTimeDuration = Min( CurrentZEDTimeDuration, ExitZedTime );
				}
				// Reduce SlowMoInstigator SlowMoCharge
				else if ( SlowMoDeltaTime >= SlowMoInstigator.SlowMoChargeUpdateAmount )  {
					SlowMoInstigator.ReduceSlowMoCharge( SlowMoDeltaTime )
					SlowMoDeltaTime = 0.0;
					CurrentZEDTimeDuration = SlowMoInstigator.SlowMoCharge;
				}
			}
			// Smooth exit from the ZedTime
			if ( CurrentZEDTimeDuration < ExitZedTime )  {
				if ( !bSpeedingBackUp )  {
					bSpeedingBackUp = True;
					for ( C = Level.ControllerList; C != None && Count < NumPlayers; C = C.NextController )  {
						if ( KFPlayerController(C) != None )  {
							KFPlayerController(C).ClientExitZedTime();
							++Count;
						}
					}
				}
				SetGameSpeed( Lerp((CurrentZEDTimeDuration / ExitZedTime), 1.0, 0.2) );
			}
		}
		else  {
			ResetSlowMoInstigator();
			CurrentZEDTimeDuration = 0.0;
			SetGameSpeed(DefaultGameSpeed);
			bZEDTimeActive = False;
			bSpeedingBackUp = False;
		}
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

// Called when a dramatic event happens that might cause slomo
// BaseZedTimePossibility - the attempted probability of doing a slomo event
function DramaticEvent( float BaseZedTimePossibility, optional float DesiredZedTimeDuration )
{
	local	float		TimeSinceLastEvent;
	local	Controller	C;
	local	int			i;

	TimeSinceLastEvent = Level.TimeSeconds - LastZedTimeEvent;
	if ( BaseZedTimePossibility < 1.0 )  {
		// Don't go in slomo if we were just IN slomo
		if ( TimeSinceLastEvent < 10.0 )
			Return;
		
		// More than a minute ago
		if ( TimeSinceLastEvent > 60.0 )
			BaseZedTimePossibility *= 4.0;
		// More than a half-minute ago
		else if( TimeSinceLastEvent > 30.0 )
			BaseZedTimePossibility *= 2.0;
	}
	
	// if we getting a chance for slomo event
	if ( FRand() <= BaseZedTimePossibility )  {
		bZEDTimeActive = True;
		bSpeedingBackUp = False;
		LastZedTimeEvent = Level.TimeSeconds;
		
		if ( DesiredZedTimeDuration > 0.0 )
			CurrentZEDTimeDuration = DesiredZedTimeDuration;
		else
			CurrentZEDTimeDuration = ZEDTimeDuration;

		SetGameSpeed(ZedTimeSlomoScale);

		for ( C = Level.ControllerList; C != None && i < 1000; C = C.NextController )  {
			++i;
			// ZedTime Clien Notify
			if ( KFPlayerController(C) != None )
				KFPlayerController(C).ClientEnterZedTime();
			/*
			// ZedTime Stat
			if ( C.PlayerReplicationInfo != None && KFSteamStatsAndAchievements(C.PlayerReplicationInfo.SteamStatsAndAchievements) != None )
				KFSteamStatsAndAchievements(C.PlayerReplicationInfo.SteamStatsAndAchievements).AddZedTime(ZEDTimeDuration);
			*/
		}
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

//[end] Functions
//====================================================================

defaultproperties
{
	 ExtraStartingCashChance=0.05
	 ExtraStartingCashModifier=4.0
	 RespawnCashModifier=0.95
	 
	 bSaveSpectatorScores=False
	 BotAtHumanFriendlyFireScale=0.5
	 ZEDTimeDuration=3.000000
	 ExitZedTime=0.500000
	 
	 DelayBetweenSlowMoToggle=0.25
	 MinToggleSlowMoCharge=2.0
	 
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
