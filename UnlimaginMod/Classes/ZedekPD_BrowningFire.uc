//=============================================================================
// ZedekPD_BrowningFire Fire
//=============================================================================
class ZedekPD_BrowningFire extends UM_BaseHandgunFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-4.000000,Z=1.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="slidetop"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectHandCannon'
	 //[end]
	 EmptyFireAnims(0)=(Anim="Fire_Empty",Rate=1.000000)
     EmptyFireAimedAnims(0)=(Anim="Fire_Iron_empty",Rate=1.000000)
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 // Recoil
	 RecoilRate=0.1
	 RecoilUpRot=(Min=220,Max=280)
	 RecoilLeftChance=0.49
     RecoilLeftRot=(Min=36,Max=80)
	 RecoilRightRot=(Min=38,Max=80)

     FireSoundRef="Browning_S.shoot_m"
     StereoFireSoundRef="Browning_S.shoot_s"
	 NoAmmoSoundRef="KF_HandcannonSnd.50AE_DryFire"
	 bRandomPitchFireSound=True
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=1.900000
     FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     TweenTime=0.025000
     FireRate=0.190000
     AmmoClass=Class'UnlimaginMod.ZedekPD_BrowningAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=70.000000,Y=60.000000,Z=340.000000)
     ShakeRotRate=(X=11500.000000,Y=11500.000000,Z=10000.000000)
     ShakeRotTime=3.500000
     ShakeOffsetMag=(X=6.000000,Y=2.800000,Z=7.800000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.500000
	 ProjectileClass=Class'UnlimaginMod.UM_BrowningPistolBullet'
     BotRefireRate=0.650000
     AimError=54.000000
     Spread=0.010000
	 MaxSpread=0.050000
     SpreadStyle=SS_Random
}
