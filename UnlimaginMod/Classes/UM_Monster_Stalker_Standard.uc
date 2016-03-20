//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Monster_Stalker_Standard
//	Parent class:	 UM_BaseMonster_Stalker
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.10.2012 16:26
//================================================================================
class UM_Monster_Stalker_Standard extends UM_BaseMonster_Stalker;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.stalker_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.stalker_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.stalker_diff');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.stalker_spec');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.stalker_invisible');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.StalkerCloakOpacity_cmb');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.StalkerCloakEnv_rot');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.stalker_opacity_osc');
	myLevel.AddPrecacheMaterial(Material'KFCharacters.StalkerSkin');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmStalker'
     DetachedLegClass=Class'KFChar.SeveredLegStalker'
     DetachedHeadClass=Class'KFChar.SeveredHeadStalker'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Stalker_A.Stalker_Mesh'
     // Collision
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=14.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=69.0
	 //CollisionRadius=20.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=55.0
	 CollisionRadius=15.4
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=7.0,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-1.2,Z=0.0),AreaImpactStrength=5.2)
	 //ToDo: UM_PawnBodyCollision - ��� 糅褌褊��� ���韈�� ����粨��. ﾂ 萵���裨�褌 鈞�褊頸� �� 碚�裹 蒟�琿����.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=14.0,AreaHeight=36.0,AreaImpactStrength=7.0)
	 BaseEyeHeight=43.0
	 EyeHeight=43.0
	 // DrawScale
	 DrawScale=1.100000
	 //OnlineHeadshotOffset=(X=18.000000,Z=33.000000)
	 OnlineHeadshotOffset=(X=18.000000,Z=41.000000)
	 OnlineHeadshotScale=1.200000
	 // Skins
	 Skins(0)=Shader'KF_Specimens_Trip_T.stalker_invisible'
	 Skins(1)=Shader'KF_Specimens_Trip_T.stalker_invisible'
	 UnCloakedSkins(0)=Combiner'KF_Specimens_Trip_T.stalker_cmb'
	 UnCloakedSkins(1)=FinalBlend'KF_Specimens_Trip_T.stalker_fb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseStalker.Stalker_IdleLoop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_HitPlayer'
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Death'
	 ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
	 ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
	 ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
	 ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Stalker.Stalker_Challenge'
}
