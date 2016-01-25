//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseBattleRifleFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 16:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseBattleRifleFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.700000
	 FireMovingSpeedScale=0.450000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.960000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.450000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.920000
	 SemiAutoSpreadBonus=0.850000
	 BurstSpreadBonus=0.950000
	 //AimError
     AimingAimErrorBonus=0.550000
     CrouchedAimErrorBonus=0.850000
	 //ShakeView
	 AimingShakeBonus=0.960000
	 //Movement
	 MaxMoveShakeScale=1.030000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001200
	 //[end]
	 RecoilRate=0.080000
	 Spread=0.006000
	 MaxSpread=0.030000
}
