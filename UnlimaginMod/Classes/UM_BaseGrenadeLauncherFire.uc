//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseGrenadeLauncherFire
//	Parent class:	 UM_BaseProjectileWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 02:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseGrenadeLauncherFire extends UM_BaseProjectileWeaponFire
	Abstract;


// Calculate modifications to spread
// GrenadeLaunchers doesn't have any spread bonuses, just return incoming Spread
function float UpdateSpread(float NewSpread)
{
	Return NewSpread;
}


defaultproperties
{
	 //Animation
	 FireEndAnims(0)=(Anim="")
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.800000
	 FireMovingSpeedScale=0.500000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.990000
	 AimingHorizontalRecoilBonus=1.000000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=1.000000
	 CrouchedSpreadBonus=0.960000
     //AimError
     AimingAimErrorBonus=0.700000
     CrouchedAimErrorBonus=0.800000
	 //ShakeView
	 AimingShakeBonus=0.980000
	 //Movement
	 MaxMoveShakeScale=1.100000
	 MovingAimErrorScale=4.200000
	 MovingSpreadScale=0.020000
	 //[end]
	 //Booleans
	 bNoKickMomentum=True
	 bChangeProjByPerk=False
	 bRandomPitchFireSound=True
     //Sounds
	 RandomPitchAdjustAmt=0.050000
	 //Fire properties
	 EffectiveRange=4000.000000
	 KickMomentum=(X=0.000000,Z=0.000000)
	 LowGravKickMomentumScale=1.000000
	 RecoilRate=0.050000
	 AmmoPerFire=1
	 ProjPerFire=1
	 //ProjSpawnOffsets(0)=(X=0.000000,Y=0.000000,Z=0.000000)
	 FireForce="FlakCannonFire"
	 ProjectileClass=Class'Old2k4.FlakChunk'
	 BotRefireRate=0.700000
	 AimError=30.000000
	 //Spread
	 Spread=0.500000
	 MaxSpread=0.500000
     SpreadStyle=SS_Random
}
