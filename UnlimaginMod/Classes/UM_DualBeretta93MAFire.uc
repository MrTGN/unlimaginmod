//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DualBeretta93MAFire
//	Parent class:	 DualiesFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.06.2012 15:38
//================================================================================
class UM_DualBeretta93MAFire extends DualiesFire;

var		int		Burstlength;
var		int		RoundsToFire;
var		bool	bBursting;

event ModeDoFire()
{
	local name bn;
	
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		{
			DamageType = class'UnlimaginMod.UM_DamTypeDualBeretta93MAInc';
		}
		else
		{
			DamageType = default.DamageType;
		}
	}
	
	// -- Bursting --
	if (bBursting && RoundsToFire > 0)
		RoundsToFire--;
	//If not already firing, start a burst.
	if (!bBursting && AllowFire())
	{
		bBursting = True;
		bn = Dualies(Weapon).altFlashBoneName;
		Dualies(Weapon).altFlashBoneName = Dualies(Weapon).FlashBoneName;
		Dualies(Weapon).FlashBoneName = bn;
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
		if (KFWeapon(Weapon).MagAmmoRemaining >= Burstlength)
			RoundsToFire = BurstLength;
		else
			RoundsToFire = KFWeapon(Weapon).MagAmmoRemaining;
	}
	if (RoundsToFire < 1)
	{
		RoundsToFire = 0;
		bBursting = False;
		Return;
	}
	
	Super(KFFire).ModeDoFire();
	InitEffects();
}

function StartSuperBerserk()
{

}

defaultproperties
{
     Burstlength=3
     FireLoopAnim="Fire"
	 RecoilRate=0.065000
     maxVerticalRecoilAngle=180
     maxHorizontalRecoilAngle=52
     DamageMin=25
     DamageMax=35
     bWaitForRelease=False
     FireRate=0.075000
	 ShakeRotMag=(X=40.000000,Y=40.000000,Z=150.000000)
     ShakeRotRate=(X=8000.000000,Y=8000.000000,Z=8000.000000)
     ShakeRotTime=3.000000
     ShakeOffsetMag=(X=5.000000,Y=2.500000,Z=5.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=1.250000
     Spread=0.010000
	 MaxSpread=0.050000
}
