//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieBloat_HALLOWEEN
//	Parent class:	 UM_ZombieBloat
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 24.10.2012 1:12
//================================================================================
class UM_ZombieBloat_HALLOWEEN extends UM_ZombieBloat;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

function PlayDyingSound()
{
	if ( Level.NetMode != NM_Client )  {
		if ( bGibbed )  {
			PlaySound(sound'KF_EnemiesFinalSnd_HALLOWEEN.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
			Return;
		}

		if ( bDecapitated )
			PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,true,525);
		else
			PlaySound(sound'KF_EnemiesFinalSnd_HALLOWEEN.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
	}
}

defaultproperties
{
     BileExplosion=Class'KFMod.BileExplosion_Halloween'
     BileExplosionHeadless=Class'KFMod.BileExplosionHeadless_Halloween'
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmBloat_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegBloat_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadBloat_HALLOWEEN'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_Challenge'
     MenuName="HALLOWEEN Bloat"
     AmbientSound=Sound'KF_BaseBloat_HALLOWEEN.Bloat_Idle1Loop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Bloat_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Bloat.Bloat_RedneckZombie_CMB'
}
