//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseWeaponModule
//	Parent class:	 Actor
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 16.01.2014 18:21
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseWeaponModule extends Actor
	Abstract;


//========================================================================
//[block] Variables

var		bool		bModuleIsEnabled;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		SwitchMode;
	
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bModuleIsEnabled;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function SwitchMode()
{
	bModuleIsEnabled = !bModuleIsEnabled;
}

//[end] Functions
//====================================================================


defaultproperties
{
}
