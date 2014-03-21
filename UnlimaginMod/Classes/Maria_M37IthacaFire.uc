//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
class Maria_M37IthacaFire extends UM_BaseShotgunFire;

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=Sound'FMX_Ithaca_Snd.m3-1'
	 FireSoundRef="FMX_Ithaca_Snd.m3-1"
	 //StereoFireSound=Sound'FMX_Ithaca_Snd.m3-2'
	 StereoFireSoundRef="FMX_Ithaca_Snd.m3-2"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
	 //[end]
	 //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_M37IthacaMedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_M37IthacaSlug',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_M37IthacaIncBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_M37IthacaFragBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
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
	 KickMomentum=(X=-85.000000,Z=15.000000)
     maxVerticalRecoilAngle=1350
     maxHorizontalRecoilAngle=900
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     ProjPerFire=8
     bWaitForRelease=True
     TransientSoundVolume=1.600000
     TransientSoundRadius=500.000000
     //FireAnimRate=0.950000
     FireRate=0.965000
     AmmoClass=Class'UnlimaginMod.Maria_M37IthacaAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_M37Ithaca_00Buckshot'
     BotRefireRate=1.500000
	 AimError=72.000000
     Spread=1175.000000
}
