// Written by .:..: (2009)
Class UM_ServerStats extends UM_BaseServerStats;


var		UM_StatsObject				MyStatsObject;
var		UnlimaginMutator			MutatorOwner;
var		bool						bHasChanged, bStatsChecking, bStHasInit;
var		bool						bHadSwitchedVet,bSwitchIsOKNow;
var		class<UM_VeterancyTypes>	SelectingPerk;


function int GetID()
{
	return MyStatsObject.ID;
}

function SetID( int ID )
{
	MyStatsObject.ID = ID;
}

event PreBeginPlay()
{
	// Spawning the stat replication actor before the MutatorOwner check us by CheckReplacement function
	if ( Rep == None )  {
		Rep = Spawn(Class'UM_ClientRepInfoLink', Owner);
		Rep.StatObject = self;
	}
	
	Super.PreBeginPlay();
}

event PostBeginPlay()
{
	if ( Rep != None )
		Rep.SpawnCustomLinks();

	OwnerController = UM_PlayerController(Owner);
	bStatsReadyNow = !MutatorOwner.bUseRemoteDatabase;
		
	if ( !bStatsReadyNow || OwnerController == None )  {
		Timer();
		SetTimer((1.0 + FRand()), True);
		Return;
	}
	
	MyStatsObject = MutatorOwner.GetStatsForPlayer(OwnerController);
	if ( KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo) != None )
		KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo).ClientVeteranSkill = None;
	
	bSwitchIsOKNow = True;
	
	if ( MyStatsObject != None )  {
		// Apply selected character.
		if ( MyStatsObject.SelectedChar != "" )
			ApplyCharacter(MyStatsObject.SelectedChar);
		else if ( Rep.bNoStandardChars && Rep.CustomChars.Length > 0 )  {
			MyStatsObject.SelectedChar = Rep.PickRandomCustomChar();
			ApplyCharacter(MyStatsObject.SelectedChar);
		}

		RepCopyStats();
		bHasChanged = True;
		CheckPerks(True);
		ServerSelectPerkName(MyStatsObject.GetSelectedPerk());
	}
	else
		CheckPerks(True);
	
	if ( KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo).ClientVeteranSkill == None )
		ServerSelectPerk(Rep.PickRandomPerk());
	
	bSwitchIsOKNow = False;
	bHadSwitchedVet = False;
	SetTimer(0.1, False);
}

function ApplyCharacter( string CN )
{
	OwnerController.PawnSetupRecord = class'xUtil'.static.FindPlayerRecord(CN);
	if ( OwnerController.PawnSetupRecord.VoiceClassName != "" )
		OwnerController.PlayerReplicationInfo.SetCharacterVoice(OwnerController.PawnSetupRecord.VoiceClassName);
	
	OwnerController.PlayerReplicationInfo.SetCharacterName(CN);
}

function ChangeCharacter( string CN )
{
	local bool bCustom;

	bCustom = Rep.IsCustomCharacter(CN);
	if ( !bCustom )  {
		// Prevent from switching to a standard character.
		if ( Rep.bNoStandardChars && Rep.CustomChars.Length > 0 )  {
			CN = Rep.PickRandomCustomChar();
			bCustom = True;
		}
		else 
			CN = Class'KFGameType'.Static.GetValidCharacter(CN); // Make sure client doesn't chose some invalid character.
	}

	ApplyCharacter(CN);

	// Was not a custom character, don't save client char on server.
	if ( !bCustom )
		CN = "";
	
	if ( MyStatsObject != None )
		MyStatsObject.SetSelectedChar(CN);
}

final function GetData( string D )
{
	bStatsReadyNow = True;
	MyStatsObject.SetSaveData(D);
	RepCopyStats();
	bHasChanged = True;
	bSwitchIsOKNow = True;

	// Apply selected character.
	if ( MyStatsObject.SelectedChar != "" )
		ApplyCharacter(MyStatsObject.SelectedChar);
	else if ( Rep.bNoStandardChars && Rep.CustomChars.Length > 0 )  {
		MyStatsObject.SelectedChar = Rep.PickRandomCustomChar();
		ApplyCharacter(MyStatsObject.SelectedChar);
	}

	CheckPerks(True);
	ServerSelectPerkName(MyStatsObject.GetSelectedPerk());
	Rep.SendClientPerks();
	
	if ( KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(OwnerController.PlayerReplicationInfo).ClientVeteranSkill == None )
		ServerSelectPerk(Rep.PickRandomPerk());
	
	bHadSwitchedVet = False;
	bSwitchIsOKNow = False;
	SetTimer(0.1,false);
}

