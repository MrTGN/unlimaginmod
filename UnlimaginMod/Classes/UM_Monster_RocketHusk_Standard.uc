//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_RocketHusk_Standard
//	Parent class:	 UM_BaseMonster_RocketHusk
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:16
//================================================================================
class UM_Monster_RocketHusk_Standard extends UM_BaseMonster_RocketHusk;

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T_Two.burns_diff');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T_Two.burns_emissive_mask');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T_Two.burns_energy_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T_Two.burns_env_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T_Two.burns_fire_cmb');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T_Two.burns_shdr');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T_Two.burns_cmb');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmHusk'
     DetachedLegClass=Class'KFChar.SeveredLegHusk'
     DetachedHeadClass=Class'KFChar.SeveredHeadHusk'
     DetachedSpecialArmClass=Class'KFChar.SeveredArmHuskGun'
	 // ControllerClass
     ControllerClass=Class'UnlimaginMod.UM_ZombieHuskController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Husk_A.Husk_Mesh'
	 // Collision
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
	 BaseEyeHeight=40.0
	 EyeHeight=40.0
	 // DrawScale
	 DrawScale=1.400000
	 //OnlineHeadshotOffset=(X=20.000000,Z=55.000000)
	 OnlineHeadshotOffset=(X=10.000000,Z=38.000000)
	 // Mass
	 Mass=320.000000
	 // Skins
	 Skins(0)=Texture'KF_Specimens_Trip_T_Two.burns.burns_tatters'
     Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'
	 // Sounds
	 AmbientSound=Sound'KF_BaseHusk.Husk_IdleLoop'
	 SoundVolume=200
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
     PainSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
}
