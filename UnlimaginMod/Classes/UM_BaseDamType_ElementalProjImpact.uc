//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_ElementalProjImpact
//	Parent class:	 UM_BaseDamType_ProjectileImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.02.2013 04:09
//================================================================================
class UM_BaseDamType_ElementalProjImpact extends UM_BaseDamType_ProjectileImpact
	Abstract;


static function AwardDamage(KFSteamStatsAndAchievements KFStatsAndAchievements, int Amount)
{
}


defaultproperties
{
	 DamageThreshold=1
     DeathString="%k killed %o (Projectile)."
     FemaleSuicide="%o blew up."
     MaleSuicide="%o blew up."
	 bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
     bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=2250.000000
     KDeathVel=115.000000
     KDeathUpKick=5.000000
     VehicleDamageScaling=0.700000
}
