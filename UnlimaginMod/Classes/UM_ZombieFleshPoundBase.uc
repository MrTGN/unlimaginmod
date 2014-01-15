//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieFleshPoundBase
//	Parent class:	 UM_KFMonster
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 13.10.2012 23:12
//================================================================================
class UM_ZombieFleshPoundBase extends UM_KFMonster;

#exec OBJ LOAD FILE=KFPlayerSound.uax

var () float BlockDamageReduction;
var bool bChargingPlayer,bClientCharge;
var int TwoSecondDamageTotal;
var float LastDamagedTime,RageEndTime;

var() vector RotMag;						// how far to rot view
var() vector RotRate;				// how fast to rot view
var() float	RotTime;				// how much time to rot the instigator's view
var() vector OffsetMag;			// max view offset vertically
var() vector OffsetRate;				// how fast to offset view vertically
var() float	OffsetTime;				// how much time to offset view

var name ChargingAnim;		// How he runs when charging the player.

//var ONSHeadlightCorona DeviceGlow; //KFTODO: Don't think this is needed, its not reffed anywhere

var () int RageDamageThreshold;  // configurable.

var FleshPoundAvoidArea AvoidArea;  // Make the other AI fear this AI

var bool    bFrustrated;        // The fleshpound is tired of being kited and is pissed and ready to attack

replication
{
	reliable if(Role == ROLE_Authority)
		bChargingPlayer, bFrustrated;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     EnergyToPenetrateHead=800.000000
     EnergyToPenetrateBody=1200.000000
	 BlockDamageReduction=0.400000
     RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
     RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     RotTime=6.000000
     OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     OffsetTime=3.500000
     ChargingAnim="PoundRun"
     RageDamageThreshold=360
     MeleeAnims(0)="PoundAttack1"
     MeleeAnims(1)="PoundAttack2"
     MeleeAnims(2)="PoundAttack3"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Talk'
     StunsRemaining=1
     BleedOutDuration=7.000000
     ZapThreshold=1.750000
     ZappedDamageMod=1.250000
     bHarpoonToBodyStuns=False
     DamageToMonsterScale=5.000000
     ZombieFlag=3
     MeleeDamage=35
     damageForce=15000
     bFatAss=True
     KFRagdollName="FleshPound_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Jump'
     SpinDamConst=20.000000
     SpinDamRand=20.000000
     bMeleeStunImmune=True
     Intelligence=BRAINS_Mammal
     bUseExtendedCollision=True
     ColOffset=(Z=52.000000)
     ColRadius=36.000000
     ColHeight=35.000000
     SeveredArmAttachScale=1.300000
     SeveredLegAttachScale=1.200000
     SeveredHeadAttachScale=1.500000
     PlayerCountHealthScale=0.250000
     OnlineHeadshotOffset=(X=22.000000,Z=68.000000)
     OnlineHeadshotScale=1.300000
     HeadHealth=700.000000
     PlayerNumHeadHealthScale=0.300000
     MotionDetectorThreat=5.000000
     bBoss=True
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
     ScoringValue=200
     IdleHeavyAnim="PoundIdle"
     IdleRifleAnim="PoundIdle"
     RagDeathUpKick=100.000000
     MeleeRange=55.000000
     GroundSpeed=130.000000
     WaterSpeed=120.000000
     HealthMax=1500.000000
     Health=1500
     HeadHeight=2.500000
     HeadScale=1.300000
     MenuName="Flesh Pound"
     MovementAnims(0)="PoundWalk"
     MovementAnims(1)="WalkB"
     WalkAnims(0)="PoundWalk"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
     IdleCrouchAnim="PoundIdle"
     IdleWeaponAnim="PoundIdle"
     IdleRestAnim="PoundIdle"
     AmbientSound=Sound'KF_BaseFleshpound.FP_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip.FleshPound_Freak'
     PrePivot=(Z=0.000000)
     Skins(0)=Combiner'KF_Specimens_Trip_T.fleshpound_cmb'
     Skins(1)=Shader'KFCharacters.FPAmberBloomShader'
     Mass=600.000000
     RotationRate=(Yaw=45000,Roll=0)
}