event Timer()
{
	if ( !bStatsReadyNow )  {
		MutatorOwner.GetRemoteStatsForPlayer(Self);
		Return;
	}
	
	if ( !bStHasInit && OwnerController != None )  {
		if ( OwnerController.SteamStatsAndAchievements != None && OwnerController.SteamStatsAndAchievements != Self )
			OwnerController.SteamStatsAndAchievements.Destroy();
		OwnerController.SteamStatsAndAchievements = Self;
		OwnerController.PlayerReplicationInfo.SteamStatsAndAchievements = Self;
		bStHasInit = True;
		Rep.SendClientPerks();
	}
	
	if ( bStatsChecking )  {
		bStatsChecking = False;
		CheckPerks(False);
	}
}

final function RepCopyStats()
{
	// Copy all stats from data object for client replication
	Rep.RDamageHealedStat = MyStatsObject.DamageHealedStat;
	Rep.RWeldingPointsStat = MyStatsObject.WeldingPointsStat;
	Rep.RShotgunDamageStat = MyStatsObject.ShotgunDamageStat;
	Rep.RHeadshotKillsStat = MyStatsObject.HeadshotKillsStat;
	Rep.RStalkerKillsStat = MyStatsObject.StalkerKillsStat;
	Rep.RBullpupDamageStat = MyStatsObject.BullpupDamageStat;
	Rep.RMeleeDamageStat = MyStatsObject.MeleeDamageStat;
	Rep.RFlameThrowerDamageStat = MyStatsObject.FlameThrowerDamageStat;
	Rep.RSelfHealsStat = MyStatsObject.SelfHealsStat;
	Rep.RSoleSurvivorWavesStat = MyStatsObject.SoleSurvivorWavesStat;
	Rep.RCashDonatedStat = MyStatsObject.CashDonatedStat;
	Rep.RFeedingKillsStat = MyStatsObject.FeedingKillsStat;
	Rep.RBurningCrossbowKillsStat = MyStatsObject.BurningCrossbowKillsStat;
	Rep.RGibbedFleshpoundsStat = MyStatsObject.GibbedFleshpoundsStat;
	Rep.RStalkersKilledWithExplosivesStat = MyStatsObject.StalkersKilledWithExplosivesStat;
	Rep.RGibbedEnemiesStat = MyStatsObject.GibbedEnemiesStat;
	Rep.RBloatKillsStat = MyStatsObject.BloatKillsStat;
	Rep.RTotalZedTimeStat = MyStatsObject.TotalZedTimeStat;
	Rep.RSirenKillsStat = MyStatsObject.SirenKillsStat;
	Rep.RKillsStat = MyStatsObject.KillsStat;
	Rep.RExplosivesDamageStat = MyStatsObject.ExplosivesDamageStat;
	Rep.TotalPlayTime = MyStatsObject.TotalPlayTime;
	Rep.WinsCount = MyStatsObject.WinsCount;
	Rep.LostsCount = MyStatsObject.LostsCount;
	//-- New stat objects by TGN, Unliamgin CG --
	Rep.Unlimagin_ClotKills = MyStatsObject.ClotKills;
	Rep.Unlimagin_DemolitionsPipebombKillsStat = MyStatsObject.DemolitionsPipebombKillsStat;
	Rep.Unlimagin_FireAxeKills = MyStatsObject.FireAxeKills;
	Rep.Unlimagin_ChainsawKills = MyStatsObject.ChainsawKills;
	//-- End of new stat objects by TGN --
	MyStatsObject.GetCustomValues(Rep.CustomLink);
}

function ServerSelectPerkName( name N )
{
	local	byte	i;

	if ( N == '' )
		Return;

	for ( i = 0; i < Rep.CachePerks.Length; ++i )  {
		if ( Rep.CachePerks[i].PerkClass.Name == N )  {
			ServerSelectPerk(Rep.CachePerks[i].PerkClass);
			Break;
		}
	}
}

final function bool SelectionOK( Class<UM_VeterancyTypes> VetType )
{
	local	byte	i;

	for ( i = 0; i < Rep.CachePerks.Length; ++i )  {
		if ( Rep.CachePerks[i].PerkClass == VetType )
			Return Rep.CachePerks[i].CurrentLevel > 0;
	}
	
	Return False;
}

