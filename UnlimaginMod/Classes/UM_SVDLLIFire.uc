//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SVDLLIFire
//	Parent class:	 UM_BaseSniperRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.06.2013 20:56
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SVDLLIFire extends UM_BaseSniperRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-3.000000,Z=0.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'SVDLLI_A.SVDLLI_Snd.SVDLLI_shot'
	 FireSoundRef="UnlimaginMod_Snd.SVD.SVD_shot_M"
	 //StereoFireSound=Sound'SVDLLI_A.SVDLLI_Snd.SVDLLI_shot'
     StereoFireSoundRef="UnlimaginMod_Snd.SVD.SVD_shot_S"
	 //NoAmmoSound=Sound'SVDLLI_A.SVDLLI_Snd.SVDLLI_empty'
	 NoAmmoSoundRef="SVDLLI_A.SVDLLI_Snd.SVDLLI_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.OperationY_MuzzleFlash1rdSVDLLI'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectSVDLLI'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.085000
     maxVerticalRecoilAngle=1920
     maxHorizontalRecoilAngle=440
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=3.600000
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     //FireForce="AssaultRifleFire"
	 FireForce="ShockRifleFire"
     FireRate=0.250000
     AmmoClass=Class'UnlimaginMod.OperationY_SVDLLIAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=90.000000,Y=74.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=10.000000,Y=2.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_SVDBullet'
     BotRefireRate=0.650000
     AimError=2.000000
     Spread=0.004000
	 MaxSpread=0.024000
     SpreadStyle=SS_Random
}
