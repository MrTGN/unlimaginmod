//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM3Fire
//	Parent class:	 UM_BaseShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2012 20:24
//================================================================================
class UM_BenelliM3Fire extends UM_BaseShotgunFire;


defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBenelli'
	 //[end]
	 //FireSound=SoundGroup'KF_PumpSGSnd.SG_Fire'
	 FireSoundRef="KF_PumpSGSnd.SG_Fire"
	 StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     //NoAmmoSound=Sound'KF_PumpSGSnd.SG_DryFire'
	 NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
	 KickMomentum=(X=-85.000000,Z=15.000000)
     maxVerticalRecoilAngle=1450
     maxHorizontalRecoilAngle=900
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=0.950000)
	 FireAnims(0)=(Rate=0.950000)
     ProjPerFire=8
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireAnimRate=0.950000
     FireRate=0.965000
     AmmoClass=Class'KFMod.ShotgunAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_BenelliM3_00Buckshot'
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM3MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM3Slug',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM3IncBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_BenelliM3FragBullet',PerkProjPerFire=1,PerkProjSpread=0.012000)
     BotRefireRate=1.500000
     Spread=1155.000000
}