function ServerSelectPerk( Class<UM_VeterancyTypes> VetType )
{
	local	UM_PlayerReplicationInfo	UMPRI;
	local	byte	i;

	if ( !bStatsReadyNow )
		Return;
	
	UMPRI = UM_PlayerReplicationInfo(OwnerController.PlayerReplicationInfo);
	if ( VetType == None || !SelectionOK(VetType) )  {
		if ( !bSwitchIsOKNow )
			OwnerController.ClientMessage("Your desired perk is unavailable.");
		
		Return;
	}
	else if ( UMPRI != None && UMPRI.ClientVeteranSkill == VetType )  {
		if ( SelectingPerk != None )  {
			SelectingPerk = None;
			OwnerController.ClientMessage("You will remain the same perk now.");
		}
		
		Return;
	}
	
	if ( MyStatsObject != None )
		MyStatsObject.SetSelectedPerk(VetType.Name);
	
	if ( !Level.Game.bWaitingToStartMatch && !bSwitchIsOKNow && OwnerController.Pawn != None && !MutatorOwner.bAllowAlwaysPerkChanges )  {
		if ( KFGameReplicationInfo(Level.GRI).bWaveInProgress || bHadSwitchedVet )  {
			OwnerController.ClientMessage(Repl(OwnerController.YouWillBecomePerkString, "%Perk%", VetType.Default.VeterancyName));
			SelectingPerk = VetType;
			OwnerController.SelectedVeterancy = VetType; // Force KFGameType update this.
			Return;
		}
		else
			bHadSwitchedVet = True;
	}
	
	SelectingPerk = None;
	
	for ( i = 0; i < Rep.CachePerks.Length; ++i )  {
		if ( Rep.CachePerks[i].PerkClass == VetType )  {
			if ( Rep.CachePerks[i].CurrentLevel == 0 )
				Return;
			
			if ( UMPRI != None )  {
				OwnerController.SelectedVeterancy = VetType;
				UMPRI.ClientVeteranSkill = VetType;
				UMPRI.ClientVeteranSkillLevel = Rep.CachePerks[i].CurrentLevel - 1;
				// Notifying that the Veterancy info has changed
				UMPRI.NotifyVeterancyChanged();
			}
		}
	}
}

final function CheckPerks( bool bInit )
{
	local	UM_PlayerReplicationInfo	UMPRI;
	local	byte	i, NewLevel;

	if ( !bStatsReadyNow )
		Return;
	
	if ( bInit )  {
		for( i = 0; i < Rep.CachePerks.Length; ++i )
			Rep.CachePerks[i].CurrentLevel = Rep.CachePerks[i].PerkClass.Static.PerkIsAvailable(Rep);
		
		Return;
	}
	
	// Checking perks for the new level
	for( i = 0; i < Rep.CachePerks.Length; ++i )  {
		if ( Rep.CachePerks[i].CurrentLevel <= Rep.MaximumLevel )  {
			NewLevel = Rep.CachePerks[i].PerkClass.Static.PerkIsAvailable(Rep);
			// New Level is Available
			if ( NewLevel > Rep.CachePerks[i].CurrentLevel )  {
				UMPRI = UM_PlayerReplicationInfo(OwnerController.PlayerReplicationInfo);
				Rep.CachePerks[i].CurrentLevel = NewLevel;
				Rep.ClientPerkLevel(i, NewLevel);
				// If this is a current ClientVeteranSkill
				if ( UMPRI != None && UMPRI.ClientVeteranSkill == Rep.CachePerks[i].PerkClass )  {
					UMPRI.ClientVeteranSkillLevel = NewLevel - 1;
					// Notifying that the Veterancy info has changed
					UMPRI.NotifyVeterancyChanged();
				}
				
				if ( MutatorOwner.bMessageAnyPlayerLevelUp )
					BroadcastLocalizedMessage( Class'UM_SRVetEarnedMessage', (NewLevel - 1), OwnerController.PlayerReplicationInfo,, Rep.CachePerks[i].PerkClass );
			}
		}
	}
}

final function DelayedStatCheck()
{
	if ( MyStatsObject != None )
		MyStatsObject.bStatsChanged = True;
	
	if ( bStatsChecking || !bStatsReadyNow )
		Return;
	
	bStatsChecking = True;
	SetTimer(1,false);
}

function NotifyStatChanged()
{
	bHasChanged = True;
	DelayedStatCheck();
}

function MatchEnded()
{
}

