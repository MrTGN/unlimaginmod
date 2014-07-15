//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeProtectaFragImpact
//	Parent class:	 UM_BaseDamType_12GaugeExpImpact
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 03.11.2013 15:45
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeProtectaFragImpact extends UM_BaseDamType_12GaugeExpImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.OperationY_ProtectaShotgun'
     KDamageImpulse=2000.000000
     KDeathVel=80.000000
     KDeathUpKick=40.000000
	 HumanObliterationThreshhold=120
}
