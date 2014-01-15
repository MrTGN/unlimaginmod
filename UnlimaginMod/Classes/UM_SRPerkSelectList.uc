class UM_SRPerkSelectList extends KFPerkSelectList;

function InitList(KFSteamStatsAndAchievements StatsAndAchievements)
{
	local int i;
	local KFPlayerController KFPC;
	local UM_SRClientPerkRepLink ST;
	local class<KFVeterancyTypes> CurCL;

	// Grab the Player Controller for later use
	KFPC = KFPlayerController(PlayerOwner());
	if ( KFPC != None && KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo) != None )
		CurCL = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).ClientVeteranSkill;

	// Hold onto our reference
	ST = Class'UM_SRClientPerkRepLink'.Static.FindStats(PlayerOwner());
	if ( ST == None )
		Return;

	// Update the ItemCount and select the first item
	ItemCount = ST.CachePerks.Length;
	SetIndex(0);

	PerkName.Remove(0, PerkName.Length);
	PerkLevelString.Remove(0, PerkLevelString.Length);
	PerkProgress.Remove(0, PerkProgress.Length);

	for ( i = 0; i < ItemCount; ++i )  {
		PerkName[PerkName.Length] = ST.CachePerks[i].PerkClass.Static.GetVetInfoText(ST.CachePerks[i].CurrentLevel,3);
		if ( ST.CachePerks[i].CurrentLevel==0 )
			PerkLevelString[PerkLevelString.Length] = "N/A";
		else
			PerkLevelString[PerkLevelString.Length] = LvAbbrString @ (ST.CachePerks[i].CurrentLevel-1);
		
		PerkProgress[PerkProgress.Length] = ST.CachePerks[i].PerkClass.Static.GetTotalProgress(ST,ST.CachePerks[i].CurrentLevel);
		if ( ST.CachePerks[i].PerkClass==CurCL )
			SetIndex(i);
	}
	
	if ( bNotify )
		CheckLinkedObjects(Self);
	
	if ( MyScrollBar != None )
		MyScrollBar.AlignThumb();
}

function bool PreDraw(Canvas Canvas)
{
	if ( Controller.MouseX >= ClientBounds[0] && Controller.MouseX <= ClientBounds[2] 
		 && Controller.MouseY >= ClientBounds[1] )  {
		//  Figure out which Item we're clicking on
		MouseOverIndex = Top + ((Controller.MouseY - ClientBounds[1]) / ItemHeight);
		if ( MouseOverIndex >= ItemCount )
			MouseOverIndex = -1;
	}
	else
		MouseOverIndex = -1;

	Return False;
}

function DrawPerk(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	local float TempX, TempY;
	local float IconSize, ProgressBarWidth;
	local float TempWidth, TempHeight;
	local UM_SRClientPerkRepLink ST;
	local Material M,SM;

	ST = Class'UM_SRClientPerkRepLink'.Static.FindStats(Canvas.Viewport.Actor);
	if ( ST == None )
		Return;

	// Offset for the Background
	TempX = X;
	TempY = Y + ItemSpacing / 2.0;

	// Initialize the Canvas
	Canvas.Style = 1;
	Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);
	if ( bSelected )  {
		Canvas.DrawTileStretched(SelectedPerkBackground, IconSize, IconSize);
		Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
		Canvas.DrawTileStretched(SelectedInfoBackground, Width - IconSize, Height - ItemSpacing - 14);
	}
	else  {
		Canvas.DrawTileStretched(PerkBackground, IconSize, IconSize);
		Canvas.SetPos(TempX + IconSize - 1.0, Y + 7.0);
		Canvas.DrawTileStretched(InfoBackground, Width - IconSize, Height - ItemSpacing - 14);
	}

	// Offset and Calculate Icon's Size
	TempX += ItemBorder * Height;
	TempY += ItemBorder * Height;
	IconSize = Height - ItemSpacing - (ItemBorder * 2.0 * Height);

	// Draw Icon
	Canvas.SetPos(TempX, TempY);
	ST.CachePerks[CurIndex].PerkClass.Static.PreDrawPerk(Canvas,Max(ST.CachePerks[CurIndex].CurrentLevel,1)-1,M,SM);
	Canvas.DrawTile(M, IconSize, IconSize, 0, 0, M.MaterialUSize(), M.MaterialVSize());

	TempX += IconSize + (IconToInfoSpacing * Width);
	TempY += TextTopOffset * Height;

	ProgressBarWidth = Width - (TempX - X) - (IconToInfoSpacing * Width);

	// Select Text Color
	if ( CurIndex == MouseOverIndex )
		Canvas.SetDrawColor(255, 0, 0, 255);
	else 
		Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw the Perk's Level Name
	Canvas.StrLen(PerkName[CurIndex], TempWidth, TempHeight);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawText(PerkName[CurIndex]);

	// Draw the Perk's Level
	if ( PerkLevelString[CurIndex] != "" )  {
		Canvas.StrLen(PerkLevelString[CurIndex], TempWidth, TempHeight);
		Canvas.SetPos(TempX + ProgressBarWidth - TempWidth, TempY);
		Canvas.DrawText(PerkLevelString[CurIndex]);
	}

	TempY += TempHeight + (0.01 * Height);

	// Draw Progress Bar
	Canvas.SetDrawColor(255, 255, 255, 255);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawTileStretched(ProgressBarBackground, ProgressBarWidth, ProgressBarHeight * Height);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawTileStretched(ProgressBarForeground, ProgressBarWidth * PerkProgress[CurIndex], ProgressBarHeight * Height);
}

defaultproperties
{
}
