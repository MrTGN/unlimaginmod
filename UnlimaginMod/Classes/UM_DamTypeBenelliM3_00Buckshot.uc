//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeBenelliM3_00Buckshot
//	Parent class:	 UM_BaseDamType_Shotgun
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 04.11.2013 19:29
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_DamTypeBenelliM3_00Buckshot extends UM_BaseDamType_Shotgun
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_BenelliM3Shotgun'
	 DeathString="%k killed %o (Benelli M3 Shotgun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=10800.000000
     KDeathVel=300.000000
     KDeathUpKick=125.000000
}
