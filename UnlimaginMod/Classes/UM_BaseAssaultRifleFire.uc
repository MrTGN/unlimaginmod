//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseAssaultRifleFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 01.05.2013 01:17
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_BaseAssaultRifleFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.750000
	 FireMovingSpeedScale=0.500000
	 //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.950000
	 AimingHorizontalRecoilBonus=0.990000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=0.600000
	 CrouchedSpreadBonus=0.900000
	 SemiAutoSpreadBonus=0.850000
	 BurstSpreadBonus=0.950000
	 //AimError
     AimingAimErrorBonus=0.700000
     CrouchedAimErrorBonus=0.900000
	 //ShakeView
	 AimingShakeBonus=0.950000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.050000
	 MovingAimErrorScale=3.800000
	 MovingSpreadScale=0.001000
	 //[end]
	 RecoilRate=0.080000
	 Spread=0.009000
	 MaxSpread=0.045000
}