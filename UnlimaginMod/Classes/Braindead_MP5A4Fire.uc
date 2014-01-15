//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// MP5MFire
//=============================================================================
// MP5 Medic Gun primary fire class
//=============================================================================
// Killing Floor Source
// Copyright (C) 2011 Tripwire Interactive LLC
// - John "Ramm-Jaeger" Gibson
//=============================================================================
class Braindead_MP5A4Fire extends UM_BaseSMGFire;

defaultproperties
{
     bHighRateOfFire=True
	 //[block] Dynamic Loading Vars
	 //FireEndSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop_End_M'
	 FireEndSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop_End_M"
     //FireEndStereoSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop_End_S'
	 FireEndStereoSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop_End_S"
	 //AmbientFireSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop'
	 AmbientFireSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop"
	 //FireSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_M'
	 FireSoundRef="KF_MP5Snd.Fire.MP5_Fire_M"
	 //StereoFireSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_S'
	 StereoFireSoundRef="KF_MP5Snd.Fire.MP5_Fire_S"
     //NoAmmoSound=Sound'KF_MP7Snd.MP7_DryFire'
	 NoAmmoSoundRef="KF_MP7Snd.MP7_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stMP'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMP5SMG'
	 //[end]
	 TransientSoundVolume=2.000000
	 bWaitForRelease=False
	 RecoilRate=0.060000
     maxVerticalRecoilAngle=124
     maxHorizontalRecoilAngle=80
     RecoilVelocityScale=0.000000
     FireRate=0.075000
	 AmmoClass=Class'UnlimaginMod.Braindead_MP5A4Ammo'
	 ShakeRotMag=(X=25.000000,Y=25.000000,Z=125.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=4.000000,Y=2.500000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_MP5A4Bullet'
     AimError=40.000000
	 Spread=0.011000
	 MaxSpread=0.050000
     SpreadStyle=SS_Random
     AmbientFireSoundRadius=500.000000
     AmbientFireVolume=255
}
