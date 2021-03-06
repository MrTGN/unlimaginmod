//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseMachineGunFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 18:52
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseMachineGunFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     RecoilVelocityScale=2.5
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.650000
	 FireMovingSpeedScale=0.400000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.980000
	 AimingHorizontalRecoilBonus=1.000000
	 //Spread
	 SpreadCooldownTime=0.600000
	 AimingSpreadBonus=0.920000
	 CrouchedSpreadBonus=0.980000
	 SemiAutoSpreadBonus=0.900000
	 BurstSpreadBonus=0.980000
     //AimError
     AimingAimErrorBonus=0.700000
     CrouchedAimErrorBonus=0.850000
	 //ShakeView
	 AimingShakeBonus=0.960000
	 //Movement
	 MaxMoveShakeScale=1.040000
	 MovingAimErrorScale=4.500000
	 MovingSpreadScale=0.001400
	 //[end]
	 RecoilRate=0.090000
	 Spread=0.020000
	 MaxSpread=0.130000
}
