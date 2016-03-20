//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Monster_RocketHusk_Standard
//	Parent class:	 UM_BaseMonster_RocketHusk
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
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
     BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=6.4,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=0.2,Z=0.0),AreaImpactStrength=6.8)
	 //ToDo: UM_PawnBodyCollision - ��� 糅褌褊��� ���韈�� ����粨��. ﾂ 萵���裨�褌 鈞�褊頸� �� 碚�裹 蒟�琿����.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=16.0,AreaHeight=32.2,AreaImpactStrength=9.0)
	 BaseEyeHeight=40.0
	 EyeHeight=40.0
	 // DrawScale
	 DrawScale=1.400000
	 //OnlineHeadshotOffset=(X=20.000000,Z=55.000000)
	 OnlineHeadshotOffset=(X=10.000000,Z=38.000000)
	 // Skins
	 Skins(0)=Texture'KF_Specimens_Trip_T_Two.burns.burns_tatters'
     Skins(1)=Shader'KF_Specimens_Trip_T_Two.burns.burns_shdr'
	 // Sounds
	 AmbientSound=Sound'KF_BaseHusk.Husk_IdleLoop'
	 SoundVolume=200
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Husk.Husk_Challenge'
}
