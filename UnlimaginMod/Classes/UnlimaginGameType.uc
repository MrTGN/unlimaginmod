//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UnlimaginGameType
//	Parent class:	 KFGameType
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 13:12
//================================================================================
class UnlimaginGameType extends KFGameType
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

/*var()	globalconfig 	int		UM_MaximumPlayers;
var()	globalconfig 	int		UM_WaveTotalMaxMonsters;*/

var()	int		UM_MaximumPlayers;
var()	int		UM_WaveTotalMaxMonsters;

var()	string					UM_EndGameBossClass; // class of the end game boss, moved to non config - Ramm
var()	string					UM_FallbackMonsterClass;
var()	array<MClassTypes>		UM_MonsterClasses; // Unlimagin monster classed
var()	array<string>			UM_MonsterSquads; // Unlimagin monster squads
var()	array<SpecialSquad>		UM_SpecialSquads; // The special squad array for a long game
var()	array<SpecialSquad>		UM_FinalSquads; // Squads that spawn with the Patriarch

var()	WaveInfo				UM_Waves[16];	// Wave config
/*
var()	globalconfig	int		UM_FinalWave;
var()	globalconfig	int		UM_MaxZombiesOnce; // Max zombies that can be in play at once
var()	globalconfig	int		UM_TimeBetweenWaves;*/

var()	int		UM_FinalWave;
var()	int		UM_MaxZombiesOnce; // Max zombies that can be in play at once
var()	int		UM_TimeBetweenWaves;

var		Class<UM_ActorPool>		ActorPoolClass;

var		class<KFMonstersCollection>		UM_MonsterCollection;
var		Class<KFLevelRules>				DefaultLevelRulesClass;
var		string							UM_LoginMenuClass;

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

function LoadUpMonsterList()
{
	local int i,j,q,c,n;
	local Class<KFMonster> MC;
	local string S,ID;
	local bool bInitSq;
	local array<IMClassList> InitMList;

    /*if( KFGameLength != GL_Custom )
    {
        InitMList = LoadUpMonsterListFromCollection();
    }
    else
    {
        InitMList = LoadUpMonsterListFromGameType();
    }*/
	InitMList = LoadUpMonsterListFromCollection();

	//Log("Got"@j@"monsters. Loading up monster squads...",'Init');
	for( i=0; i<MonsterSquad.Length; i++ )
	{
		S = MonsterSquad[i];
		if( S=="" )
			Continue;
		bInitSq = False;
		n = 0;
		While( S!="" )
		{
			q = int(Left(S,1));
			ID = Mid(S,1,1);
			S = Mid(S,2);
			MC = None;
			for( j=0; j<InitMList.Length; j++ )
			{
				if( InitMList[j].ID~=ID )
				{
					MC = InitMList[j].MClass;
					Break;
				}
			}
			if( MC==None )
				Continue;
			if( !bInitSq )
			{
				InitSquads.Length = c+1;
				bInitSq = True;
			}
			while( (q--)>0 )
			{
				InitSquads[c].MSquad.Length = n+1;
				InitSquads[c].MSquad[n] = MC;
				n++;
			}
		}
		if( bInitSq )
			c++;
	}
	//Log("Got"@c@"monster squads.",'Init');
	if( FallbackMonster==class'EliteKrall' && InitMList.Length>0 )
		FallbackMonster = InitMList[0].MClass;
}

