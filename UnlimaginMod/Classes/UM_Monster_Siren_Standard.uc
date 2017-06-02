//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Siren_Standard
//	Parent class:	 UM_BaseMonster_Siren
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:23
//================================================================================
class UM_Monster_Siren_Standard extends UM_BaseMonster_Siren;

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.siren_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.siren_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.siren_diffuse');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.siren_hair');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.siren_hair_fb');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedLegClass=Class'KFChar.SeveredLegSiren'
     DetachedHeadClass=Class'KFChar.SeveredHeadSiren'
     ControllerClass=Class'UnlimaginMod.UM_ZombieSirenController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Siren_A.SirenMesh'
	 // Collision
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=14.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=66.0
	 //CollisionRadius=19.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=52.5
	 CollisionRadius=14.7
	 BaseEyeHeight=44.0
	 EyeHeight=44.0
	 // DrawScale
	 DrawScale=1.050000
	 //OnlineHeadshotOffset=(X=6.000000,Z=41.000000)
	 OnlineHeadshotOffset=(X=6.000000,Z=42.000000)
	 OnlineHeadshotScale=1.200000
	 // Mass
	 Mass=100.000000 // lb (ôóíò)
	 // Skins
	 Skins(0)=FinalBlend'KF_Specimens_Trip_T.siren_hair_fb'
	 Skins(1)=Combiner'KF_Specimens_Trip_T.siren_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseSiren.Siren_IdleLoop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Jump'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Pain'
	 DyingSound=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Death'
	 ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Challenge'
}
