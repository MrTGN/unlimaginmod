//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Monster_Scrake_Standard
//	Parent class:	 UM_BaseMonster_Scrake
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.10.2012 16:18
//================================================================================
class UM_Monster_Scrake_Standard extends UM_BaseMonster_Scrake;

#exec OBJ LOAD FILE=KFPlayerSound.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.scrake_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.scrake_diff');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.scrake_spec');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.scrake_saw_panner');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.scrake_FB');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.Chainsaw_blade_diff');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmScrake'
     DetachedLegClass=Class'KFChar.SeveredLegScrake'
     DetachedHeadClass=Class'KFChar.SeveredHeadScrake'
     DetachedSpecialArmClass=Class'KFChar.SeveredArmScrakeSaw'
	 // ControllerClass
     ControllerClass=Class'UnlimaginMod.UM_ZombieScrakeController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Scrake_A.Scrake_Mesh'
	 // Collision
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
     BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=7.0,AreaHeight=7.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-2.4,Z=0.0),AreaImpactStrength=10.0)
	 //ToDo: UM_PawnBodyCollision - ��� 糅褌褊��� ���韈�� ����粨��. ﾂ 萵���裨�褌 鈞�褊頸� �� 碚�裹 蒟�琿����.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=20.0,AreaHeight=44.4,AreaImpactStrength=14.4)
	 BaseEyeHeight=52.0
	 EyeHeight=52.0
	 // DrawScale
	 DrawScale=1.050000
	 //OnlineHeadshotOffset=(X=22.000000,Y=5.000000,Z=58.000000)
	 OnlineHeadshotOffset=(X=20.000000,Y=5.000000,Z=50.000000)
	 OnlineHeadshotScale=1.500000
	 // Skins
	 Skins(0)=Shader'KF_Specimens_Trip_T.scrake_FB'
	 Skins(1)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
	 // Sounds
	 AmbientSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Idle'
	 SoundVolume=175
	 SoundRadius=100.000000
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Chainsaw_HitPlayer'
	 SawAttackLoopSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Impale'
	 ChainSawOffSound=SoundGroup'KF_ChainsawSnd.Chainsaw_Deselect'
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Death'
	 ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
	 ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
	 ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
	 ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
}
