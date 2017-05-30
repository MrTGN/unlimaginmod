//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieClot_XMas
//	Parent class:	 UM_BaseMonster_Clot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.12.2012 22:34
//================================================================================
class UM_ZombieClot_XMas extends UM_BaseMonster_Clot;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax
#exec OBJ LOAD FILE=KF_Specimens_Trip_XMAS_T.utx

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.Clot_Elf.Clot_Elf_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.clot_elf_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.clot_elf_diff');
	//myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.clot_spec');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmClot_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegClot_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadClot_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_Challenge'
     MenuName="Christmas Clot"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.clot.Clot_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.Clot_Elf'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.Clot_Elf.Clot_Elf_cmb'
}
