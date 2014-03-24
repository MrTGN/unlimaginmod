//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M4Fire
//	Parent class:	 UM_BaseAssaultRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 23.05.2013 22:07
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M4Fire extends UM_BaseAssaultRifleFire;



defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-1.000000,Z=-2.000000)
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
     RecoilRate=0.064500
     maxVerticalRecoilAngle=204
     maxHorizontalRecoilAngle=105
     FireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_M"
     StereoFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_S"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     FireRate=0.070500
     AmmoClass=Class'KFMod.M4Ammo'
     ShakeRotMag=(X=52.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=6400.000000,Y=6400.000000,Z=6400.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_M4Bullet'
     BotRefireRate=0.990000
     AimError=65.000000
     Spread=0.008500
	 MaxSpread=0.051000
     SpreadStyle=SS_Random
}
