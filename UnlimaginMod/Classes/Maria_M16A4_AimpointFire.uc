//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// UnlimaginMod - Maria_M16A4_AimpointFire
// Copyright (C) 2012
// - Maria
//===================================================================================
class Maria_M16A4_AimpointFire extends UM_BaseAssaultRifleFire;

defaultproperties
{
     bSetToBurst=True
     RoundsInBurst=3
	 //[block] Dynamic Loading Vars
	 //FireEndSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop_End_M'
	 FireEndSoundRef="KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop_End_M"
     //FireEndStereoSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop_End_S'
	 FireEndStereoSoundRef="KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop_End_S"
     //AmbientFireSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop'
	 AmbientFireSoundRef="KF_M4RifleSnd.Fire.M4Rifle_Fire_Loop"
	 //FireSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_M'
	 FireSoundRef="KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_M"
	 //StereoFireSound=SoundGroup'KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_S'
	 StereoFireSoundRef="KF_M4RifleSnd.Fire.M4Rifle_Fire_Single_S"
     //NoAmmoSound=Sound'KF_AK47Snd.AK47_DryFire'
	 NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-3.000000,Z=-2.000000)
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
	 // Recoil
	 RecoilRate=0.065
	 RecoilUpRot=(Min=142,Max=192)
	 RecoilLeftChance=0.48
     RecoilLeftRot=(Min=68,Max=94)
	 RecoilRightRot=(Min=70,Max=102)
	 
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
	 bWaitForRelease=True
     FireRate=0.075000
     AmmoClass=Class'UnlimaginMod.Maria_M16A4Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=350.000000)
     ShakeRotRate=(X=5000.000000,Y=5000.000000,Z=5000.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_M16A4_AimpointBullet'
     BotRefireRate=0.990000
     AimError=64.000000
     Spread=0.008500
	 MaxSpread=0.060000
     SpreadStyle=SS_Random
}
