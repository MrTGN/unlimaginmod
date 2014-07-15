//=============================================================================
// UnlimaginMod - Maria_Cz75LaserFire
// Copyright (C) 2012
// - Maria
//=============================================================================
class Maria_Cz75LaserFire extends UM_BaseHandgunFire;

var		float		AimErrorWithLaser, AimErrorWithOutLaser;

defaultproperties
{
     ProjSpawnOffsets(0)=(X=1.000000,Y=-14.000000,Z=9.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=SoundGroup'KF_9MMSnd.9mm_Fire'
	 FireSoundRef="KF_9MMSnd.9mm_Fire"
	 StereoFireSoundRef="KF_9MMSnd.9mm_FireST"
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stMP'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEject9mm'
	 //[end]
     FireAnims(0)=(Anim="Fire",Rate=1.500000)
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.500000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=400
     maxHorizontalRecoilAngle=52
     bRandomPitchFireSound=True
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=1.850000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.175000
     AmmoClass=Class'UnlimaginMod.Maria_Cz75LaserAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=64.000000,Y=55.000000,Z=262.000000)
     ShakeRotRate=(X=10500.000000,Y=10500.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_Cz75LaserBullet'
     BotRefireRate=0.350000
     AimErrorWithLaser=25.000000
	 AimErrorWithOutLaser=50.000000
	 AimError=50.000000
     Spread=0.011000
	 MaxSpread=0.046000
     SpreadStyle=SS_Random
}
