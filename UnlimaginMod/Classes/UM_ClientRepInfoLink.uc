Class UM_ClientRepInfoLink extends LinkedReplicationInfo
	DependsOn(UM_HUD);

var int RDamageHealedStat, RWeldingPointsStat, RShotgunDamageStat, RHeadshotKillsStat, RChainsawKills,
		RStalkerKillsStat, RBullpupDamageStat, RMeleeDamageStat, RFlameThrowerDamageStat,RTotalZedTimeStat,
		RSelfHealsStat, RSoleSurvivorWavesStat, RCashDonatedStat, RFeedingKillsStat,RHuntingShotgunKills,
		RBurningCrossbowKillsStat, RGibbedFleshpoundsStat, RStalkersKilledWithExplosivesStat,
		RGibbedEnemiesStat, RBloatKillsStat, RSirenKillsStat, RKillsStat, RMedicKnifeKills, RExplosivesDamageStat,
		TotalPlayTime, WinsCount, LostsCount,
		Unlimagin_DemolitionsPipebombKillsStat, Unlimagin_ClotKills, Unlimagin_FireAxeKills, 
		Unlimagin_ChainsawKills;
		
var byte MinimumLevel,MaximumLevel;
var float NextRepTime,RequirementScaling;
var int ClientAccknowledged[2],SendIndex,ClientAckSkinNum;

struct FPerksListType
{
	var class<UM_SRVeterancyTypes> PerkClass;
	var byte CurrentLevel;
};
var array<FPerksListType> CachePerks;

var UM_BaseServerStats StatObject;

struct FShopItemIndex
{
	var class<Pickup> PC;
	var byte CatNum;
};
var array< FShopItemIndex > ShopInventory;
var array<Material> ShopPerkIcons;
var array<string> ShopCategories,CustomChars;
var array<GUIBuyable> AllocatedObjects;
var array<UM_HUD.SmileyMessageType> SmileyTags;

var UM_SRCustomProgress CustomLink;

var bool bMinimalRequirements,bBWZEDTime,bNoStandardChars;

replication
{
	reliable if( Role==ROLE_Authority && bNetOwner )
		RDamageHealedStat, RWeldingPointsStat, RShotgunDamageStat, RHeadshotKillsStat, RChainsawKills,
		RStalkerKillsStat, RBullpupDamageStat, RMeleeDamageStat, RFlameThrowerDamageStat,
		RSelfHealsStat, RSoleSurvivorWavesStat, RCashDonatedStat, RFeedingKillsStat, RHuntingShotgunKills,
		RBurningCrossbowKillsStat, RGibbedFleshpoundsStat, RStalkersKilledWithExplosivesStat, RExplosivesDamageStat,
		RGibbedEnemiesStat, RBloatKillsStat, RTotalZedTimeStat, RSirenKillsStat, RKillsStat, RMedicKnifeKills,
		TotalPlayTime, WinsCount, LostsCount, bBWZEDTime, bNoStandardChars,
		MinimumLevel, RequirementScaling, MaximumLevel, bMinimalRequirements,CustomLink, 
		Unlimagin_ClotKills, Unlimagin_DemolitionsPipebombKillsStat, Unlimagin_FireAxeKills, 
		Unlimagin_ChainsawKills;

	// Functions server can call.
	reliable if( Role == ROLE_Authority )
		ClientReceivePerk,ClientPerkLevel,ClientReceiveWeapon,ClientSendAcknowledge,ClientReceiveCategory,
		ClientReceiveChar,ClientReceiveTag,ClientAllReceived;

	reliable if( Role < ROLE_Authority )
		ServerSelectPerk,ServerRequestPerks,ServerAcnowledge,ServerSetCharacter,ServerAckSkin;
}

event Destroyed()
{
	local UM_SRCustomProgress S,NS;

	for( S=CustomLink; S!=None; S=NS )
	{
		NS = S.NextLink;
		S.Destroy();
	}
	Super.Destroyed();
}

simulated final function string GetCustomValue( class<UM_SRCustomProgress> C )
{
	local UM_SRCustomProgress S;

	for( S=CustomLink; S!=None; S=S.NextLink )
		if( S.Class.Name==C.Name )
			Return S.GetProgress();
	Return "";
}

