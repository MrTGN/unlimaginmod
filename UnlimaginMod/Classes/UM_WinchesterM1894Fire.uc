//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_WinchesterM1894Fire
//	Parent class:	 UM_BaseSniperRifleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 19:03
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_WinchesterM1894Fire extends UM_BaseSniperRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-2.000000,Z=1.000000)
	 //[block] Dynamic Loading Vars
	 StereoFireSoundRef="KF_RifleSnd.Rifle_FireST"
	 //FireSound=SoundGroup'KF_RifleSnd.Rifle_Fire'
	 FireSoundRef="KF_RifleSnd.Rifle_Fire"
     //NoAmmoSound=Sound'KF_RifleSnd.Rifle_DryFire'
	 NoAmmoSoundRef="KF_RifleSnd.Rifle_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectEBR'
	 //[end]
	 FireAimedAnims(0)=(Anim="AimFire",Rate=1.000000)
     RecoilRate=0.100000
     maxVerticalRecoilAngle=800
     maxHorizontalRecoilAngle=250
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     FireForce="ShockRifleFire"
     FireRate=0.900000
     AmmoClass=Class'KFMod.WinchesterAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=100.000000,Y=100.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_WinchesterM1894Bullet'
     BotRefireRate=0.650000
     AimError=60.000000
     Spread=0.007000
	 MaxSpread=0.026000
}
