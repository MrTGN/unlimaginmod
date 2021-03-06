//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_SCARMK17Fire
//	Parent class:	 UM_BaseAssaultRifleFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 19:52
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_SCARMK17Fire extends UM_BaseAssaultRifleFire;


defaultproperties
{
     ProjSpawnOffsets(0)=(X=0.000000,Y=-1.000000,Z=-2.000000)
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stSTG'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectSCAR'
	 //[end]
	 FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
	 // Recoil
	 RecoilRate=0.076000
	 RecoilUpRot=(Min=326,Max=502)
	 RecoilLeftChance=0.46
     RecoilLeftRot=(Min=198,Max=236)
	 RecoilRightRot=(Min=202,Max=248)
	 
     FireSoundRef="KF_SCARSnd.SCAR_Fire"
     StereoFireSoundRef="KF_SCARSnd.SCAR_FireST"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
     bPawnRapidFireAnim=True
     TransientSoundVolume=1.800000
     FireLoopAnims(0)=(Anim="Fire",Rate=1.000000)
	 FireLoopAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     TweenTime=0.025000
     FireForce="AssaultRifleFire"
     FireRate=0.096000
     AmmoClass=Class'KFMod.SCARMK17Ammo'
     AmmoPerFire=1
     ShakeRotMag=(X=50.000000,Y=50.000000,Z=300.000000)
     ShakeRotRate=(X=7500.000000,Y=7500.000000,Z=7500.000000)
     ShakeRotTime=0.650000
     ShakeOffsetMag=(X=6.000000,Y=3.000000,Z=7.500000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.150000
	 ProjectileClass=Class'UnlimaginMod.UM_SCARMK17Bullet'
     BotRefireRate=0.990000
     AimError=62.000000
     Spread=0.007500
	 MaxSpread=0.052000
     SpreadStyle=SS_Random
}
