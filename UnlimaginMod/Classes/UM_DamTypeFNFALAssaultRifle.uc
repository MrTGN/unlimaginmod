//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeFNFALAssaultRifle
//	Parent class:	 UM_BaseDamType_AssaultRifle
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.10.2012 22:17
//================================================================================
class UM_DamTypeFNFALAssaultRifle extends UM_BaseDamType_AssaultRifle
	Abstract;

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_FNFAL_ACOG_AssaultRifle'
     DeathString="%k killed %o (FN FAL)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=6600.000000
     KDeathVel=190.000000
     KDeathUpKick=25.000000
}
