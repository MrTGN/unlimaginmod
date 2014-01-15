//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeTrenchgunFragImpact
//	Parent class:	 UM_BaseDamType_12GaugeExpImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 18.11.2012 15:53
//================================================================================
class UM_DamTypeTrenchgunFragImpact extends UM_BaseDamType_12GaugeExpImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_Trenchgun'
     KDamageImpulse=2500.000000
     KDeathVel=100.000000
     KDeathUpKick=50.000000
	 HumanObliterationThreshhold=150
}