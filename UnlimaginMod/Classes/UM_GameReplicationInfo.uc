/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_GameReplicationInfo
	Creation date:	 30.10.2014 08:44
----------------------------------------------------------------------------------
	Copyright � 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright � 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright � 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_GameReplicationInfo extends KFGameReplicationInfo;

//========================================================================
//[block] Variables

var					float					FriendlyFireScale;
var					float					GameDifficulty;	// Need becuase GameDiff from KFGameReplicationInfo is bNetInitial. It replicates only during the initialization.
var					bool					bAllowPlayerSpawn;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		FriendlyFireScale, GameDifficulty;
	
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bAllowPlayerSpawn;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
}
