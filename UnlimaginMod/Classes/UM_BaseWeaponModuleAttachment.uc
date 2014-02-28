//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponModuleAttachment
//	Parent class:	 Actor
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 16.01.2014 18:52
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseWeaponModuleAttachment extends Actor
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
	//reliable if ( Role == ROLE_Authority )
		//TurnOnModule, TurnOffModule;
	reliable if( Role == ROLE_Authority && bNetDirty )
		bModuleIsActive;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

// If ROLE_SimulatedProxy has just spawned on client
simulated event PostNetBeginPlay()
{
	if ( bModuleIsActive )
		ClientTurnOnModule();
	else
		ClientTurnOffModule();
}

// Clients switching
simulated event PostNetReceive()
{
	if ( bModuleIsActive )
		ClientTurnOnModule();
	else
		ClientTurnOffModule();
}

function TurnOnModule()
{
	bModuleIsActive = True;
	NetUpdateTime = Level.TimeSeconds - 1.0;
}

function TurnOffModule()
{
	bModuleIsActive = False;
	NetUpdateTime = Level.TimeSeconds - 1.0;
}

// Client effects and sounds
simulated function ClientTurnOnModule()
{

}

// Client effects and sounds
simulated function ClientTurnOffModule()
{

}

//[end] Functions
//====================================================================


defaultproperties
{
     DrawType=DT_Mesh
     bOnlyDrawIfAttached=True
     bOnlyDirtyReplication=True
     RemoteRole=ROLE_SimulatedProxy
     NetUpdateFrequency=8.000000
     bUseLightingFromBase=True
	 bReplicateInstigator=True
     bBlockHitPointTraces=False
}
