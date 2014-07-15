//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UM_SRLobbyMenu extends LobbyMenu;

struct FPlayerBoxEntry
{
	var moCheckBox			ReadyBox;
	var KFPlayerReadyBar	PlayerBox;
	var GUIImage			PlayerPerk;
	var GUILabel			PlayerVetLabel;
	var bool bIsEmpty;
};
var array<FPlayerBoxEntry>		PlayerBoxes;

var automated GUIScrollTextBox tb_ServerMOTD;
var int MaxPlayersOnList;
var bool bMOTDInit,bMOTDHidden;

function AddPlayer( KFPlayerReplicationInfo PRI, int Index, Canvas C )
{
	local float Top;
	local Material M;

	if ( Index >= PlayerBoxes.Length )  {
		Top = Index*0.045;
		PlayerBoxes.Length = Index+1;
		PlayerBoxes[Index].ReadyBox = new (None) Class'moCheckBox';
		PlayerBoxes[Index].ReadyBox.bValueReadOnly = true;
		PlayerBoxes[Index].ReadyBox.ComponentJustification = TXTA_Left;
		PlayerBoxes[Index].ReadyBox.CaptionWidth = 0.82;
		PlayerBoxes[Index].ReadyBox.LabelColor.B = 0;
		PlayerBoxes[Index].ReadyBox.WinTop = 0.0475+Top;
		PlayerBoxes[Index].ReadyBox.WinLeft = 0.075;
		PlayerBoxes[Index].ReadyBox.WinWidth = 0.4;
		PlayerBoxes[Index].ReadyBox.WinHeight = 0.045;
		PlayerBoxes[Index].ReadyBox.RenderWeight = 0.55;
		PlayerBoxes[Index].ReadyBox.bAcceptsInput = False;
		PlayerBoxes[Index].PlayerBox = new (None) Class'KFPlayerReadyBar';
		PlayerBoxes[Index].PlayerBox.WinTop = 0.04+Top;
		PlayerBoxes[Index].PlayerBox.WinLeft = 0.04;
		PlayerBoxes[Index].PlayerBox.WinWidth = 0.35;
		PlayerBoxes[Index].PlayerBox.WinHeight = 0.045;
		PlayerBoxes[Index].PlayerBox.RenderWeight = 0.35;
		PlayerBoxes[Index].PlayerPerk = new (None) Class'GUIImage';
		PlayerBoxes[Index].PlayerPerk.ImageStyle = ISTY_Justified;
		PlayerBoxes[Index].PlayerPerk.WinTop = 0.043+Top;
		PlayerBoxes[Index].PlayerPerk.WinLeft = 0.0418;
		PlayerBoxes[Index].PlayerPerk.WinWidth = 0.039;
		PlayerBoxes[Index].PlayerPerk.WinHeight = 0.039;
		PlayerBoxes[Index].PlayerPerk.RenderWeight = 0.56;
		PlayerBoxes[Index].PlayerVetLabel = new (None) Class'GUILabel';
		PlayerBoxes[Index].PlayerVetLabel.TextAlign = TXTA_Right;
		PlayerBoxes[Index].PlayerVetLabel.TextColor = Class'Canvas'.Static.MakeColor(19,19,19);
		PlayerBoxes[Index].PlayerVetLabel.TextFont = "UT2SmallFont";
		PlayerBoxes[Index].PlayerVetLabel.WinTop = 0.04+Top;
		PlayerBoxes[Index].PlayerVetLabel.WinLeft = 0.22907;
		PlayerBoxes[Index].PlayerVetLabel.WinWidth = 0.151172;
		PlayerBoxes[Index].PlayerVetLabel.WinHeight = 0.045;
		PlayerBoxes[Index].PlayerVetLabel.RenderWeight = 0.5;
		AppendComponent(PlayerBoxes[Index].ReadyBox, true);
		AppendComponent(PlayerBoxes[Index].PlayerBox, true);
		AppendComponent(PlayerBoxes[Index].PlayerPerk, true);
		AppendComponent(PlayerBoxes[Index].PlayerVetLabel, true);
		
		Top = (PlayerBoxes[Index].PlayerBox.WinTop+PlayerBoxes[Index].PlayerBox.WinHeight);
		if ( !bMOTDHidden && Top >= ADBackground.WinTop )  {
			ADBackground.WinTop = Top + 0.01;
			if ( (ADBackground.WinTop + ADBackground.WinHeight) > t_ChatBox.WinTop )  {
				ADBackground.WinHeight = t_ChatBox.WinTop-ADBackground.WinTop;
				if ( ADBackground.WinHeight < 0.15 )  {
					RemoveComponent(ADBackground);
					RemoveComponent(tb_ServerMOTD);
					bMOTDHidden = True;
				}
			}
		}
	}
	
	PlayerBoxes[Index].ReadyBox.Checked(PRI.bReadyToPlay);
	PlayerBoxes[Index].ReadyBox.SetCaption(" "$Left(PRI.PlayerName,20));

	if ( PRI.ClientVeteranSkill != None )  {
		PlayerBoxes[Index].PlayerVetLabel.Caption = "Lv" @ PRI.ClientVeteranSkillLevel @ PRI.ClientVeteranSkill.default.VeterancyName;
		if ( Class<UM_SRVeterancyTypes>(PRI.ClientVeteranSkill) != None )  {
			Class<UM_SRVeterancyTypes>(PRI.ClientVeteranSkill).Static.PreDrawPerk(C,PRI.ClientVeteranSkillLevel,PlayerBoxes[Index].PlayerPerk.Image,M);
			PlayerBoxes[Index].PlayerPerk.ImageColor = C.DrawColor;
		}
		else  {
			PlayerBoxes[Index].PlayerPerk.Image = PRI.ClientVeteranSkill.default.OnHUDIcon;
			PlayerBoxes[Index].PlayerPerk.ImageColor = Class'Canvas'.Static.MakeColor(255,255,255);
		}
	}
	else  {
		PlayerBoxes[Index].PlayerPerk.Image = None;
		PlayerBoxes[Index].PlayerVetLabel.Caption = "";
	}
	
	PlayerBoxes[Index].bIsEmpty = False;
}
function EmptyPlayers( int Index )
{
	while( Index<PlayerBoxes.Length && !PlayerBoxes[Index].bIsEmpty )  {
		PlayerBoxes[Index].ReadyBox.Checked(False);
		PlayerBoxes[Index].PlayerPerk.Image = None;
		PlayerBoxes[Index].PlayerVetLabel.Caption = "";
		PlayerBoxes[Index].ReadyBox.SetCaption("");
		PlayerBoxes[Index].bIsEmpty = True;
		++Index;
	}
}

