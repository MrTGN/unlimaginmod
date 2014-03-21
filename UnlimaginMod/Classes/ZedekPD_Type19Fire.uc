//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Type-19 Fire
//===================================================================================
class ZedekPD_Type19Fire extends UM_BasePDWFire;

#exec OBJ LOAD FILE=UnlimaginMod_Snd.uax

defaultproperties
{
     RoundsInBurst=3
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'Type19_S.type19_fire_m'
	 //FireSoundRef="Type19_S.type19_fire_m"
	 FireSoundRef="UnlimaginMod_Snd.Type19_AR.Type19Fire_M"
	 //FireSound=Sound'UnlimaginMod_Snd.Type19_AR.Type19Fire_M'
	 //StereoFireSoundRef="Type19_S.type19_fire_s"
	 StereoFireSoundRef="UnlimaginMod_Snd.Type19_AR.Type19Fire_S"
	 //StereoFireSound=Sound'UnlimaginMod_Snd.Type19_AR.Type19Fire_S'
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="type19_clip"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBullpup'
	 //[end]
     RecoilRate=0.070000
     maxVerticalRecoilAngle=245
     maxHorizontalRecoilAngle=90
	 bWaitForRelease=False
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.075000
     AmmoClass=Class'UnlimaginMod.ZedekPD_Type19Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=54.000000,Y=60.000000,Z=345.000000)
     ShakeRotRate=(X=6600.000000,Y=6600.000000,Z=6400.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_Type19Bullet'
     BotRefireRate=0.990000
     AimError=62.000000
     Spread=0.011000
	 MaxSpread=0.053000
     SpreadStyle=SS_Random
}
