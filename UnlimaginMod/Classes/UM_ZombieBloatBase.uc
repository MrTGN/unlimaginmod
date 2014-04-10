//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieBloatBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 22:54
//================================================================================
class UM_ZombieBloatBase extends UM_Monster;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

var BileJet BloatJet;
var bool bPlayBileSplash;
var bool bMovingPukeAttack;
var float RunAttackTimeout;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     EnergyToPenetrateHead=520.000000
	 EnergyToPenetrateBody=1000.000000
	 MiniBossMaxSpeedScale=2.800000
     MeleeAnims(0)="BloatChop2"
     MeleeAnims(1)="BloatChop2"
     MeleeAnims(2)="BloatChop2"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Talk'
     BleedOutDuration=6.000000
     ZapThreshold=0.500000
     ZappedDamageMod=1.500000
     bHarpoonToBodyStuns=False
     ZombieFlag=1
     MeleeDamage=14
     damageForce=70000
     bFatAss=True
     KFRagdollName="Bloat_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Jump'
     PuntAnim="BloatPunt"
     Intelligence=BRAINS_Stupid
     bCanDistanceAttackDoors=True
     bUseExtendedCollision=True
     ColOffset=(Z=60.000000)
     ColRadius=27.000000
     ColHeight=22.000000
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.300000
     SeveredHeadAttachScale=1.700000
     PlayerCountHealthScale=0.250000
     OnlineHeadshotOffset=(X=5.000000,Z=70.000000)
     OnlineHeadshotScale=1.500000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
     AmmunitionClass=Class'KFMod.BZombieAmmo'
     ScoringValue=17
     IdleHeavyAnim="BloatIdle"
     IdleRifleAnim="BloatIdle"
     MeleeRange=30.000000
     GroundSpeed=75.000000
     WaterSpeed=102.000000
     HealthMax=525.000000
     Health=525
     HeadHeight=2.500000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="Bloat"
     MovementAnims(0)="WalkBloat"
     MovementAnims(1)="WalkBloat"
     WalkAnims(0)="WalkBloat"
     WalkAnims(1)="WalkBloat"
     WalkAnims(2)="WalkBloat"
     WalkAnims(3)="WalkBloat"
     IdleCrouchAnim="BloatIdle"
     IdleWeaponAnim="BloatIdle"
     IdleRestAnim="BloatIdle"
     AmbientSound=Sound'KF_BaseBloat.Bloat_Idle1Loop'
     Mesh=SkeletalMesh'KF_Freaks_Trip.Bloat_Freak'
     DrawScale=1.075000
     PrePivot=(Z=5.000000)
     Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'
     SoundVolume=200
     Mass=400.000000
     RotationRate=(Yaw=45000,Roll=0)
}
