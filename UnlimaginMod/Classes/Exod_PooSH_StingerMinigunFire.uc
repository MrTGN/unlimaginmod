//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Exod_PooSH_StingerMinigunFire extends UM_BaseMachineGunFire;


defaultproperties
{
     bHighRateOfFire=True
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'Stinger_Snd.Stinger.StingerPrimaryAmb'
	 FireSoundRef="Stinger_Snd.Stinger.StingerPrimaryAmb"
     //NoAmmoSound=Sound'KF_SCARSnd.SCAR_DryFire'
	 NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
	 //AmbientFireSound=Sound'Stinger_Snd.Stinger.StingerPrimaryAmb'
	 AmbientFireSoundRef="Stinger_Snd.Stinger.StingerPrimaryAmb"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="Stinger-TurretMini"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Stinger-CordFlap"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
     ProjSpawnOffsets(0)=(X=0.000000,Y=10.000000,Z=0.000000)
	 RecoilRate=0.025000
     maxVerticalRecoilAngle=250
     maxHorizontalRecoilAngle=125
     TransientSoundVolume=9.000000
     PreFireAnims(0)=(Anim="WeaponFireStart",Rate=1.000000)
     FireLoopAnims(0)=(Anim="WeaponFire",Rate=1.600000)
     FireEndAnims(0)=(Anim="WeaponFireEnd",Rate=1.000000)
     FireRate=0.050000
     AmmoClass=Class'UnlimaginMod.Exod_PooSH_StingerMinigunAmmo'
	 ProjPerFire=1
	 AmmoPerFire=1
     ShakeRotMag=(X=65.000000,Y=60.000000,Z=360.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_StingerMinigunBullet'
     BotRefireRate=0.990000
     AimError=50.000000
     Spread=0.025000
	 MaxSpread=0.098000
     SpreadStyle=SS_Random
}
