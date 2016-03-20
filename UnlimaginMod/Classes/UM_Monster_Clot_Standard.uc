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
	 // Collision
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=17.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=69.0
	 //CollisionRadius=24.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=55.0
	 CollisionRadius=18.7
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.6,AreaHeight=6.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=1.6,Y=-1.6,Z=0.0),AreaImpactStrength=5.4)
	 //ToDo: UM_PawnBodyCollision - ύςξ βπεμεννΰÿ κξλθηθÿ ςσλξβθωΰ. Β δΰλόνειψεμ ηΰμενθςό νΰ αξλεε δεςΰλόνσώ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=17.0,AreaHeight=36.8,AreaImpactStrength=7.4)
	 BaseEyeHeight=44.0
	 EyeHeight=44.0
	 // DrawScale
	 DrawScale=1.100000
	 //OnlineHeadshotOffset=(X=20.000000,Z=37.000000)
	 OnlineHeadshotOffset=(X=10.000000,Z=42.000000)
	 OnlineHeadshotScale=1.300000
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
}