event InitGame( string Options, out string Error )
{
//	local int i,j;
	local KFLevelRules KFLRit;
	local ShopVolume SH;
	local ZombieVolume ZZ;
	local string InOpt;
	//local int i;

	Super(xTeamGame).InitGame(Options, Error);
	
	FallbackMonster = class<Monster>(DynamicLoadObject(UM_FallbackMonsterClass, class'Class'));
	//if (FallbackMonster == None)
	//	FallbackMonster = class'EliteKrall';

	MaxLives = 1;
	bForceRespawn = true;

	MaxPlayers = Clamp( UM_MaximumPlayers, 0, 32);


	foreach DynamicActors(class'KFLevelRules',KFLRit)
	{
		if ( KFLRules == None )
			KFLRules = KFLRit;
		else 
			Warn("MULTIPLE KFLEVELRULES FOUND!!!!!");
	}
	foreach AllActors(class'ShopVolume',SH)
		ShopList[ShopList.Length] = SH;
	foreach AllActors(class'ZombieVolume',ZZ)
		ZedSpawnList[ZedSpawnList.Length] = ZZ;

	//provide default rules if mapper did not need custom one
	if ( KFLRules == None )
		KFLRules = Spawn(DefaultLevelRulesClass);

	log("KFLRules = "$KFLRules);

	InOpt = ParseOption(Options, "UseBots");
	if ( InOpt != "" )
	{
		bNoBots = bool(InOpt);
	}

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
	if ( GameDifficulty >= 7.0 ) // Hell on Earth
	{
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashHell;
		MinRespawnCash = MinRespawnCashHell;
	}
	else if ( GameDifficulty >= 5.0 ) // Suicidal
	{
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashSuicidal;
		MinRespawnCash = MinRespawnCashSuicidal;
	}
	else if ( GameDifficulty >= 4.0 ) // Hard
	{
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashHard;
		MinRespawnCash = MinRespawnCashHard;
	}
	else if ( GameDifficulty >= 2.0 ) // Normal
	{
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashNormal;
		MinRespawnCash = MinRespawnCashNormal;
	}
	else //if ( GameDifficulty == 1.0 ) // Beginner
	{
		TimeBetweenWaves = UM_TimeBetweenWaves;
		StartingCash = StartingCashBeginner;
		MinRespawnCash = MinRespawnCashBeginner;
	}

	InitialWave = 0;
	
	FinalWave = Clamp(UM_FinalWave,5,15);
	
	PrepareSpecialSquads();

	/*for( i=0; i<3; i++ )
	{
		FinalSquads[i] = UM_FinalSquads[i];
	}*/

	LoadUpMonsterList();
	
	//Spawning ActorPool
	if ( ActorPoolClass != None && Class'UM_AData'.default.ActorPool == None )
	{
		log("-------- Creating ActorPool --------",Class.Outer.Name);
		Spawn(ActorPoolClass);
	}
	//Spawn(Class'UM_TestActor');
}

function NotifyGameEvent(int EventNumIn)
{
	if(MonsterCollection != class'UM_KFMonstersCollection' )
	{//we already have an event

		if(EventNumIn == 3 && MonsterCollection != class'UM_KFMonstersXMasCollection')
		{
			log("Was we should be in halloween mode but we aren't!");
		}
		if(EventNumIn == 2 && MonsterCollection != class'UM_KFMonstersHalloweenCollection')
		{
			log("Was we should be in halloween mode but we aren't!");
		}
		if(EventNumIn == 0 && MonsterCollection != class'UM_KFMonstersCollection')
		{
			log("Was we shouldn't have an event but we do!");
		}
		return;
	}
    else
    {
        //if we've already decided on doing an event, return
        if(EventNum != EventNumIn && EventNum != 0)
        {
            return;
        }
    }

    if(EventNumIn == 2 )
    {
        MonsterCollection = class'UM_KFMonstersHalloweenCollection';
    }
    else if(EventNumIn == 3 )
    {
        MonsterCollection = class'UM_KFMonstersXMasCollection';
    }
    //EventNum = EventNumIn;
    PrepareSpecialSquads();
    LoadUpMonsterList();
}

simulated function PrepareSpecialSquadsFromCollection()
{
	local int i;
	
	for( i=0; i<FinalWave; i++ )  {
		Waves[i] = UM_Waves[i];
		MonsterCollection.default.SpecialSquads[i] = MonsterCollection.default.NormalSpecialSquads[i];
	}
}

simulated function PrepareSpecialSquads()
{
	PrepareSpecialSquadsFromCollection();
}

// For the GUI buy menu
simulated function float GetDifficulty()
{
	Return GameDifficulty;
}

