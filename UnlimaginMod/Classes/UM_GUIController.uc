//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_GUIController
//	Parent class:	 KFGUIController
//������������������������������������������������������������������������������
//	Copyright:		 � 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 16.03.2014 21:57
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_GUIController extends KFGUIController;


//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event ResolutionChanged()
{
    if ( ViewportOwner.Actor != None && UM_SRPlayerController(ViewportOwner.Actor) != None )
        UM_SRPlayerController(ViewportOwner.Actor).SetUpWidescreenFOV();
}

//[end] Functions
//====================================================================


defaultproperties
{
}