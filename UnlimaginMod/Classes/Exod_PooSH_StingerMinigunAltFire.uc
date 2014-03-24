//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Exod_PooSH_StingerMinigunAltFire extends UM_BaseMachineGunFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'Stinger_Snd.Stinger.StingerAltStop'
	 FireSoundRef="Stinger_Snd.Stinger.StingerShot"
     //NoAmmoSound=Sound'KF_SCARSnd.SCAR_DryFire'
	 NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
	 //[end]
	 //[block] Fire Effects
	 //bAttachFlashEmitter=False
	 //bAttachSmokeEmitter=False
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="Stinger-TurretMini"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Stinger-CordFlap"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=10.000000,Z=0.000000)
	 RecoilRate=0.275000
     maxVerticalRecoilAngle=540
     maxHorizontalRecoilAngle=260
     TransientSoundVolume=12.000000
     FireAnims(0)=(Anim="WeaponRampUp",Rate=2.000000)
	 FireEndAnims(0)=(Anim="WeaponFireEnd",Rate=1.000000)
     //FireLoopAnims(0)="WeaponRampUp"
     //FireLoopAnimRate=2.000000
     FireRate=0.366667
     AmmoClass=Class'UnlimaginMod.Exod_PooSH_StingerMinigunAmmo'
     ProjPerFire=1
	 AmmoPerFire=3
     ShakeRotMag=(X=75.000000,Y=60.000000,Z=360.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_StingerMinigunBullet'
     BotRefireRate=0.990000
     AimError=85.000000
	 DamageAtten=1.000000
     Spread=500.000000
	 MaxSpread=600.000000
     SpreadStyle=SS_Random
}
