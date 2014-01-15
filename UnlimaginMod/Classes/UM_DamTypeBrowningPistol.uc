//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeBrowningPistol
//	Parent class:	 UM_BaseDamType_Handgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.08.2013 20:56
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeBrowningPistol extends UM_BaseDamType_Handgun
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.ZedekPD_BrowningPistol'
     DeathString="%k killed %o (Browning Hi-Power)."
     KDamageImpulse=2000.000000
     KDeathVel=150.000000
     KDeathUpKick=10.000000
}
