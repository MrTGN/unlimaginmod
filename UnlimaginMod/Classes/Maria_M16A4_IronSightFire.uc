//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// UnlimaginMod - Maria_M16A4_IronSightFire
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_IronSightFire extends UM_BaseAssaultRifleFire;

defaultproperties
{
     bHighRateOfFire=True
	 //[block] Dynamic Loading Vars
	 FireEndSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop_End_M"
     FireEndStereoSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop_End_S"
     AmbientFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Loop"
	 //FireSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_M'
	 //StereoFireSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_S'
     //NoAmmoSound=Sound'KF_AK47Snd.AK47_DryFire'
	 FireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_M"
     StereoFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_S"
	 NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 //[end]
	 //[block] Fire Anims
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron_Loop",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire_Loop",Rate=1.000000)
	 FireEndAimedAnims(0)=(Anim="Fire_Iron_End",Rate=1.000000)
	 FireEndAnims(0)=(Anim="Fire_End",Rate=1.000000)
	 //[end]
	 //[block] Fire Effects
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectM4Rifle'
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-3.000000,Z=-1.000000)
     // Recoil
	 RecoilRate=0.065
	 RecoilUpRot=(Min=142,Max=192)
	 RecoilLeftChance=0.49
     RecoilLeftRot=(Min=68,Max=92)
	 RecoilRightRot=(Min=70,Max=104)

	 
     FireRate=0.075000
     AmmoClass=Class'UnlimaginMod.Maria_M16A4Ammo'
     ShakeRotMag=(X=52.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_M16A4_IronSightBullet'
     BotRefireRate=0.990000
     AimError=76.000000
     Spread=0.008500
	 MaxSpread=0.060000
     SpreadStyle=SS_Random
}
