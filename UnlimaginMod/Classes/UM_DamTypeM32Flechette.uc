//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeM32Flechette
//	Parent class:	 UM_BaseDamType_Shotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.11.2012 21:28
//================================================================================
class UM_DamTypeM32Flechette extends UM_BaseDamType_Shotgun
	Abstract;

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_M32Shotgun'
     DeathString="%k killed %o (M32 Flechette Shotgun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=8600.000000
     KDeathVel=200.000000
     KDeathUpKick=100.000000
}
