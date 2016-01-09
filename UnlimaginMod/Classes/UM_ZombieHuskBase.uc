//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieHuskBase
//	Parent class:	 UM_Monster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:18
//================================================================================
class UM_ZombieHuskBase extends UM_Monster
	Abstract;

var     float   NextFireProjectileTime; // Track when we will fire again
var()   float   ProjectileFireInterval; // How often to fire the fire projectile
var()   float   BurnDamageScale;        // How much to reduce fire damage for the Husk

var		class<Projectile>				HuskProjectileClass;
var		array< class<Projectile> >		RandProjectileClass;

//-------------------------------------------------------------------------------
// NOTE: All Code resides in the child class(this class was only created to
//         eliminate hitching caused by loading default properties during play)
//-------------------------------------------------------------------------------

defaultproperties
{
     HeadShotSlowMoChargeBonus=0.25
	 RandProjectileClass(0)=Class'UnlimaginMod.UM_HuskExplosiveProjectile'
	 RandProjectileClass(1)=Class'UnlimaginMod.UM_HuskNapalmProjectile'
	 ProjectileFireInterval=5.500000
     BurnDamageScale=0.250000
     MeleeAnims(0)="Strike"
     MeleeAnims(1)="Strike"
     MeleeAnims(2)="Strike"
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Talk'
     BleedOutDuration=6.000000
     ZapThreshold=0.750000
     bHarpoonToBodyStuns=False
     ZombieFlag=1
     MeleeDamage=15
     damageForce=70000
     bFatAss=True
     KFRagdollName="Burns_Trip"
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Jump'
     Intelligence=BRAINS_Mammal
     bCanDistanceAttackDoors=True
     SeveredArmAttachScale=0.900000
     SeveredLegAttachScale=0.900000
     SeveredHeadAttachScale=0.900000
     //PlayerCountHealthScale=0.100000
	 //PlayerNumHeadHealthScale=0.050000
	 PlayerCountHealthScale=0.05
	 PlayerNumHeadHealthScale=0.05
     HeadHealth=200.000000
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     AmmunitionClass=Class'KFMod.BZombieAmmo'
     ScoringValue=17
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     MeleeRange=30.000000
     GroundSpeed=115.000000
     WaterSpeed=102.000000
     HealthMax=600.000000
     Health=600
     HeadHeight=1.000000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="Husk"
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="WalkL"
     WalkAnims(3)="WalkR"
     IdleCrouchAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
     AmbientSound=Sound'KF_BaseHusk.Husk_IdleLoop'
     
	 Skins(0)=Texture'KF_Specimens_Trip_T_Two.burns.burns_tatters'
     Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'
	 Mesh=SkeletalMesh'UM_Husk_A.Husk_Mesh'
	 
	 MeshTestCollisionHeight=45.0
	 MeshTestCollisionRadius=16.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=79.0
	 //CollisionRadius=29.0
	 
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=63.0
	 CollisionRadius=22.4
	 
     BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=6.4,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=0.2,Z=0.0),AreaImpactStrength=6.8)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=16.0,AreaHeight=32.2,AreaImpactStrength=9.0)
	 BaseEyeHeight=40.0
	 EyeHeight=40.0
	 // DrawScale
	 DrawScale=1.400000
	 
	 //OnlineHeadshotOffset=(X=20.000000,Z=55.000000)
	 OnlineHeadshotOffset=(X=10.000000,Z=38.000000)
	 
     SoundVolume=200
     Mass=400.000000
     RotationRate=(Yaw=45000,Roll=0)
}
