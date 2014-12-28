//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieCrawlerBase
//	Parent class:	 UM_Monster
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.10.2012 23:10
//================================================================================
class UM_ZombieCrawlerBase extends UM_Monster;

#exec OBJ LOAD FILE=KFPlayerSound.uax

var() float PounceSpeed;
var bool bPouncing;

var(Anims)  name    MeleeAirAnims[3]; // Attack anims for when flying through the air

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	 MiniBossMaxSpeedScale=2.400000
	 // JumpZ
	 MinJumpZScale=0.850000
	 MaxJumpZScale=1.200000
	 // Extra Sizes
	 MaxExtraSizeScale=1.300000
	 ZombieDamType(0)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
     ZombieDamType(1)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
     ZombieDamType(2)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
	 PounceSpeed=330.000000
     MeleeAirAnims(0)="InAir_Attack1"
     MeleeAirAnims(1)="InAir_Attack2"
	 MeleeAirAnims(2)="InAir_Attack1"
     MeleeAnims(0)="ZombieLeapAttack"
     MeleeAnims(1)="ZombieLeapAttack2"
	 MeleeAnims(2)="ZombieLeapAttack"
     HitAnims(0)="HitF"
     HitAnims(1)="HitF"
	 HitAnims(2)="HitF"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Talk'
     KFHitFront="HitF"
     KFHitBack="HitF"
     KFHitLeft="HitF"
     KFHitRight="HitF"
     bStunImmune=True
     bCannibal=True
     ZombieFlag=2
     MeleeDamage=6
     damageForce=5000
     KFRagdollName="Crawler_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Jump'
     CrispUpThreshhold=10
     Intelligence=BRAINS_Mammal
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.850000
     SeveredHeadAttachScale=1.100000
     OnlineHeadshotOffset=(X=28.000000,Z=7.000000)
     OnlineHeadshotScale=1.200000
     MotionDetectorThreat=0.340000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Acquire'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Acquire'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Acquire'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Acquire'
     ScoringValue=10
     IdleHeavyAnim="ZombieLeapIdle"
     IdleRifleAnim="ZombieLeapIdle"
     bCrawler=True
     GroundSpeed=140.000000
     WaterSpeed=130.000000
     JumpZ=350.000000
     HealthMax=70.000000
     Health=70
     HeadHeight=2.500000
     HeadScale=1.050000
     MenuName="Crawler"
     bDoTorsoTwist=False
	 MovementAnims(0)="ZombieScuttle"
     MovementAnims(1)="ZombieScuttleB"
     MovementAnims(2)="ZombieScuttleL"
     MovementAnims(3)="ZombieScuttleR"
     WalkAnims(0)="ZombieScuttle"
     WalkAnims(1)="ZombieScuttleB"
     WalkAnims(2)="ZombieScuttleL"
     WalkAnims(3)="ZombieScuttleR"
     AirAnims(0)="ZombieSpring"
     AirAnims(1)="ZombieSpring"
     AirAnims(2)="ZombieSpring"
     AirAnims(3)="ZombieSpring"
     TakeoffAnims(0)="ZombieSpring"
     TakeoffAnims(1)="ZombieSpring"
     TakeoffAnims(2)="ZombieSpring"
     TakeoffAnims(3)="ZombieSpring"
	 DoubleJumpAnims(0)="ZombieSpring"
     DoubleJumpAnims(1)="ZombieSpring"
     DoubleJumpAnims(2)="ZombieSpring"
     DoubleJumpAnims(3)="ZombieSpring"
     AirStillAnim="ZombieSpring"
     TakeoffStillAnim="ZombieLeapIdle"
     IdleCrouchAnim="ZombieLeapIdle"
     IdleWeaponAnim="ZombieLeapIdle"
     IdleRestAnim="ZombieLeapIdle"
     bOrientOnSlope=True
     AmbientSound=Sound'KF_BaseCrawler.Crawler_Idle'
     
	 Skins(0)=Combiner'KF_Specimens_Trip_T.crawler_cmb'
	 Mesh=SkeletalMesh'UM_Crawler_A.Crawler_Mesh'
	 MeshTestCollisionHeight=20.0
	 MeshTestCollisionRadius=36.0
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.4,AreaHeight=7.5,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=-1.8,Z=0.0),AreaImpactStrength=5.1)
	 //ToDo: UM_PawnBodyCollision - ��� 糅褌褊��� ���韈�� ����粨��. ﾂ 萵���裨�褌 鈞�褊頸� �� 碚�裹 蒟�琿����.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=36.0,AreaHeight=20.0,AreaImpactStrength=6.6)
	 BaseEyeHeight=8.0
	 EyeHeight=8.0
	 // DrawScale
	 DrawScale=1.100000
}
