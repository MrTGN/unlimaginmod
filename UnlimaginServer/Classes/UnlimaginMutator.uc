//================================================================================
//	Package:		 UnlimaginServer
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UnlimaginMutator
//	Parent class:	 Mutator
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//  ServerPerks by Marco
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.07.2012 23:34
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
Class UnlimaginMutator extends Mutator
	Config(UnlimaginServer);


//========================================================================
//[block] Variables

const		UnlimaginModVersion = "0.114";
//const		UnlimaginModBuildDate = ;

struct ReplacedPickupData
{
	var		name		DefaultClass;
	var		string		ReplaceByClass;
};

struct ChatIconType
{
	var()	config		string		IconTexture, IconTag;
	var()	config		bool		bCaseInsensitive;
};

var()	globalconfig	array< string >			Perks, TraderInventory, WeaponCategories, CustomCharacters;
var()	globalconfig	int						MinPerksLevel, MaxPerksLevel, RemotePort, MidGameSaveWaves;
var()	globalconfig	float					RequirementScaling;
var()	globalconfig	string					RemoteDatabaseURL, RemotePassword;
var()	globalconfig	array< ChatIconType >	SmileyTags;

var		array< byte >							LoadInvCategory;
var		array< class<UM_VeterancyTypes> >		LoadPerks;
var		array< class<Pickup> >					LoadInventory;
//var		array< UM_PlayerController >			PendingPlayers;
var		array<UM_StatsObject>					ActiveStats;
var		localized		string					ServerPerksGroup;
var		transient		UM_DatabaseUdpLink		Link;
var		array<UM_ServerStats>					PendingData;
var						KFGameType				KFGT;
var						int						LastSavedWave, WaveCounter;
var		array<UM_HUD.SmileyMessageType>			SmileyMsgs;

var()	globalconfig	bool					bNoSavingProgress, bUseRemoteDatabase, bUsePlayerNameAsID;
var()	globalconfig	bool					bMessageAnyPlayerLevelUp, bUseLowestRequirements, bBWZEDTime;
var()	globalconfig	bool					bUseEnhancedScoreboard, bOverrideUnusedCustomStats, bAllowAlwaysPerkChanges;
var()	globalconfig	bool					bForceCustomChars, bEnableChatIcons, bEnhancedShoulderView;

var						bool					bEnabledEmoIcons;

var		array< string >							ModServerPackages;

var		array< ReplacedPickupData >				ReplacedPickups;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

event PreBeginPlay()
{
	Super.PreBeginPlay();
	FriendlyName = default.FriendlyName@"V"$UnlimaginModVersion;
}

function AddModServerPackages()
{
	local	int		i;
	// Forcing packages to be downloaded by clients
	Log("Adding"@ModServerPackages.Length@"additional serverpackages",Class.Outer.Name);
	for ( i = 0; i < ModServerPackages.Length; i++ ) {
		if ( ModServerPackages[i] == "" )  {
			ModServerPackages.Remove(i, 1);
			--i;
		}
		AddToPackageMap(ModServerPackages[i]);
	}
}

