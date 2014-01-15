//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeM99HeadShot
//	Parent class:	 UM_DamTypeM99SniperRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 22:59
//================================================================================
class UM_DamTypeM99HeadShot extends UM_DamTypeM99SniperRifle
	Abstract;

/*static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if ( KFStatsAndAchievements != none )
	{
		if ( Killed.IsA('ZombieScrake') || Killed.IsA('UM_ZombieScrake'))
		{
			KFStatsAndAchievements.AddM99Kill();
		}
	}
}*/

defaultproperties
{
     DeathString="%ÿ%k put an bullet %o's head."
     FlashFog=(X=600.000000)
     VehicleDamageScaling=0.650000
}
