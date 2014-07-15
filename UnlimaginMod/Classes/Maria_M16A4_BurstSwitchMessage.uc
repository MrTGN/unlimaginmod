//===================================================================================
// UnlimaginMod - Maria_M16A4_BurstSwitchMessage
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_BurstSwitchMessage extends CriticalEventPlus;

var string SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		return Default.SwitchMessage[Switch];
}

defaultproperties
{
     SwitchMessage(0)="[Burst]"
     SwitchMessage(1)="[Semi-Auto]"
     DrawColor=(B=0,G=0,R=220)
     FontSize=-2
}
