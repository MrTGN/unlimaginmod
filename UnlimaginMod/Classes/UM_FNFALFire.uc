//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FNFALFire
//	Parent class:	 FNFALFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.07.2012 2:44
//================================================================================
class UM_FNFALFire extends UM_BaseAssaultRifleFire;



defaultproperties
{
     bHighRateOfFire=True
	 RoundsInBurst=3
	 bSetToBurst=False
	 bWaitForRelease=False
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'KFMod.KFShellEjectFAL'
	 //[end]
	 FireEndSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_FNFALSnd.FNFAL_Fire_Loop"
     RecoilRate=0.080000
     maxVerticalRecoilAngle=150
     maxHorizontalRecoilAngle=115
     FireSoundRef="KF_FNFALSnd.FNFAL_Fire_Single_M"
     StereoFireSoundRef="KF_FNFALSnd.FNFAL_Fire_Single_S"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
     FireRate=0.085700
	 //FireRate=0.088880
     AmmoClass=Class'KFMod.FNFALAmmo'
     ShakeRotMag=(X=80.000000,Y=80.000000,Z=450.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=8.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_FNFALBullet'
     BotRefireRate=0.990000
     AimError=63.000000
     Spread=0.009500
     MaxSpread=0.070000
     SpreadStyle=SS_Random
}