simulated final function int GetCustomValueInt( class<UM_SRCustomProgress> C )
{
	local UM_SRCustomProgress S;

	for( S=CustomLink; S!=None; S=S.NextLink )
		if( S.Class.Name==C.Name )
			Return S.GetProgressInt();
	Return 0;
}

final function UM_SRCustomProgress AddCustomValue( class<UM_SRCustomProgress> C )
{
	local UM_SRCustomProgress S,Last;

	for( S=CustomLink; S!=None; S=S.NextLink )
	{
		Last = S;
		if( S.Class.Name==C.Name )
			Return S;
	}
	S = Spawn(C,Owner);
	S.RepLink = Self;

	// Add new one in the end of the chain.
	if( Last!=None )
		Last.NextLink = S;
	else CustomLink = S;
	Return S;
}

final function ProgressCustomValue( class<UM_SRCustomProgress> C, int Count )
{
	local UM_SRCustomProgress S;

	for( S=CustomLink; S!=None; S=S.NextLink )
	{
		if( S.Class.Name==C.Name )
		{
			S.IncrementProgress(Count);
			Break;
		}
	}
}

final function SpawnCustomLinks()
{
	local int i;

	for( i=0; i<CachePerks.Length; ++i )
		CachePerks[i].PerkClass.Static.AddCustomStats(Self);
}

simulated static final function UM_ClientRepInfoLink FindStats( PlayerController Other )
{
	local LinkedReplicationInfo L;
	local UM_ClientRepInfoLink C;

	if( Other.PlayerReplicationInfo==None )
	{
		foreach Other.DynamicActors(Class'UM_ClientRepInfoLink',C)
			if( C.Owner==Other )
			{
				C.RepLinkBroken();
				Return C;
			}
		Return None; // Not yet init.
	}
	for( L=Other.PlayerReplicationInfo.CustomReplicationInfo; L!=None; L=L.NextReplicationInfo )
		if( UM_ClientRepInfoLink(L)!=None )
			Return UM_ClientRepInfoLink(L);
	if( Other.Level.NetMode!=NM_Client )
		Return None; // Not yet init.
	foreach Other.DynamicActors(Class'UM_ClientRepInfoLink',C)
		if( C.Owner==Other )
		{
			C.RepLinkBroken();
			Return C;
		}
	Return None;
}

simulated event Tick( float DeltaTime )
{
	local PlayerController PC;
	local LinkedReplicationInfo L;

	if( Level.NetMode==NM_DedicatedServer )
	{
		Disable('Tick');
		Return;
	}
	PC = Level.GetLocalPlayerController();
	if( Level.NetMode!=NM_Client && PC!=Owner )
	{
		Disable('Tick');
		Return;
	}
	if( PC.PlayerReplicationInfo==None )
		Return;
	Disable('Tick');
	Class'UM_SRLevelCleanup'.Static.AddSafeCleanup(PC);

	if( PC.PlayerReplicationInfo.CustomReplicationInfo!=None )
	{
		for( L=PC.PlayerReplicationInfo.CustomReplicationInfo; L!=None; L=L.NextReplicationInfo )
			if( L==Self )
				Return; // Make sure not already added.

		NextReplicationInfo = None;
		for( L=PC.PlayerReplicationInfo.CustomReplicationInfo; L!=None; L=L.NextReplicationInfo )
			if( L.NextReplicationInfo==None )
			{
				L.NextReplicationInfo = Self; // Add to the end of the chain.
				Return;
			}
	}
	PC.PlayerReplicationInfo.CustomReplicationInfo = Self;
}
simulated final function RepLinkBroken() // Called by GUI when this is noticed.
{
	Enable('Tick');
	Tick(0);
}

