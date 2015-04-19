//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieCrawlerBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:10
//================================================================================
class UM_ZombieCrawlerBase extends UM_Monster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

var() float PounceSpeed;
var bool bPouncing;

var(Anims)		name				MeleeAirAnims[3]; // Attack anims for when flying through the air

var				bool				bPoisonous;
var				float				PoisonousChance;
var(Display)	Material			PoisonousMaterial;
var				class<DamTypeZombieAttack>	PoisonDamageType;
var				range				PoisonDamageRandRange;


replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bPoisonous;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	 HeadShotSlowMoChargeBonus=0.25
	 
	 PoisonousChance=0.25
	 //PoisonousMaterial=ConstantColor'KillingFloorLabTextures.Statics.elevater_glow'
	 //PoisonousMaterial=FinalBlend'kf_fx_trip_t.siren.siren_scream_fb'
	 PoisonousMaterial=Combiner'kf_fx_trip_t.siren.siren_scream_cmb'
	 PoisonDamageType=Class'UnlimaginMod.UM_ZombieDamType_CrawlerPoison'
	 PoisonDamageRandRange=(Min=6.0,Max=8.0)
	 ExtraSpeedChance=0.200000
	 ExtraSpeedScaleRange=(Min=1.2,Max=2.4)
	 // JumpZ
	 JumpZScaleRange=(Min=0.85,Max=1.2)
	 // Extra Sizes
	 ExtraSizeScaleRange=(Min=0.52,Max=1.3)
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
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 CollisionHeight=27.0
	 CollisionRadius=52.0
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.4,AreaHeight=7.5,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=-1.8,Z=0.0),AreaImpactStrength=5.1)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=36.0,AreaHeight=20.0,AreaImpactStrength=6.6)
	 BaseEyeHeight=8.0
	 EyeHeight=8.0
	 // DrawScale
	 DrawScale=1.100000
	 
	 //OnlineHeadshotOffset=(X=28.000000,Z=7.000000)
	 OnlineHeadshotOffset=(X=30.000000,Z=5.000000)
     OnlineHeadshotScale=1.200000
}
