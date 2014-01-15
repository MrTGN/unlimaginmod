//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class OperationY_HK417Fire extends UM_BaseBattleRifleFire;


defaultproperties
{
	 ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=-1.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'HK417_A.HK417_shot'
	 FireSoundRef="HK417_A.HK417_shot"
     //StereoFireSound=Sound'HK417_A.HK417_shot'
	 StereoFireSoundRef="HK417_A.HK417_shot"
     //NoAmmoSound=Sound'HK417_A.HK417_empty'
	 NoAmmoSoundRef="HK417_A.HK417_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectEBR'
	 //[end]
	 FireAimedAnims(0)=(Anim="Iron_Idle",Rate=1.000000)
	 FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Iron_Idle",Rate=1.000000)
     RecoilRate=0.085000
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=400
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=4.000000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.100000
     AmmoClass=Class'UnlimaginMod.OperationY_HK417Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=85.000000,Y=62.000000,Z=476.000000)
     ShakeRotRate=(X=9500.000000,Y=9400.000000,Z=9400.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=10.000000,Y=2.000000,Z=9.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.500000
	 ProjectileClass=Class'UnlimaginMod.UM_HK417Bullet'
     BotRefireRate=0.990000
     AimError=20.000000
     Spread=0.005000
	 MaxSpread=0.025000
     SpreadStyle=SS_Random
}
