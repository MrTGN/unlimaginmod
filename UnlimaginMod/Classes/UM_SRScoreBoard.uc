class UM_SRScoreBoard extends KFScoreBoard;

var localized string NotShownInfo, PlayerCountText, SpectatorCountText, AliveCountText, BotText;

simulated event UpdateScoreBoard(Canvas Canvas)
{
	local PlayerReplicationInfo PRI, OwnerPRI;
	local int i, FontReduction, NetXPos, PlayerCount, HeaderOffsetY, HeadFoot, MessageFoot, PlayerBoxSizeY, BoxSpaceY, NameXPos, BoxTextOffsetY, OwnerOffset, HealthXPos, BoxXPos,KillsXPos, TitleYPos, BoxWidth, VetXPos, NotShownCount;
	local float XL,YL;
	local float deathsXL, KillsXL, NetXL, HealthXL, MaxNamePos, KillWidthX, CashXPos, TimeXPos;
	local Material VeterancyBox,StarBox;
	local string S;
	local byte Stars;

	OwnerPRI = KFPlayerController(Owner).PlayerReplicationInfo;
	OwnerOffset = -1;

	for ( i = 0; i < GRI.PRIArray.Length; ++i )  {
		PRI = GRI.PRIArray[i];
		if ( !PRI.bOnlySpectator )  {
			if( !PRI.bOutOfLives && KFPlayerReplicationInfo(PRI).PlayerHealth>0 )
				++HeadFoot;
			
			if ( PRI == OwnerPRI )
				OwnerOffset = i;
			
			++PlayerCount;
		}
		else 
			++NetXPos;
	}

	// First, draw title.
	S = SkillLevel[Clamp(InvasionGameReplicationInfo(GRI).BaseDifficulty, 0, 7)] @ "|" @ WaveString @ (InvasionGameReplicationInfo(GRI).WaveNumber + 1) @ "|" @ Level.Title @ "|" @ FormatTime(GRI.ElapsedTime);

	Canvas.Font = class'ROHud'.static.GetSmallMenuFont(Canvas);
	Canvas.TextSize(S, XL,YL);
	Canvas.DrawColor = HUDClass.default.RedColor;
	Canvas.Style = ERenderStyle.STY_Normal;

	HeaderOffsetY = Canvas.ClipY * 0.11;
	Canvas.SetPos(0.5 * (Canvas.ClipX - XL), HeaderOffsetY);
	Canvas.DrawTextClipped(S);

	// Second title line
	S = PlayerCountText@PlayerCount@SpectatorCountText@NetXPos@AliveCountText@HeadFoot;
	Canvas.TextSize(S, XL,YL);
	HeaderOffsetY+=YL;
	Canvas.SetPos(0.5 * (Canvas.ClipX - XL), HeaderOffsetY);
	Canvas.DrawTextClipped(S);
	HeaderOffsetY+=(YL*3.f);

	// Select best font size and box size to fit as many players as possible on screen
	if ( Canvas.ClipX < 600 )
		i = 4;
	else if ( Canvas.ClipX < 800 )
		i = 3;
	else if ( Canvas.ClipX < 1000 )
		i = 2;
	else if ( Canvas.ClipX < 1200 )
		i = 1;
	else 
		i = 0;

	Canvas.Font = class'ROHud'.static.LoadMenuFontStatic(i);
	Canvas.TextSize("Test", XL, YL);
	PlayerBoxSizeY = 1.2 * YL;
	BoxSpaceY = 0.25 * YL;

	while( ((PlayerBoxSizeY + BoxSpaceY) * PlayerCount) > (Canvas.ClipY - HeaderOffsetY) )  {
		// Shrink font, if too small then Break loop.
		if ( ++i >= 5 || ++FontReduction >= 3 )  {
			// We need to remove some player names here to make it fit.
			NotShownCount = PlayerCount-int((Canvas.ClipY-HeaderOffsetY)/(PlayerBoxSizeY+BoxSpaceY))+1;
			PlayerCount-=NotShownCount;
			Break;
		}
		Canvas.Font = class'ROHud'.static.LoadMenuFontStatic(i);
		Canvas.TextSize("Test", XL, YL);
		PlayerBoxSizeY = 1.2 * YL;
		BoxSpaceY = 0.25 * YL;
	}

	HeadFoot = 7 * YL;
	MessageFoot = 1.5 * HeadFoot;

	BoxWidth = 0.9 * Canvas.ClipX;
	BoxXPos = 0.5 * (Canvas.ClipX - BoxWidth);
	BoxWidth = Canvas.ClipX - 2 * BoxXPos;
	VetXPos = BoxXPos + 0.0001 * BoxWidth;
	NameXPos = VetXPos + PlayerBoxSizeY*1.75f;
	KillsXPos = BoxXPos + 0.55 * BoxWidth;
	CashXPos = BoxXPos + 0.65 * BoxWidth;
	HealthXpos = BoxXPos + 0.75 * BoxWidth;
	TimeXPos = BoxXPos + 0.87 * BoxWidth;
	NetXPos = BoxXPos + 0.996 * BoxWidth;

	// draw background boxes
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.DrawColor.A = 128;

	for ( i = 0; i < PlayerCount; ++i )  {
		Canvas.SetPos(BoxXPos, HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * i);
		Canvas.DrawTileStretched( BoxMaterial, BoxWidth, PlayerBoxSizeY);
	}
	
	// Add box for not shown players.
	if ( NotShownCount > 0 )  {
		Canvas.DrawColor = HUDClass.default.RedColor;
		Canvas.SetPos(BoxXPos, HeaderOffsetY + (PlayerBoxSizeY + BoxSpaceY) * PlayerCount);
		Canvas.DrawTileStretched( BoxMaterial, BoxWidth, PlayerBoxSizeY);
		Canvas.DrawColor = HUDClass.default.WhiteColor;
	}

	// Draw headers
	TitleYPos = HeaderOffsetY - 1.1 * YL;
	Canvas.TextSize(HealthText, HealthXL, YL);
	Canvas.TextSize(DeathsText, DeathsXL, YL);
	Canvas.TextSize(KillsText, KillsXL, YL);
	Canvas.TextSize(NetText, NetXL, YL);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(NameXPos, TitleYPos);
	Canvas.DrawTextClipped(PlayerText);

	Canvas.SetPos(KillsXPos - 0.5 * KillsXL, TitleYPos);
	Canvas.DrawTextClipped(KillsText);

	Canvas.TextSize(PointsText, XL, YL);
	Canvas.SetPos(CashXPos - 0.5 * XL, TitleYPos);
	Canvas.DrawTextClipped(PointsText);

	Canvas.TextSize(TimeText, XL, YL);
	Canvas.SetPos(TimeXPos - 0.5 * XL, TitleYPos);
	Canvas.DrawTextClipped(TimeText);

	Canvas.SetPos(HealthXPos - 0.5 * HealthXL, TitleYPos);
	Canvas.DrawTextClipped(HealthText);

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(0.5 * Canvas.ClipX, HeaderOffsetY + 4);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	Canvas.SetPos(NetXPos - NetXL, TitleYPos);
	Canvas.DrawTextClipped(NetText);

	BoxTextOffsetY = HeaderOffsetY + 0.5 * (PlayerBoxSizeY - YL);

	Canvas.DrawColor = HUDClass.default.WhiteColor;
	MaxNamePos = Canvas.ClipX;
	Canvas.ClipX = KillsXPos - 4.f;

	for ( i = 0; i < PlayerCount; ++i )  {
		Canvas.SetPos(NameXPos, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		if ( i == OwnerOffset )  {
			Canvas.DrawColor.G = 0;
			Canvas.DrawColor.B = 0;
		}
		else  {
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
		Canvas.DrawTextClipped(GRI.PRIArray[i].PlayerName);
	}
	
	// Draw not shown info
	if ( NotShownCount > 0 )  {
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 0;
		Canvas.SetPos(NameXPos, ((PlayerBoxSizeY + BoxSpaceY) * PlayerCount + BoxTextOffsetY));
		Canvas.DrawText(NotShownCount@NotShownInfo, True);
	}

	Canvas.ClipX = MaxNamePos;
	Canvas.DrawColor = HUDClass.default.WhiteColor;

	Canvas.Style = ERenderStyle.STY_Normal;

	// Draw the player informations.
	for ( i = 0; i < PlayerCount; ++i )  {
		PRI = GRI.PRIArray[i];
		Canvas.DrawColor = HUDClass.default.WhiteColor;

		// Display perks.
		if ( KFPlayerReplicationInfo(PRI) != None 
			 && Class<UM_VeterancyTypes>(KFPlayerReplicationInfo(PRI).ClientVeteranSkill) != None )  {
			Stars = Class<UM_VeterancyTypes>(KFPlayerReplicationInfo(PRI).ClientVeteranSkill).Static.PreDrawPerk(Canvas, KFPlayerReplicationInfo(PRI).ClientVeteranSkillLevel, VeterancyBox, StarBox);
			if ( VeterancyBox != None )
				DrawPerkWithStars(Canvas,VetXPos,HeaderOffsetY+(PlayerBoxSizeY+BoxSpaceY)*i,PlayerBoxSizeY,Stars,VeterancyBox,StarBox);
			
			Canvas.DrawColor = HUDClass.default.WhiteColor;
		}

		// draw kills
		Canvas.TextSize(KFPlayerReplicationInfo(PRI).Kills, KillWidthX, YL);
		Canvas.SetPos(KillsXPos - 0.5 * KillWidthX, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawTextClipped(KFPlayerReplicationInfo(PRI).Kills);

		// draw cash
		S = string(int(PRI.Score));
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(CashXPos-XL*0.5f, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		Canvas.DrawText(S,True);

		// draw time
		if( GRI.ElapsedTime<PRI.StartTime ) // Login timer error, fix it.
			GRI.ElapsedTime = PRI.StartTime;
		S = FormatTime(GRI.ElapsedTime-PRI.StartTime);
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(TimeXPos-XL*0.5f, (PlayerBoxSizeY + BoxSpaceY)*i + BoxTextOffsetY);
		Canvas.DrawText(S,True);

		// Draw ping
		if ( PRI.bAdmin )  {
			Canvas.DrawColor = HUDClass.default.RedColor;
			S = AdminText;
		}
		else if ( !GRI.bMatchHasBegun )  {
			if ( PRI.bReadyToPlay )
				S = ReadyText;
			else 
				S = NotReadyText;
		}
		else if ( !PRI.bBot )
			S = string(PRI.Ping*4);
		else 
			S = BotText;
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(NetXPos-XL, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawTextClipped(S);

		// draw healths
		if ( PRI.bOutOfLives || KFPlayerReplicationInfo(PRI).PlayerHealth <= 0 )  {
			Canvas.DrawColor = HUDClass.default.RedColor;
			S = OutText;
		}
		else  {
			if ( KFPlayerReplicationInfo(PRI).PlayerHealth >= 90 )
				Canvas.DrawColor = HUDClass.default.GreenColor;
			else if ( KFPlayerReplicationInfo(PRI).PlayerHealth >= 50 )
				Canvas.DrawColor = HUDClass.default.GoldColor;
			else 
				Canvas.DrawColor = HUDClass.default.RedColor;
			S = KFPlayerReplicationInfo(PRI).PlayerHealth@HealthyString;
		}
		
		Canvas.TextSize(S, XL, YL);
		Canvas.SetPos(HealthXpos - 0.5 * XL, (PlayerBoxSizeY + BoxSpaceY) * i + BoxTextOffsetY);
		Canvas.DrawTextClipped(S);
	}
}

simulated final function DrawPerkWithStars( Canvas C, float X, float Y, float Scale, int Stars, Material PerkIcon, Material StarIcon )
{
	local byte i;

	C.SetPos(X,Y);
	C.DrawTile(PerkIcon, Scale, Scale, 0, 0, PerkIcon.MaterialUSize(), PerkIcon.MaterialVSize());
	Y += Scale * 0.9f;
	X += Scale * 0.8f;
	Scale *= 0.2f;
	while( Stars > 0 )  {
		for( i = 1; i <= Min(5,Stars); ++i )  {
			C.SetPos(X, (Y - (i * Scale * 0.8f)));
			C.DrawTile(StarIcon, Scale, Scale, 0, 0, StarIcon.MaterialUSize(), StarIcon.MaterialVSize());
		}
		
		X += Scale;
		Stars -= 5;
	}
}

defaultproperties
{
	NotShownInfo="player names not shown"
	HealthyString="HP"
	PlayerCountText="Players:"
	SpectatorCountText="| Spectators:"
	AliveCountText="| Alive players:"
	BotText="BOT"
}
