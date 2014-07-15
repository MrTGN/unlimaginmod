//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M32ShotgunFire
//	Parent class:	 UM_BaseShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:17
//================================================================================
class UM_M32ShotgunFire extends UM_BaseShotgunFire;


defaultproperties
{
	//[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)=
	 ShellEjectEmitterClasses(0)=None
	 //[end]
     EffectiveRange=700.000000
     maxVerticalRecoilAngle=1250
     maxHorizontalRecoilAngle=550
     FireAimedAnims(0)=(Anim="Iron_Fire",Rate=1.000000)
     FireSoundRef="KF_PumpSGSnd.SG_Fire"
     StereoFireSoundRef="KF_PumpSGSnd.SG_FireST"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
     ProjPerFire=24
     ProjSpawnOffsets(0)=(X=0.000000,Y=10.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     FireForce="AssaultRifleFire"
     FireRate=0.330000
     AmmoClass=Class'UnlimaginMod.UM_M32ShotgunAmmo'
     ShakeRotMag=(X=50.000000,Y=44.000000,Z=240.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=5.000000,Y=3.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     ProjectileClass=Class'UnlimaginMod.UM_M32ShotgunFlechetteProj'
     //Firebug
     PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_M32ShotgunIncBullet',PerkProjPerFire=8,PerkProjSpread=1950.000000)
     //Demolitions
     PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_M32ShotgunFragBullet',PerkProjPerFire=8,PerkProjSpread=1950.000000)
     BotRefireRate=1.800000
     AimError=64.000000
     Spread=2800.000000
}