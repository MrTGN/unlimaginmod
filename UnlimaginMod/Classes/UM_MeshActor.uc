//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_MeshActor
//	Parent class:	 UM_BaseActor
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 21.10.2013 14:44
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 This is a simple actor, that can be used to spawn 
//					 a new additional mesh for the actors, or just to spawn and 
//					 place the mesh somewhere on the level.
//================================================================================
class UM_MeshActor extends UM_BaseActor;

simulated final function Vector GetBoneLocation(name BoneName)
{
	local	Vector	L;
	
	if ( BoneName != '' )
		L = GetBoneCoords(BoneName).Origin;
	
	Return L;
}

defaultproperties
{
     DrawType=DT_Mesh
	 bOnlyDrawIfAttached=True
	 bOnlyDirtyReplication=True
     RemoteRole=ROLE_SimulatedProxy
	 bUseLightingFromBase=True
}
