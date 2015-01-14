//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieStalkerBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:29
//================================================================================
class UM_ZombieStalkerBase extends UM_Monster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax

var		float			NextCheckTime, LastUncloakTime;
var		KFHumanPawn		LocalKFHumanPawn;

// From CloatBase
var		KFPawn			DisabledPawn;	// The pawn that has been disabled by this zombie's grapple
var		bool			bGrappling;		// This zombie is grappling someone
var		float			GrappleEndTime;		// When the current grapple should be over
var()	float			GrappleDuration;	// How long a grapple by this zombie should last
var		float			GrabMessageDelay;	// Amount of time between a player saying "I've been grabbed" message
var		float			GrabChance, MinGrabChance, MaxGrabChance;

replication
{
     reliable if(bNetDirty && Role == ROLE_Authority)
          bGrappling;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     MinGrabChance=0.200000
	 MaxGrabChance=0.800000
	 GrappleDuration=1.500000
     GrabMessageDelay=12.000000
     MeleeAnims(0)="StalkerSpinAttack"
     MeleeAnims(1)="StalkerAttack1"
     MeleeAnims(2)="JumpAttack"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Talk'
     MeleeDamage=9
     damageForce=5000
     KFRagdollName="Stalker_Trip"
     ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
     ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
     ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Jump'
     CrispUpThreshhold=10
     PuntAnim="ClotPunt"
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.700000
     OnlineHeadshotOffset=(X=18.000000,Z=33.000000)
     OnlineHeadshotScale=1.200000
     MotionDetectorThreat=0.250000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
     ScoringValue=15
     SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
     IdleHeavyAnim="StalkerIdle"
     IdleRifleAnim="StalkerIdle"
     MeleeRange=30.000000
     GroundSpeed=200.000000
     WaterSpeed=180.000000
     JumpZ=350.000000
     Health=100
     HeadHeight=2.500000
     MenuName="Stalker"
     MovementAnims(0)="ZombieRun"
     MovementAnims(1)="ZombieRun"
     MovementAnims(2)="ZombieRun"
     MovementAnims(3)="ZombieRun"
     WalkAnims(0)="ZombieRun"
     WalkAnims(1)="ZombieRun"
     WalkAnims(2)="ZombieRun"
     WalkAnims(3)="ZombieRun"
     IdleCrouchAnim="StalkerIdle"
     IdleWeaponAnim="StalkerIdle"
     IdleRestAnim="StalkerIdle"
     AmbientSound=Sound'KF_BaseStalker.Stalker_IdleLoop'
     
	 Skins(0)=Shader'KF_Specimens_Trip_T.stalker_invisible'
     Skins(1)=Shader'KF_Specimens_Trip_T.stalker_invisible'
	 Mesh=SkeletalMesh'UM_Stalker_A.Stalker_Mesh'
	 //MeshTestCollisionHeight=50.0
	 //MeshTestCollisionRadius=14.0
	 CollisionHeight=50.0
	 CollisionRadius=14.0
     BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=7.0,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-1.2,Z=0.0),AreaImpactStrength=5.2)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=14.0,AreaHeight=36.0,AreaImpactStrength=7.0)
	 BaseEyeHeight=43.0
	 EyeHeight=43.0
	 // DrawScale
	 DrawScale=1.100000
	 
     RotationRate=(Yaw=45000,Roll=0)
}
