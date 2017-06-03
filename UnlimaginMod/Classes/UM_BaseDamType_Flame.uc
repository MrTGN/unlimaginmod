//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_Flame
//	Parent class:	 UM_BaseWeaponDamageType
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.02.2013 04:28
//================================================================================
class UM_BaseDamType_Flame extends UM_BaseWeaponDamageType
	Abstract;

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddFlameThrowerDamage(Amount);
}

defaultproperties
{
     // damage stats saving
	 bDealBurningDamage=True
	 //[block] Death stings
     DeathString="%k incinerated %o (Flame)."
     FemaleSuicide="%o roasted herself alive."
     MaleSuicide="%o roasted himself alive."
	 //[end]
	 FlashFog=(X=800.000000,Y=600.000000,Z=240.000000)
}
