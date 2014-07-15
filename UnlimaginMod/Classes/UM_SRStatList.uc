class UM_SRStatList extends GUIVertList;

// Display
var	texture	InfoBackground;

// State
var	localized array<string>			ProgressName;
var	array<string>				StatProgress;
var	array<byte>				DisplayFormat; // 0 - value, 1 - time

function bool PreDraw(Canvas Canvas)
{
	Return False;
}

function InitList( UM_SRClientPerkRepLink L )
{
	local UM_SRCustomProgress P;
	local int i;

	for( P = L.CustomLink; P != None; P = P.NextLink )
		++i;

	ItemCount = Default.ProgressName.Length + i;
	ProgressName.Length = ItemCount;
	StatProgress.Length = ItemCount;

	i = Default.ProgressName.Length;
	for( P = L.CustomLink; P != None; P = P.NextLink )  {
		ProgressName[i] = P.ProgressName;
		StatProgress[i] = P.GetDisplayString();
		++i;
	}

	// Update the ItemCount and select the first item
	SetIndex(0);

	StatProgress[0] = string(L.RDamageHealedStat);
	StatProgress[1] = string(L.RWeldingPointsStat);
	StatProgress[2] = string(L.RShotgunDamageStat);
	StatProgress[3] = string(L.RHeadshotKillsStat);
	StatProgress[4] = string(L.RChainsawKills);
	StatProgress[5] = string(L.RStalkerKillsStat);
	StatProgress[6] = string(L.RBullpupDamageStat);
	StatProgress[7] = string(L.RMeleeDamageStat);
	StatProgress[8] = string(L.RFlameThrowerDamageStat);
	StatProgress[9] = string(L.RSelfHealsStat);
	StatProgress[10] = string(L.RSoleSurvivorWavesStat);
	StatProgress[11] = string(L.RCashDonatedStat);
	StatProgress[12] = string(L.RFeedingKillsStat);
	StatProgress[13] = string(L.RHuntingShotgunKills);
	StatProgress[14] = string(L.RBurningCrossbowKillsStat);
	StatProgress[15] = string(L.RGibbedFleshpoundsStat);
	StatProgress[16] = string(L.RStalkersKilledWithExplosivesStat);
	StatProgress[17] = string(L.RExplosivesDamageStat);
	StatProgress[18] = string(L.RGibbedEnemiesStat);
	StatProgress[19] = string(L.RBloatKillsStat);
	StatProgress[20] = string(L.RTotalZedTimeStat);
	StatProgress[21] = string(L.RSirenKillsStat);
	StatProgress[22] = string(L.RKillsStat);
	StatProgress[23] = string(L.RMedicKnifeKills);
	StatProgress[24] = string(L.TotalPlayTime);
	StatProgress[25] = string(L.WinsCount);
	StatProgress[26] = string(L.LostsCount);
	//-- New stat objects by TGN, Unliamgin CG --
	StatProgress[27] = string(L.Unlimagin_ClotKills);
	StatProgress[28] = string(L.Unlimagin_DemolitionsPipebombKillsStat);
	StatProgress[29] = string(L.Unlimagin_FireAxeKills);
	StatProgress[30] = string(L.Unlimagin_ChainsawKills);
	//-- End of new stat objects by TGN --

	for( i = 0; i < DisplayFormat.Length; ++i )  {
		if( DisplayFormat[i] == 1 )
			StatProgress[i] = GetTimeText(int(StatProgress[i]));
	}

	if ( bNotify )
		CheckLinkedObjects(Self);

	if ( MyScrollBar != none )
		MyScrollBar.AlignThumb();
}

final function string GetTimeText( int V )
{
	local int Hours, Minutes;

	Minutes = V / 60;
	Hours   = Minutes / 60;
	V -= (Minutes * 60);
	Minutes -= (Hours * 60);

	Return Eval(Hours<10,"0"$Hours,string(Hours))$":"$Eval(Minutes<10,"0"$Minutes,string(Minutes))$":"$Eval(V<10,"0"$V,string(V));
}

function DrawStat(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	local float TempX, TempY;
	local float TempWidth, TempHeight;

	// Offset for the Background
	TempX = X;
	TempY = Y;

	// Initialize the Canvas
	Canvas.Style = 1;
	Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawTileStretched(InfoBackground, Width, Height);

	// Select Text Color
	Canvas.SetDrawColor(0, 0, 0, 255);

	// Draw progress type.
	Canvas.TextSize(ProgressName[CurIndex], TempWidth, TempHeight);
	TempX += Width * 0.1f;
	TempY += (Height-TempHeight) * 0.5f;
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawText(ProgressName[CurIndex]$":");

	// Draw current progress.
	Canvas.TextSize(StatProgress[CurIndex], TempWidth, TempHeight);
	Canvas.SetPos((X + Width * 0.88f - TempWidth), TempY);
	Canvas.DrawText(StatProgress[CurIndex]);
}

function float PerkHeight(Canvas c)
{
	Return (MenuOwner.ActualHeight() / 14.0) - 1.0;
}

defaultproperties
{
	OnDrawItem=DrawStat
	OnPreDraw=PreDraw

	InfoBackground=Texture'KF_InterfaceArt_tex.Menu.Item_box_bar'

	FontScale=FNS_Medium
	GetItemHeight=PerkHeight

	ItemCount=27
	ProgressName(0)="Healed damage"
	ProgressName(1)="Welded hitpoints"
	ProgressName(2)="Shotgun damage"
	ProgressName(3)="Headshot kills"
	ProgressName(4)="Chainsaw kills"
	ProgressName(5)="Stalker kills"
	ProgressName(6)="Bullpup/AK47/SCAR damage"
	ProgressName(7)="Melee damage"
	ProgressName(8)="Flame thrower damage"
	ProgressName(9)="Self healed count"
	ProgressName(10)="Sole survivor waves count"
	ProgressName(11)="Cash donated"
	ProgressName(12)="Feeding zombies killed"
	ProgressName(13)="Hunting shotgun kills"
	ProgressName(14)="Burning crossbow kills"
	ProgressName(15)="Gibbed fleshpounds"
	ProgressName(16)="Stalkers killed with explosives"
	ProgressName(17)="Explosives damage count"
	ProgressName(18)="Gibbed zombies count"
	ProgressName(19)="Bloat kills"
	ProgressName(20)="Total ZED-time"
	ProgressName(21)="Siren kills"
	ProgressName(22)="Total kills"
	ProgressName(23)="Knife kills as medic"
	ProgressName(24)="Total playtime"
	ProgressName(25)="Won games"
	ProgressName(26)="Lost games"

	DisplayFormat(20)=1
	DisplayFormat(24)=1
}