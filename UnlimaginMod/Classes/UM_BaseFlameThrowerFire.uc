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


// Copied from KFShotgunFire with some changes like in KFFire
// Handle setting new recoil
simulated function HandleRecoil(float Rec)
{
	local rotator NewRecoilRotation;
	local KFPlayerController KFPC;
	local KFPawn KFPwn;
	local vector AdjustedVelocity;
	local float AdjustedSpeed;

    if ( Instigator != None )
    {
		KFPC = KFPlayerController(Instigator.Controller);
		KFPwn = KFPawn(Instigator);
	}

    if ( KFPC == None || KFPwn == None )
    	Return;

	if ( !KFPC.bFreeCamera )
	{
		if ( Weapon.GetFireMode(ThisModeNum).bIsFiring )
    	{
          	NewRecoilRotation.Pitch = RandRange(maxVerticalRecoilAngle * 0.5, maxVerticalRecoilAngle);
         	NewRecoilRotation.Yaw = RandRange(maxHorizontalRecoilAngle * 0.5, maxHorizontalRecoilAngle);

          	if ( !bRecoilRightOnly && Rand(2) == 1 )
				NewRecoilRotation.Yaw *= -1;

            if ( RecoilVelocityScale > 0.0 )
    	    {
				// FlameThrower will always Ignore Z velocity
				AdjustedVelocity = Weapon.Owner.Velocity;
				AdjustedVelocity.Z = 0.0;
				AdjustedSpeed = VSize(AdjustedVelocity);
				//log("Velocity = "$VSize(Weapon.Owner.Velocity)$" scale = "$(VSize(Weapon.Owner.Velocity)* RecoilVelocityScale));
				NewRecoilRotation.Pitch += (AdjustedSpeed * RecoilVelocityScale);
				NewRecoilRotation.Yaw += (AdjustedSpeed * RecoilVelocityScale);
			}
			// Recoil based on how much Health the player have
    	    NewRecoilRotation.Pitch += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation.Yaw += (Instigator.HealthMax / Instigator.Health * 5);
    	    NewRecoilRotation *= Rec;

 		    KFPC.SetRecoil(NewRecoilRotation, RecoilRate * (default.FireRate / FireRate));
    	}
 	}
}

defaultproperties
{
     //[block] Fire Effects
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
