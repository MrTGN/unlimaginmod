//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeM4AssaultRifle
//	Parent class:	 UM_BaseDamType_AssaultRifle
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.10.2012 22:12
//================================================================================
class UM_DamTypeM4AssaultRifle extends UM_BaseDamType_AssaultRifle
	Abstract;

defaultproperties
{
	 WeaponClass=Class'UnlimaginMod.UM_M4AssaultRifle'
     DeathString="%k killed %o (M4)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=1500.000000
     KDeathVel=115.000000
     KDeathUpKick=2.000000
}
