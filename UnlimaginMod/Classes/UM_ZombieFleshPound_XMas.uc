//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieFleshPound_XMas
//	Parent class:	 UM_BaseMonster_FleshPound
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.12.2012 22:47
//================================================================================
class UM_ZombieFleshPound_XMas extends UM_BaseMonster_FleshPound;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax

// changes colors on Device (notified in anim)
simulated function DeviceGoRed()
{
	Skins[2]=Shader'KFCharacters.FPRedBloomShader';
}

simulated function DeviceGoNormal()
{
	Skins[2] = Shader'KFCharacters.FPAmberBloomShader';
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.NutPound.NutPound_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.NutPound_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.NutPounder_T');
	//myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_XMAS_T.NutPound.nutpound_hair_fb');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmPound_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegPound_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadPound_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd.Fleshpound.FP_Challenge'
     MenuName="Christmas Flesh Pound"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Fleshpound.FP_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.NutPound'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.NutPound.NutPound_cmb'
     Skins(1)=FinalBlend'KF_Specimens_Trip_XMAS_T.NutPound.nutpound_hair_fb'
     Skins(2)=Shader'KFCharacters.FPAmberBloomShader'
}
