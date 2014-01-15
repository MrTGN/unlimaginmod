//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M4203Fire
//	Parent class:	 UM_BaseAssaultRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2012 22:20
//================================================================================
class UM_M4203Fire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     bHighRateOfFire=True
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectM4Rifle'
	 //[end]
	 FireEndSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop"
     RecoilRate=0.060400
     maxVerticalRecoilAngle=180
     maxHorizontalRecoilAngle=100
     FireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_M"
     StereoFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_S"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     bWaitForRelease=False
	 FireRate=0.070500
     AmmoClass=Class'KFMod.M4203Ammo'
     // how far to rotate view
	 ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     // how fast to rotate view
     ShakeRotRate=(X=6000.000000,Y=6000.000000,Z=6000.000000)
     // how much time to rotate the instigator's view
     ShakeRotTime=0.750000
     // max view offset
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.000000)
     // how fast to offset view
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     // how much time to offset view
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_M4203Bullet'
     BotRefireRate=0.990000
     AimError=44.000000
     Spread=0.008000
     MaxSpread=0.044000
     SpreadStyle=SS_Random     
}
