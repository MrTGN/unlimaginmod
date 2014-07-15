//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeProtectaIncImpact
//	Parent class:	 UM_BaseDamType_12GaugeIncImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 03.11.2013 15:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeProtectaIncImpact extends UM_BaseDamType_12GaugeIncImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.OperationY_ProtectaShotgun'
     KDamageImpulse=1600.000000
     KDeathVel=80.000000
     KDeathUpKick=40.000000
     HumanObliterationThreshhold=120
}
