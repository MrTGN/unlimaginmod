//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieFleshPound_HALLOWEEN
//	Parent class:	 UM_BaseMonster_FleshPound
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.10.2012 1:15
//================================================================================
class UM_ZombieFleshPound_HALLOWEEN extends UM_BaseMonster_FleshPound;


#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax
#exec OBJ LOAD FILE=KF_Specimens_Trip_HALLOWEEN_T.utx

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmPound_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegPound_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadPound_HALLOWEEN'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Fleshpound.FP_Challenge'
     MenuName="HALLOWEEN Flesh Pound"
     AmbientSound=Sound'KF_BaseFleshpound_HALLOWEEN.FP_Idle1Loop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.FleshPound_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Fleshpound.Fleshpound_RedneckZombie_CMB'
}
