//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPThompsonM1928Fire
//	Parent class:	 UM_ThompsonM1928Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.07.2013 17:16
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SPThompsonM1928Fire extends UM_ThompsonM1928Fire;


defaultproperties
{
     bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_SPThompsonM1928MedGas')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_SPThompsonM1928IncBullet')
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_SPThompsonM1928ExpBullet')
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSPThompson'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMP5SMG'
	 //[end]
	 FireEndSoundRef="KF_SP_ThompsonSnd.SP_Thompson_Fire_LoopEnd_M"
     FireEndStereoSoundRef="KF_SP_ThompsonSnd.SP_Thompson_Fire_LoopEnd_S"
     AmbientFireSoundRef="KF_SP_ThompsonSnd.SP_Thompson_Fire_Loop"
	 FireSoundRef="KF_SP_ThompsonSnd.SP_Thompson_Fire_Single_M"
     StereoFireSoundRef="KF_SP_ThompsonSnd.SP_Thompson_Fire_Single_S"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 maxVerticalRecoilAngle=145
     maxHorizontalRecoilAngle=100
     AmmoClass=Class'KFMod.SPThompsonAmmo'
     ShakeRotMag=(X=50.000000,Y=58.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_SPThompsonM1928Bullet'
     AimError=78.000000
     Spread=0.011000
	 MaxSpread=0.067000
     SpreadStyle=SS_Random
}
