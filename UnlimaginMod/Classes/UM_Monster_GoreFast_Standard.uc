//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Monster_GoreFast_Standard
//	Parent class:	 UM_BaseMonster_GoreFast
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.10.2012 16:13
//================================================================================
class UM_Monster_GoreFast_Standard extends UM_BaseMonster_GoreFast;

#exec OBJ LOAD FILE=KFPlayerSound.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gorefast_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gorefast_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.gorefast_diff');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmGorefast'
     DetachedLegClass=Class'KFChar.SeveredLegGorefast'
     DetachedHeadClass=Class'KFChar.SeveredHeadGorefast'
     bLeftArmGibbed=True
	 // ControllerClass
     ControllerClass=Class'UnlimaginMod.UM_ZombieGoreFastController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_GoreFast_A.GoreFastMesh'
	 // Collision
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=17.4
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=76.0
	 //CollisionRadius=27.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=60.0
	 CollisionRadius=20.88
	 BaseEyeHeight=44.0
	 EyeHeight=44.0
	 //OnlineHeadshotOffset=(X=5.000000,Z=53.000000)
	 OnlineHeadshotOffset=(X=5.000000,Z=42.000000)
	 OnlineHeadshotScale=1.500000
	 // DrawScale
	 DrawScale=1.200000
	 // Mass
	 Mass=300.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.gorefast_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseGorefast.Gorefast_Idle'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_HitPlayer'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Pain'
	 DyingSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Death'
	 ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.GoreFast.Gorefast_Challenge'
}
