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
	 MeshTestCollisionRadius=25.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=92.0
	 //CollisionRadius=33.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=73.5
	 CollisionRadius=26.25
	 BaseEyeHeight=61.0
	 EyeHeight=61.0
	 // DrawScale
	 DrawScale=1.050000
	 //OnlineHeadshotOffset=(X=28.000000,Z=75.000000)
	 OnlineHeadshotOffset=(X=20.000000,Z=59.000000)
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
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Patriarch.Kev_Death'
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
	 SaveMeSound=sound'KF_EnemiesFinalSnd.Patriarch.Kev_SaveMe'
}
