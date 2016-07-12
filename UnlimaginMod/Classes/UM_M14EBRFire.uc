//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M14EBRFire
//	Parent class:	 UM_BaseBattleRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.06.2013 00:26
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M14EBRFire extends UM_BaseBattleRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-1.000000,Z=0.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectEBR'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.085000
     maxVerticalRecoilAngle=1850
     maxHorizontalRecoilAngle=450
     FireSoundRef="KF_M14EBRSnd.M14EBR_Fire"
     StereoFireSoundRef="KF_M14EBRSnd.M14EBR_FireST"
     NoAmmoSoundRef="KF_M14EBRSnd.M14EBR_DryFire"
     bPawnRapidFireAnim=True
     bWaitForRelease=False
     TransientSoundVolume=2.000000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
	 FireRate=0.093750
     AmmoClass=Class'KFMod.M14EBRAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=84.000000,Y=60.000000,Z=300.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=8.000000,Y=3.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_M14EBRBullet'
     BotRefireRate=0.990000
     AimError=36.000000
     Spread=0.006000
	 MaxSpread=0.028000
     SpreadStyle=SS_Random
}
