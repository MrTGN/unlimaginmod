class ZedekPD_MR96RevolverFire extends UM_BaseHandgunFire;


defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectHandCannon'
	 //[end]
	 FireSoundRef="MR96_S.mr96_fire_m"
     StereoFireSoundRef="MR96_S.mr96_fire_s"
     NoAmmoSoundRef="KF_HandcannonSnd.50AE_DryFire"
     RecoilRate=0.070000
     maxVerticalRecoilAngle=510
     maxHorizontalRecoilAngle=75
     bWaitForRelease=True
     TransientSoundVolume=2.250000
	 FireAimedAnims(0)=(Anim="Iron_Fire",Rate=1.000000)
     FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     TweenTime=0.025000
     FireRate=0.150000
     AmmoClass=Class'UnlimaginMod.ZedekPD_MR96RevolverAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=74.000000,Y=60.000000,Z=390.000000)
     ShakeRotRate=(X=12000.000000,Y=12000.000000,Z=10000.000000)
     ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.400000,Y=1.000000,Z=7.900000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
	 ProjectileClass=Class'UnlimaginMod.UM_MR96RevolverBullet'
     BotRefireRate=0.650000
     AimError=50.000000
     Spread=0.008000
	 MaxSpread=0.040000
     SpreadStyle=SS_Random
}
