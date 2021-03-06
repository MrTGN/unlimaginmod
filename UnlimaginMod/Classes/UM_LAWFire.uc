//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_LAWFire
//	Parent class:	 LAWFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.07.2012 20:50
//================================================================================
class UM_LAWFire extends LAWFire;

function bool AllowFire()
{
	Return ( Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
			ProjectileClass = Class'UnlimaginMod.UM_LAWNapalmProj';
		else
			ProjectileClass = default.ProjectileClass;
	}

	Super(KFShotgunFire).ModeDoFire();
}

defaultproperties
{
     CrouchedAccuracyBonus=0.100000
     maxVerticalRecoilAngle=1000
     maxHorizontalRecoilAngle=250
     ProjectileClass=Class'KFMod.LAWProj'
     Spread=0.100000
}
