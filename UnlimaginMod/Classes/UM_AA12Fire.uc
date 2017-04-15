//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12Fire
//	Parent class:	 UM_BaseMagShotgunFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 16.08.2012 20:41
//================================================================================
class UM_AA12Fire extends UM_BaseMagShotgunFire;


defaultproperties
{
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectShotty'
	 //[end]
	 ProjSpawnOffsets(0)=(X=0.000000,Y=-2.000000,Z=-2.000000)
	 // Recoil
	 RecoilRate=0.080000
	 RecoilUpRot=(Min=420,Max=760)
	 RecoilLeftChance=0.46
     RecoilLeftRot=(Min=300,Max=380)
	 RecoilRightRot=(Min=320,Max=400)

     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_AA12Snd.AA12_Fire"
     StereoFireSoundRef="KF_AA12Snd.AA12_FireST"
     NoAmmoSoundRef="KF_AA12Snd.AA12_DryFire"
     ProjPerFire=8
     TransientSoundVolume=2.000000
     TransientSoundRadius=500.000000
     FireRate=0.200000
     AmmoClass=Class'KFMod.AA12Ammo'
	 ShakeRotMag=(X=50.000000,Y=50.000000,Z=200.000000)
     ShakeRotRate=(X=12000.000000,Y=12000.000000,Z=10000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=6.000000,Y=2.000000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     ProjectileClass=Class'UnlimaginMod.UM_AA12_00Buckshot'
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_AA12MedGasBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Sharpshooter
	 PerkProjsInfo(2)=(PerkProjClass=Class'UnlimaginMod.UM_AA12Slug',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_AA12IncBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 //Demolitions
	 PerkProjsInfo(6)=(PerkProjClass=Class'UnlimaginMod.UM_AA12FragBullet',PerkProjPerFire=1,PerkProjSpread=0.016000)
	 BotRefireRate=0.250000
     AimError=68.000000
     Spread=1400.000000
}
