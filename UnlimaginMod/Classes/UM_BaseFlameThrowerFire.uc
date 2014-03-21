//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseFlameThrowerFire
//	Parent class:	 UM_BaseAutomaticWeaponFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.05.2013 02:24
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseFlameThrowerFire extends UM_BaseAutomaticWeaponFire
	Abstract;


defaultproperties
{
     //[block] Fire Effects
	 bRecoilIgnoreZVelocity=True
	 MuzzleBones(0)="tip"
	 SmokeEmitterClasses(0)=Class'UnlimaginMod.UM_BaseMuzzleSmoke1st'
	 FlashEmitterClasses(0)=None
	 ShellEjectBones(0)=
	 ShellEjectEmitterClasses(0)=None
	 //[end]
	 bFiringDoesntAffectMovement=True
	 bHighRateOfFire=True
	 //Instigator MovingSpeedScale
	 FirstShotMovingSpeedScale=0.850000
	 FireMovingSpeedScale=0.650000
     //[block] Bonuses
	 //Recoil
	 AimingVerticalRecoilBonus=0.990000
	 AimingHorizontalRecoilBonus=1.000000
	 //Spread
	 SpreadCooldownTime=0.500000
	 AimingSpreadBonus=1.000000
	 CrouchedSpreadBonus=1.000000
	 SemiAutoSpreadBonus=1.000000
	 BurstSpreadBonus=1.000000
     //AimError
     AimingAimErrorBonus=0.800000
     CrouchedAimErrorBonus=0.900000
	 //ShakeView
	 AimingShakeBonus=0.980000
	 //Movement
	 CrouchedMovingBonus=0.650000
	 MaxMoveShakeScale=1.050000
	 MovingAimErrorScale=4.000000
	 MovingSpreadScale=0.001200
	 //[end]
	 //Bonuses
	 RecoilRate=0.060000
}
