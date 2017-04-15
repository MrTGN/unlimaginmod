//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseAssaultRifleFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.05.2013 01:17
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseAssaultRifleFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     RecoilVelocityScale=2.0
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.75
	 FireMovingSpeedScale=0.5
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.95
	 AimingHorizontalRecoilBonus=0.99
	 //Spread
	 SpreadCooldownTime=0.5
	 AimingSpreadBonus=0.9
	 CrouchedSpreadBonus=0.95
	 SemiAutoSpreadBonus=0.85
	 BurstSpreadBonus=0.95
	 //AimError
     AimingAimErrorBonus=0.6
     CrouchedAimErrorBonus=0.85
	 //ShakeView
	 AimingShakeBonus=0.95
	 //Movement
	 MaxMoveShakeScale=1.03
	 MovingAimErrorScale=4.0
	 // InstigatorMovingSpeed = 200
	 // Total MaxSpread = MaxSpread + (200 * MovingSpreadScale)
	 MovingSpreadScale=0.0008
	 //[end]
	 RecoilRate=0.08
	 Spread=0.009
	 MaxSpread=0.062
}
