//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Beretta93MAFire
//	Parent class:	 SingleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 29.06.2012 20:50
//================================================================================
class UM_Beretta93MAFire extends SingleFire;

event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
			DamageType = class'UnlimaginMod.UM_DamTypeBeretta93MAInc';
		else
			DamageType = default.DamageType;
	}
	
	Super(KFFire).ModeDoFire();
}

function StartSuperBerserk()
{

}
 
defaultproperties
{
     FireLoopAnim="Fire"
	 RecoilRate=0.065000
     maxVerticalRecoilAngle=175
     maxHorizontalRecoilAngle=50
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
