//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
 //L85 Fire
//=============================================================================
class ZedekPD_XM8Fire extends UM_BaseAssaultRifleFire;

#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'XM8_Snd.xm8_fire'
	 //FireSoundRef="XM8_Snd.xm8_fire"
	 FireSoundRef="UnlimaginMod_Snd.XM8_AR.XM8_Fire_M"
	 //FireSound=Sound'UnlimaginMod_Snd.XM8_AR.XM8_Fire_M'
	 StereoFireSoundRef="UnlimaginMod_Snd.XM8_AR.XM8_Fire_S"
	 //StereoFireSound=Sound'UnlimaginMod_Snd.XM8_AR.XM8_Fire_S'
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Trigger"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=245
     maxHorizontalRecoilAngle=88
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.080000
     AmmoClass=Class'UnlimaginMod.ZedekPD_XM8Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=68.000000,Y=72.000000,Z=342.000000)
     ShakeRotRate=(X=6500.000000,Y=6500.000000,Z=6500.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.200000,Y=3.200000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_XM8Bullet'
     BotRefireRate=0.990000
     AimError=60.000000
     Spread=0.009500
	 MaxSpread=0.046000
     SpreadStyle=SS_Random
}
