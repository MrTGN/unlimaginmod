//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieGoreFast_HALLOWEEN
//	Parent class:	 UM_ZombieGoreFast
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 1:16
//================================================================================
class UM_ZombieGoreFast_HALLOWEEN extends UM_ZombieGoreFast;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmGorefast_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegGorefast_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadGorefast_HALLOWEEN'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.GoreFast.Gorefast_Challenge'
     MenuName="HALLOWEEN Gorefast"
     AmbientSound=Sound'KF_BaseGorefast_HALLOWEEN.Gorefast_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.GoreFast_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.GoreFast.gorefast_RedneckZombie_CMB'
}
