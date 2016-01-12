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
class UM_ZombieBloatBase extends UM_Monster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

var		BileJet		BloatJet;
var		bool		bPlayBileSplash;
var		bool		bMovingPukeAttack;
var		float		RunAttackTimeout;

var	class<FleshHitEmitter>	BileExplosion;
var	class<FleshHitEmitter>	BileExplosionHeadless;
var	Class<Projectile>		BileProjectileClass;


//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     ImpressiveKillChance=0.15
	 
	 HeadShotSlowMoChargeBonus=0.25
	 
	 BileProjectileClass=Class'UnlimaginMod.UM_BloatVomit'
	 ExtraSpeedScaleRange=(Max=2.8)
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
     SeveredArmAttachScale=1.100000
     SeveredLegAttachScale=1.300000
     SeveredHeadAttachScale=1.700000
     //PlayerCountHealthScale=0.250000
	 PlayerCountHealthScale=0.15
	 PlayerNumHeadHealthScale=0.15
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
     
	 Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'
	 Mesh=SkeletalMesh'UM_Bloat_A.Bloat_Mesh'
	 
	 MeshTestCollisionHeight=62.0
	 MeshTestCollisionRadius=25.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=84.0
	 //CollisionRadius=34.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=66.65
	 CollisionRadius=26.875
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=8.0,AreaHeight=9.0,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-2.0,Z=0.0),AreaImpactStrength=7.6)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=25.0,AreaHeight=44.0,AreaImpactStrength=14.6)
	 BaseEyeHeight=56.0
	 EyeHeight=56.0
	 // DrawScale
	 DrawScale=1.075000
	 
	 //OnlineHeadshotOffset=(X=5.000000,Z=70.000000)
	 OnlineHeadshotOffset=(X=5.000000,Z=54.000000)
     OnlineHeadshotScale=1.500000
	 
	 SoundVolume=200
     Mass=400.000000
     RotationRate=(Yaw=45000,Roll=0)
}
