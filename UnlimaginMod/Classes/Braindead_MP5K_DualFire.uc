//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//=============================================================================
// Braindead_MP5K_Dual Fire
//=============================================================================
class Braindead_MP5K_DualFire extends UM_BaseSMGFire;

simulated function ChangeMuzzleNum()
{
	if ( MuzzleNum > 0 )
		SetMuzzleNum(0);
	else
		SetMuzzleNum(1);
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'KF_MAC10MPSnd.FireBase.MAC10_fire01'
	 FireSoundRef="KF_MAC10MPSnd.FireBase.MAC10_fire01"
	 //StereoFireSound=Sound'KF_MAC10MPSnd.FireBase.MAC10_fireST01'
	 StereoFireSoundRef="KF_MAC10MPSnd.FireBase.MAC10_fireST01"
     //NoAmmoSound=Sound'KF_9MMSnd.9mm_DryFire'
	 NoAmmoSoundRef="KF_9MMSnd.9mm_DryFire"
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=18.000000,Z=0.000000,AimY=14.000000)
	 ProjSpawnOffsets(1)=(X=0.000000,Y=-18.000000,Z=0.000000,AimY=-14.000000)
	 FireAnims(0)=(Anim="FireRight",Rate=1.000000)
	 FireAnims(1)=(Anim="FireLeft",Rate=1.000000)
     FireAimedAnims(0)=(Anim="FireRight_Iron",Rate=1.000000)
	 FireAimedAnims(1)=(Anim="FireLeft_Iron",Rate=1.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="Tip_Right"
	 MuzzleBones(1)="Tip_Left"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 SmokeEmitterClasses(1)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(1)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject_right"
	 ShellEjectBones(1)="Shell_eject_left"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEject9mm'
	 ShellEjectEmitterClasses(1)=Class'ROEffects.KFShellEject9mm'
	 //[end]
	 // Recoil
	 RecoilRate=0.060000
	 RecoilUpRot=(Min=132,Max=176)
	 RecoilLeftChance=0.5
     RecoilLeftRot=(Min=52,Max=80)
	 RecoilRightRot=(Min=52,Max=80)
	 
     bRandomPitchFireSound=False
     bPawnRapidFireAnim=True
     TransientSoundVolume=2.000000
     FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.070000
     AmmoClass=Class'UnlimaginMod.Braindead_MP5KAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=60.000000,Y=70.000000,Z=250.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=9.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_MP5KBullet'
     BotRefireRate=0.250000
     AimError=80.000000
     Spread=0.011000
	 MaxSpread=0.078000
     SpreadStyle=SS_Random
}