event PostBeginPlay()
{
	//local int	i, j, l;
	local int	i, j;
	local class<UM_VeterancyTypes> V;
	local class<Pickup> P;
	local string S;
	local byte Cat;
	local class<PlayerRecordClass> PR;
	local Object O;
	local Texture T;

	KFGT = KFGameType(Level.Game);
	bEnabledEmoIcons = bEnableChatIcons;
	
	// Load perks.
	for ( i = 0; i < Perks.Length; ++i )  {
		if ( Perks[i] != None )
			V = class<UM_VeterancyTypes>(DynamicLoadObject(Perks[i], Class'Class'));
		
		if ( V == None )
			continue;

		LoadPerks[LoadPerks.Length] = V;
		ImplementPackage(V.Outer.Name);
	}
	
	if ( WeaponCategories.Length == 0 ) {
		WeaponCategories.Length = 1;
		WeaponCategories[0] = "All";
	}

	// Load up trader inventory.
	for( i = 0; i < TraderInventory.Length; ++i )  {
		S = TraderInventory[i];
		j = InStr(S,":");
		
		if ( j > 0 ) {
			Cat = Min(int(Left(S,j)),WeaponCategories.Length - 1);
			S = Mid(S,j+1);
		}
		else 
			Cat = 0;
		
		P = class<Pickup>(DynamicLoadObject(S,Class'Class'));
		if ( P != None ) {
			LoadInventory[LoadInventory.Length] = P;
			LoadInvCategory[LoadInvCategory.Length] = Cat;
			if ( P.Outer.Name != 'KFMod' )
				ImplementPackage(P.Outer.Name);
		
			/*
			l = Class'UM_WeaponInfoGenerator'.default.WeaponsInfo.Length;
			Class'UM_WeaponInfoGenerator'.default.WeaponsInfo.Insert(l,1);
			Class'UM_WeaponInfoGenerator'.default.WeaponsInfo[l].PickupClass = Class<KFWeaponPickup>(P);
			Class'UM_WeaponInfoGenerator'.default.WeaponsInfo[l].CatNum = Cat;
			*/
		}
	}
	
	if ( Class'UM_GlobalData'.default.WeapInfoGen == None )
		Spawn(Class'UM_WeaponInfoGenerator');
	
	// Load custom chars.
	for( i=0; i<CustomCharacters.Length; ++i )
	{
		// Separate group from actual skin.
		S = CustomCharacters[i];
		j = InStr(S,":");
		if( j>=0 )
			S = Mid(S,j+1);
		PR = class<PlayerRecordClass>(DynamicLoadObject(S$"Mod."$S,class'Class',True));
		if( PR!=None )
		{
			if( PR.Default.MeshName!="" ) // Add mesh package.
			{
				O = DynamicLoadObject(PR.Default.MeshName,class'Mesh',True);
				while( O!=None && O.Outer!=None )
					O = O.Outer;
				if( O!=None )
					ImplementPackage(O.Name);
			}
			if( PR.Default.BodySkinName!="" ) // Add skin package.
			{
				O = DynamicLoadObject(PR.Default.BodySkinName,class'Material',True);
				while( O!=None && O.Outer!=None )
					O = O.Outer;
				if( O!=None )
					ImplementPackage(O.Name);
			}
			ImplementPackage(PR.Outer.Name);
		}
	}
	
	// Load chat icons
	if( bEnabledEmoIcons )
	{
		j = 0;
		for( i=0; i<SmileyTags.Length; ++i )
		{
			if( SmileyTags[i].IconTexture=="" || SmileyTags[i].IconTag=="" )
				continue;
			T = Texture(DynamicLoadObject(SmileyTags[i].IconTexture,class'Texture',True));
			if( T==None )
				continue;
			SmileyMsgs.Length = j+1;
			SmileyMsgs[j].SmileyTex = T;
			if( SmileyTags[i].bCaseInsensitive )
				SmileyMsgs[j].SmileyTag = Caps(SmileyTags[i].IconTag);
			else SmileyMsgs[j].SmileyTag = SmileyTags[i].IconTag;
			SmileyMsgs[j].bInCAPS = SmileyTags[i].bCaseInsensitive;
			++j;
		}
		bEnabledEmoIcons = (j!=0);
	}
	
	AddModServerPackages();

	if( bUseRemoteDatabase )
	{
		Log("Using remote database:"@RemoteDatabaseURL$":"$RemotePort,Class.Outer.Name);
		Link = Spawn(Class'UM_DatabaseUdpLink');
		Link.Mut = Self;
	}
}

final function ImplementPackage( name N )
{
	local	int		i;
	local	string	S;
	
	S = string(N);
	// Checking if this package has already been added
	for ( i = 0; i < ModServerPackages.Length; ++i ) {
		if ( ModServerPackages[i] == "" )  {
			ModServerPackages.Remove(i, 1);
			--i;
			continue;
		}
		else if ( ModServerPackages[i] == S )
			Return;
	}
	ModServerPackages[ModServerPackages.Length] = S;
}

/*
final function AddPlayerToPendingPlayers( UM_PlayerController PC )
{
	PendingPlayers[PendingPlayers.Length] = PC;
	SetTimer(0.15, false);
}

event Timer()
{
	local	int		i;
	
	while ( PendingPlayers.Length > 0 )  {
		i = PendingPlayers.Length - 1;
		if ( PendingPlayers[i] != None && PendingPlayers[i].Player != None )  {
			// Storing bUseAdvBehindview to the bEnhancedShoulderView in PlayerControllers
			PendingPlayers[i].bUseAdvBehindview = bEnhancedShoulderView;
			if ( UM_ServerStats(PendingPlayers[i].SteamStatsAndAchievements) == None )  {
				// Has stats but not what we need
				if ( PendingPlayers[i].SteamStatsAndAchievements != None )
					PendingPlayers[i].SteamStatsAndAchievements.Destroy();
				// Spawning a new stats for the player
				PendingPlayers[i].SteamStatsAndAchievements = Spawn(Class'UM_ServerStats', PendingPlayers[i]);
			}
		}
		PendingPlayers.Remove(i, 1);
	}
}	*/

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local	int		i;
	
	// Check for the ReplacedPickups
	if ( Pickup(Other) != None )  {
		for ( i = 0; i < ReplacedPickups.Length; ++i )  {
			if ( ReplacedPickups[i].DefaultClass != '' && Other.IsA(ReplacedPickups[i].DefaultClass) )  {
				ReplaceWith( Other, ReplacedPickups[i].ReplaceByClass );
				Return False;	// Was replaced
			}
		}
	}
	// Finding a new joined players
	/*  # Moved to the UM_PlayerController
	else if ( UM_PlayerController(Other) != None )
		AddPlayerToPendingPlayers( UM_PlayerController(Other) );	*/
	// Finding a new stats objects
	else if ( UM_ServerStats(Other) != None )
		SetServerPerks( UM_ServerStats(Other) );
	// Finding new stats replication actors
	else if ( UM_ClientRepInfoLink(Other) != None )
		SetupRepLink( UM_ClientRepInfoLink(Other) );

	Return True;	// Wasn't replaced
}