function InitComponent(GUIController MyC, GUIComponent MyO)
{
	Super(UT2k4MainPage).InitComponent(MyC, MyO);

	i_Portrait.WinTop = PlayerPortraitBG.ActualTop() + 30;
	i_Portrait.WinHeight = PlayerPortraitBG.ActualHeight() - 36;
	t_ChatBox.FocusInstead = PerkClickLabel;
}

event Opened(GUIComponent Sender)
{
	bShouldUpdateVeterancy = true;
	SetTimer(1,true);
}

function DrawPortrait()
{
	if ( PlayerOwner().PlayerReplicationInfo != None )
		sChar = PlayerOwner().PlayerReplicationInfo.CharacterName;
	else
		sChar = PlayerOwner().GetUrlOption("Character");

	if ( sCharD != sChar )  {
		sCharD = sChar;
		SetPlayerRec();
	}
}

function bool NotifyLevelChange()
{
	bPersistent = False;
	bAllowClose = True;
	
	Return True;
}

function SetPlayerRec()
{
	PlayerRec = Class'xUtil'.Static.FindPlayerRecord(sChar);
	i_Portrait.Image = PlayerRec.Portrait;
}

function bool InternalOnPreDraw(Canvas C)
{
	local int i, j;
	local string StoryString;
	local String SkillString;
	local KFGameReplicationInfo KFGRI;
	local PlayerController PC;

	PC = PlayerOwner();

	if ( PC == None || PC.Level == None ) // Error?
		return false;
	
	if ( (PC.PlayerReplicationInfo != None && (!PC.PlayerReplicationInfo.bWaitingPlayer || PC.PlayerReplicationInfo.bOnlySpectator)) 
		 || PC.Outer.Name == 'Entry' )  {
		bAllowClose = True;
		PC.ClientCloseMenu(True, False);
		Return False;
	}

	t_Footer.InternalOnPreDraw(C);
	KFGRI = KFGameReplicationInfo(PC.GameReplicationInfo);
	if ( KFGRI != None )
		WaveLabel.Caption = string(KFGRI.WaveNumber + 1) $ "/" $ string(KFGRI.FinalWave);
	else  {
		WaveLabel.Caption = "?/?";
		Return False;
	}
	
	C.DrawColor.A = 255;

	// First fill in non-ready players.
	for ( i = 0; i < KFGRI.PRIArray.Length; i++ )  {
		if ( KFGRI.PRIArray[i] == None || KFGRI.PRIArray[i].bOnlySpectator 
			 || KFGRI.PRIArray[i].bReadyToPlay || KFPlayerReplicationInfo(KFGRI.PRIArray[i]) == None )
			Continue;

		AddPlayer(KFPlayerReplicationInfo(KFGRI.PRIArray[i]),j,C);
		if ( ++j >= MaxPlayersOnList )
			GoTo'DoneIt';
	}

	// Then comes rest.
	for ( i = 0; i < KFGRI.PRIArray.Length; i++ )  {
		if ( KFGRI.PRIArray[i] == None || KFGRI.PRIArray[i].bOnlySpectator 
			 || !KFGRI.PRIArray[i].bReadyToPlay || KFPlayerReplicationInfo(KFGRI.PRIArray[i]) == None )
			Continue;

		if ( KFGRI.PRIArray[i].bReadyToPlay && !bTimeoutTimeLogged )  {
			ActivateTimeoutTime = PC.Level.TimeSeconds;
			bTimeoutTimeLogged = True;
		}
		
		AddPlayer(KFPlayerReplicationInfo(KFGRI.PRIArray[i]),j,C);
		
		if( ++j >= MaxPlayersOnList )
			GoTo'DoneIt';
	}

	if ( j < MaxPlayersOnList )
		EmptyPlayers(j);

DoneIt:
	StoryString = PC.Level.Description;

	if ( !bStoryBoxFilled )  {
		l_StoryBox.LoadStoryText();
		bStoryBoxFilled = True;
	}

	CheckBotButtonAccess();

	if ( KFGRI.BaseDifficulty <= 1 )
		SkillString = BeginnerString;
	else if ( KFGRI.BaseDifficulty <= 2 )
		SkillString = NormalString;
	else if ( KFGRI.BaseDifficulty <= 4 )
		SkillString = HardString;
	else 
		SkillString = SuicidalString;

	CurrentMapLabel.Caption = CurrentMapString @ PC.Level.Title;
	DifficultyLabel.Caption = DifficultyString @ SkillString;

	Return False;
}

