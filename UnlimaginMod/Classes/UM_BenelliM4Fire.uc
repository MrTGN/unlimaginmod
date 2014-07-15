//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM4Fire
//	Parent class:	 UM_BaseShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2012 6:13
//================================================================================
class UM_BenelliM4Fire extends UM_BaseShotgunFire;


defaultproperties
{
     // Use this for SpawnOffset fine-tuning.
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-1.000000,Z=0.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBenelli'
	 //[end]
     KickMomentum=(X=-45.000000,Z=10.000000)
     maxVerticalRecoilAngle=1400
     maxHorizontalRecoilAngle=800
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_PumpSGSnd.SG_Fire"
     StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
     ProjPerFire=10
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.200000
     AmmoClass=Class'KFMod.BenelliAmmo'
     ShakeRotMag=(X=55.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.500000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_BenelliM4_1Buckshot'
     //[block] Perks ProjectileClasses and etc.
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4Slug',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4IncBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM4FragBullet',PerkProjPerFire=1,PerkProjSpread=0.013000)
	 //[end]
     BotRefireRate=0.200000
     AimError=62.000000
	 Spread=1400.000000
}
