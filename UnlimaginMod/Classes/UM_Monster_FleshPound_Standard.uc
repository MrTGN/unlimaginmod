//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_FleshPound_Standard
//	Parent class:	 UM_BaseMonster_FleshPound
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:11
//================================================================================
class UM_Monster_FleshPound_Standard extends UM_BaseMonster_FleshPound;

#exec OBJ LOAD FILE=KFPlayerSound.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.fleshpound_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.fleshpound_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.fleshpound_diff');
	myLevel.AddPrecacheMaterial(Shader'KFCharacters.FPRedBloomShader');
}

defaultproperties
{
     // DetachedBodyParts
     DetachedArmClass=Class'KFChar.SeveredArmPound'
     DetachedLegClass=Class'KFChar.SeveredLegPound'
     DetachedHeadClass=Class'KFChar.SeveredHeadPound'
     // ControllerClass
	 ControllerClass=Class'UnlimaginMod.UM_ZombieFleshPoundController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_FleshPound_A.FleshPound_Mesh'
	 // Collision
	 MeshTestCollisionHeight=70.0
	 MeshTestCollisionRadius=26.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=88.0
	 //CollisionRadius=33.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=70.0
	 CollisionRadius=26.0
	 BaseEyeHeight=62.0
	 EyeHeight=62.0
	 // DrawScale
	 DrawScale=1.000000
	 //OnlineHeadshotOffset=(X=22.000000,Z=68.000000)
	 OnlineHeadshotOffset=(X=20.000000,Z=60.000000)
     OnlineHeadshotScale=1.300000
	 // Mass
	 Mass=600.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.fleshpound_cmb'
     Skins(1)=Shader'KFCharacters.FPAmberBloomShader'
	 RageSkins(0)=Combiner'KF_Specimens_Trip_T.fleshpound_cmb'
	 RageSkins(1)=Shader'KFCharacters.FPRedBloomShader'
	 // Sounds
	 AmbientSound=Sound'KF_BaseFleshpound.FP_IdleLoop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_HitPlayer'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Death'
	 GibbedDeathSound=SoundGroup'KF_EnemyGlobalSnd.Gibs_Large'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
}
