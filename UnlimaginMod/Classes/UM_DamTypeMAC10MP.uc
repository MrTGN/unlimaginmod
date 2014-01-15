//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeMAC10MP
//	Parent class:	 UM_BaseDamType_SMG
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 14:25
//================================================================================
class UM_DamTypeMAC10MP extends UM_BaseDamType_SMG
	Abstract;

defaultproperties
{
	 WeaponClass=Class'UnlimaginMod.UM_MAC10MP'
     DeathString="%k killed %o (MAC-10)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=1850.000000
     KDeathVel=150.000000
     KDeathUpKick=5.000000
}