final function Class<UM_SRVeterancyTypes> PickRandomPerk()
{
	local array< class<UM_SRVeterancyTypes> > CA;
	local int i;

	for( i=0; i<CachePerks.Length; i++ )
	{
		if( CachePerks[i].PerkClass!=None && CachePerks[i].CurrentLevel>0 )
			CA[CA.Length] = CachePerks[i].PerkClass;
	}
	if( CA.Length==0 )
		Return None;
	Return CA[Rand(CA.Length)];
}
final function ServerSelectPerk( Class<UM_SRVeterancyTypes> VetType )
{
	StatObject.ServerSelectPerk(VetType);
}
final function ServerRequestPerks()
{
	if( NextRepTime<Level.TimeSeconds )
		SendClientPerks();
}
final function SendClientPerks()
{
	local byte i;

	if( !StatObject.bStatsReadyNow )
		Return;
	NextRepTime = Level.TimeSeconds+2.f;
	for( i=0; i<CachePerks.Length; i++ )
		ClientReceivePerk(i,CachePerks[i].PerkClass,CachePerks[i].CurrentLevel);
}
simulated function ClientReceivePerk( int Index, class<UM_SRVeterancyTypes> V, byte Level )
{
	// Setup correct icon for trader.
	if ( V.Default.PerkIndex < 255 && V.Default.OnHUDIcon != None )  {
		if ( ShopPerkIcons.Length <= V.Default.PerkIndex )
			ShopPerkIcons.Length = V.Default.PerkIndex + 1;
		ShopPerkIcons[V.Default.PerkIndex] = V.Default.OnHUDIcon;
	}

	if ( CachePerks.Length <= Index )
		CachePerks.Length = (Index + 1);
	CachePerks[Index].PerkClass = V;
	CachePerks[Index].CurrentLevel = Level;
}
simulated function ClientPerkLevel( int Index, byte CurLevel )
{
	Level.GetLocalPlayerController().ReceiveLocalizedMessage(Class'UM_SRVetOwnerEarnedMessage',(CurLevel-1),,,CachePerks[Index].PerkClass);
	CachePerks[Index].CurrentLevel = CurLevel;
}

simulated function ClientReceiveWeapon( int Index, class<Pickup> P, byte Categ )
{
	ShopInventory.Length = Max(ShopInventory.Length,Index+1);
	if( ShopInventory[Index].PC==None )
	{
		ShopInventory[Index].PC = P;
		ShopInventory[Index].CatNum = Categ;
		++ClientAccknowledged[0];
	}
}
simulated function ClientReceiveCategory( byte Index, string S )
{
	ShopCategories.Length = Max(ShopCategories.Length,Index+1);
	if( ShopCategories[Index]=="" )
	{
		ShopCategories[Index] = S;
		++ClientAccknowledged[1];
	}
}
simulated function ClientSendAcknowledge()
{
	ServerAcnowledge(ClientAccknowledged[0],ClientAccknowledged[1]);
}
function ServerAcnowledge( int A, int B )
{
	ClientAccknowledged[0] = A;
	ClientAccknowledged[1] = B;
}
simulated function ClientReceiveChar( string CharName, int Num )
{
	CustomChars.Length = Num+1;
	CustomChars[Num] = CharName;
	ServerAckSkin(Num+1);
}
simulated final function ClientReceiveTag( Texture T, string Tag, bool bInCaps )
{
	local int i;
	
	i = SmileyTags.Length;
	SmileyTags.Length = i+1;
	SmileyTags[i].SmileyTex = T;
	SmileyTags[i].SmileyTag = Tag;
	SmileyTags[i].bInCAPS = bInCaps;
}
simulated final function ClientAllReceived()
{
	local PlayerController PC;
	
	if( SmileyTags.Length==0 )
		Return;
	PC = Level.GetLocalPlayerController();
	if( PC!=None && UM_HUD(PC.MyHUD)!=None )
		UM_HUD(PC.MyHUD).SmileyMsgs = SmileyTags;
}

function ServerAckSkin( int Index )
{
	ClientAckSkinNum = Index;
}

simulated final function string PickRandomCustomChar()
{
	local string S;
	local int i;
	
	if( CustomChars.Length==0 )
		Return "";
	S = CustomChars[Rand(CustomChars.Length)];
	i = InStr(S,":");
	if( i>=0 )
		S = Mid(S,i+1);
	Return S;
}
simulated final function bool IsCustomCharacter( string CN )
{
	local int i;

	for( i=0; i<CustomChars.Length; ++i )
		if( CustomChars[i]~=CN || Right(CustomChars[i],Len(CN)+1)~=(":"$CN) )
			Return True;
	Return False;
}
simulated final function SelectedCharacter( string CN )
{
	if( !IsCustomCharacter(CN) ) // Was not a custom character, update URL too.
	{
		if( bNoStandardChars && CustomChars.Length>0 ) // Denied.
			Return;
		Level.GetLocalPlayerController().UpdateURL("Character", CN, True);
	}
	ServerSetCharacter(CN);
}

