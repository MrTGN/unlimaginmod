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
class Braindead_MP5SDFire extends UM_BaseSMGFire;

defaultproperties
{
     bHighRateOfFire=True
	 RoundsInBurst=3
	 //[block] Dynamic Loading Vars
	 //FireEndSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop_End_M'
     //FireEndStereoSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop_End_S'
     //AmbientFireSound=SoundGroup'KF_MP5Snd.Fire.MP5_Fire_Loop'
	 //FireEndSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop_End_M"
	 //FireEndStereoSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop_End_S"
	 //AmbientFireSoundRef="KF_MP5Snd.Fire.MP5_Fire_Loop"
     FireEndSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_MAC10MPSnd.MAC10_Fire_Loop"
	 //FireSound=Sound'BD_MP5SD_S.FireBase.MP5_Silenced_fire01'
	 FireSoundRef="BD_MP5SD_S.FireBase.MP5_Silenced_fire01"
	 //StereoFireSound=Sound'BD_MP5SD_S.FireBase.MP5_Silenced_fireST01'
	 StereoFireSoundRef="BD_MP5SD_S.FireBase.MP5_Silenced_fireST01"
     //NoAmmoSound=Sound'KF_MP7Snd.MP7_DryFire'
	 NoAmmoSoundRef="KF_MP7Snd.MP7_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.Braindead_MP5_1st_MuzzleFlash'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMP5SMG'
	 //[end]
     //[block] Fire Anims
	 FireEndAimedAnims(0)=(Anim="Fire_Iron_End",Rate=1.000000)
     FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 //[end]
     bWaitForRelease=False
	 RecoilRate=0.060000
     maxVerticalRecoilAngle=124
     maxHorizontalRecoilAngle=75
     RecoilVelocityScale=0.000000
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.820000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.075000
     AmmoClass=Class'UnlimaginMod.Braindead_MP5SDAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=25.000000,Y=25.000000,Z=125.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=4.000000,Y=2.500000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_MP5SDBullet'
     BotRefireRate=0.100000
     AimError=68.000000
     Spread=0.009000
	 MaxSpread=0.065000
     SpreadStyle=SS_Random
}
