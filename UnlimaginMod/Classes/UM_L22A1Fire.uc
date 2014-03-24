//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_L22A1Fire
//	Parent class:	 UM_BaseAssaultRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.06.2013 03:38
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_L22A1Fire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-2.000000,Z=-1.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=SoundGroup'KF_BullpupSnd.Bullpup_Fire'
	 FireSoundRef="KF_BullpupSnd.Bullpup_Fire"
	 StereoFireSoundRef="KF_BullpupSnd.Bullpup_FireST"
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Bullpup"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=240
     maxHorizontalRecoilAngle=80
     bPawnRapidFireAnim=True
	 bWaitForRelease=False
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.092300
     AmmoClass=Class'KFMod.BullpupAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=65.000000,Y=70.000000,Z=340.000000)
     ShakeRotRate=(X=7000.000000,Y=7000.000000,Z=7000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_L22A1Bullet'
     BotRefireRate=0.990000
     AimError=62.000000
     Spread=0.010000
	 MaxSpread=0.060000
     SpreadStyle=SS_Random
}
