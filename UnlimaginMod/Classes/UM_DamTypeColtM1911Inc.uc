//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeColtM1911Inc
//	Parent class:	 UM_BaseDamType_IncendiaryBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.03.2013 18:00
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_DamTypeColtM1911Inc extends UM_BaseDamType_IncendiaryBullet
	Abstract;

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.Whisky_ColtM1911Pistol'
	 DeathString="%k killed %o with Colt M1911."
	 KDamageImpulse=1800.000000
	 KDeathVel=140.000000
	 KDeathUpKick=5.000000
     VehicleDamageScaling=0.800000
}
