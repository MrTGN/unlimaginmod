class Braindead_MP5SwitchMessage extends CriticalEventPlus;

var string SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		Return Default.SwitchMessage[Switch];
}

defaultproperties
{
     SwitchMessage(0)="[Auto]"
     SwitchMessage(1)="[Burst]"
     SwitchMessage(2)="[Semi-Auto]"
     DrawColor=(B=0,G=0,R=220)
     FontSize=-2
}
