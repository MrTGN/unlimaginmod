//=============================================================================
// Shotgun Fire
//=============================================================================
class MrQuebec_HekuT_Spas12Fire extends UM_BaseShotgunFire;


defaultproperties
{
     //[block] Dynamic Loading Vars
	 FireSoundRef="KF_ShotgunDragonsBreathSnd.ShotgunDragon_Fire_Single_M"
     StereoFireSoundRef="KF_ShotgunDragonsBreathSnd.ShotgunDragon_Fire_Single_S"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
	 //[end] 
	 // Use this for SpawnOffset fine-tuning.
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-2.000000,Z=0.000000)
	 //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 //PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Sharpshooter
	 //PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4Slug',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_Spas12IncBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_Spas12FragBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
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
	 // Recoil
	 RecoilRate=0.1
	 RecoilUpRot=(Min=900,Max=1300)
	 RecoilLeftChance=0.46
     RecoilLeftRot=(Min=580,Max=760)
	 RecoilRightRot=(Min=620,Max=800)

	 
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     bRandomPitchFireSound=True
     ProjPerFire=7
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.250000
     AmmoClass=Class'UnlimaginMod.MrQuebec_HekuT_Spas12Ammo'
     ShakeRotMag=(X=56.000000,Y=51.000000,Z=396.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.500000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_Spas12_000Buckshot'
     BotRefireRate=0.200000
	 AimError=64.000000
	 Spread=1125.000000
}