function DrawPerk(Canvas Canvas)
{
	local float X, Y, Width, Height;
	local int LevelIndex;
	local float TempX, TempY;
	local float TempWidth, TempHeight;
	local float IconSize, ProgressBarWidth;
	local string PerkName, PerkLevelString;
	local KFPlayerReplicationInfo KFPRI;
	local GameReplicationInfo GRI;
	local Material M,SM;

	DrawPortrait();

	if( !bMOTDHidden )  {
		X = 9.f / Canvas.ClipX;
		Y = 32.f / Canvas.ClipY;
		tb_ServerMOTD.WinWidth = ADBackground.WinWidth-X*2.f;
		tb_ServerMOTD.WinHeight = ADBackground.WinHeight-Y*1.25f;
		tb_ServerMOTD.WinLeft = ADBackground.WinLeft+X;
		tb_ServerMOTD.WinTop = ADBackground.WinTop+Y;

		if( !bMOTDInit )  {
			GRI = PlayerOwner().Level.GRI;
			if( GRI != None && GRI.MessageOfTheDay != "" )  {
				bMOTDInit = True;
				tb_ServerMOTD.SetContent(GRI.MessageOfTheDay);
			}
		}
	}

	KFPRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);

	if ( KFPRI == None || KFPRI.ClientVeteranSkill == None )  {
		if ( CurrentVeterancyLevel != 255 )  {
			CurrentVeterancyLevel = 255;
			lb_PerkEffects.SetContent("None perk active");
		}
		Return;
	}

	LevelIndex = KFPRI.ClientVeteranSkillLevel;
	PerkName = KFPRI.ClientVeteranSkill.default.VeterancyName;
	PerkLevelString = "Lv" @ LevelIndex;

	//Get the position size etc in pixels
	X = (i_BGPerk.WinLeft + 0.003) * Canvas.ClipX;
	Y = (i_BGPerk.WinTop + 0.040) * Canvas.ClipY;

	Width = (i_BGPerk.WinWidth - 0.006) * Canvas.ClipX;
	Height = (i_BGPerk.WinHeight - 0.043) * Canvas.ClipY;

	// Offset for the Background
	TempX = X;
	TempY = Y;

	// Initialize the Canvas
	Canvas.Style = 1;
	Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);
	//Canvas.DrawTileStretched(ItemBackground, Width, Height);

	// Offset and Calculate Icon's Size
	TempX += ItemBorder * Height;
	TempY += ItemBorder * Height;
	IconSize = Height - (ItemBorder * 2.0 * Height);

	// Draw Icon
	Canvas.SetPos(TempX, TempY);
	if ( Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill) != None )
		Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill).Static.PreDrawPerk(Canvas,KFPRI.ClientVeteranSkillLevel,M,SM);
	else 
		M = KFPRI.ClientVeteranSkill.default.OnHUDIcon;
	Canvas.DrawTile(M, IconSize, IconSize, 0, 0, M.MaterialUSize(), M.MaterialVSize());

	TempX += IconSize + (IconToInfoSpacing * Width);
	TempY += TextTopOffset * Height;

	ProgressBarWidth = Width - (TempX - X) - (IconToInfoSpacing * Width);

	// Select Text Color
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw the Perk's Level name
	Canvas.StrLen(PerkName, TempWidth, TempHeight);
	Canvas.SetPos(TempX, TempY);
	Canvas.DrawText(PerkName);

	// Draw the Perk's Level
	if ( PerkLevelString != "" )  {
		Canvas.StrLen(PerkLevelString, TempWidth, TempHeight);
		Canvas.SetPos(TempX + ProgressBarWidth - TempWidth, TempY);
		Canvas.DrawText(PerkLevelString);
	}

	TempY += TempHeight + (0.01 * Height);

	if(  CurrentVeterancy != KFPRI.ClientVeteranSkill || CurrentVeterancyLevel != LevelIndex )  {
		CurrentVeterancy = KFPRI.ClientVeteranSkill;
		CurrentVeterancyLevel = LevelIndex;
		lb_PerkEffects.SetContent(Class<UM_SRVeterancyTypes>(KFPRI.ClientVeteranSkill).Static.GetVetInfoText(LevelIndex,1));
	}
}

