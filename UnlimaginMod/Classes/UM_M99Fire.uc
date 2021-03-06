//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_M99Fire
//	Parent class:	 UM_BaseSingleShotSniperRifleFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 26.05.2013 02:10
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_M99Fire extends UM_BaseSingleShotSniperRifleFire;


defaultproperties
{
     //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stPTRD'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'UnlimaginMod.OperationY_KFShellEjectM82A1LLI'
	 //[end]
	 EffectiveRange=25000.000000
	 // Recoil
	 RecoilRate=0.1
	 RecoilUpRot=(Min=3000,Max=3800)
	 RecoilLeftChance=0.48
     RecoilLeftRot=(Min=50,Max=100)
	 RecoilRightRot=(Min=60,Max=110)

     FireAimedAnims(0)=(Anim="Fire_Iron",Rate=1.000000)
     FireSoundRef="KF_M99Snd.M99_Fire_M"
     StereoFireSoundRef="KF_M99Snd.M99_Fire_S"
     NoAmmoSoundRef="KF_SCARSnd.SCAR_DryFire"
     ProjPerFire=1
     ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=0.000000)
     bWaitForRelease=True
     TransientSoundVolume=1.800000
     FireForce="AssaultRifleFire"
     FireRate=3.030000
     AmmoClass=Class'KFMod.M99Ammo'
	 ShakeRotMag=(X=110.000000,Y=90.000000,Z=500.000000)
     ShakeRotRate=(X=10000.000000,Y=10000.000000,Z=10000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=12.000000,Y=3.000000,Z=10.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'UnlimaginMod.UM_M99Bullet'
     BotRefireRate=3.570000
	 bNoKickMomentum=False
	 bOnlyLowGravKickMomentum=False
	 KickMomentum=(X=-100.000000,Z=15.000000)
     AimError=2.000000
     Spread=0.001000
	 MaxSpread=0.005000
}
