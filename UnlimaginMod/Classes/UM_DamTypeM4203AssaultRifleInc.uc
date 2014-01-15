//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeM4203AssaultRifleInc
//	Parent class:	 UM_BaseDamType_IncendiaryBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.09.2012 18:45
//================================================================================
class UM_DamTypeM4203AssaultRifleInc extends UM_BaseDamType_IncendiaryBullet
	Abstract;

defaultproperties
{
     //WeaponClass=Class'UnlimaginMod.UM_M4203AssaultRifle'
	 WeaponClass=Class'UnlimaginMod.UM_M4203AssaultRifle'
     DeathString="%k killed %o (M4 203)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=1500.000000
     KDeathVel=115.000000
     KDeathUpKick=3.000000
}
