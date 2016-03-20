//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Bloat_Standard
//	Parent class:	 UM_BaseMonster_Bloat
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 15:58
//================================================================================
class UM_Monster_Bloat_Standard extends UM_BaseMonster_Bloat;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{
    Super.PreCacheStaticMeshes(myLevel);
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.limbs.bloat_head');
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.bloat_diffuse');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmBloat'
     DetachedLegClass=Class'KFChar.SeveredLegBloat'
     DetachedHeadClass=Class'KFChar.SeveredHeadBloat'
     // ControllerClass
	 ControllerClass=Class'UnlimaginMod.UM_ZombieBloatController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Bloat_A.Bloat_Mesh'
	 // Collision
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
	 //ToDo: UM_PawnBodyCollision - ύςξ βπεμεννΰÿ κξλθηθÿ ςσλξβθωΰ. Β δΰλόνειψεμ ηΰμενθςό νΰ αξλεε δεςΰλόνσώ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=25.0,AreaHeight=44.0,AreaSizeScale=1.05,AreaImpactStrength=14.6)
	 BaseEyeHeight=56.0
	 EyeHeight=56.0
	 // DrawScale
	 DrawScale=1.075000
	 //OnlineHeadshotOffset=(X=5.000000,Z=70.000000)
	 OnlineHeadshotOffset=(X=5.000000,Z=54.000000)
	 OnlineHeadshotScale=1.500000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseBloat.Bloat_Idle1Loop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Death'
	 ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 DyingSound=Sound'KF_EnemiesFinalSnd.Bloat_DeathPop'
}
