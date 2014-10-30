/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_GameReplicationInfo
	Creation date:	 30.10.2014 08:44
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_GameReplicationInfo extends KFGameReplicationInfo;

var		bool		bFriendlyFireIsEnabled;

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bFriendlyFireIsEnabled;
}

defaultproperties
{
}
