//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseTacticalModule
//	Parent class:	 UM_BaseWeaponModule
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.03.2014 16:18
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseTacticalModule extends UM_BaseWeaponModule
	Abstract;


//========================================================================
//[block] Variables

var		bool								bModuleIsActive;
var		UM_BaseTacticalModuleAttachment		ModuleAttachment;	//3rd person view

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

function InitModule(bool bNewModuleIsActive, UM_BaseTacticalModuleAttachment NewModuleAttachment)
{
	ModuleAttachment = NewModuleAttachment;
	
	if ( bNewModuleIsActive )
		TurnOnModule();
	else
		TurnOffModule();
}

function Toggle()
{
	if ( bModuleIsActive )
		TurnOffModule();
	else
		TurnOnModule();
}

function TurnOnModule()
{
	bModuleIsActive = True;
	NetUpdateTime = Level.TimeSeconds - 1.0;
	if ( ModuleAttachment != None )
		ModuleAttachment.TurnOnModule()
}

function TurnOffModule()
{
	bModuleIsActive = False;
	NetUpdateTime = Level.TimeSeconds - 1.0;
	if ( ModuleAttachment != None )
		ModuleAttachment.TurnOffModule()
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
}
