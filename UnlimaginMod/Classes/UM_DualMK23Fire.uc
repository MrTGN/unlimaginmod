//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DualMK23Fire
//	Parent class:	 DualMK23Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.07.2012 23:48
//================================================================================
class UM_DualMK23Fire extends DualMK23Fire;

var		int		Burstlength;
var		float	Burstrate;

var		bool	bSetToBurst;
var		int		RoundsToFire;
var		bool	bBursting;

event ModeDoFire()
{
	local name bn;
	
	//[block] Switching DamageType for Firebug
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switch damage type for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		{
			//Decreasing damages for the Firebug
			//DamageMin = int(default.DamageMin * 0.75);
			//DamageMax = int(default.DamageMax * 0.75);
			
			//Switching damage type
			DamageType = class'UnlimaginMod.UM_DamTypeDualMK23Inc';
		}
		else
		{
			//Restoring default damages for the other skills
			//DamageMin = default.DamageMin;
			//DamageMax = default.DamageMax;
			
			//Restoring default damage type
			DamageType = default.DamageType;
		}
	}
	//[end]
	
	if ( bSetToBurst )
	{
		if ( bBursting )
		{
			RoundsToFire--;
			if ( RoundsToFire < 1 )
			{
				SetTimer(0, False);
				RoundsToFire = 0;
				bBursting = False;
				Return;
			}
		}
		else if ( !bBursting && AllowFire() ) //If not already firing, start a burst.
		{
			bBursting = True;
			//[block] Switching fire flash bone and anim to second or first gun
			bn = UM_DualMK23Pistol(Weapon).altFlashBoneName;
			UM_DualMK23Pistol(Weapon).altFlashBoneName = UM_DualMK23Pistol(Weapon).FlashBoneName;
			UM_DualMK23Pistol(Weapon).FlashBoneName = bn;
			if ( KFWeap.bAimingRifle )
			{
				fa = FireAimedAnim2;
				FireAimedAnim2 = FireAimedAnim;
				FireAimedAnim = fa;
			}
			else
			{
				fa = FireAnim2;
				FireAnim2 = FireAnim;
				FireAnim = fa;
			}
			//[end]
			if (KFWeapon(Weapon).MagAmmoRemaining >= Burstlength)
				RoundsToFire = BurstLength;
			else
				RoundsToFire = KFWeapon(Weapon).MagAmmoRemaining;
			SetTimer(BurstRate, True);
		}
	}
	else
	{
		bn = UM_DualMK23Pistol(Weapon).altFlashBoneName;
		UM_DualMK23Pistol(Weapon).altFlashBoneName = UM_DualMK23Pistol(Weapon).FlashBoneName;
		UM_DualMK23Pistol(Weapon).FlashBoneName = bn;
		if ( KFWeap.bAimingRifle )
		{
			fa = FireAimedAnim2;
			FireAimedAnim2 = FireAimedAnim;
			FireAimedAnim = fa;
		}
		else
		{
			fa = FireAnim2;
			FireAnim2 = FireAnim;
			FireAnim = fa;
		}
	}
	
	Super(KFFire).ModeDoFire();
	InitEffects();
}

simulated event Timer()
{
	if ( bBursting )
		ModeDoFire();
	else 
		SetTimer(0, False);
}

defaultproperties
{
     Burstlength=3
	  Burstrate=0.100000
	  bSetToBurst=False
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=100
	  DamageType=Class'KFMod.DamTypeDualMK23Pistol'
     DamageMin=40
     DamageMax=50
	  bWaitForRelease=True
     FireRate=0.120000
     ShakeRotMag=(Z=290.000000)
     ShakeRotRate=(X=10080.000000,Y=10080.000000)
     ShakeRotTime=3.300000
     ShakeOffsetMag=(Y=1.000000,Z=8.000000)
     ShakeOffsetTime=2.300000
     Spread=0.010000
	  MaxSpread=0.045000
}
