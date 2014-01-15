//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_IncendiaryBullet
//	Parent class:	 UM_BaseProjectileDamageType
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.02.2013 03:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Temporary class for the old standart Killing Floor weapons
//================================================================================
class UM_BaseDamType_IncendiaryBullet extends UM_BaseProjectileDamageType
	Abstract;

static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
	KFStatsAndAchievements.AddFlameThrowerDamage(Amount);
	KFStatsAndAchievements.AddMac10BurnDamage(Amount);
}

defaultproperties
{
     // damage stats saving
	 bDealBurningDamage=True
	 //[block] Death stings
	 DeathString="%k killed %o (Incendiary Bullet)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
	 //[end]
	 //[block] Headshots
	 bCheckForHeadShots=True
	 HeadShotDamageMult=1.100000
	 //[end]
	 bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
	 bRagdollBullet=True
	 //bBulletHit=True
     // magnitude of impulse applied to KActor due to this damage type.
	 KDamageImpulse=1600.000000
	 // How fast ragdoll moves upon death
     KDeathVel=150.000000
	 // Amount of upwards kick ragdolls get when they die
     KDeathUpKick=5.000000
	 // Add extra Z to momentum on walking pawns
     bExtraMomentumZ=False
}
