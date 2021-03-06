//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieScrake_HALLOWEEN
//	Parent class:	 UM_BaseMonster_Scrake
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.10.2012 1:17
//================================================================================
class UM_ZombieScrake_HALLOWEEN extends UM_BaseMonster_Scrake;


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
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Scrake.Scrake_Challenge'
     MenuName="HALLOWEEN Scrake"
     AmbientSound=Sound'KF_BaseScrake.Chainsaw.Scrake_Chainsaw_Idle'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Scrake_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Scrake.Scrake_RedneckZombie_CMB'
     Skins(1)=Combiner'KF_Specimens_Trip_T.scrake_cmb'
     Skins(2)=TexPanner'KF_Specimens_Trip_T.scrake_saw_panner'
}
