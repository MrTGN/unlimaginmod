//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZoomSwitchMessage
//	Parent class:	 CriticalEventPlus
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.11.2012 21:05
//================================================================================
class UM_ZoomSwitchMessage extends CriticalEventPlus;

var	string SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		Return Default.SwitchMessage[Switch];
}

defaultproperties
{
     SwitchMessage(0)="[1.6x Zoom]"
     SwitchMessage(1)="[2x Zoom]"
     SwitchMessage(2)="[2.5x Zoom]"
     SwitchMessage(3)="[4x Zoom]"
     SwitchMessage(4)="[4.0x Zoom]"
     SwitchMessage(5)="[8x Zoom]"
     DrawColor=(B=0,G=0,R=220)
     FontSize=-2
}