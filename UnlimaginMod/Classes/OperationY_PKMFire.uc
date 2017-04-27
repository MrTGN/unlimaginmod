//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_PKMFire extends UM_BaseMachineGunFire;

defaultproperties
{
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'PKM_SN.pkm_shoot_mono'
	 FireSoundRef="PKM_SN.pkm_shoot_mono"
     //StereoFireSound=Sound'PKM_SN.pkm_shoot_stereo'
	 //StereoFireSoundRef="PKM_SN.pkm_shoot_stereo" - их stereo содержит 1 канал, т.е. тот же звук, что и mono
     //NoAmmoSound=Sound'PKM_SN.pkm_empty'
	 NoAmmoSoundRef="PKM_SN.pkm_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip_1"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.MuzzleFlash1stPKM'
	 ShellEjectBones(0)="Shell_13"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.KFShellEjectPKM'
	 //[end]
	 // Recoil
	 RecoilRate=0.080000
	 RecoilUpRot=(Min=360,Max=480)
	 RecoilLeftChance=0.48
     RecoilLeftRot=(Min=198,Max=240)
	 RecoilRightRot=(Min=206,Max=250)
	 
     bPawnRapidFireAnim=True
     TransientSoundVolume=4.400000
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.092300
     AmmoClass=Class'UnlimaginMod.OperationY_PKMAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=90.000000,Y=76.000000,Z=360.000000)
     ShakeRotRate=(X=6000.000000,Y=6000.000000,Z=5800.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=10.000000,Y=3.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_PKMBullet'
     BotRefireRate=0.990000
     AimError=85.000000
     Spread=0.020000
	 MaxSpread=0.120000
     SpreadStyle=SS_Random
}