function UpdateGameLength()
{
	local Controller C;

	for ( C = Level.ControllerList; C != None; C = C.NextController )  {
		if ( PlayerController(C) != None && PlayerController(C).SteamStatsAndAchievements != None )
			PlayerController(C).SteamStatsAndAchievements.bUsedCheats = PlayerController(C).SteamStatsAndAchievements.bUsedCheats || bCustomGameLength;
	}
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
            if(NextSpawnSquad[0].default.EventClasses.Length > eventNum)
            {
                NextSpawnSquad[0] = Class<KFMonster>(DynamicLoadObject(NextSpawnSquad[0].default.EventClasses[eventNum],Class'Class'));
            }
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

event PostLogin( PlayerController NewPlayer )
{
    local int i;

    NewPlayer.SetGRI(GameReplicationInfo);
    NewPlayer.PlayerReplicationInfo.PlayerID = CurrentID++;

    Super(Invasion).PostLogin(NewPlayer);

    if ( UnrealPlayer(NewPlayer) != None )
        UnrealPlayer(NewPlayer).ClientReceiveLoginMenu(UM_LoginMenuClass, bAlwaysShowLoginMenu);
    
	if ( NewPlayer.PlayerReplicationInfo.Team != None )
        GameEvent("TeamChange",""$NewPlayer.PlayerReplicationInfo.Team.TeamIndex,NewPlayer.PlayerReplicationInfo);

    // Initialize the listen server hosts's VOIP. Had to add this here since the
    // Epic code to do this was calling GetLocalPlayerController() in event Login()
    // which of course will always fail, because the PC's "Player" variable
    // hasn't been set yet. - Ramm
    if ( NewPlayer != None && Level.NetMode == NM_ListenServer && 
		 Level.GetLocalPlayerController() == NewPlayer )
		NewPlayer.InitializeVoiceChat();

    if ( KFPlayerController(NewPlayer) != None )  {
        for ( i = 0; i < InstancedWeaponClasses.Length; i++ )  {
            KFPlayerController(NewPlayer).ClientWeaponSpawned(InstancedWeaponClasses[i], none);
        }
    }

    if ( NewPlayer.PlayerReplicationInfo.bOnlySpectator ) // must not be a spectator
        KFPlayerController(NewPlayer).JoinedAsSpectatorOnly();
    else
        NewPlayer.GotoState('PlayerWaiting');

    if ( KFPlayerController(NewPlayer) != None )
        StartInitGameMusic(KFPlayerController(NewPlayer));

    if ( bCustomGameLength && NewPlayer.SteamStatsAndAchievements != None )
        NewPlayer.SteamStatsAndAchievements.bUsedCheats = true;
}

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

	KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonsters=TotalMaxMonsters;
	KFGameReplicationInfo(Level.Game.GameReplicationInfo).MaxMonstersOn=true;
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
	if ( Class'UM_AData'.default.ActorPool != None )  {
		log("------ Clearing and destroying ActorPool ------", Class.Outer.Name);
		Class'UM_AData'.default.ActorPool.Clear();
		Class'UM_AData'.default.ActorPool.Destroy();
	}
	Super.EndGame(Winner, Reason);
}

defaultproperties
{
     ActorPoolClass=Class'UnlimaginMod.UM_ActorPool'
	 
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
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersCollection'
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersSummerCollection'
	 //UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersHalloweenCollection'
	 MonsterCollection=Class'UnlimaginMod.UM_KFMonstersXMasCollection'
	 UM_MonsterCollection=Class'UnlimaginMod.UM_KFMonstersXMasCollection'
 
	 
	 //FinalWave
     UM_FinalWave=7
	  
     //MaxZombiesOnce
     UM_MaxZombiesOnce=50
	  
     UM_TimeBetweenWaves=100
	  
     UM_WaveTotalMaxMonsters=800
	  
     MutatorClass="UnlimaginServer.UnlimaginMutator"
	 
	 UM_LoginMenuClass="UnlimaginMod.UM_SRInvasionLoginMenu"
	 DefaultPlayerClassName="UnlimaginMod.UM_HumanPawn"
     ScoreBoardType="UnlimaginMod.UM_SRScoreBoard"
     HUDType="UnlimaginMod.UM_SRHUDKillingFloor"
     MapListType="KFMod.KFMapList"
	 
	 PlayerControllerClass=Class'UnlimaginMod.UM_PlayerController'
     PlayerControllerClassName="UnlimaginMod.UM_PlayerController"
	 DefaultLevelRulesClass=Class'UnlimaginMod.UM_SRGameRules'
	 
	 
     UM_MaximumPlayers=12
	  
     //GameReplicationInfoClass=Class'UnlimaginMod.UnlimaginGameReplicationInfo'
	  
     GameName="Unlimagin Mod"
}