final function SetServerPerks( UM_ServerStats Stat )
{
	local int i;

	Stat.MutatorOwner = Self;
	Stat.Rep.MinimumLevel = MinPerksLevel;
	Stat.Rep.MaximumLevel = MaxPerksLevel + 1;
	Stat.Rep.RequirementScaling = RequirementScaling;
	Stat.Rep.CachePerks.Length = LoadPerks.Length;
	for( i = 0; i < LoadPerks.Length; ++i )
		Stat.Rep.CachePerks[i].PerkClass = LoadPerks[i];
}

final function SetupRepLink( UM_ClientRepInfoLink R )
{
	local int i;

	R.bMinimalRequirements = bUseLowestRequirements;
	R.bBWZEDTime = bBWZEDTime;
	R.bNoStandardChars = bForceCustomChars;
	
	R.ShopInventory.Length = LoadInventory.Length;
	for ( i = 0; i < LoadInventory.Length; ++i )  {
		R.ShopInventory[i].PC = LoadInventory[i];
		R.ShopInventory[i].CatNum = LoadInvCategory[i];
	}
	
	R.ShopCategories = WeaponCategories;
	R.CustomChars = CustomCharacters;
	
	if ( bEnabledEmoIcons )
		R.SmileyTags = SmileyMsgs;
}

function GetServerDetails( out GameInfo.ServerResponseLine ServerState )
{
	local int i, l;

	l = ServerState.ServerInfo.Length;
	
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Unlimagin Mod Version";
	ServerState.ServerInfo[l].Value = UnlimaginModVersion;
	l++;
	
	/*
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Unlimagin Mod Build Date";
	ServerState.ServerInfo[l].Value = UnlimaginModBuildDate;
	l++;
	*/
	
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Min perk level";
	ServerState.ServerInfo[l].Value = string(MinPerksLevel);
	l++;
	
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Max perk level";
	ServerState.ServerInfo[l].Value = string(MaxPerksLevel);
	l++;
	
	ServerState.ServerInfo.Length = l + 1;
	ServerState.ServerInfo[l].Key = "Number of trader weapons";
	ServerState.ServerInfo[l].Value = string(LoadInventory.Length);
	l++;
	
	for( i = 0; i < LoadPerks.Length; ++i )  {
		ServerState.ServerInfo.Length = l + 1;
		ServerState.ServerInfo[l].Key = "Veterancy #"$string(i + 1);
		ServerState.ServerInfo[l].Value = LoadPerks[i].Default.VeterancyName;
		l++;
	}
}

static final function string GetPlayerID( PlayerController PC )
{
	if ( Default.bUsePlayerNameAsID )
		Return PC.PlayerReplicationInfo.PlayerName;
	
	Return PC.GetPlayerIDHash();
}

final function UM_StatsObject GetStatsForPlayer( PlayerController PC )
{
	local	UM_StatsObject	S;
	local	string			sID;
	local	int				i;

	if ( bNoSavingProgress || Level.Game.bGameEnded )
		Return None;
	
	sID = GetPlayerID(PC);
	for ( i = 0; i < ActiveStats.Length; ++i )  {
		if ( string(ActiveStats[i].Name) ~= sID )  {
			S = ActiveStats[i];
			Break;
		}
	}
	
	if ( S == None )  {
		S = new(None, sID) Class'UM_StatsObject';
		ActiveStats[ActiveStats.Length] = S;
	}
	
	S.PlayerName = PC.PlayerReplicationInfo.PlayerName;
	S.PlayerIP = PC.GetPlayerNetworkAddress();
	
	Return S;
}

final function SaveStats()
{
	local int i;
	local UM_ClientRepInfoLink CP;

	Log("*** Saving"@ActiveStats.Length@"stats objects ***",Class.Outer.Name);
	foreach DynamicActors(Class'UM_ClientRepInfoLink',CP)
		if( CP.StatObject!=None && UM_ServerStats(CP.StatObject).MyStatsObject!=None )
			UM_ServerStats(CP.StatObject).MyStatsObject.SetCustomValues(CP.CustomLink);

	if( bUseRemoteDatabase )
	{
		if( Link!=None )
			Link.SaveStats();
		return;
	}
	for( i=0; i<ActiveStats.Length; ++i )
		if( ActiveStats[i].bStatsChanged )
		{
			ActiveStats[i].bStatsChanged = false;
			ActiveStats[i].SaveConfig();
		}
}

