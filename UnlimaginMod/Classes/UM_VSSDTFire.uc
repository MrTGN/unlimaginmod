//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_VSSDTFire
//	Parent class:	 UM_BaseAutomaticSniperRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.03.2013 20:26
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_VSSDTFire extends UM_BaseAutomaticSniperRifleFire;


defaultproperties
{
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'VSSDT_v2_A.VSS_Fire'
	 FireSoundRef="VSSDT_v2_A.VSS_Fire"
     //NoAmmoSound=Sound'KF_RifleSnd.Rifle_DryFire'
	 NoAmmoSoundRef="KF_RifleSnd.Rifle_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMac'
	 //[end]
	 FireAimedAnims(0)=(Anim="Iron_Idle",Rate=1.000000) // "Fire_Iron"
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Iron_Idle",Rate=1.000000)
	 RecoilRate=0.070000
     maxVerticalRecoilAngle=475
     maxHorizontalRecoilAngle=145
	 bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=4.000000
     FireForce="ShockRifleFire"
     FireRate=0.075000
	 //FireRate=0.080000
     AmmoClass=Class'UnlimaginMod.OperationY_VSSDTAmmo'
	 AmmoPerFire=1
     ShakeRotMag=(X=72.000000,Y=60.000000,Z=470.000000)
     ShakeRotRate=(X=9800.000000,Y=9800.000000,Z=9800.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=7.200000,Y=2.800000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.500000
	 ProjectileClass=Class'UnlimaginMod.UM_VSSDTBullet'
     BotRefireRate=0.650000
     AimError=15.000000
     Spread=0.005000
	 MaxSpread=0.030000
	 SpreadStyle=SS_Random
}
