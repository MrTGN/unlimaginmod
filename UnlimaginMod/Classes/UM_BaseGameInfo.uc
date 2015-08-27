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
var		string							GameSettingsClassName;
var		class<UM_BaseGameSettings>		GameSettingsClass;

var		transient	float				DefaultGameSpeed;	// Sets in the InitGame event

var		int								MaxHumanPlayers;

var		UM_HumanPawn					SlowMoInstigator;
var		transient	float				SlowMoDeltaTime;
var		const		float				DelayBetweenSlowMoToggle;
var		transient	float				NextSlowMoToggleTime;
var		float							MinToggleSlowMoCharge;

var		transient	bool				bSlowMoStartedByHuman;

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

protected function bool LoadGameSettings()
{
	local	int		i;
	
	if ( GameSettingsClassName != "" )
		GameSettingsClass = Class<UM_BaseGameSettings>( BaseActor.static.LoadClass(GameSettingsClassName) );
	else  {
		Warn("GameSettingsClassName not specified!", Class.Outer.Name);
		GameSettingsClassName = "UnlimaginMod.UM_BaseGameSettings";
		GameSettingsClass = Class<UM_BaseGameSettings>( BaseActor.static.LoadClass(GameSettingsClassName) );
	}
	
	if ( GameSettingsClass == None )  {
		Warn("GameSettingsClass wasn't found!", Class.Outer.Name);
		Return False;
	}
	
	// MaxHumanPlayers
	default.MaxHumanPlayers = GameSettingsClass.default.MaxHumanPlayers;
	MaxHumanPlayers = default.MaxHumanPlayers;
	
	// DramaticKills
	default.DramaticKills.Length = GameSettingsClass.default.DramaticKills.Length;
	DramaticKills.Length = default.DramaticKills.Length;
	for ( i = 0; i < GameSettingsClass.default.DramaticKills.Length; ++i )  {
		// MinKilled
		default.DramaticKills[i].MinKilled = GameSettingsClass.default.DramaticKills[i].MinKilled;
		DramaticKills[i].MinKilled = default.DramaticKills[i].MinKilled;
		// EventChance
		default.DramaticKills[i].EventChance = GameSettingsClass.default.DramaticKills[i].EventChance;
		DramaticKills[i].EventChance = default.DramaticKills[i].EventChance;
		// EventDuration
		default.DramaticKills[i].EventDuration = GameSettingsClass.default.DramaticKills[i].EventDuration;
		DramaticKills[i].EventDuration = default.DramaticKills[i].EventDuration;
	}
	
	Return True;
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

function ToggleSlowMoBy( UM_HumanPawn Human )
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
