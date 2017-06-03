//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_MachineGun
//	Parent class:	 UM_BaseDamType_ProjectileImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.02.2013 01:31
//================================================================================
class UM_BaseDamType_MachineGun extends UM_BaseDamType_ProjectileImpact
	Abstract;

static function AwardKill(KFSteamStatsAndAchievements KFStatsAndAchievements, KFPlayerController Killer, KFMonster Killed )
{
	if ( UM_BaseMonster_Stalker(Killed) != None )
		KFStatsAndAchievements.AddStalkerKill();
}

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddBullpupDamage(Amount);
}

defaultproperties
{
     DamageThreshold=1
	 DeathString="%k killed %o (MachineGun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
	 bRagdollBullet=True
	 bBulletHit=True
	 //7,62x54mm
     KDamageImpulse=5500.000000
     KDeathVel=175.000000
     KDeathUpKick=20.000000
}
