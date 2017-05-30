//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Crawler_Standard
//	Parent class:	 UM_BaseMonster_Crawler
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:08
//================================================================================
class UM_Monster_Crawler_Standard extends UM_BaseMonster_Crawler;

#exec OBJ LOAD FILE=KFPlayerSound.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.crawler_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.crawler_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.crawler_diff');
	// PoisonousSkins
	myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.siren.siren_scream_energy');
	myLevel.AddPrecacheMaterial(Combiner'kf_fx_trip_t.siren.siren_scream_cmb');
	//myLevel.AddPrecacheMaterial(FinalBlend'kf_fx_trip_t.siren.siren_scream_fb');
}

defaultproperties
{
     // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmCrawler'
     DetachedLegClass=Class'KFChar.SeveredLegCrawler'
     DetachedHeadClass=Class'KFChar.SeveredHeadCrawler'
	 // ControllerClass
	 ControllerClass=Class'UnlimaginMod.UM_ZombieCrawlerController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Crawler_A.Crawler_Mesh'
	 // Collision
	 MeshTestCollisionHeight=19.0
	 MeshTestCollisionRadius=36.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale * ExtraSizeScaleRange.Max;
	 //CollisionHeight=27.0
	 //CollisionRadius=52.0
	 //CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 //CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=22.0
	 CollisionRadius=39.6
	 BaseEyeHeight=8.0
	 EyeHeight=8.0
	 // DrawScale
	 DrawScale=1.100000
	 //OnlineHeadshotOffset=(X=28.000000,Z=7.000000)
	 OnlineHeadshotOffset=(X=30.000000,Z=5.000000)
     OnlineHeadshotScale=1.200000
	 // Mass
	 Mass=100.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.crawler_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseCrawler.Crawler_Idle'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_HitPlayer'
	 PainSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Death'
	 GibbedDeathSound=SoundGroup'KF_EnemyGlobalSnd.Gibs_Small'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Crawler.Crawler_Acquire'
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.5,AreaHeight=8.0,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=-1.8,Z=0.0),AreaImpactStrength=5.1)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=36.0,AreaHeight=19.0,AreaImpactStrength=6.6)
}
