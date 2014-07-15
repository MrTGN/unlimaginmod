//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeHandGrenadeImpact
//	Parent class:	 UM_BaseDamType_ExplosiveProjImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.07.2013 03:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeHandGrenadeImpact extends UM_BaseDamType_ExplosiveProjImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_Weapon_HandGrenade'
	 KDamageImpulse=2000.000000
     KDeathVel=100.000000
     KDeathUpKick=20.000000
	 HumanObliterationThreshhold=0
}
