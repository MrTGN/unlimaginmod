//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Braindead_HuntingRifleFire
//===================================================================================
class Braindead_HuntingRifleFire extends UM_BaseSniperRifleFire;


defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 //[end]
	 // X - pointing from the observer to the screen (length)
	 // Y - horizontal axis (width)
	 // Z - vertical axis (height)
	 ProjSpawnOffsets(0)=(X=5.000000,Y=0.000000,Z=-2.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'HuntingRifle_Snd.awp1_mono'
	 FireSoundRef="HuntingRifle_Snd.awp1_mono"
	 //FireSoundRef="UnlimaginMod_Snd.Remington700Rifle.shot_338_lapua_M"
	 //StereoFireSound=Sound'HuntingRifle_Snd.awp1_stereo'
	 StereoFireSoundRef="HuntingRifle_Snd.awp1_stereo"
	 //StereoFireSoundRef="UnlimaginMod_Snd.Remington700Rifle.shot_338_lapua_S"
     //NoAmmoSound=Sound'KF_RifleSnd.Rifle_DryFire'
	 NoAmmoSoundRef="KF_RifleSnd.Rifle_DryFire"
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.100000
     maxVerticalRecoilAngle=810
     maxHorizontalRecoilAngle=250
     bWaitForRelease=True
	 bPawnRapidFireAnim=True
     TransientSoundVolume=2.100000
     FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     FireForce="ShockRifleFire"
     FireRate=1.900000
     AmmoClass=Class'UnlimaginMod.Braindead_HuntingRifleAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=100.000000,Y=95.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_HuntingRifleBullet'
     BotRefireRate=0.650000
     AimError=12.000000
     Spread=0.006000
	 MaxSpread=0.016000
	 SpreadStyle=SS_Random
}
