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
	 Mesh=SkeletalMesh'UM_Bloat_A.UM_Bloat_Mesh'
	 // MeshTestCollision
	 MeshTestCollisionHeight=63.0
	 MeshTestCollisionRadius=25.0
	 // DrawScale
	 DrawScale=1.075000
	 // Collision
	 // CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 // CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=67.725
	 CollisionRadius=26.875
	 // EyeHeight
	 // MeshTestEyeHeight=55.0
	 BaseEyeHeight=59.125
	 EyeHeight=59.125
	 // CrouchHeight = CollisionHeight / 1.5625;
	 // CrouchRadius = CollisionRadius;
	 CrouchHeight=43.344
	 CrouchRadius=26.875
	 // OnlineHeadshotOffset=(X=5.0,Z=58.0) // old
	 // Head Offset for the server HeadShot processing when the walking anim is playing on the clients
	 //OnlineHeadshotOffset=(X=4.0,Z=56.5) * DrawScale
	 OnlineHeadshotOffset=(X=4.3,Z=60.7375)
	 OnlineHeadshotScale=1.5
	 // Mass
	 Mass=460.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseBloat.Bloat_Idle1Loop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Pain'
	 DyingSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Death'
	 ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 GibbedDeathSound=Sound'KF_EnemiesFinalSnd.Bloat_DeathPop'
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=7.5,AreaHeight=9.5,AreaSizeScale=1.05,AreaBone="HitPoint_Head",AreaImpactStrength=7.6)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=24.0,AreaHeight=53.5,AreaOffset=(Z=-9.5),AreaImpactStrength=14.6)
}
