//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BasePDWFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 01.05.2013 16:15
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_BasePDWFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.850000
	 FireMovingSpeedScale=0.650000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.940000
	 AimingHorizontalRecoilBonus=0.9800000
	 //Spread
	 SpreadCooldownTime=0.400000
	 AimingSpreadBonus=0.600000
	 CrouchedSpreadBonus=0.880000
	 SemiAutoSpreadBonus=0.850000
	 BurstSpreadBonus=0.950000
     //AimError
     AimingAimErrorBonus=0.720000
     CrouchedAimErrorBonus=0.900000
	 //ShakeView
	 AimingShakeBonus=0.940000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.040000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001200
	 //[end]
	 RecoilRate=0.070000
	 Spread=0.011000
	 MaxSpread=0.052000
}