//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeBouncingGrenadeShrapnel
//	Parent class:	 UM_BaseDamType_Shotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.11.2012 23:46
//================================================================================
class UM_DamTypeBouncingGrenadeShrapnel extends UM_BaseDamType_Shotgun
	Abstract;

defaultproperties
{
     WeaponClass=Class'KFMod.NailGun'
	 //WeaponClass=Class'UnlimaginMod.UM_Weapon_HandGrenade'
     DeathString="%o filled %k's body with shrapnel."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=8000.000000
     KDeathVel=280.000000
     KDeathUpKick=100.000000
}
