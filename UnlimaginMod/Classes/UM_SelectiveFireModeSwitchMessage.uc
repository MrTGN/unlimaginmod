//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_SelectiveFireModeSwitchMessage
//	Parent class:	 CriticalEventPlus
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 02.01.2014 04:23
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_SelectiveFireModeSwitchMessage extends CriticalEventPlus;

var		string		SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		Return Default.SwitchMessage[Switch];
}

defaultproperties
{
     SwitchMessage(0)="[Auto]"
     SwitchMessage(1)="[Semi-Auto]"
	 SwitchMessage(2)="[2 Round Burst]"
	 SwitchMessage(3)="[3 Round Burst]"
	 SwitchMessage(4)="[4 Round Burst]"
	 SwitchMessage(5)="[5 Round Burst]"
     DrawColor=(B=0,G=0,R=240)
     FontSize=-2
}
