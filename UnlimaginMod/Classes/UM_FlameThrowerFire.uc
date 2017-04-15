//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_TestFlameThrowerAltFire
//	Parent class:	 UM_BaseFlameThrowerFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 27.04.2013 08:26
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_FlameThrowerFire extends UM_BaseFlameThrowerFire;


defaultproperties
{
     bChangeProjByPerk=True
	 //Field Medic
	 PerkProjsInfo(0)=(PerkProjClass=Class'UnlimaginMod.UM_FlameThrowerMedGas')
	 //
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=None
	 ShellEjectBones(0)=""
	 ShellEjectEmitterClasses(0)=None
	 //[end]
	 AmbientFireSoundRadius=500.000000
     AmbientFireVolume=255
     FireEndSoundRef="KF_FlamethrowerSnd.FT_Fire1Shot"
     AmbientFireSoundRef="KF_FlamethrowerSnd.FireLoop"
	 NoAmmoSoundRef="KF_FlamethrowerSnd.FT_DryFire"
     EffectiveRange=1500.000000
	 // Recoil
	 RecoilRate=0.065000
	 RecoilUpRot=(Min=80,Max=120)
	 RecoilLeftChance=0.5
     RecoilLeftRot=(Min=50,Max=80)
	 RecoilRightRot=(Min=50,Max=80)
	 
	 ProjSpawnOffsets(0)=(X=0.000000,Y=1.000000,Z=0.000000)
	 bSplashDamage=True
     bRecommendSplashDamage=True
     bWaitForRelease=False
     TransientSoundVolume=1.000000
     TransientSoundRadius=500.000000
     FireAnims(0)=(Anim="'",Rate=1.000000)
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
     FireEndAnims(0)=(Anim="Idle",Rate=1.000000)
	 FireRate=0.070000
     AmmoClass=Class'KFMod.FlameAmmo'
     ShakeRotMag=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeRotRate=(X=0.000000,Y=0.000000,Z=0.000000)
	 ShakeRotTime=0.000000
     ShakeOffsetMag=(X=0.000000,Y=0.000000,Z=0.000000)
	 ShakeOffsetRate=(X=0.000000,Y=0.000000,Z=0.000000)
	 ShakeOffsetTime=0.000000
     ProjectileClass=Class'KFMod.FlameTendril'
	 BotRefireRate=0.070000
     AimError=70.000000
     Spread=760.000000
	 MaxSpread=900.000000
     SpreadStyle=SS_Random
}
