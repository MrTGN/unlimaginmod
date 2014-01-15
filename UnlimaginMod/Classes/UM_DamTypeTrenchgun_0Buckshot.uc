//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeTrenchgun_0Buckshot
//	Parent class:	 UM_BaseDamType_Shotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.11.2012 4:35
//================================================================================
class UM_DamTypeTrenchgun_0Buckshot extends UM_BaseDamType_Shotgun
	Abstract;

defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_Trenchgun'
     DeathString="%k killed %o (Winchester Model 1897)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=9500.000000
     KDeathVel=290.000000
     KDeathUpKick=105.000000
}
