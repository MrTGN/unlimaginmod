class OperationY_M82A1LLIFire extends UM_BaseSniperRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-2.000000,Z=0.000000)
	 bNoKickMomentum=False
	 bOnlyLowGravKickMomentum=False
	 KickMomentum=(X=-96.000000,Z=14.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_shot'
	 FireSoundRef="M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_shot"
	 //StereoFireSound=Sound'M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_shot'
	 StereoFireSoundRef="M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_shot"
     //NoAmmoSound=Sound'M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_empty'
	 NoAmmoSoundRef="M82A1LLI_A.M82A1LLI_Snd.M82A1LLI_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip_LLIePLLIeHb"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'UnlimaginMod.OperationY_MuzzleFlash1stM82A1LLI'
	 ShellEjectBones(0)="SE_LLIePLLIeHb"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectM82A1LLI'
	 //[end]
	 EffectiveRange=25000.000000
     RecoilRate=0.100000
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     maxVerticalRecoilAngle=3600
     maxHorizontalRecoilAngle=120
     bPawnRapidFireAnim=True
     bWaitForRelease=True
     TransientSoundVolume=3.800000
	 FireLoopAnims(0)=(Anim="")
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.400000
     AmmoClass=Class'UnlimaginMod.OperationY_M82A1LLIAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=110.000000,Y=105.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=11.000000,Y=3.000000,Z=11.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_M82A1LLIBullet'
     BotRefireRate=0.650000
     AimError=0.000000
     Spread=0.002000
	 MaxSpread=0.010000
     SpreadStyle=SS_Random
}