final function CheckWinOrLose()
{
	local	bool	bWin;
	local	Controller	P;
	local	PlayerController	Player;

	bWin = (KFGameReplicationInfo(Level.GRI) != None && KFGameReplicationInfo(Level.GRI).EndGameType == 2);
	for ( P = Level.ControllerList; P != None; P = P.nextController )  {
		Player = PlayerController(P);
		if ( Player != None && UM_ServerStats(Player.SteamStatsAndAchievements) != None )
			UM_ServerStats(Player.SteamStatsAndAchievements).WonLostGame(bWin);
	}
}

final function InitNextWave()
{
	if ( ++WaveCounter >= MidGameSaveWaves )  {
		WaveCounter = 0;
		SaveStats();
	}
}

Auto state EndGameTracker
{
Begin:
	while( !Level.Game.bGameEnded )
	{
		Sleep(1.f);
		if( MidGameSaveWaves>0 && KFGT!=None && KFGT.WaveNum!=LastSavedWave )
		{
			LastSavedWave = KFGT.WaveNum;
			InitNextWave();
		}
	}
	CheckWinOrLose();
	SaveStats();
	if ( Class'UM_GlobalData'.default.WeapInfoGen != None )
		Class'UM_GlobalData'.default.WeapInfoGen.Destroy();
}

final function ReceivedPlayerID( string S )
{
	local int i,RID;

	i = InStr(S,"|");
	RID = int(Left(S,i));
	S = Mid(S,i+1);

	for( i=0; i<PendingData.Length; ++i )
	{
		if ( PendingData[i] == None )
			PendingData.Remove(i--,1);
		else if ( S ~= string(PendingData[i].MyStatsObject.Name) )  {
			PendingData[i].SetID(RID);
			break;
		}
	}
}

final function ReceivedPlayerData( string S )
{
	local int i,RID;

	i = InStr(S,"|");
	RID = int(Left(S,i));
	S = Mid(S,i+1);

	for( i = 0; i < PendingData.Length; ++i )  {
		if ( PendingData[i]==None )
			PendingData.Remove(i--,1);
		else if ( RID==PendingData[i].GetID() )  {
			PendingData[i].GetData(S);
			PendingData.Remove(i,1);
			break;
		}
	}
}

final function string GetSafeName( string S )
{
	ReplaceText(S,"=","-");
	ReplaceText(S,Chr(10),""); // LF
	ReplaceText(S,Chr(13),""); // CR
	ReplaceText(S,Chr(34),"'"); // "
	return S;
}

final function GetRemoteStatsForPlayer( UM_ServerStats Other )
{
	local int i;

	if ( Link==None || !Link.bConnectionReady )
		Return;
	Link.SendText(Link.A,Chr(Link.ENetID.ID_NewPlayer)$Other.MyStatsObject.Name$"*"$GetSafeName(Other.OwnerController.PlayerReplicationInfo.PlayerName));
	
	for ( i = 0; i < PendingData.Length; ++i )
		if ( PendingData[i] == Other )
			Return;
	
	PendingData[PendingData.Length] = Other;
}


function string GetInventoryClassOverride(string InventoryClassName)
{
	// Check for other mutators in the linked list
	if ( NextMutator != None )
		Return NextMutator.GetInventoryClassOverride(InventoryClassName);
		
	Return InventoryClassName;
}

static function FillPlayInfo(PlayInfo PlayInfo)
{
	Super.FillPlayInfo(PlayInfo);

	PlayInfo.AddSetting(default.ServerPerksGroup,"Perks","Perk Classes",1,1,"Text","42",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"CustomCharacters","Custom chars",1,1,"Text","42",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"TraderInventory","Trader Weapons",1,1,"Text","42",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"WeaponCategories","Weapon categories",1,1,"Text","42",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"MinPerksLevel","Min Perk Level",1,0, "Text", "4;-1:254",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"MaxPerksLevel","Max Perk Level",1,0, "Text", "4;0:254",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"RequirementScaling","Req Scaling",1,0, "Text", "6;0.01:4.00",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"bNoSavingProgress","No saving",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bAllowAlwaysPerkChanges","Unlimited perk changes",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bUseRemoteDatabase","Use remote database",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"RemoteDatabaseURL","Remote database URL",1,1,"Text","64",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"RemotePort","Remote database port",1,0, "Text", "5;0:65535",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"RemotePassword","Remote database password",1,0, "Text", "64",,,True);
	PlayInfo.AddSetting(default.ServerPerksGroup,"MidGameSaveWaves","MidGame Save Waves",1,0, "Text", "5;0:10",,,True);

	PlayInfo.AddSetting(default.ServerPerksGroup,"bUsePlayerNameAsID","Use PlayerName as ID",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bMessageAnyPlayerLevelUp","Notify any levelup",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bUseLowestRequirements","Use lowest req",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bBWZEDTime","BW ZED-time",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bUseEnhancedScoreboard","Enhanced scoreboard",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bForceCustomChars","Force Custom Chars",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bEnableChatIcons","Enable chat icons",1,0, "Check");
	PlayInfo.AddSetting(default.ServerPerksGroup,"bEnhancedShoulderView","Shoulder view",1,0, "Check");
}

