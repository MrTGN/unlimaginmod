//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeNapalmHandGrenadeImpact
//	Parent class:	 UM_BaseDamType_IncendiaryProjImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.07.2013 21:53
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_DamTypeNapalmHandGrenadeImpact extends UM_BaseDamType_IncendiaryProjImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_Weapon_HandGrenade'
	 KDamageImpulse=2000.000000
     KDeathVel=100.000000
     KDeathUpKick=20.000000
	 HumanObliterationThreshhold=0
}
