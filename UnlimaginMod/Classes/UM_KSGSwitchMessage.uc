//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGSwitchMessage
//	Parent class:	 CriticalEventPlus
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.09.2012 15:51
//================================================================================
class UM_KSGSwitchMessage extends CriticalEventPlus;

var	string SwitchMessage[10];

static function string GetString (optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject)
{
	if ( (Switch >= 0) && (Switch <= 9) )
		return Default.SwitchMessage[Switch];
}

defaultproperties
{
	//Default Buckshots
	SwitchMessage(0)="Set to Wide-Spreading 4 Buckshot."
	SwitchMessage(1)="Set to Tight-Spreading 000 Buckshot."
	//FieldMedic
	SwitchMessage(2)="Set to Wide-Spreading Gas Projectile."
	SwitchMessage(3)="Set to Tight-Spreading Gas Projectile."
	//Sharpshooter
	SwitchMessage(4)="Set to Shotgun Slug."
	//Firebug
	SwitchMessage(5)="Set to Wide-Spreading Incendiary Bullet."
	SwitchMessage(6)="Set to Tight-Spreading Incendiary Bullet."
	//Demolitions
	SwitchMessage(7)="Set to Wide-Spreading Frag."
	SwitchMessage(8)="Set to Tight-Spreading Frag."

	DrawColor=(B=50,G=240,R=0)
	FontSize=-2
}
