//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeM99HeadShot
//	Parent class:	 UM_DamTypeM99SniperRifle
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.10.2012 22:59
//================================================================================
class UM_DamTypeM99HeadShot extends UM_DamTypeM99SniperRifle
	Abstract;

/*static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if ( KFStatsAndAchievements != None && UM_BaseMonster_Scrake(Killed) != None )
		KFStatsAndAchievements.AddM99Kill();
}*/

defaultproperties
{
     DeathString="%�%k put an bullet %o's head."
     FlashFog=(X=600.000000)
     VehicleDamageScaling=0.650000
}
