//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieScrake_HALLOWEEN
//	Parent class:	 UM_ZombieScrake
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 1:17
//================================================================================
class UM_ZombieScrake_HALLOWEEN extends UM_ZombieScrake;


#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax
#exec OBJ LOAD FILE=KF_BaseScrake_HALLOWEEN.uax

defaultproperties
{
     SawAttackLoopSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Impale'
     ChainSawOffSound=SoundGroup'KF_ChainsawSnd.Chainsaw_Deselect'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Chainsaw_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmScrake_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegScrake_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadScrake_HALLOWEEN'
     DetachedSpecialArmClass=Class'KFChar.SeveredArmScrakeSaw_HALLOWEEN'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Death'
     ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Challenge'
     ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Challenge'
     ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Challenge'
     ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Challenge'
     MenuName="HALLOWEEN Scrake"
     AmbientSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Scrake_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Scrake.Scrake_RedneckZombie_CMB'
     Skins(1)=Combiner'KF_Specimens_Trip_T.scrake_cmb'
     Skins(2)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
}
