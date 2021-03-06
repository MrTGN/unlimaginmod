//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseDamType_BouncingBall
//	Parent class:	 UM_BaseDamType_ProjectileImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 11.08.2013 05:31
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseDamType_BouncingBall extends UM_BaseDamType_ProjectileImpact
	Abstract;


defaultproperties
{
     bIsMeleeDamage=True
	 DeathString="%k killed %o (Fucking Ball!)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
	 bExtraMomentumZ=True
	 bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
	 bRagdollBullet=True
	 DamageThreshold=1
	 bBulletHit=True
     FlashFog=(X=600.000000)
     KDamageImpulse=12000.000000
     KDeathVel=300.000000
     KDeathUpKick=200.000000
     VehicleDamageScaling=0.700000
}
