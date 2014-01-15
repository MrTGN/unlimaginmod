//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_V94Fire extends UM_BaseSniperRifleFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'B94_SN.b94_shoot_mono'
	 FireSoundRef="B94_SN.b94_shoot_mono"
	 //StereoFireSound=Sound'B94_SN.b94_shoot_stereo'
	 StereoFireSoundRef="B94_SN.b94_shoot_stereo"
     //NoAmmoSound=Sound'B94_SN.empty'
	 NoAmmoSoundRef="B94_SN.empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.OperationY_V94_1st_MuzzleFlash'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectM82A1LLI'
	 //[end]
	 EffectiveRange=25000.000000
     RecoilRate=0.100000
     maxVerticalRecoilAngle=3650
     maxHorizontalRecoilAngle=100
     FireAimedAnims(0)=(Anim="Fire",Rate=1.000000)
     ProjPerFire=1
     ProjSpawnOffsets(0)=(X=2.000000,Y=0.000000,Z=0.000000)
     bPawnRapidFireAnim=True
	 bWaitForRelease=True
     TransientSoundVolume=3.400000
     FireLoopAnims(0)=(Anim="")
     FireForce="ShockRifleFire"
     FireRate=0.600000
     AmmoClass=Class'UnlimaginMod.OperationY_V94Ammo'
     ShakeRotMag=(X=120.000000,Y=110.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=12.000000,Y=3.000000,Z=12.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
	 ShakeOffsetTime=2.000000
	 bNoKickMomentum=False
	 bOnlyLowGravKickMomentum=False
	 KickMomentum=(X=-110.000000,Z=20.000000)
	 LowGravKickMomentumScale=7.000000
	 ProjectileClass=Class'UnlimaginMod.UM_V94Bullet'
     BotRefireRate=3.750000
     AimError=0.000000
     Spread=0.001000
	 MaxSpread=0.010000
}
