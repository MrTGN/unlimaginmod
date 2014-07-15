//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeM203M381GrenadeImpact
//	Parent class:	 UM_BaseDamType_ExplosiveProjImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 03.04.2014 21:21
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeM203M381GrenadeImpact extends UM_BaseDamType_ExplosiveProjImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_M4203AssaultRifle'
	 KDamageImpulse=2500.000000
     KDeathVel=140.000000
     KDeathUpKick=20.000000
	 HumanObliterationThreshhold=0
}
