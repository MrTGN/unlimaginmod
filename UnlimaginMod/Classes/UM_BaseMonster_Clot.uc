//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Clot
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:06
//================================================================================
class UM_BaseMonster_Clot extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_Freaks_Trip.ukx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

var     KFPawn  DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var     bool    bGrappling;             // This zombie is grappling someone
var     float   GrappleEndTime;         // When the current grapple should be over
var()   float   GrappleDuration;        // How long a grapple by this zombie should last

var	float	ClotGrabMessageDelay;	// Amount of time between a player saying "I've been grabbed" message

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bGrappling;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     GrappleDuration=1.500000
     ClotGrabMessageDelay=12.000000
     MeleeAnims(0)="ClotGrapple"
     MeleeAnims(1)="ClotGrappleTwo"
     MeleeAnims(2)="ClotGrappleThree"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Talk'
     bCannibal=True
     MeleeDamage=6
     damageForce=5000
     KFRagdollName="Clot_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Jump'
     CrispUpThreshhold=9
     PuntAnim="ClotPunt"
     AdditionalWalkAnims(0)="ClotWalk2"
     Intelligence=BRAINS_Mammal
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.800000
     SeveredHeadAttachScale=0.800000
     MotionDetectorThreat=0.340000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
     ScoringValue=7
     MeleeRange=20.000000
     GroundSpeed=105.000000
     WaterSpeed=105.000000
     JumpZ=340.000000
     HealthMax=130.000000
     Health=130
     MenuName="Clot"
     MovementAnims(0)="ClotWalk"
     WalkAnims(0)="ClotWalk"
     WalkAnims(1)="ClotWalk"
     WalkAnims(2)="ClotWalk"
     WalkAnims(3)="ClotWalk"
     AmbientSound=Sound'KF_BaseClot.Clot_Idle1Loop'
     
	 Skins(0)=Combiner'KF_Specimens_Trip_T.clot_cmb'
	 Mesh=SkeletalMesh'UM_Clot_A.Clot_Mesh'
	 
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=17.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=69.0
	 //CollisionRadius=24.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=55.0
	 CollisionRadius=18.7
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.6,AreaHeight=6.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=1.6,Y=-1.6,Z=0.0),AreaImpactStrength=5.4)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=17.0,AreaHeight=36.8,AreaImpactStrength=7.4)
	 BaseEyeHeight=44.0
	 EyeHeight=44.0
	 // DrawScale
     DrawScale=1.100000
	 
	 //OnlineHeadshotOffset=(X=20.000000,Z=37.000000)
	 OnlineHeadshotOffset=(X=10.000000,Z=42.000000)
     OnlineHeadshotScale=1.300000

     RotationRate=(Yaw=45000,Roll=0)
}
