//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeMagnum44Inc
//	Parent class:	 UM_BaseDamType_IncendiaryBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 20:15
//================================================================================
class UM_DamTypeMagnum44Inc extends UM_BaseDamType_IncendiaryBullet
	Abstract;

defaultproperties
{
     WeaponClass=Class'KFMod.Magnum44Pistol'
     DeathString="%k killed %o (44 Magnum)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=3500.000000
     KDeathVel=175.000000
     KDeathUpKick=15.000000
     VehicleDamageScaling=0.800000
}
