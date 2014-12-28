//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieBossBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:00
//================================================================================
class UM_ZombieBossBase extends UM_Monster;

#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

var bool bChargingPlayer,bClientCharg,bFireAtWill,bMinigunning,bIsBossView;
var float RageStartTime,LastChainGunTime,LastMissileTime,LastSneakedTime;

var bool bClientMiniGunning;

var name ChargingAnim;		// How he runs when charging the player.
var byte SyringeCount,ClientSyrCount;

var int MGFireCounter;

var vector TraceHitPos;
var Emitter mTracer,mMuzzleFlash;
var bool bClientCloaked;
var float LastCheckTimes;
var int HealingLevels[3],HealingAmount;

var(Sounds)     sound   RocketFireSound;    // The sound of the rocket being fired
var(Sounds)     sound   MiniGunFireSound;   // The sound of the minigun being fired
var(Sounds)     sound   MiniGunSpinSound;   // The sound of the minigun spinning
var(Sounds)     sound   MeleeImpaleHitSound;// The sound of melee impale attack hitting the player

var             float   MGFireDuration;     // How long to fire for this burst
var             float   MGLostSightTimeout; // When to stop firing because we lost sight of the target
var()           float   MGDamage;           // How much damage the MG will do

var()           float   ClawMeleeDamageRange;// How long his arms melee strike is
var()           float   ImpaleMeleeDamageRange;// How long his spike melee strike is

var             float   LastChargeTime;     // Last time the patriarch charged
var             float   LastForceChargeTime;// Last time patriarch was forced to charge
var             int     NumChargeAttacks;   // Number of attacks this charge
var             float   ChargeDamage;       // How much damage he's taken since the last charge
var             float   LastDamageTime;     // Last Time we took damage

// Sneaking
var             float   SneakStartTime;     // When did we start sneaking
var             int     SneakCount;         // Keep track of the loop that sends the boss to initial hunting state

// PipeBomb damage
var()           float   PipeBombDamageScale;// Scale the pipe bomb damage over time

replication
{
	reliable if( Role==ROLE_Authority )
		bChargingPlayer,SyringeCount,TraceHitPos,bMinigunning,bIsBossView;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	 ChargingAnim="RunF"
     HealingLevels(0)=5600
     HealingLevels(1)=3500
     HealingLevels(2)=2187
     HealingAmount=1750
     RocketFireSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_FireRocket'
     MiniGunFireSound=Sound'KF_BasePatriarch.Attack.Kev_MG_GunfireLoop'
     MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'
     MeleeImpaleHitSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_HitPlayer_Impale'
     MGDamage=6.000000
     ClawMeleeDamageRange=85.000000
     ImpaleMeleeDamageRange=45.000000
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Talk'
     ZapThreshold=5.000000
     ZappedDamageMod=1.250000
     ZapResistanceScale=1.000000
     bHarpoonToHeadStuns=False
     bHarpoonToBodyStuns=False
     DamageToMonsterScale=5.000000
     ZombieFlag=3
     MeleeDamage=75
     damageForce=170000
     bFatAss=True
     KFRagdollName="Patriarch_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_HitPlayer_Fist'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Jump'
     bMeleeStunImmune=True
     CrispUpThreshhold=1
     bCanDistanceAttackDoors=True
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.200000
     SeveredHeadAttachScale=1.500000
     PlayerCountHealthScale=0.750000
     BurningWalkFAnims(0)="WalkF"
     BurningWalkFAnims(1)="WalkF"
     BurningWalkFAnims(2)="WalkF"
     BurningWalkAnims(0)="WalkF"
     BurningWalkAnims(1)="WalkF"
     BurningWalkAnims(2)="WalkF"
     OnlineHeadshotOffset=(X=28.000000,Z=75.000000)
     OnlineHeadshotScale=1.200000
     MotionDetectorThreat=10.000000
     bOnlyDamagedByCrossbow=True
     bBoss=True
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Death'
     ScoringValue=500
     IdleHeavyAnim="BossIdle"
     IdleRifleAnim="BossIdle"
     RagDeathVel=80.000000
     RagDeathUpKick=100.000000
     MeleeRange=10.000000
     GroundSpeed=120.000000
     WaterSpeed=120.000000
     HealthMax=4000.000000
     Health=4000
     HeadScale=1.300000
     MenuName="Patriarch"
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkF"
     MovementAnims(2)="WalkF"
     MovementAnims(3)="WalkF"
     AirAnims(0)="JumpInAir"
     AirAnims(1)="JumpInAir"
     AirAnims(2)="JumpInAir"
     AirAnims(3)="JumpInAir"
     TakeoffAnims(0)="JumpTakeOff"
     TakeoffAnims(1)="JumpTakeOff"
     TakeoffAnims(2)="JumpTakeOff"
     TakeoffAnims(3)="JumpTakeOff"
     LandAnims(0)="JumpLanded"
     LandAnims(1)="JumpLanded"
     LandAnims(2)="JumpLanded"
     LandAnims(3)="JumpLanded"
     AirStillAnim="JumpInAir"
     TakeoffStillAnim="JumpTakeOff"
     IdleCrouchAnim="BossIdle"
     IdleWeaponAnim="BossIdle"
     IdleRestAnim="BossIdle"
     AmbientSound=Sound'KF_BasePatriarch.Idle.Kev_IdleLoop'
     
	 Skins(0)=Combiner'KF_Specimens_Trip_T.gatling_cmb'
     Skins(1)=Combiner'KF_Specimens_Trip_T.patriarch_cmb'
	 Mesh=SkeletalMesh'UM_Patriarch_A.Patriarch_Mesh'
     MeshTestCollisionHeight=70.0
	 MeshTestCollisionRadius=25.0
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=8.5,AreaHeight=9.0,AreaBone="CHR_Head",AreaOffset=(X=3.0,Y=-1.8,Z=0.0),AreaImpactStrength=16.5)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=25.0,AreaHeight=52.0,AreaImpactStrength=22.5)
	 BaseEyeHeight=61.0
	 EyeHeight=61.0
	 // DrawScale
	 DrawScale=1.050000
	 	 
     SoundVolume=75
     bNetNotify=False
     Mass=1000.000000
     RotationRate=(Yaw=36000,Roll=0)
}
