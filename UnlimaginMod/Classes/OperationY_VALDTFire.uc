class OperationY_VALDTFire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'VALDT_v2_A.VSS_Fire'
	 FireSoundRef="VALDT_v2_A.VSS_Fire"
	 //StereoFireSound=Sound'VALDT_v2_A.VSS_Fire'
	 NoAmmoSoundRef="KF_AK47Snd.AK47_DryFire"
	 //[end]
	 //[block] Fire Effects
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.OperationY_MuzzleFlash3rdVALDT'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectMac'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire",Rate=1.000000)
	 // Recoil
	 RecoilRate=0.066
	 RecoilUpRot=(Min=198,Max=250)
	 RecoilLeftChance=0.49
     RecoilLeftRot=(Min=82,Max=132)
	 RecoilRightRot=(Min=86,Max=140)
	 
	 bPawnRapidFireAnim=True
     TransientSoundVolume=2.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.071000
     AmmoClass=Class'UnlimaginMod.OperationY_VALDTAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=73.000000,Y=61.000000,Z=354.000000)
     ShakeRotRate=(X=6200.000000,Y=6200.000000,Z=6200.000000)
     ShakeRotTime=0.750000
     ShakeOffsetMag=(X=7.300000,Y=3.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
	 ProjectileClass=Class'UnlimaginMod.UM_VALDTBullet'
     BotRefireRate=0.990000
     AimError=70.000000
     Spread=0.007000
	 MaxSpread=0.045000
     SpreadStyle=SS_Random
}
