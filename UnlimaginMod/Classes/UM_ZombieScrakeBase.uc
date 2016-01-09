//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieScrakeBase
//	Parent class:	 UM_Monster
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.10.2012 23:23
//================================================================================
class UM_ZombieScrakeBase extends UM_Monster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

var(Sounds) sound   SawAttackLoopSound; // THe sound for the saw revved up, looping
var(Sounds) sound   ChainSawOffSound;   //The sound of this zombie dieing without a head

var         bool    bCharging;          // Scrake charges when his health gets low
var()       float   AttackChargeRate;   // Ratio to increase scrake movement speed when charging and attacking

// Exhaust effects
var()	class<VehicleExhaustEffect>	ExhaustEffectClass; // Effect class for the exhaust emitter
var()	VehicleExhaustEffect 		ExhaustEffect;
var 		bool	bNoExhaustRespawn;

replication
{
	reliable if(Role == ROLE_Authority)
		bCharging;
}

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
	 HeadShotSlowMoChargeBonus=0.35
	 SawAttackLoopSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Impale'
     ChainSawOffSound=SoundGroup'KF_ChainsawSnd.Chainsaw_Deselect'
     AttackChargeRate=2.500000
     ExhaustEffectClass=Class'KFMod.ChainsawExhaust'
     MeleeAnims(0)="SawZombieAttack1"
     MeleeAnims(1)="SawZombieAttack2"
	 MeleeAnims(2)="SawZombieAttack1"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Talk'
     StunsRemaining=1
     BleedOutDuration=6.000000
     ZapThreshold=1.250000
     ZappedDamageMod=1.250000
	 bHarpoonToBodyStuns=False
	 DamageToMonsterScale=8.000000
     ZombieFlag=3
     MeleeDamage=20
     damageForce=-75000
     bFatAss=True
     KFRagdollName="Scrake_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Chainsaw_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Jump'
     bMeleeStunImmune=True
     Intelligence=BRAINS_Mammal
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.100000
     //PlayerCountHealthScale=0.500000
	 //PlayerNumHeadHealthScale=0.300000
	 PlayerCountHealthScale=0.3
	 PlayerNumHeadHealthScale=0.3
     PoundRageBumpDamScale=0.010000
     HeadHealth=650.000000
     MotionDetectorThreat=3.000000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
     ScoringValue=75
     IdleHeavyAnim="SawZombieIdle"
     IdleRifleAnim="SawZombieIdle"
     MeleeRange=40.000000
     GroundSpeed=85.000000
     WaterSpeed=75.000000
     HealthMax=1000.000000
     Health=1000
     HeadHeight=2.200000
     MenuName="Scrake"
     MovementAnims(0)="SawZombieWalk"
     MovementAnims(1)="SawZombieWalk"
     MovementAnims(2)="SawZombieWalk"
     MovementAnims(3)="SawZombieWalk"
     WalkAnims(0)="SawZombieWalk"
     WalkAnims(1)="SawZombieWalk"
     WalkAnims(2)="SawZombieWalk"
     WalkAnims(3)="SawZombieWalk"
     IdleCrouchAnim="SawZombieIdle"
     IdleWeaponAnim="SawZombieIdle"
     IdleRestAnim="SawZombieIdle"
     AmbientSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Idle'
     
	 Skins(0)=Shader'KF_Specimens_Trip_T.scrake_FB'
     Skins(1)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
	 Mesh=SkeletalMesh'UM_Scrake_A.Scrake_Mesh'
	 
	 MeshTestCollisionHeight=59.6
	 MeshTestCollisionRadius=20.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=79.0
	 //CollisionRadius=27.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=62.58
	 CollisionRadius=21.0
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=7.0,AreaHeight=7.6,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-2.4,Z=0.0),AreaImpactStrength=10.0)
	 //ToDo: UM_PawnBodyCollision - ��� 糅褌褊��� ���韈�� ����粨��. ﾂ 萵���裨�褌 鈞�褊頸� �� 碚�裹 蒟�琿����.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=20.0,AreaHeight=44.4,AreaImpactStrength=14.4)
	 BaseEyeHeight=52.0
	 EyeHeight=52.0
	 // DrawScale
	 DrawScale=1.050000
	 
	 //OnlineHeadshotOffset=(X=22.000000,Y=5.000000,Z=58.000000)
	 OnlineHeadshotOffset=(X=20.000000,Y=5.000000,Z=50.000000)
     OnlineHeadshotScale=1.500000
	 
     SoundVolume=175
     SoundRadius=100.000000
     Mass=500.000000
     RotationRate=(Yaw=45000,Roll=0)
}
