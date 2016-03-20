//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FNFALSwitchMessage
//	Parent class:	 CriticalEventPlus
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.07.2012 0:05
//================================================================================
class UM_FNFALSwitchMessage extends CriticalEventPlus;

var	string SwitchMessage[10];

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
     DrawColor=(B=240,G=180,R=0)
     FontSize=-2
}