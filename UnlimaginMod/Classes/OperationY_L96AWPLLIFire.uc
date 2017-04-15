class OperationY_L96AWPLLIFire extends UM_BaseSniperRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-3.000000,Z=1.000000)
	 //[block] Dynamic Loading Vars
	 //FireSound=Sound'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_shot'
	 FireSoundRef="L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_shot"
	 //StereoFireSound=Sound'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_shot'
     //NoAmmoSound=Sound'L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_empty'
	 NoAmmoSoundRef="L96AWPLLI_A.L96AWPLLI_T.L96AWPLLI_empty"
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip_LLIePLLIeHb"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Ejector_LLIePLLIeHb"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectL96AWPLLI'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 // Recoil
	 RecoilRate=0.20000
	 RecoilUpRot=(Min=680,Max=800)
	 RecoilLeftChance=0.47
     RecoilLeftRot=(Min=150,Max=200)
	 RecoilRightRot=(Min=160,Max=220)

     //bPawnRapidFireAnim=True
     bWaitForRelease=True
	 FireLoopAnims(0)=(Anim="")
     FireEndAnims(0)=(Anim="")
     TransientSoundVolume=3.850000
     TweenTime=0.025000
     //FireForce="AssaultRifleFire"
	 FireForce="ShockRifleFire"
     FireRate=1.900000
     AmmoClass=Class'UnlimaginMod.OperationY_L96AWPLLIAmmo'
     AmmoPerFire=1
     ShakeRotMag=(X=105.000000,Y=92.000000,Z=502.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=11.000000,Y=2.800000,Z=11.600000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
	 ProjectileClass=Class'UnlimaginMod.UM_L96AWPLLIBullet'
     BotRefireRate=0.650000
     AimError=4.000000
     Spread=0.004000
	 MaxSpread=0.012000
     SpreadStyle=SS_Random
}
