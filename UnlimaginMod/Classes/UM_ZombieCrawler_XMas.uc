//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieCrawler_XMas
//	Parent class:	 UM_BaseMonster_Crawler
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.12.2012 22:39
//================================================================================
class UM_ZombieCrawler_XMas extends UM_BaseMonster_Crawler;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.ReinDeer.ReinDeer_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.ReinDeer_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.ReinDeer');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmCrawler_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegCrawler_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadCrawler_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Acquire'
     MenuName="Christmas Crawler"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.RainDeer'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.ReinDeer.ReinDeer_cmb'
}
