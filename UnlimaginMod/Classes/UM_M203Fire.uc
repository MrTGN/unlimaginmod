//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M203Fire
//	Parent class:	 UM_BaseSingleShotGrenadeLauncherFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.09.2012 20:50
//================================================================================
class UM_M203Fire extends UM_BaseSingleShotGrenadeLauncherFire;


defaultproperties
{
     bChangeProjByPerk=True
	 //Commando
	 PerkProjsInfo(3)=(PerkProjClass=Class'UnlimaginMod.UM_M203StickySensorGrenade')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_M203NapalmGrenadeProj')
	 //
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stNadeL'
	 ShellEjectBones(0)=
	 ShellEjectEmitterClasses(0)=None
	 //[end]
	 EffectiveRange=2500.000000
	 // Recoil
	 RecoilRate=0.080000
	 RecoilUpRot=(Min=142,Max=196)
	 RecoilLeftChance=0.5
     RecoilLeftRot=(Min=30,Max=46)
	 RecoilRightRot=(Min=32,Max=50)
	 
     FireAnims(0)=(Anim="Fire_Secondary",Rate=1.000000)
	 FireAimedAnims(0)=(Anim="Fire_Iron_Secondary",Rate=1.000000)
     FireSoundRef="KF_M79Snd.M79_Fire"
     StereoFireSoundRef="KF_M79Snd.M79_FireST"
     NoAmmoSoundRef="KF_M79Snd.M79_DryFire"
     ProjPerFire=1
     ProjSpawnOffsets(0)=(X=2.000000,Y=2.000000,Z=-4.000000)
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireForce="AssaultRifleFire"
     FireRate=3.333000
     AmmoClass=Class'KFMod.M203Ammo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'UnlimaginMod.UM_M203M381Grenade'
     BotRefireRate=1.800000
     AimError=60.000000
     Spread=0.015000
}