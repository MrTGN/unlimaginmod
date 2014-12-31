//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieGoreFastBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:15
//================================================================================
class UM_ZombieGoreFastBase extends UM_Monster;

#exec OBJ LOAD FILE=KFPlayerSound.uax

var		bool	bRunning;
var		float	RunAttackTimeout, RunGroundSpeedScale;

replication
{
	reliable if(Role == ROLE_Authority)
		bRunning;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     RunGroundSpeedScale=1.850000
	 MeleeAnims(0)="GoreAttack1"
     MeleeAnims(1)="GoreAttack2"
     MeleeAnims(2)="GoreAttack1"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Talk'
     bCannibal=True
     MeleeDamage=15
     damageForce=5000
     KFRagdollName="GoreFast_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Jump'
     CrispUpThreshhold=8
     SeveredArmAttachScale=0.900000
     SeveredLegAttachScale=0.900000
     PlayerCountHealthScale=0.150000
     OnlineHeadshotOffset=(X=5.000000,Z=53.000000)
     OnlineHeadshotScale=1.500000
     MotionDetectorThreat=0.500000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
     ScoringValue=12
     IdleHeavyAnim="GoreIdle"
     IdleRifleAnim="GoreIdle"
     MeleeRange=30.000000
     GroundSpeed=120.000000
     WaterSpeed=140.000000
     HealthMax=250.000000
     Health=250
     HeadHeight=2.500000
     HeadScale=1.500000
     MenuName="Gorefast"
     MovementAnims(0)="GoreWalk"
     WalkAnims(0)="GoreWalk"
     WalkAnims(1)="GoreWalk"
     WalkAnims(2)="GoreWalk"
     WalkAnims(3)="GoreWalk"
     IdleCrouchAnim="GoreIdle"
     IdleWeaponAnim="GoreIdle"
     IdleRestAnim="GoreIdle"
     AmbientSound=Sound'KF_BaseGorefast.Gorefast_Idle'
     
	 Skins(0)=Combiner'KF_Specimens_Trip_T.gorefast_cmb'
	 Mesh=SkeletalMesh'UM_GoreFast_A.GoreFast_Mesh'
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=17.4
	 CollisionHeight=50.0
	 CollisionRadius=17.4
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.8,AreaHeight=6.0,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-1.8,Z=0.0),AreaImpactStrength=5.8)
	 //ToDo: UM_PawnBodyCollision - ύςξ βπεμεννΰÿ κξλθηθÿ ςσλξβθωΰ. Β δΰλόνειψεμ ηΰμενθςό νΰ αξλεε δεςΰλόνσώ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=17.4,AreaHeight=38.0,AreaImpactStrength=8.2)
	 BaseEyeHeight=44.0
	 EyeHeight=44.0
	 // DrawScale
	 DrawScale=1.200000
	 
     Mass=350.000000
     RotationRate=(Yaw=45000,Roll=0)
}