static event string GetDescriptionText(string PropName)
{
	switch (PropName)
	{
		case "Perks":			return "Perk classes.";
		case "CustomCharacters":	return "Custom mod characters.";
		case "MinPerksLevel":		return "Minimum perk level players can have.";
		case "MaxPerksLevel":		return "Maximum perk level players can have.";
		case "RequirementScaling":	return "Perk requirements scaling.";
		case "bNoSavingProgress":	return "Server shouldn't save perk progression.";
		case "bUseRemoteDatabase":	return "Instead of storing perk data locally on server, use remote data storeage server.";
		case "RemoteDatabaseURL":	return "URL of the remote database.";
		case "RemotePort":		return "Port of the remote database.";
		case "RemotePassword":		return "Password for server to access the remote database.";
		case "MidGameSaveWaves":	return "Between how many waves should it mid-game save stats.";
		case "TraderInventory":		return "Trader inventory classes list";
		case "bUsePlayerNameAsID":	return "Use PlayerName's as ID instead of ID Hash.";
		case "bMessageAnyPlayerLevelUp": return "Broadcast a global message anytime someone gains a perk upgrade.";
		case "bUseLowestRequirements":	return "Use lowest form of requirements for perks.";
		case "bBWZEDTime":		return "Make screen go black and white during ZED-time.";
		case "WeaponCategories":	return "Weapon category names.";
		case "bUseEnhancedScoreboard":	return "Should use serverperk's own scoreboard.";
		case "bAllowAlwaysPerkChanges":	return "Allow unlimited perk changes.";
		case "bForceCustomChars":	return "Force players to use specified custom characters.";
		case "bEnableChatIcons":	return "Should enable chat icons to replace specific tags in chat.";
		case "bEnhancedShoulderView": return "Should enable a more enhanced on shoulder behindview.";
	}
	return Super.GetDescriptionText(PropName);
}

//[end] Functions
//====================================================================

