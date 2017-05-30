//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Boss_Standard
//	Parent class:	 UM_BaseMonster_Boss
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:02
//================================================================================
class UM_Monster_Boss_Standard extends UM_BaseMonster_Boss;

#exec OBJ LOAD FILE=KFPatch2.utx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx
#exec OBJ LOAD FILE=kf_fx_trip_t.utx

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gatling_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gatling_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.gatling_D');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.PatGungoInvisible_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.patriarch_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.patriarch_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.patriarch_D');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_invisible');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_invisible_gun');
    myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_fizzle_FB');
    myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.Gore.Patriarch_Gore_Limbs_Diff');
    myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.Gore.Patriarch_Gore_Limbs_Spec');
 }

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmPatriarch'
     DetachedLegClass=Class'KFChar.SeveredLegPatriarch'
     DetachedHeadClass=Class'KFChar.SeveredHeadPatriarch'
     DetachedSpecialArmClass=Class'KFChar.SeveredRocketArmPatriarch'
	 // ControllerClass
     ControllerClass=Class'UnlimaginMod.UM_ZombieBossController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Patriarch_A.Patriarch_Mesh'
	 // Collision
	 MeshTestCollisionHeight=70.0
	 MeshTestCollisionRadius=24.0
	 // DrawScale
	 DrawScale=1.050000
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=73.5
	 CollisionRadius=25.2
	 //MeshEyeHeight=65.5
	 BaseEyeHeight=68.775
	 EyeHeight=68.775
	 // CrouchHeight = CollisionHeight / 1.5625;
	 // CrouchRadius = CollisionRadius;
	 CrouchHeight=47.04
	 CrouchRadius=25.2
	 // OnlineHeadshotOffset=(X=28.000000,Z=75.000000) // old
	 // OnlineHeadshotOffset is a Head Offset for the server HeadShot processing when the walking anim is playing on the clients
	 // MeshTestOnlineHeadshotOffset=(X=24.0,Z=59.0) * DrawScale
	 OnlineHeadshotOffset=(X=25.2,Z=61.95)
	 OnlineHeadshotScale=1.200000
	 // Mass
	 Mass=900.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.gatling_cmb'
	 Skins(1)=Combiner'KF_Specimens_Trip_T.patriarch_cmb'
	 CloakedSkins(0)=Shader'KF_Specimens_Trip_T.patriarch_invisible_gun'
	 CloakedSkins(1)=Shader'KF_Specimens_Trip_T.patriarch_invisible'
	 // Sounds
	 AmbientSound=Sound'KF_BasePatriarch.Idle.Kev_IdleLoop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Talk'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Pain'
	 DyingSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Death'
	 GibbedDeathSound=SoundGroup'KF_EnemyGlobalSnd.Gibs_Large'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_HitPlayer_Fist'
	 RocketFireSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_FireRocket'
	 MiniGunFireSound=Sound'KF_BasePatriarch.Attack.Kev_MG_GunfireLoop'
	 MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'
	 MeleeImpaleHitSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_HitPlayer_Impale'
	 KnockDownSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_KnockedDown'
	 EntranceSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Entrance'
	 VictorySound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Victory'
	 MiniGunPreFireSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_WarnGun'
	 MisslePreFireSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_WarnRocket'
	 TauntNinjaSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_TauntNinja'
	 TauntLumberJackSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_TauntLumberJack'
	 TauntRadialSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_TauntRadial'
	 SaveMeSound=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_SaveMe'
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=8.5,AreaHeight=9.0,AreaSizeScale=1.05,AreaBone="HitPoint_Head",AreaImpactStrength=16.5)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=24.0,AreaHeight=61.0,AreaOffset=(X=0.0,Y=0.0,Z=-9.0),AreaImpactStrength=22.5)
}
