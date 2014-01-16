//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponModule
//	Parent class:	 Actor
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 16.01.2014 18:21
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseWeaponModule extends Actor
	Abstract;


//========================================================================
//[block] Variables

var		bool							bModuleIsActive;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority )
		SwitchMode;
	
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bModuleIsActive;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function SwitchMode()
{
	if ( bModuleIsActive )
		TurnOffModule();
	else
		TurnOnModule();
}

simulated function TurnOnModule()
{
	bModuleIsActive = True;
}

simulated function TurnOffModule()
{
	bModuleIsActive = False;
}

//[end] Functions
//====================================================================


defaultproperties
{
     DrawType=DT_None
     bOnlyOwnerSee=True
     bOnlyRelevantToOwner=True
     bReplicateMovement=False
     bOnlyDirtyReplication=True
	 bOnlyDrawIfAttached=True
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=2.000000
     NetPriority=3.000000
     bTravel=True
     bClientAnim=True
     bNetNotify=True
}
