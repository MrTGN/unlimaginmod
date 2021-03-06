//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_FlashlightModuleAttachment
//	Parent class:	 UM_BaseTacticalModuleAttachment
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.03.2014 15:43
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_FlashlightModuleAttachment extends UM_BaseTacticalModuleAttachment;


//========================================================================
//[block] Variables

var		Class< UM_BaseEmitter >		LightEmitterClass;
var		UM_BaseEmitter				LightEmitter;
var		name						LightBone;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// Client effects and sounds
simulated function ClientTurnOnModule()
{
	//Destroying the old Light if needed
	ClientTurnOffModule();
	
	//Spawning a new one
	if ( LightEmitterClass != None )
		LightEmitter = Spawn(LightEmitterClass);
	
	if ( LightEmitter != None )  {
		if ( LightBone != '' )
			AttachToBone(LightEmitter, LightBone);
		else
			LightEmitter.SetBase(self);
	}
}

// Client effects and sounds
simulated function ClientTurnOffModule()
{
	if ( LightEmitter != None )  {
		LightEmitter.Destroy();
		LightEmitter = None;
	}
}

//[end] Functions
//====================================================================


defaultproperties
{
     LightEmitterClass=Class'UnlimaginMod.UM_FlashlightLight3P'
}
