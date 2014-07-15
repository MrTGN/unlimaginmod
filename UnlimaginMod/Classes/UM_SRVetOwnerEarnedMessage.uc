class UM_SRVetOwnerEarnedMessage extends CriticalEventPlus
	Abstract;

var(Message) localized string EarnedString;

static function RenderComplexMessage(
    Canvas Canvas,
    out float XL,
    out float YL,
    optional String MessageString,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject )
{
	local float XS,YS,XPos,YPos,IconSize;
	local Material M1,M2;
	local byte A;

	XPos = Canvas.CurX;
	YPos = Canvas.CurY;
	Canvas.DrawTextClipped(MessageString);
	if ( Class<UM_SRVeterancyTypes>(OptionalObject) != None )  {
		A = Canvas.DrawColor.A;
		Class<UM_SRVeterancyTypes>(OptionalObject).Static.PreDrawPerk(Canvas,Switch,M1,M2);
		Canvas.DrawColor.A = A;
		if ( M1 != None )  {
			Canvas.TextSize(MessageString,XS,YS);
			IconSize = FMin(YS*2.5f,256.f);
			YPos-=(IconSize-YS)*0.5f;
			Canvas.SetPos(XPos-(IconSize*1.1f),YPos);
			A = Canvas.Style;
			Canvas.Style = ERenderStyle.STY_Alpha;
			Canvas.DrawTile( M1, IconSize, IconSize, 0, 0, M1.MaterialUSize(), M1.MaterialVSize() );
			Canvas.SetPos(XPos+XS+(IconSize*0.1f),YPos);
			Canvas.DrawTile( M1, IconSize, IconSize, 0, 0, M1.MaterialUSize(), M1.MaterialVSize() );
			Canvas.Style = A;
		}
	}
}

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject )
{
	local string S;

	if( Class<KFVeterancyTypes>(OptionalObject)==None )
		return "";
	S = Default.EarnedString;
	ReplaceText(S,"%v",Class<KFVeterancyTypes>(OptionalObject).Default.VeterancyName);
	ReplaceText(S,"%l",string(Switch));
	Return S;
}

static function ClientReceive(
    PlayerController P,
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1,
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject )
{
	P.ClientPlaySound(Sound'KF_InterfaceSnd.Perks.PerkAchieved',true,2.f,SLOT_Talk);
	P.ClientPlaySound(Sound'KF_InterfaceSnd.Perks.PerkAchieved',true,2.f,SLOT_Interface);

	if ( UM_SRHUDKillingFloor(P.myHUD) != None 
		 && KFPlayerReplicationInfo(P.PlayerReplicationInfo) != None && OptionalObject != None 
		 && KFPlayerReplicationInfo(P.PlayerReplicationInfo).ClientVeteranSkill == OptionalObject )  {
		// Temporarly fill the bar.
		UM_SRHUDKillingFloor(P.myHUD).LevelProgressBar = 1.f;
		UM_SRHUDKillingFloor(P.myHUD).NextLevelTimer = P.Level.TimeSeconds+1.f;
	}
	
	Super.ClientReceive(P,Switch,RelatedPRI_1,RelatedPRI_2,OptionalObject);
}

defaultproperties
{
	bIsUnique=True
	FontSize=3
	Lifetime=8
	PosY=0.3
	DrawColor=(R=255,G=50,B=50,A=255)
	EarnedString="You have qualified for %v level %l!"
	bIsConsoleMessage=True
	bComplexString=true
}