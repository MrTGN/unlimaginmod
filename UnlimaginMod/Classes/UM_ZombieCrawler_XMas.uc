//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieCrawler_XMas
//	Parent class:	 UM_ZombieCrawler
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 13.12.2012 22:39
//================================================================================
class UM_ZombieCrawler_XMas extends UM_ZombieCrawler;

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
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Acquire'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Acquire'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Acquire'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Acquire'
     MenuName="Christmas Crawler"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Crawler.Crawler_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.RainDeer'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.ReinDeer.ReinDeer_cmb'
}
