//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseSMGFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 00:45
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseSMGFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.800000
	 FireMovingSpeedScale=0.600000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.960000
	 AimingHorizontalRecoilBonus=0.9800000
	 //Spread
	 SpreadCooldownTime=0.420000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.950000
	 SemiAutoSpreadBonus=0.840000
	 BurstSpreadBonus=0.940000
     //AimError
     AimingAimErrorBonus=0.620000
     CrouchedAimErrorBonus=0.860000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.030000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001000
	 //[end]
	 RecoilRate=0.065000
	 Spread=0.012000
	 MaxSpread=0.056000
}