function bool ShowPerkMenu(GUIComponent Sender)
{
	if ( PlayerOwner() != None )
		PlayerOwner().ClientOpenMenu("UnlimaginMod.UM_SRProfilePage", false);
		
	Return True;
}

defaultproperties
{
	Begin Object Class=UM_SRLobbyFooter Name=BuyFooter
		RenderWeight=0.300000
		TabOrder=8
		bBoundToParent=False
		bScaleToParent=False
		OnPreDraw=BuyFooter.InternalOnPreDraw
	End Object
	t_Footer=UM_SRLobbyFooter'UnlimaginMod.UM_SRLobbyMenu.BuyFooter'

	Begin Object Class=UM_SRLobbyChat Name=ChatBox
		OnCreateComponent=ChatBox.InternalOnCreateComponent
		TabOrder=1
		RenderWeight=0.01
		OnHover=ChatBox.FloatingHover
		WinTop=0.80760
		WinLeft=0.016090
		WinWidth=0.971410
		WinHeight=0.100000
   		ToolTip=none
	End Object
	t_ChatBox=UM_SRLobbyChat'UnlimaginMod.UM_SRLobbyMenu.ChatBox'

	Begin Object Class=GUIScrollTextBox Name=MOTDScroll
		WinWidth=0.312375
		WinHeight=0.335000
		WinLeft=0.072187
		WinTop=0.354102
		CharDelay=0.0025
		EOLDelay=0.1
		TabOrder=9
		StyleName="NoBackground"
	End Object
	tb_ServerMOTD=GUIScrollTextBox'UnlimaginMod.UM_SRLobbyMenu.MOTDScroll'
	
	MaxPlayersOnList=18
	
	ReadyBox(0)=None
	ReadyBox(1)=None
	ReadyBox(2)=None
	ReadyBox(3)=None
	ReadyBox(4)=None
	ReadyBox(5)=None
	PlayerBox(0)=None
	PlayerBox(1)=None
	PlayerBox(2)=None
	PlayerBox(3)=None
	PlayerBox(4)=None
	PlayerBox(5)=None
	PlayerPerk(0)=None
	PlayerPerk(1)=None
	PlayerPerk(2)=None
	PlayerPerk(3)=None
	PlayerPerk(4)=None
	PlayerPerk(5)=None
	PlayerVetLabel(0)=None
	PlayerVetLabel(1)=None
	PlayerVetLabel(2)=None
	PlayerVetLabel(3)=None
	PlayerVetLabel(4)=None
	PlayerVetLabel(5)=None
}