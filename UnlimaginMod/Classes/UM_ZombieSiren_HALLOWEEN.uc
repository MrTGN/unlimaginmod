//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieSiren_HALLOWEEN
//	Parent class:	 UM_BaseMonster_Siren
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 1:18
//================================================================================
class UM_ZombieSiren_HALLOWEEN extends UM_BaseMonster_Siren;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.siren.Siren_Talk'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.siren.Siren_Jump'
     DetachedArmClass=None
     DetachedLegClass=Class'KFChar.SeveredLegSiren_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadSiren_HALLOWEEN'
     HitSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.siren.Siren_Pain'
     DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.siren.Siren_Death'
     MenuName="HALLOWEEN Siren"
     AmbientSound=Sound'KF_BaseSiren_HALLOWEEN.Siren_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Siren_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.siren.Siren_RedneckZombie_CMB'
     Skins(1)=FinalBlend'KF_Specimens_Trip_HALLOWEEN_T.siren.Siren_RedneckZombie_Hair_FB'
}
