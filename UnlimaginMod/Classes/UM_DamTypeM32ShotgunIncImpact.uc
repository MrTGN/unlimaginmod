//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeM32ShotgunIncImpact
//	Parent class:	 UM_BaseDamType_12GaugeIncImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 28.12.2012 23:35
//================================================================================
class UM_DamTypeM32ShotgunIncImpact extends UM_BaseDamType_12GaugeIncImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_M32Shotgun'
     KDamageImpulse=2000.000000
     KDeathVel=100.000000
     KDeathUpKick=50.000000
     HumanObliterationThreshhold=120
}