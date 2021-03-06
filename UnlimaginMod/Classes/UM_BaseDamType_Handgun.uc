//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_Handgun
//	Parent class:	 UM_BaseDamType_ProjectileImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.02.2013 02:59
//================================================================================
class UM_BaseDamType_Handgun extends UM_BaseDamType_ProjectileImpact
	Abstract;

defaultproperties
{
     bSniperWeapon=True
	 DamageThreshold=1
     DeathString="%k killed %o (Handgun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
	 bRagdollBullet=True
     bBulletHit=True
     FlashFog=(X=600.000000)
	 //9x19mm
     KDamageImpulse=750.000000
     KDeathVel=100.000000
     VehicleDamageScaling=0.700000
}
