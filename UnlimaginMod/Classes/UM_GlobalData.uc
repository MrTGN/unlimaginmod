//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_GlobalData
//	Parent class:	 Actor
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 15.09.2013 20:20
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 It is an abstract data class, used to save references 
//					 to objects into the default values and accessing them 
//					 from class'UM_GlobalData', i.e. "Global" object references.
//================================================================================
class UM_GlobalData extends Actor
	Abstract
	hidecategories(Object, Actor)
	NotPlaceable;


var		UM_ActorPool				ActorPool;
var		UM_WeaponInfoGenerator		WeapInfoGen;


defaultproperties
{
     DrawType=DT_None
     LifeSpan=0.000000
	 bCanBeDamaged=False
	 bUnlit=True
	 bAlwaysRelevant=True
	 bGameRelevant=True
	 bSkipActorPropertyReplication=True
	 RemoteRole=ROLE_DumbProxy
     bHidden=True
	 bHiddenEd=True
	 bCollideActors=False
	 bCollideWorld=False
	 bBlockZeroExtentTraces=False
     bBlockNonZeroExtentTraces=False
     bSmoothKarmaStateUpdates=False
     bBlockHitPointTraces=False
	 CollisionRadius=0.000000
     CollisionHeight=0.000000
}
