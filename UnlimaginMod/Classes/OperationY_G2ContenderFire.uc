//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_G2ContenderFire extends UM_BaseHandgunFire;

simulated function bool AllowFire()
{
	Return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'Thompson_G2_A.G2_Shot'
	 //StereoFireSound=Sound'Thompson_G2_A.G2_Shot'
	 //FireSoundRef="Thompson_G2_A.G2_Shot"
	 FireSoundRef="Thompson_G2_A.Fire"
	 //NoAmmoSound=Sound'KF_SCARSnd.SCAR_DryFire'
	 NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 //[end]
	 EffectiveRange=50000.000000
     RecoilRate=0.100000
     maxVerticalRecoilAngle=1280
     maxHorizontalRecoilAngle=100
     FireAimedAnims(0)=(Anim="Fire",Rate=1.000000)
     ProjPerFire=1
     ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=3.800000
     FireForce="AssaultRifleFire"
     FireRate=1.60000
     AmmoClass=Class'UnlimaginMod.OperationY_G2ContenderAmmo'
     ShakeRotMag=(X=75.000000,Y=50.000000,Z=405.000000)
     ShakeRotRate=(X=12000.000000,Y=12000.000000,Z=10000.000000)
	 ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.000000,Y=1.800000,Z=8.000000)
	 ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
     ProjectileClass=Class'UnlimaginMod.OperationY_G2ContenderBullet'
     BotRefireRate=3.570000
     AimError=30.000000
     Spread=0.006000
	 MaxSpread=0.036000
}
