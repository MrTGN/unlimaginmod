//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Magnum44Fire
//	Parent class:	 Magnum44Fire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2012 18:00
//================================================================================
class UM_Magnum44Fire extends Magnum44Fire;

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
			DamageType = class'UnlimaginMod.UM_DamTypeMagnum44Inc';
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
     maxVerticalRecoilAngle=600
     maxHorizontalRecoilAngle=100
	  DamageType=Class'KFMod.DamTypeMagnum44Pistol'
     DamageMin=85
     DamageMax=95
     FireRate=0.150000
     Spread=0.008000
	  MaxSpread=0.012000
}
