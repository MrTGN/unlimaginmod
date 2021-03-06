//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_SPSniperRifleFire
//	Parent class:	 UM_BaseSniperRifleFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 18.08.2013 14:08
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_SPSniperRifleFire extends UM_BaseSniperRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=-1.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSPSniper'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectEBR'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 // Recoil
	 RecoilRate=0.12
	 RecoilUpRot=(Min=142,Max=480)
	 RecoilLeftChance=0.48
     RecoilLeftRot=(Min=210,Max=260)
	 RecoilRightRot=(Min=220,Max=280)

     FireSoundRef="KF_SP_LongmusketSnd.KFO_Sniper_Fire_M"
     StereoFireSoundRef="KF_SP_LongmusketSnd.KFO_Sniper_Fire_S"
     NoAmmoSoundRef="KF_M14EBRSnd.M14EBR_DryFire"
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.940000
     AmmoClass=Class'KFMod.SPSniperAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_SPSniperRifleBullet'
     BotRefireRate=0.990000
     AimError=24.000000
     Spread=0.005000
	 MaxSpread=0.025000
     SpreadStyle=SS_Random
}
