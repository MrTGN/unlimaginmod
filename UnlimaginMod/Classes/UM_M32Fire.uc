//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_M32Fire
//	Parent class:	 M32Fire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.07.2012 3:02
//================================================================================
class UM_M32Fire extends M32Fire;

event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
			ProjectileClass = Class'UnlimaginMod.UM_M32NapalmGrenadeProj';
		else
			ProjectileClass = default.ProjectileClass;
	}

	Super(KFShotgunFire).ModeDoFire();
}

defaultproperties
{
     EffectiveRange=2500.000000
     maxVerticalRecoilAngle=200
     maxHorizontalRecoilAngle=50
	  ProjectileClass=Class'KFMod.M32GrenadeProjectile'
     Spread=0.015000
}
