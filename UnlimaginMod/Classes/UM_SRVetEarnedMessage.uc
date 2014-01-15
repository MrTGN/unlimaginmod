class UM_SRVetEarnedMessage extends CriticalEventPlus
	Abstract;

var(Message) localized string EarnedString;

static function string GetString(
    optional int Switch,
    optional PlayerReplicationInfo RelatedPRI_1, 
    optional PlayerReplicationInfo RelatedPRI_2,
    optional Object OptionalObject )
{
	local string S;

	if ( Class<KFVeterancyTypes>(OptionalObject) == None )
		Return "";
	
	S = Default.EarnedString;
	ReplaceText(S,"%s", Eval(RelatedPRI_1 != None, RelatedPRI_1.PlayerName, "Someone"));
	ReplaceText(S,"%v", Class<KFVeterancyTypes>(OptionalObject).Default.VeterancyName);
	ReplaceText(S,"%l", string(Switch));
	
	Return S;
}

defaultproperties
{
	bIsUnique=True
	FontSize=1
	PosY=0.1
	DrawColor=(R=255,G=50,B=255)
	EarnedString="%s has earned %v level %l!"
	bIsConsoleMessage=True
	Lifetime=6
}
