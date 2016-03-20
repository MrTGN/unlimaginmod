//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieSiren_XMas
//	Parent class:	 UM_BaseMonster_Siren
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.12.2012 23:48
//================================================================================
class UM_ZombieSiren_XMas extends UM_BaseMonster_Siren;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.caroler_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.caroler_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.caroler_diffuse');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd.siren.Siren_Talk'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.siren.Siren_Jump'
     DetachedHeadClass=Class'KFChar.SeveredHeadSiren_XMas'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.siren.Siren_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.siren.Siren_Death'
     MenuName="Christmas Siren"
     AmbientSound=Sound'KF_BaseSiren.Siren_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.Caroler'
     Skins(0)=FinalBlend'KF_Specimens_Trip_T.siren_hair_fb'
     Skins(1)=Shader'KF_Specimens_Trip_XMAS_T.Caroler.caroler_shdr'
}
