//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// L85A2 Fire
//===================================================================================
class JSullivan_L85A2Fire extends UM_BaseAssaultRifleFire;

defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=-2.000000)
	 //[block] Dynamic Loading Vars
	 //FireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_M"
	 FireSoundRef="KF_BullpupSnd.Bullpup_Fire"
     //StereoFireSoundRef="KF_M4RifleSnd.M4Rifle_Fire_Single_S"
	 StereoFireSoundRef="KF_BullpupSnd.Bullpup_FireST"
     NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 //[end]
	 //[block] Fire Effects
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     RecoilRate=0.070000
     maxVerticalRecoilAngle=252
     maxHorizontalRecoilAngle=50
     bPawnRapidFireAnim=True
     bWaitForRelease=False
     TransientSoundVolume=1.750000
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.092300
     AmmoClass=Class'UnlimaginMod.JSullivan_L85A2Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=65.000000,Y=62.000000,Z=350.000000)
     ShakeRotRate=(X=6200.000000,Y=6200.000000,Z=6200.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.800000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_L85A2Bullet'
     BotRefireRate=0.350000
     AimError=60.000000
     Spread=0.009000
	 MaxSpread=0.045000
     SpreadStyle=SS_Random
}
