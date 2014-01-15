//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeKSGFragImpact
//	Parent class:	 UM_BaseDamType_12GaugeExpImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.10.2012 18:51
//================================================================================
class UM_DamTypeKSGFragImpact extends UM_BaseDamType_12GaugeExpImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_KSGShotgun'
     KDamageImpulse=2800.000000
     KDeathVel=100.000000
     KDeathUpKick=80.000000
	 HumanObliterationThreshhold=180
}