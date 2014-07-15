//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DualDeagleFire
//	Parent class:	 DualDeagleFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.07.2012 22:17
//================================================================================
class UM_DualDeagleFire extends DualDeagleFire;

event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		{
			//Decreasing damages for the Firebug
			DamageMin = int(default.DamageMin * 0.75);
			DamageMax = int(default.DamageMax * 0.75);
			
			//Switching damage type
			DamageType = class'UnlimaginMod.UM_DamTypeDualDeagleInc';
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
	
	Super(DualiesFire).ModeDoFire();
}

defaultproperties
{
     maxVerticalRecoilAngle=1200
     maxHorizontalRecoilAngle=200
     DamageType=Class'KFMod.DamTypeDualDeagle'
     DamageMin=95
     DamageMax=115
     FireRate=0.130000
     Spread=0.010000
}
