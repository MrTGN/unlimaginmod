//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieBloat_XMas
//	Parent class:	 UM_ZombieBloat
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.12.2012 22:10
//================================================================================
class UM_ZombieBloat_XMas extends UM_ZombieBloat;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax

function PlayDyingSound()
{
	if ( Level.NetMode!=NM_Client )
	{
		if ( bGibbed )
		{
			PlaySound(sound'KF_EnemiesFinalSnd_Xmas.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
			return;
		}

		if ( bDecapitated )
		{
			PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,true,525);
		}
		else
		{
			PlaySound(sound'KF_EnemiesFinalSnd_Xmas.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
		}
	}
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.BloatSanta.BloatSanta_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.BloatSanta_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.Bloat_Santa');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmBloat_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegBloat_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadBloat_XMas'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd_Xmas.Bloat.Bloat_Challenge'
     MenuName="Christmas Bloat"
     AmbientSound=Sound'KF_BaseBloat_xmas.Bloat_Idle1Loop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.BloatSanta'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.BloatSanta.BloatSanta_cmb'
}
