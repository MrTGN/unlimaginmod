//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeAA12IncImpact
//	Parent class:	 UM_BaseDamType_12GaugeIncImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.10.2012 19:07
//================================================================================
class UM_DamTypeAA12IncImpact extends UM_BaseDamType_12GaugeIncImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_AA12AutoShotgun'
     DeathString="%k killed %o (IncBullet Impact)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=2400.000000
     KDeathVel=100.000000
     KDeathUpKick=50.000000
	 HumanObliterationThreshhold=140
}