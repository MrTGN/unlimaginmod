//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_BattleRifle
//	Parent class:	 UM_BaseDamType_ProjectileImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.02.2013 02:51
//================================================================================
class UM_BaseDamType_BattleRifle extends UM_BaseDamType_ProjectileImpact
	Abstract;

defaultproperties
{
	 DamageThreshold=1
     bSniperWeapon=True
     DeathString="%k killed %o (BattleRifle)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
	 bRagdollBullet=True
	 bBulletHit=True
	 //7,62x54mm
     KDamageImpulse=7500.000000
     KDeathVel=175.000000
     KDeathUpKick=25.000000
}
