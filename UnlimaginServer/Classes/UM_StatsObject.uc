// Written by .:..: (2009)
Class UM_StatsObject extends Object
	PerObjectConfig
	Config(UnlimaginServerStats);

struct FCustomConfig
{
	var config name N;
	var config string V;
};

var config array<FCustomConfig> CC;
var config string PlayerName,PlayerIP,SelectedVeterancy,SelectedChar;
var config int DamageHealedStat, WeldingPointsStat, ShotgunDamageStat, HeadshotKillsStat,
		StalkerKillsStat, BullpupDamageStat, MeleeDamageStat, FlameThrowerDamageStat,
		SelfHealsStat, SoleSurvivorWavesStat, CashDonatedStat, FeedingKillsStat,
		BurningCrossbowKillsStat, GibbedFleshpoundsStat, StalkersKilledWithExplosivesStat, 
		GibbedEnemiesStat, BloatKillsStat, SirenKillsStat, KillsStat, ExplosivesDamageStat, TotalPlayTime, WinsCount, LostsCount,
		FireAxeKills, DemolitionsPipebombKillsStat, ClotKills, ChainsawKills;
var config float TotalZedTimeStat;

var name StrToNameProp;
var int ID;
var bool bStatsChanged;

final function name StringToName( string S )
{
	if( S=="" )
		return '';
	SetPropertyText("StrToNameProp",S);
	return StrToNameProp;
}
final function SetCustomValues( UM_SRCustomProgress L )
{
	local int i,c;

	if( Class'UnlimaginMutator'.Default.bOverrideUnusedCustomStats )
		CC.Length = 0;

	c = CC.Length;
	for( L=L; L!=None; L=L.NextLink )
	{
		// Look for excisting entry.
		for( i=0; i<c; ++i )
			if( CC[i].N==L.Class.Name )
			{
				CC[i].V = L.GetProgress();
				break;
			}

		// Add new entry.
		if( i==c )
		{
			CC.Length = c+1;
			CC[c].N = L.Class.Name;
			CC[c].V = L.GetProgress();
			++c;
		}
	}
}
final function GetCustomValues( UM_SRCustomProgress L )
{
	local int i,c;

	c = CC.Length;
	for( L=L; L!=None; L=L.NextLink )
	{
		for( i=0; i<c; ++i )
			if( CC[i].N==L.Class.Name )
			{
				L.SetProgress(CC[i].V);
				break;
			}
	}
}

final function SetSelectedChar( string S )
{
	SelectedChar = S;
	bStatsChanged = true;
}
final function SetSelectedPerk( name S )
{
	SelectedVeterancy = string(S);
}
final function name GetSelectedPerk()
{
	local int i;

	i = InStr(SelectedVeterancy,".");
	if( i>=0 )
		SelectedVeterancy = Mid(SelectedVeterancy,i+1);
	return StringToName(SelectedVeterancy);
}

final function string GetSaveData()
{
	local string Result;

	Result = SelectedVeterancy$","$DamageHealedStat$","$WeldingPointsStat$","$ShotgunDamageStat$","$HeadshotKillsStat$","$StalkerKillsStat;
	Log("First part:"@Result);
	Result = Result$","$BullpupDamageStat$","$MeleeDamageStat$","$FlameThrowerDamageStat$","$SelfHealsStat$","$SoleSurvivorWavesStat;
	Result = Result$","$CashDonatedStat$","$FeedingKillsStat$","$BurningCrossbowKillsStat$","$FireAxeKills$","$ChainsawKills$","$GibbedFleshpoundsStat$","$StalkersKilledWithExplosivesStat$","$DemolitionsPipebombKillsStat;
	Result = Result$","$GibbedEnemiesStat$","$BloatKillsStat$","$ClotKills$","$SirenKillsStat$","$KillsStat$","$ExplosivesDamageStat;
	Result = Result$","$int(TotalZedTimeStat)$","$TotalPlayTime$","$WinsCount$","$LostsCount$",'"$SelectedChar$"'";
	Result = Result$","$GetPropertyText("CC");
	return Result;
}
static final function int GetNextValue( out string S )
{
	local int i,Result;

	i = InStr(S,",");
	if( i==-1 )
	{
		Result = int(S);
		S = "";
	}
	else
	{
		Result = int(Left(S,i));
		S = Mid(S,i+1);
	}
	return Result;
}
static final function string GetNextStrValue( out string S )
{
	local int i;
	local string Result;

	i = InStr(S,",");
	if( i==-1 )
	{
		if( Left(S,1)=="'" )
			Result = Mid(S,1,Len(S)-2);
		//else bad string.
		S = "";
	}
	else if( Left(S,1)=="'" && Mid(S,i-1,1)=="'" )
	{
		Result = Mid(S,1,i-2);
		S = Mid(S,i+1);
	}
	else // bad string again.
	{
		S = Mid(S,i+1);
	}
	return Result;
}
final function SetSaveData( string S )
{
	local int i;

	i = InStr(S,",");
	if( i==-1 )
		return;
	SelectedVeterancy = Left(S,i);
	S = Mid(S,i+1);
	DamageHealedStat = GetNextValue(S);
	WeldingPointsStat = GetNextValue(S);
	ShotgunDamageStat = GetNextValue(S);
	HeadshotKillsStat = GetNextValue(S);
	StalkerKillsStat = GetNextValue(S);
	BullpupDamageStat = GetNextValue(S);
	MeleeDamageStat = GetNextValue(S);
	FlameThrowerDamageStat = GetNextValue(S);
	SelfHealsStat = GetNextValue(S);
	SoleSurvivorWavesStat = GetNextValue(S);
	CashDonatedStat = GetNextValue(S);
	FeedingKillsStat = GetNextValue(S);
	BurningCrossbowKillsStat = GetNextValue(S);
	GibbedFleshpoundsStat = GetNextValue(S);
	StalkersKilledWithExplosivesStat = GetNextValue(S);
	GibbedEnemiesStat = GetNextValue(S);
	BloatKillsStat = GetNextValue(S);
	//-- New stat objects by TGN, Unliamgin CG --
	ClotKills = GetNextValue(S);
	DemolitionsPipebombKillsStat = GetNextValue(S);
	FireAxeKills = GetNextValue(S);
	ChainsawKills = GetNextValue(S);
	//-- End of new stat objects by TGN --
	SirenKillsStat = GetNextValue(S);
	KillsStat = GetNextValue(S);
	ExplosivesDamageStat = GetNextValue(S);
	TotalZedTimeStat = GetNextValue(S);
	TotalPlayTime = GetNextValue(S);
	WinsCount = GetNextValue(S);
	LostsCount = GetNextValue(S);
	SelectedChar = GetNextStrValue(S);

	CC.Length = 0;
	if( Len(S)>0 )
		SetPropertyText("CC",S);
}

defaultproperties
{
	ID=-1
}