//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeMoss12IncImpact
//	Parent class:	 UM_BaseDamType_12GaugeIncImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.03.2013 19:12
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeMoss12IncImpact extends UM_BaseDamType_12GaugeIncImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.Hemi_Braindead_Moss12Shotgun'
     KDamageImpulse=2500.000000
     KDeathVel=100.000000
     KDeathUpKick=60.000000
     HumanObliterationThreshhold=150
}
