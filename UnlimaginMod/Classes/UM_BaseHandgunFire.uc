//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseHandgunFire
//	Parent class:	 UM_BaseProjectileWeaponFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 18.05.2013 05:02
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseHandgunFire extends UM_BaseProjectileWeaponFire
	Abstract;


defaultproperties
{
     RecoilVelocityScale=2.5
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.820000
	 FireMovingSpeedScale=0.600000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.960000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.950000
     //AimError
     AimingAimErrorBonus=0.650000
     CrouchedAimErrorBonus=0.850000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 MaxMoveShakeScale=1.040000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001200
	 //[end]
	 RecoilRate=0.080000
	 Spread=0.010000
	 ShotsForMaxSpread=6
	 MaxSpread=0.150000
     SpreadStyle=SS_Random
}
