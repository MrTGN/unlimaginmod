//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseSniperRifleFire
//	Parent class:	 UM_BaseProjectileWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.04.2013 18:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base Semi-auto SniperRifle Fire class
//================================================================================
class UM_BaseSniperRifleFire extends UM_BaseProjectileWeaponFire
	Abstract;


defaultproperties
{
     //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.700000
	 FireMovingSpeedScale=0.450000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.980000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.550000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.900000
	 //AimError
     AimingAimErrorBonus=0.500000
     CrouchedAimErrorBonus=0.800000
	 //ShakeView
	 AimingShakeBonus=0.940000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.100000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001200
	 //[end]
	 bWaitForRelease=True
	 RecoilRate=0.080000
	 Spread=0.005000
	 ShotsForMaxSpread=6
	 MaxSpread=0.025000
}
