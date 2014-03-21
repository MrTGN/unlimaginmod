//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM4A1Fire
//	Parent class:	 UM_BaseSMGFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 23.05.2013 23:06
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ThompsonM4A1Fire extends UM_BaseSMGFire;



defaultproperties
{
     bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_ThompsonM4A1MedGas')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_ThompsonM4A1IncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_ThompsonM4A1ExpBullet')
	 bHighRateOfFire=True
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'KFMod.IJCShellEjectThompson'
	 //[end]
	 FireEndSoundRef="KF_IJC_HalloweenSnd.ThompsonSMG_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_IJC_HalloweenSnd.ThompsonSMG_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_IJC_HalloweenSnd.ThompsonSMG_Fire_Loop"
     RecoilRate=0.080000
     maxVerticalRecoilAngle=158
     maxHorizontalRecoilAngle=110
     FireSoundRef="KF_IJC_HalloweenSnd.Thompson_Fire_Single_M"
     StereoFireSoundRef="KF_IJC_HalloweenSnd.Thompson_Fire_Single_S"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
     FireRate=0.085700
     AmmoClass=Class'KFMod.ThompsonAmmo'
     ShakeRotMag=(X=56.000000,Y=60.000000,Z=352.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.200000,Y=3.000000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_ThompsonM4A1Bullet'
     BotRefireRate=0.150000
     AimError=76.000000
     Spread=0.012000
	 MaxSpread=0.060000
     SpreadStyle=SS_Random
}
