//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseShotgunFire
//	Parent class:	 UM_BaseProjectileWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.04.2013 21:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base fire class of standard pump-action shotgun with
//					 tube magazine.
//================================================================================
class UM_BaseShotgunFire extends UM_BaseProjectileWeaponFire
	Abstract;


// Calculate modifications to spread
// Shotguns doesn't have any spread bonuses, just return incoming Spread
function float UpdateSpread(float NewSpread)
{
	Return NewSpread;
}

defaultproperties
{
	 RecoilVelocityScale=3.0
	 //[block] Fire Effects
	 bAttachFlashEmitter=True
	 bAttachSmokeEmitter=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=Class'ROEffects.MuzzleFlash1stKar'
	 ShellEjectBones(0)="Shell_eject"
	 ShellEjectEmitterClasses(0)=Class'ROEffects.KFShellEjectBenelli'
	 //[end]
	 //Animation
	 FireEndAnims(0)=(Anim="")
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.700000
	 FireMovingSpeedScale=0.450000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.980000
	 AimingHorizontalRecoilBonus=1.000000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=1.000000
	 CrouchedSpreadBonus=1.000000
	 //AimError
     AimingAimErrorBonus=0.600000
     CrouchedAimErrorBonus=0.900000
	 //ShakeView
	 AimingShakeBonus=0.980000
	 //Movement
	 MaxMoveShakeScale=1.050000
	 MovingAimErrorScale=4.100000
	 MovingSpreadScale=1.000000
	 //[end]
	 //Booleans
	 bNoKickMomentum=False
	 bChangeProjByPerk=True
	 bRandomPitchFireSound=True
     //Sounds
	 RandomPitchAdjustAmt=0.050000
	 //Fire properties
	 EffectiveRange=2000.000000
	 KickMomentum=(X=-50.000000,Z=15.000000)
	 LowGravKickMomentumScale=10.000000
	 RecoilRate=0.050000
	 AmmoPerFire=1
	 ProjPerFire=9
	 //ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=0.000000)
	 FireForce="FlakCannonFire"
	 ProjectileClass=Class'Old2k4.FlakChunk'
	 BotRefireRate=0.700000
	 AimError=40.000000
	 //Spread
	 Spread=2000.000000
     SpreadStyle=SS_Random
}
