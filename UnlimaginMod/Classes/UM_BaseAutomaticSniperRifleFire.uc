//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseAutomaticSniperRifleFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 19:01
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseAutomaticSniperRifleFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     RecoilVelocityScale=2.0
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.700000
	 FireMovingSpeedScale=0.500000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.960000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.400000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.900000
	 SemiAutoSpreadBonus=0.850000
	 BurstSpreadBonus=0.940000
     //AimError
     AimingAimErrorBonus=0.500000
     CrouchedAimErrorBonus=0.850000
	 //ShakeView
	 AimingShakeBonus=0.960000
	 //Movement
	 MaxMoveShakeScale=1.020000
	 MovingAimErrorScale=4.200000
	 MovingSpreadScale=0.001200
	 //[end]
	 RecoilRate=0.080000
	 Spread=0.005000
	 MaxSpread=0.025000
}
