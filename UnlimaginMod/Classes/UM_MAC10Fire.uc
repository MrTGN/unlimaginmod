//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MAC10Fire
//	Parent class:	 MAC10Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 23:22
//================================================================================
class UM_MAC10Fire extends UM_BaseSMGFire;


defaultproperties
{
     bHighRateOfFire=True
	 bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_MAC10MedGas')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_MAC10IncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_MAC10ExpBullet')
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tipS"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Mac11_Ejector"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMac'
	 //[end]
	 FireEndSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop"
     RecoilRate=0.050000
     maxVerticalRecoilAngle=150
     maxHorizontalRecoilAngle=100
     FireSoundRef="KF_MAC10MPSnd.MAC10_Silenced_Fire"
     StereoFireSoundRef="KF_MAC10MPSnd.MAC10_Silenced_FireST"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     FireRate=0.052400
     AmmoClass=Class'KFMod.MAC10Ammo'
     ShakeRotMag=(X=40.000000,Y=40.000000,Z=200.000000)
     ShakeRotRate=(X=8000.000000,Y=8000.000000,Z=8000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=4.600000,Y=2.800000,Z=5.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_MAC10Bullet'
     BotRefireRate=0.990000
     AimError=74.000000
     Spread=0.012000
	 MaxSpread=0.090000
     SpreadStyle=SS_Random
}
