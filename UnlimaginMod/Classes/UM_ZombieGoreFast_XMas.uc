//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieGoreFast_XMas
//	Parent class:	 UM_BaseMonster_GoreFast
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.12.2012 22:53
//================================================================================
class UM_ZombieGoreFast_XMas extends UM_BaseMonster_GoreFast;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax
#exec OBJ LOAD FILE=KF_Specimens_Trip_XMAS_T.utx

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.GingerFast.GingerFast_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.GingerFast_env_cmb');
	//myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.GingerFast_cmb');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmGorefast_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegGorefast_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadGorefast_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Challenge'
     MenuName="Christmas Gorefast"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.GoreFast.Gorefast_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.GingerFast'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.GingerFast.GingerFast_cmb'
}