function ServerSetCharacter( string CN )
{
	if( xPlayer(Owner)!=None )
		StatObject.ChangeCharacter(CN);
}

final function bool CanBuyPickup( class<KFWeaponPickup> WC )
{
	local int i;
	local KFPlayerReplicationInfo K;
	
	for( i=(ShopInventory.Length-1); i>=0; --i )
		if( ShopInventory[i].PC==WC )
		{
			K = KFPlayerReplicationInfo(StatObject.OwnerController.PlayerReplicationInfo);
			for( i=(CachePerks.Length-1); i>=0; --i )
				if( !CachePerks[i].PerkClass.Static.AllowWeaponInTrader(WC,K,CachePerks[i].CurrentLevel) )
					Return False;
			Return True;
		}
	Return False;
}

Auto state RepSetup
{
Begin:
	if( Level.NetMode==NM_Client )
		Stop;
	Sleep(1.f);
	NetUpdateFrequency = 0.5f;

	if ( NetConnection(StatObject.OwnerController.Player)!=None ) // Network client.
	{
		// Now MAKE SURE client receives the full inventory list.
		while( ClientAccknowledged[0]<ShopInventory.Length || ClientAccknowledged[1]<ShopCategories.Length )
		{
			for( SendIndex=0; SendIndex<ShopInventory.Length; ++SendIndex )
			{
				ClientReceiveWeapon(SendIndex,ShopInventory[SendIndex].PC,ShopInventory[SendIndex].CatNum);
				Sleep(0.1f);
			}
			for( SendIndex=0; SendIndex<ShopCategories.Length; ++SendIndex )
			{
				ClientReceiveCategory(SendIndex,ShopCategories[SendIndex]);
				Sleep(0.1f);
			}
			ClientSendAcknowledge();
			Sleep(1.f);
		}

		// Send client all the custom characters.
		while( ClientAckSkinNum<CustomChars.Length )
		{
			ClientReceiveChar(CustomChars[ClientAckSkinNum],ClientAckSkinNum);
			Sleep(0.15f);
		}
		
		// Send all chat icons.
		for( SendIndex=0; SendIndex<SmileyTags.Length; ++SendIndex )
		{
			ClientReceiveTag(SmileyTags[SendIndex].SmileyTex,SmileyTags[SendIndex].SmileyTag,SmileyTags[SendIndex].bInCAPS);
			Sleep(0.1f);
		}
		SmileyTags.Length = 0;
	}
	ClientAllReceived();

	GoToState('');
}

simulated final function ResetItem( GUIBuyable Item )
{
	Item.ItemName = "";
	Item.ItemDescription = "";
	Item.ItemCategorie = "";
	Item.ItemImage = None;
	Item.ItemWeaponClass = None;
	Item.ItemAmmoClass = None;
	Item.ItemPickupClass = None;
	Item.ItemCost = 0;
	Item.ItemAmmoCost = 0;
	Item.ItemFillAmmoCost = 0;
	Item.ItemWeight = 0;
	Item.ItemPower = 0;
	Item.ItemRange = 0;
	Item.ItemSpeed = 0;
	Item.ItemAmmoCurrent = 0;
	Item.ItemAmmoMax = 0;
	Item.bSaleList = False;
	Item.bSellable = False;
	Item.bMelee = False;
	Item.bIsVest = False;
	Item.bIsFirstAidKit = False;
	Item.ItemPerkIndex = 0;
	Item.ItemSellValue = 0;
}

defaultproperties
{
	bAlwaysRelevant=False
	bOnlyRelevantToOwner=True
	bOnlyDirtyReplication=True
	RequirementScaling=1
	MaximumLevel=7
	ShopPerkIcons(0)=Texture'KillingFloorHUD.Perks.Perk_Medic'
	ShopPerkIcons(1)=Texture'KillingFloorHUD.Perks.Perk_Support'
	ShopPerkIcons(2)=Texture'KillingFloorHUD.Perks.Perk_SharpShooter'
	ShopPerkIcons(3)=Texture'KillingFloorHUD.Perks.Perk_Commando'
	ShopPerkIcons(4)=Texture'KillingFloorHUD.Perks.Perk_Berserker'
	ShopPerkIcons(5)=Texture'KillingFloorHUD.Perks.Perk_Firebug'
	ShopPerkIcons(6)=Texture'KillingFloor2HUD.Perk_Icons.Perk_Demolition'
}