//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Clot_Standard
//	Parent class:	 UM_BaseMonster_Clot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:05
//================================================================================
class UM_Monster_Clot_Standard extends UM_BaseMonster_Clot;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_Freaks_Trip.ukx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.clot_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.clot_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.clot_diffuse');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.clot_spec');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmClot'
     DetachedLegClass=Class'KFChar.SeveredLegClot'
     DetachedHeadClass=Class'KFChar.SeveredHeadClot'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Clot_A.Clot_Mesh'
	 // DrawScale
	 DrawScale=1.100000
	 // Collision
	 MeshTestCollisionHeight=50.1
	 MeshTestCollisionRadius=18.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=69.0
	 //CollisionRadius=24.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=55.11
	 CollisionRadius=19.8
	 // MeshTestEyeHeight=44.0
	 BaseEyeHeight=48.4
	 EyeHeight=48.4
	 // CrouchHeight = MeshTestCollisionHeight / 1.5625 * DrawScale;
	 // CrouchRadius = MeshTestCollisionRadius * DrawScale;
	 CrouchHeight=35.2704
	 CrouchRadius=19.8
	 // Head Offset for the server HeadShot processing when the walking anim is playing on the clients
	 //OnlineHeadshotOffset=(X=15.0,Z=39.5) * DrawScale
	 OnlineHeadshotOffset=(X=16.5,Z=43.45)
	 OnlineHeadshotScale=1.300000
	 // Mass
	 Mass=200.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.clot_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseClot.Clot_Idle1Loop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_HitPlayer'
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Death'
	 ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
	 ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
	 ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
	 ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.clot.Clot_Challenge'
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.0,AreaHeight=7.6,AreaSizeScale=1.05,AreaBone="HitPoint_Head",AreaImpactStrength=5.4)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=18.0,AreaHeight=42.5,AreaOffset=(Z=-7.6),AreaImpactStrength=7.4)
}
