class OperationY_ProtectaFire extends UM_BaseShotgunFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'Protecta_A.striker_shot_stereo'
	 FireSoundRef="Protecta_A.striker_shot_stereo"
	 //StereoFireSound=Sound'Protecta_A.striker_shot_stereo'
	 StereoFireSoundRef="Protecta_A.striker_shot_stereo"
	 //NoAmmoSound=Sound'Protecta_A.striker_empty'
	 NoAmmoSoundRef="Protecta_A.striker_empty"
	 //[end]
	 //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 //PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.014000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_ProtectaIncBullet',PerkProjPerFire=3,PerkProjSpread=900.000000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_ProtectaFragBullet',PerkProjPerFire=3,PerkProjSpread=900.000000)
	 //[end]
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBenelli'
	 //[end]
	 KickMomentum=(X=-85.000000,Z=15.000000)
     RecoilRate=0.100000
     maxVerticalRecoilAngle=1540
     maxHorizontalRecoilAngle=700
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     ProjPerFire=10
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     //FireAnimRate=0.950000
     FireRate=0.250000
     AmmoClass=Class'UnlimaginMod.OperationY_ProtectaAmmo'
     ShakeRotMag=(X=60.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.500000,Y=2.500000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_Protecta_1Buckshot'
     BotRefireRate=0.250000
     AimError=64.000000
     Spread=1500.000000
}
