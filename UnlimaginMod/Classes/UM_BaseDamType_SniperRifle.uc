//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_SniperRifle
//	Parent class:	 UM_BaseProjectileDamageType
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.02.2013 02:49
//================================================================================
class UM_BaseDamType_SniperRifle extends UM_BaseProjectileDamageType
	Abstract;


defaultproperties
{
     HeadShotDamageMult=1.000000
	 DamageThreshold=1
     bSniperWeapon=True
     DeathString="%k put a bullet in %o's head."
     FemaleSuicide="%o shot herself in the head."
     MaleSuicide="%o shot himself in the head."
	 bArmorStops=True
     bLocationalHit=True
     bCausesBlood=True
     bRagdollBullet=True
	 bBulletHit=True
	 //7,62x51mm NATO
     KDamageImpulse=7500.000000
     KDeathVel=200.000000
     KDeathUpKick=50.000000
}
