//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MK23Fire
//	Parent class:	 MK23Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.07.2012 23:25
//================================================================================
class UM_MK23Fire extends MK23Fire;

var		int		Burstlength;
var		float	Burstrate;
var		bool	bSetToBurst;
var		int		RoundsToFire;
var		bool	bBursting;

event ModeDoFire()
{
	//[block] Switching DamageType for the Firebug
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switching DamageType for the Firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
			DamageType = class'UnlimaginMod.UM_DamTypeMK23Inc'; //Switching DamageType
		else
			DamageType = default.DamageType; //Restoring default DamageType
	}
	//[end]

	// -- Bursting --
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
			if (KFWeapon(Weapon).MagAmmoRemaining >= Burstlength)
				RoundsToFire = BurstLength;
			else
				RoundsToFire = KFWeapon(Weapon).MagAmmoRemaining;
			SetTimer(Burstrate, True);
		}
	}
	
	Super(KFFire).ModeDoFire();
}

simulated event Timer()
{
	if (bBursting)
		ModeDoFire();
	else SetTimer(0, False);
}

defaultproperties
{
     Burstlength=3
	  Burstrate=0.100000
	  bSetToBurst=False
     maxVerticalRecoilAngle=500
     maxHorizontalRecoilAngle=100
	  DamageType=Class'KFMod.DamTypeMK23Pistol'
     DamageMin=40
     DamageMax=50
     bWaitForRelease=True
     FireRate=0.180000
     ShakeRotMag=(X=75.000000,Y=75.000000,Z=290.000000)
     ShakeRotRate=(X=10080.000000,Y=10080.000000,Z=10000.000000)
     ShakeRotTime=3.300000
     ShakeOffsetMag=(X=6.000000,Y=1.000000,Z=8.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=2.300000
     BotRefireRate=0.650000
     Spread=0.010000
	  MaxSpread=0.045000
}
