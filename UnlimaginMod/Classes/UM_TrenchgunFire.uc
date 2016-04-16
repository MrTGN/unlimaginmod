//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_TrenchgunFire
//	Parent class:	 UM_BaseShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.11.2012 15:38
//================================================================================
class UM_TrenchgunFire extends UM_BaseShotgunFire;

defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'KFMod.TrenchgunMuzzFlash'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBenelli'
	 //[end]
	 KickMomentum=(X=-85.000000,Z=15.000000)
     maxVerticalRecoilAngle=1500
     maxHorizontalRecoilAngle=900
     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_ShotgunDragonsBreathSnd.ShotgunDragon_Fire_Single_M"
     StereoFireSoundRef="KF_ShotgunDragonsBreathSnd.ShotgunDragon_Fire_Single_S"
     NoAmmoSoundRef="KF_PumpSGSnd.SG_DryFire"
     ProjPerFire=9
     bWaitForRelease=True
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     //FireAnimRate=0.950000
     FireRate=0.965000
     AmmoClass=Class'KFMod.TrenchgunAmmo'
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=400.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=5.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     ProjectileClass=Class'UnlimaginMod.UM_Trenchgun_0Buckshot'
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_TrenchgunMedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.015000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_TrenchgunSlug',PerkProjPerFire=1,PerkProjSpread=0.015000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'KFMod.TrenchgunBullet',PerkProjPerFire=14,PerkProjSpread=1125.000000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_TrenchgunFragBullet',PerkProjPerFire=1,PerkProjSpread=0.015000)
     BotRefireRate=1.500000
     AimError=68.000000
	 Spread=1480.000000
}