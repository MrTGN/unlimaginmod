//================================================================================
//	Optimized and rebalansed by Tsiryuta G. N. <spbtgn@gmail.com>
//================================================================================
//===================================================================================
// Shotgun Fire
//===================================================================================
class Hemi_Braindead_Moss12Fire extends UM_BaseShotgunFire;

defaultproperties
{
     //[block] Dynamic Loading Vars
	 //FireSound=SoundGroup'KF_Moss12Snd.SG_Fire'
	 FireSoundRef="KF_Moss12Snd.SG_Fire"
	 //StereoFireSound=SoundGroup'KF_Moss12Snd.SG_FireST'
	 StereoFireSoundRef="KF_Moss12Snd.SG_FireST"
	 //NoAmmoSound=Sound'KF_Moss12Snd.SG_DryFire'
	 NoAmmoSoundRef="KF_Moss12Snd.SG_DryFire"
	 //[end]
	 //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_Moss12MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.014000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_Moss12Slug',PerkProjPerFire=1,PerkProjSpread=0.014000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_Moss12IncBullet',PerkProjPerFire=1,PerkProjSpread=0.014000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_Moss12FragBullet',PerkProjPerFire=1,PerkProjSpread=0.014000)
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
     maxVerticalRecoilAngle=1480
     maxHorizontalRecoilAngle=900
     FireAimedAnims(0)=(Anim="IronSight_Fire",Rate=0.950000)
	 FireAnims(0)=(Rate=0.950000)
     ProjPerFire=9
     bWaitForRelease=True
     TransientSoundVolume=4.000000
     TransientSoundRadius=500.000000
     FireAnimRate=0.950000
     FireRate=0.965000
     AmmoClass=Class'UnlimaginMod.Hemi_Braindead_Moss12Ammo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_Moss12_0Buckshot'
     BotRefireRate=1.500000
     AimError=65.000000
     Spread=1315.000000
}