// Used to save Killed Stats
function NotifyKilled( Controller Killed, Pawn KilledPawn, class<DamageType> DamageType )
{
	// Server Check
	if ( Role != ROLE_Authority || KFMonster(KilledPawn) == None )
		Return;
	
	if ( UM_BaseGameInfo(Level.Game) != None )
		AddKill(KFMonster(KilledPawn).bLaserSightedEBRM14Headshotted, class<DamTypeMelee>(DamageType) != None, UM_BaseGameInfo(Level.Game).bZEDTimeActive, class<DamTypeM4AssaultRifle>(DamageType) != None || class<DamTypeM4203AssaultRifle>(DamageType) != None, class<DamTypeBenelli>(DamageType) != None, class<DamTypeMagnum44Pistol>(DamageType) != None, class<DamTypeMK23Pistol>(DamageType) != None, class<DamTypeFNFALAssaultRifle>(DamageType) != None, class<DamTypeBullpup>(DamageType) != None, UM_BaseGameInfo(Level.Game).GetCurrentMapName(Level));
	
	// KilledWhileZapped
	if ( KFMonster(KilledPawn).bZapped )
		AddZedKilledWhileZapped();
	
	if ( Class<DamTypeBurned>(DamageType) != None || Class<DamTypeFlamethrower>(DamageType) != None || Class<DamTypeBlowerThrower>(DamageType) != None )
		AddMonsterKillsWithBileOrFlame( KilledPawn.Class );
	
	// Bloat
	if ( UM_BaseMonster_Bloat(KilledPawn) != None )
		AddBloatKill( Class<DamTypeBullpup>(DamageType) != None );
	// Siren
	else if ( UM_BaseMonster_Siren(KilledPawn) != None )
		AddSirenKill( Class<DamTypeLawRocketImpact>(DamageType) != None );
	// Stalker
	else if ( UM_BaseMonster_Stalker(KilledPawn) != None )  {
		if ( Class<DamTypeFrag>(DamageType) != None || Class<UM_BaseDamType_Explosive>(DamageType) != None )
			AddStalkerKillWithExplosives();
	}
	// Scrake
	else if ( UM_BaseMonster_Scrake(KilledPawn) != None )  {
		if ( Class<DamTypeChainsaw>(DamageType) != None )
			AddChainsawScrakeKill();
	}
	// Clot
	else if ( UM_BaseMonster_Clot(KilledPawn) != None )
		AddClotKill();
	
	if ( Class<KFWeaponDamageType>(DamageType) != None )
		Class<KFWeaponDamageType>(DamageType).static.AwardKill( Self, OwnerController, KFMonster(KilledPawn) );
}

function AddDamageHealed(int Amount, optional bool bMP7MHeal, optional bool bMP5MHeal)
{
	bHasChanged = True;
	Rep.RDamageHealedStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.DamageHealedStat+=Amount;
	DelayedStatCheck();
}

function AddWeldingPoints(int Amount)
{
	bHasChanged = True;
	Rep.RWeldingPointsStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.WeldingPointsStat+=Amount;
	DelayedStatCheck();
}

function AddShotgunDamage(int Amount)
{
	bHasChanged = True;
	Rep.RShotgunDamageStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.ShotgunDamageStat+=Amount;
	DelayedStatCheck();
}

function AddHeadshotKill(bool bLaserSightedEBRHeadshot)
{
	bHasChanged = True;
	Rep.RHeadshotKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.HeadshotKillsStat++;
	DelayedStatCheck();
}

function AddStalkerKill()
{
	bHasChanged = True;
	Rep.RStalkerKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.StalkerKillsStat++;
	DelayedStatCheck();
}

function AddBullpupDamage(int Amount)
{
	bHasChanged = True;
	Rep.RBullpupDamageStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.BullpupDamageStat+=Amount;
	DelayedStatCheck();
}

function AddMeleeDamage(int Amount)
{
	bHasChanged = True;
	Rep.RMeleeDamageStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.MeleeDamageStat+=Amount;
	DelayedStatCheck();
}

function AddFlameThrowerDamage(int Amount)
{
	bHasChanged = True;
	Rep.RFlameThrowerDamageStat+=Amount;
	if ( MyStatsObject != None )
		MyStatsObject.FlameThrowerDamageStat+=Amount;
	DelayedStatCheck();
}

function WaveEnded()
{
	if ( SelectingPerk != None )  {
		bSwitchIsOKNow = True;
		ServerSelectPerk(SelectingPerk);
		bSwitchIsOKNow = False;
		bHadSwitchedVet = True;
	}
	else 
		bHadSwitchedVet = False;
}

function MatchStarting()
{
	bHadSwitchedVet = False;
}

function AddKill(bool bLaserSightedEBRM14Headshotted, bool bMeleeKill, bool bZEDTimeActive, bool bM4Kill, bool bBenelliKill, bool bRevolverKill, bool bMK23Kill, bool bFNFalKill, bool bBullpupKill, string MapName)
{
	bHasChanged = True;
	Rep.RKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.KillsStat++;
	DelayedStatCheck();
}

function AddClotKill()
{
	bHasChanged = True;
	Rep.Unlimagin_ClotKills++;
	if( MyStatsObject!=None )
		MyStatsObject.ClotKills++;
	DelayedStatCheck();
}

