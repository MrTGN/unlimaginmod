//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_AK47Fire
//	Parent class:	 UM_BaseAssaultRifleFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 30.05.2013 22:57
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_AK47Fire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectAK'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     // Recoil
	 RecoilRate=0.080000
	 RecoilUpRot=(Min=425,Max=550)
	 RecoilLeftChance=0.0
     RecoilRightRot=(Min=190,Max=260)
	 
     FireSoundRef="KF_AK47Snd.AK47_Fire"
     StereoFireSoundRef="KF_AK47Snd.AK47_FireST"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     AmmoClass=Class'KFMod.AK47Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=76.000000,Y=74.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=7.600000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_AK47Bullet'
     BotRefireRate=0.990000
     AimError=92.000000
     Spread=0.014000
	 MaxSpread=0.096000
     SpreadStyle=SS_Random
}
