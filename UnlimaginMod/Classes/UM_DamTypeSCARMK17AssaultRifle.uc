//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeSCARMK17AssaultRifle
//	Parent class:	 UM_BaseDamType_AssaultRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 22:19
//================================================================================
class UM_DamTypeSCARMK17AssaultRifle extends UM_BaseDamType_AssaultRifle
	Abstract;


defaultproperties
{
     HeadShotDamageMult=1.000000
	 WeaponClass=Class'UnlimaginMod.UM_SCARMK17AssaultRifle'
     DeathString="%k killed %o (SCARMK17)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=8500.000000
     KDeathVel=190.000000
     KDeathUpKick=20.000000
}
