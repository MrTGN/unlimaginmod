//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M79Fire
//	Parent class:	 UM_BaseSingleShotGrenadeLauncherFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.07.2012 1:29
//================================================================================
class UM_M79Fire extends UM_BaseSingleShotGrenadeLauncherFire;


defaultproperties
{
     bChangeProjByPerk=True
	 //Berserker
	 PerkProjsInfo(4)=(PerkProjClass=Class'UnlimaginMod.UM_M79BouncingBall')
	 //Firebug
	 PerkProjsInfo(5)=(PerkProjClass=Class'UnlimaginMod.UM_M79NapalmGrenadeProj')
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
	 RecoilUpRot=(Min=148,Max=200)
	 RecoilLeftChance=0.5
     RecoilLeftRot=(Min=32,Max=48)
	 RecoilRightRot=(Min=36,Max=50)
	 
     FireAimedAnims(0)=(Anim="Iron_Fire",Rate=1.000000)
     FireSoundRef="KF_M79Snd.M79_Fire"
     StereoFireSoundRef="KF_M79Snd.M79_FireST"
     NoAmmoSoundRef="KF_M79Snd.M79_DryFire"
     ProjPerFire=1
     ProjSpawnOffsets(0)=(X=2.000000,Y=10.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireForce="AssaultRifleFire"
     FireRate=3.333000
     AmmoClass=Class'KFMod.M79Ammo'
     ShakeRotMag=(X=3.000000,Y=4.000000,Z=2.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeOffsetMag=(X=3.000000,Y=3.000000,Z=3.000000)
     ProjectileClass=Class'KFMod.M79GrenadeProjectile'
     BotRefireRate=1.800000
     AimError=65.000000
     Spread=0.015000
}
