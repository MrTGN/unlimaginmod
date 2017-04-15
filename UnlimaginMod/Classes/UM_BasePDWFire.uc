//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BasePDWFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 16:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BasePDWFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     RecoilVelocityScale=1.25
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.850000
	 FireMovingSpeedScale=0.650000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.940000
	 AimingHorizontalRecoilBonus=0.9800000
	 //Spread
	 SpreadCooldownTime=0.400000
	 AimingSpreadBonus=0.900000
	 CrouchedSpreadBonus=0.940000
	 SemiAutoSpreadBonus=0.820000
	 BurstSpreadBonus=0.940000
     //AimError
     AimingAimErrorBonus=0.600000
     CrouchedAimErrorBonus=0.820000
	 //ShakeView
	 AimingShakeBonus=0.940000
	 //Movement
	 MaxMoveShakeScale=1.020000
	 MovingAimErrorScale=3.800000
	 MovingSpreadScale=0.000900
	 //[end]
	 RecoilRate=0.070000
	 Spread=0.011000
	 MaxSpread=0.052000
}