defaultproperties
{
	GroupName="KFUnlimaginMod"
	FriendlyName="Unlimagin Mod"
	Description="Global Killing Floor Mod. Copyright ｩ 2012-2014 Tsiryuta G. N."
	Perks(0)="UnlimaginMod.UM_VeterancySupport"
	Perks(1)="UnlimaginMod.UM_VeterancyBerserker"
	Perks(2)="UnlimaginMod.UM_VeterancyCommando"
	Perks(3)="UnlimaginMod.UM_VeterancyFieldMedic"
	Perks(4)="UnlimaginMod.UM_VeterancyFirebug"
	Perks(5)="UnlimaginMod.UM_VeterancySharpshooter"
	Perks(6)="UnlimaginMod.UM_VeterancyDemolitions"
	MinPerksLevel=0
	MaxPerksLevel=6
	RequirementScaling=1
	ServerPerksGroup="Perks"
	RemotePort=5000
	RemoteDatabaseURL="192.168.1.33"
	RemotePassword="Pass"
	bUseEnhancedScoreboard=True
	bEnableChatIcons=True
	bEnhancedShoulderView=True
	MidGameSaveWaves=1

	ReplacedPickups(0)=(DefaultClass="KFMod.ShotgunPickup",ReplaceByClass="UnlimaginMod.UM_BenelliM3Pickup")
	ReplacedPickups(1)=(DefaultClass="KFMod.WinchesterPickup",ReplaceByClass="UnlimaginMod.UM_WinchesterM1894Pickup")
	ReplacedPickups(2)=(DefaultClass="KFMod.CrossbowPickup",ReplaceByClass="UnlimaginMod.UM_CrossbowPickup")
	ReplacedPickups(3)=(DefaultClass="KFMod.BullpupPickup",ReplaceByClass="UnlimaginMod.UM_L22A1Pickup")
	ReplacedPickups(4)=(DefaultClass="KFMod.AK47Pickup",ReplaceByClass="UnlimaginMod.UM_AK47Pickup")
	ReplacedPickups(5)=(DefaultClass="KFMod.SCARMK17Pickup",ReplaceByClass="UnlimaginMod.UM_SCARMK17Pickup")
	ReplacedPickups(6)=(DefaultClass="KFMod.FlameThrowerPickup",ReplaceByClass="UnlimaginMod.UM_FlameThrowerPickup")
	ReplacedPickups(7)=(DefaultClass="KFMod.MAC10Pickup",ReplaceByClass="UnlimaginMod.UM_MAC10Pickup")
	ReplacedPickups(8)=(DefaultClass="KFMod.BenelliPickup",ReplaceByClass="UnlimaginMod.UM_BenelliM4Pickup")
	ReplacedPickups(9)=(DefaultClass="KFMod.M4Pickup",ReplaceByClass="UnlimaginMod.UM_M4Pickup")
	ReplacedPickups(10)=(DefaultClass="KFMod.M4203Pickup",ReplaceByClass="UnlimaginMod.UM_M4203Pickup")
	ReplacedPickups(11)=(DefaultClass="KFMod.KSGPickup",ReplaceByClass="UnlimaginMod.UM_KSGPickup")
	ReplacedPickups(12)=(DefaultClass="KFMod.MK23Pickup",ReplaceByClass="UnlimaginMod.UM_MK23Pickup")
	ReplacedPickups(13)=(DefaultClass="KFMod.DualMK23Pickup",ReplaceByClass="UnlimaginMod.UM_DualMK23Pickup")
	ReplacedPickups(14)=(DefaultClass="KFMod.FNFAL_ACOG_Pickup",ReplaceByClass="UnlimaginMod.UM_FNFAL_ACOG_Pickup")
	//ReplacedPickups()=(DefaultClass="",ReplaceByClass="")
	
	/*
	TraderInventory(0)="4:KFMod.MP7MPickup"
	TraderInventory(1)="2:KFMod.ShotgunPickup"
	TraderInventory(2)="2:KFMod.BoomStickPickup"
	TraderInventory(3)="5:KFMod.LAWPickup"
	
	TraderInventory(4)="2:UnlimaginMod.UM_AA12Pickup"
	
	TraderInventory(5)="1:KFMod.SinglePickup"
	TraderInventory(6)="1:KFMod.DualiesPickup"
	TraderInventory(7)="1:KFMod.DeaglePickup"
	TraderInventory(8)="1:KFMod.DualDeaglePickup"
	TraderInventory(9)="3:KFMod.WinchesterPickup"
	TraderInventory(10)="3:KFMod.CrossbowPickup"
	TraderInventory(11)="3:KFMod.M14EBRPickup"
	TraderInventory(12)="4:KFMod.BullpupPickup"
	TraderInventory(13)="4:KFMod.AK47Pickup"
	TraderInventory(14)="4:KFMod.SCARMK17Pickup"
	TraderInventory(15)="0:KFMod.KnifePickup"
	TraderInventory(16)="0:KFMod.MachetePickup"
	TraderInventory(17)="0:KFMod.AxePickup"
	TraderInventory(18)="0:KFMod.ChainsawPickup"
	TraderInventory(19)="0:KFMod.KatanaPickup"
	TraderInventory(20)="6:KFMod.FlameThrowerPickup"
	TraderInventory(21)="5:KFMod.PipeBombPickup"
	TraderInventory(22)="5:KFMod.M79Pickup"
	TraderInventory(23)="5:KFMod.M32Pickup"
	TraderInventory(24)="4:KFMod.MAC10Pickup"
	TraderInventory(25)="4:KFMod.MP5MPickup"
	TraderInventory(26)="2:KFMod.BenelliPickup"
	TraderInventory(27)="1:KFMod.Magnum44Pickup"
	TraderInventory(28)="1:KFMod.Dual44MagnumPickup"
	TraderInventory(29)="4:KFMod.M4Pickup"
	TraderInventory(30)="0:KFMod.ClaymoreSwordPickup"
	TraderInventory(31)="6:KFMod.HuskGunPickup"
	TraderInventory(32)="4:KFMod.M4203Pickup"
	TraderInventory(33)="4:KFMod.M7A3MPickup"
	TraderInventory(34)="2:KFMod.KSGPickup"
	TraderInventory(35)="1:KFMod.MK23Pickup"
	TraderInventory(36)="1:KFMod.DualMK23Pickup"
	TraderInventory(37)="4:KFMod.FNFAL_ACOG_Pickup" */

	WeaponCategories(0)="Melee"
	WeaponCategories(1)="Pistol"
	WeaponCategories(2)="Shotgun"
	WeaponCategories(3)="Sniper Rifle"
	WeaponCategories(4)="Machine Gun"
	WeaponCategories(5)="Explosive"
	WeaponCategories(6)="Flame Thrower"
	WeaponCategories(7)="Common"
	
	SmileyTags(0)=(IconTag=">:(",IconTexture="UnlimaginMod_T.Smileys.Smileys_Mad")
	SmileyTags(1)=(IconTag=":(",IconTexture="UnlimaginMod_T.Smileys.Smileys_Frown")
	SmileyTags(2)=(IconTag=":)",IconTexture="UnlimaginMod_T.Smileys.Smileys_GreenLickB")
	SmileyTags(3)=(IconTag=":P",IconTexture="UnlimaginMod_T.Smileys.Smileys_Tongue",bCaseInsensitive=True)
	SmileyTags(4)=(IconTag=":d",IconTexture="UnlimaginMod_T.Smileys.Smileys_GreenLick")
	SmileyTags(5)=(IconTag=":D",IconTexture="UnlimaginMod_T.Smileys.Smileys_BigGrin")
	SmileyTags(6)=(IconTag=":|",IconTexture="UnlimaginMod_T.Smileys.Smileys_Indiffe")
	SmileyTags(7)=(IconTag=":/",IconTexture="UnlimaginMod_T.Smileys.Smileys_Ohwell")
	SmileyTags(8)=(IconTag=":*",IconTexture="UnlimaginMod_T.Smileys.Smileys_RedFace")
	SmileyTags(9)=(IconTag=":-*",IconTexture="UnlimaginMod_T.Smileys.Smileys_RedFace")
	SmileyTags(10)=(IconTag="Ban?",IconTexture="UnlimaginMod_T.Smileys.Smileys_Ban",bCaseInsensitive=True)
	SmileyTags(11)=(IconTag="B)",IconTexture="UnlimaginMod_T.Smileys.Smileys_Cool")
	SmileyTags(12)=(IconTag="Hmm",IconTexture="UnlimaginMod_T.Smileys.Smileys_Hmm")
	SmileyTags(13)=(IconTag="XD",IconTexture="UnlimaginMod_T.Smileys.Smileys_Scream")
	SmileyTags(14)=(IconTag="SPAM",IconTexture="UnlimaginMod_T.Smileys.Smileys_Spam")
	
	//[block] ServerPackages
	ModServerPackages(0)="UnlimaginMod.u"
	ModServerPackages(1)="UnlimaginMod_Snd.uax"
	ModServerPackages(2)="UnlimaginMod_T.utx"
	//Whisky_ColtM1911
	ModServerPackages(4)="IJCWeaponPackSoundsW2.uax"
	ModServerPackages(5)="UM_WM1911Pistol_A.ukx"
	ModServerPackages(6)="WM1911Pistol_SM.usx"
	ModServerPackages(7)="WM1911Pistol_T.utx"
	//OperationY_G2Contender
	ModServerPackages(8)="Thompson_G2_A.ukx"
	//Maria_Cz75Laser
	ModServerPackages(9)="Cz75Laser_A.ukx"
	ModServerPackages(10)="Cz75Laser_SM.usx"
	ModServerPackages(11)="Cz75Laser_T.utx"
	//ZedekPD_MR96Revolver
	ModServerPackages(12)="MR96_A.ukx"
	ModServerPackages(13)="MR96_S.uax"
	ModServerPackages(14)="MR96_SM.usx"
	ModServerPackages(15)="MR96_T.utx"
	//Maria_M37Ithaca
	ModServerPackages(16)="FMX_Ithaca_A.ukx"
	ModServerPackages(17)="FMX_Ithaca_Snd.uax"
	ModServerPackages(18)="FMX_Ithaca_SM.usx"
	ModServerPackages(19)="FMX_Ithaca_T.utx"
	//Hemi_Braindead_Moss12
	ModServerPackages(20)="KF_Moss123rdAnims.ukx"
	ModServerPackages(21)="KF_Moss12Anims.ukx"
	ModServerPackages(22)="KF_Moss12Snd.uax"
	ModServerPackages(23)="KF_Moss12_pickups.usx"
	ModServerPackages(24)="KF_Moss123rd.usx"
	ModServerPackages(25)="KF_Moss12.utx"
	//OperationY_Protecta
	ModServerPackages(26)="Protecta_A.ukx"
	//MrQuebec_HekuT_Spas12
	ModServerPackages(27)="Spas_A.ukx"
	ModServerPackages(28)="Spas_SM.usx"
	ModServerPackages(29)="Spas_T.utx"
	//Braindead_HuntingRifle
	ModServerPackages(30)="HuntingRifleA.ukx"
	ModServerPackages(31)="HuntingRifle_Snd.uax"
	ModServerPackages(32)="HuntingRifleS.usx"
	ModServerPackages(33)="HuntingRifleT.utx"
	//OperationY_SVDLLI
	ModServerPackages(34)="SVDLLI_A.ukx"
	//OperationY_V94
	ModServerPackages(35)="B94_A.ukx"
	ModServerPackages(36)="B94_SN.uax"
	ModServerPackages(37)="B94_SM.usx"
	ModServerPackages(38)="B94_T.utx"
	//OperationY_HK417
	ModServerPackages(39)="HK417_A.ukx"
	//OperationY_VSSDT
	ModServerPackages(40)="VSSDT_v2_A.ukx"
	//OperationY_M82A1LLI
	ModServerPackages(41)="M82A1LLI_A.ukx"
	//OperationY_L96AWPLLI
	ModServerPackages(42)="L96AWPLLI_A.ukx"
	//FluX_G36C
	ModServerPackages(43)="FX-G36C_v2_A.ukx"
	ModServerPackages(44)="FX-G36C_v2_Snd.uax"
	ModServerPackages(45)="FX-G36C_SM.usx"
	ModServerPackages(46)="FX-G36C_T.utx"
	//Maria_M16A4
	ModServerPackages(47)="M16A4Rifle_A.ukx"
	ModServerPackages(48)="M16A4Rifle_SM.usx"
	ModServerPackages(49)="M16A4Rifle_T.utx"
	//JSullivan_L85A2
	ModServerPackages(50)="JS_L85A2_3rd.ukx"
	ModServerPackages(51)="JS_L85A2_A.ukx"
	ModServerPackages(52)="JS_L85A2_M.usx"
	ModServerPackages(53)="JS_L85A2_T.utx"
	//Braindead_MP5Pack
	ModServerPackages(54)="BD_FL_MP5_A.ukx"
	ModServerPackages(55)="BD_MP5SD_S.uax"
	ModServerPackages(56)="BD_MP5_SM.usx"
	ModServerPackages(57)="BD_MP5_FL_T.utx"
	//Exod_BlueStahli_XMV850
	ModServerPackages(58)="XMV850_A.ukx"
	ModServerPackages(59)="XMV850_Snd.uax"
	//ModServerPackages(60)="XMV850S.uax"	//Not in use
	ModServerPackages(61)="XMV850_SM.usx"
	ModServerPackages(62)="XMV850_T.utx"
	//Exod_PooSH_StingerMinigun
	ModServerPackages(63)="Stinger_A.ukx"
	ModServerPackages(64)="Stinger_Snd.uax"
	ModServerPackages(65)="Stinger_SM.usx"
	ModServerPackages(66)="Stinger_T.utx"
	//ZedekPD_Type19
	ModServerPackages(67)="Type19_A.ukx"
	ModServerPackages(68)="Type19_S.uax"
	ModServerPackages(69)="Type19_SM.usx"
	ModServerPackages(70)="Type19_T.utx"
	//ZedekPD_XM8
	ModServerPackages(71)="XM8_A.ukx"
	ModServerPackages(72)="XM8_Snd.uax"
	ModServerPackages(73)="XM8_SM.usx"
	ModServerPackages(74)="XM8_3rd_T.utx"
	ModServerPackages(75)="XM8_T.utx"
	//OperationY_UMP45
	ModServerPackages(76)="UMP45_A.ukx"
	ModServerPackages(77)="UMP45_Snd.uax"
	ModServerPackages(78)="UMP45_sm.usx"
	ModServerPackages(79)="UMP45_T.utx"
	//OperationY_PKM
	ModServerPackages(80)="Pkm_A.ukx"
	ModServerPackages(81)="PKM_SN.uax"
	ModServerPackages(82)="Pkm_SM.usx"
	ModServerPackages(83)="Pkm_T.utx"
	//OperationY_UMP45EOTech
	ModServerPackages(84)="UMP45LLI_A.ukx"
	//OperationY_VALDT
	ModServerPackages(85)="VALDT_v2_A.ukx"
	//ZedekPD_Brownings
	ModServerPackages(86)="Browning_A.ukx"
	ModServerPackages(87)="Browning_S.uax"
	ModServerPackages(88)="Browning_SM.usx"
	ModServerPackages(89)="Browning_T.utx"
	//OperationY_AUG_A1AssaultRifle
	ModServerPackages(90)="AUG_A1_A.ukx"
	//Whisky_Hammer
	ModServerPackages(91)="whisky_hammer_A.ukx"
	ModServerPackages(92)="WHammer_SM.usx"
	ModServerPackages(93)="whisky_hammer_T.utx"
	// UM_Monsters
	ModServerPackages(94)="UM_Bloat_A.ukx"
	ModServerPackages(95)="UM_Clot_A.ukx"
	ModServerPackages(96)="UM_Crawler_A.ukx"
	ModServerPackages(97)="UM_FleshPound_A.ukx"
	ModServerPackages(98)="UM_GoreFast_A.ukx"
	ModServerPackages(99)="UM_Husk_A.ukx"
	ModServerPackages(100)="UM_Patriarch_A.ukx"
	ModServerPackages(101)="UM_Scrake_A.ukx"
	ModServerPackages(102)="UM_Siren_A.ukx"
	ModServerPackages(103)="UM_Stalker_A.ukx"
	//ModServerPackages()=""
	
	//[end]
}