function AddBloatKill(bool bWithBullpup)
{
	bHasChanged = True;
	Rep.RBloatKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.BloatKillsStat++;
	DelayedStatCheck();
}

function AddSirenKill(bool bLawRocketImpact)
{
	bHasChanged = True;
	Rep.RSirenKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.SirenKillsStat++;
	DelayedStatCheck();
}

function AddDemolitionsPipebombKill()
{
	bHasChanged = True;
	Rep.Unlimagin_DemolitionsPipebombKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.DemolitionsPipebombKillsStat++;
	DelayedStatCheck();
}

function AddStalkerKillWithExplosives()
{
	bHasChanged = True;
	Rep.RStalkersKilledWithExplosivesStat++;
	if( MyStatsObject!=None )
		MyStatsObject.StalkersKilledWithExplosivesStat++;
	DelayedStatCheck();
}

function AddFireAxeKill()
{
	bHasChanged = True;
	Rep.Unlimagin_FireAxeKills++;
	if( MyStatsObject!=None )
		MyStatsObject.FireAxeKills++;
	DelayedStatCheck();
}

function AddChainsawScrakeKill()
{
	bHasChanged = True;
	Rep.Unlimagin_ChainsawKills++;
	if( MyStatsObject!=None )
		MyStatsObject.ChainsawKills++;
	DelayedStatCheck();
}

function AddBurningCrossbowKill()
{
	bHasChanged = True;
	Rep.RBurningCrossbowKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.BurningCrossbowKillsStat++;
	DelayedStatCheck();
}

function AddFeedingKill()
{
	bHasChanged = True;
	Rep.RFeedingKillsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.FeedingKillsStat++;
	DelayedStatCheck();
}

function AddGibKill(bool bWithM79)
{
	bHasChanged = True;
	Rep.RGibbedEnemiesStat++;
	if( MyStatsObject!=None )
		MyStatsObject.GibbedEnemiesStat++;
	DelayedStatCheck();
}

function AddFleshpoundGibKill()
{
	bHasChanged = True;
	Rep.RGibbedFleshpoundsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.GibbedFleshpoundsStat++;
	DelayedStatCheck();
}

function AddSelfHeal()
{
	bHasChanged = True;
	Rep.RSelfHealsStat++;
	if( MyStatsObject!=None )
		MyStatsObject.SelfHealsStat++;
	DelayedStatCheck();
}

function AddOnlySurvivorOfWave()
{
	bHasChanged = True;
	Rep.RSoleSurvivorWavesStat++;
	if( MyStatsObject!=None )
		MyStatsObject.SoleSurvivorWavesStat++;
	DelayedStatCheck();
}

function AddDonatedCash(int Amount)
{
	bHasChanged = True;
	Rep.RCashDonatedStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.CashDonatedStat+=Amount;
	DelayedStatCheck();
}

function AddZedTime(float Amount)
{
	bHasChanged = True;
	Rep.RTotalZedTimeStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.TotalZedTimeStat+=Amount;
}

function AddExplosivesDamage(int Amount)
{
	bHasChanged = True;
	Rep.RExplosivesDamageStat+=Amount;
	if( MyStatsObject!=None )
		MyStatsObject.ExplosivesDamageStat+=Amount;
}

function WonLostGame( bool bDidWin )
{
	if( bDidWin )
	{
		++Rep.WinsCount;
		if( MyStatsObject!=None )
			++MyStatsObject.WinsCount;
	}
	else
	{
		++Rep.LostsCount;
		if( MyStatsObject!=None )
			++MyStatsObject.LostsCount;
	}
	bHasChanged = True;
	DelayedStatCheck();
	GoToState('');
}

event Destroyed()
{
	if ( Rep != None )  {
		if ( MyStatsObject != None )
			MyStatsObject.SetCustomValues(Rep.CustomLink);
		Rep.Destroy();
		Rep = None;
	}
	
	// Was destroyed mid-game for random reason, respawn.
	/*
	if ( OwnerController != None && !OwnerController.bDeleteMe )
		MutatorOwner.AddPlayerToPendingPlayers( OwnerController );	*/
	
	Super.Destroyed();
}

Auto state PlaytimeTimer
{
Begin:
	while( True )  {
		Sleep(1.0);
		if ( OwnerController != None && bStatsReadyNow && !OwnerController.PlayerReplicationInfo.bOnlySpectator )  {
			++Rep.TotalPlayTime;
			if ( MyStatsObject != None )
				++MyStatsObject.TotalPlayTime;
		}
	}
}

defaultproperties
{
}