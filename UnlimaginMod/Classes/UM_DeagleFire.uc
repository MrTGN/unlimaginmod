//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DeagleFire
//	Parent class:	 DeagleFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.07.2012 22:18
//================================================================================
class UM_DeagleFire extends DeagleFire;

event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		{
			//Decreasing damages for the Firebug
			DamageMin = int(default.DamageMin * 0.75);
			DamageMax = int(default.DamageMax * 0.75);
			
			//Switching damage type
			DamageType = class'UnlimaginMod.UM_DamTypeDeagleInc';
		}
		else
		{
			//Restoring default damages for the other skills
			DamageMin = default.DamageMin;
			DamageMax = default.DamageMax;
			
			//Restoring default damage type
			DamageType = default.DamageType;
		}
	}

	Super(KFFire).ModeDoFire();
}

defaultproperties
{
     maxVerticalRecoilAngle=1200
     maxHorizontalRecoilAngle=200
     DamageType=Class'KFMod.DamTypeDeagle'
     DamageMin=95
     DamageMax=115
     FireRate=0.250000
     Spread=0.010000
}
