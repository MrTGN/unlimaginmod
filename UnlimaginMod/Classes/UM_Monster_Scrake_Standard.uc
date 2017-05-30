//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Scrake_Standard
//	Parent class:	 UM_BaseMonster_Scrake
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
	 BaseEyeHeight=52.0
	 EyeHeight=52.0
	 // DrawScale
	 DrawScale=1.050000
	 //OnlineHeadshotOffset=(X=22.000000,Y=5.000000,Z=58.000000)
	 OnlineHeadshotOffset=(X=20.000000,Y=5.000000,Z=50.000000)
	 OnlineHeadshotScale=1.500000
	 // Mass
	 Mass=420.000000
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
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Pain'
	 DyingSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Death'
	 ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Scrake.Scrake_Challenge'
}
