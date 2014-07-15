//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponModule
//	Parent class:	 UM_BaseActor
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
class UM_BaseWeaponModule extends UM_BaseActor
	Abstract;



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
