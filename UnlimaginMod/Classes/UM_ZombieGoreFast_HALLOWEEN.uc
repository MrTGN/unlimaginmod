//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieGoreFast_HALLOWEEN
//	Parent class:	 UM_BaseMonster_GoreFast
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.10.2012 1:16
//================================================================================
class UM_ZombieGoreFast_HALLOWEEN extends UM_BaseMonster_GoreFast;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmGorefast_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegGorefast_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadGorefast_HALLOWEEN'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Challenge'
     MenuName="HALLOWEEN Gorefast"
     AmbientSound=Sound'KF_BaseGorefast_HALLOWEEN.Gorefast_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.GoreFast_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.GoreFast.gorefast_RedneckZombie_CMB'
}
