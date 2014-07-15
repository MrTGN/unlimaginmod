//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeBenelliM3_TriBallBuckshot
//	Parent class:	 UM_BaseDamType_Shotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.05.2014 15:11
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_DamTypeBenelliM3_TriBallBuckshot extends UM_BaseDamType_Shotgun
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_BenelliM3Shotgun'
	 DeathString="%k killed %o (Benelli M3 Shotgun)."
     FemaleSuicide="%o shot herself in the foot."
     MaleSuicide="%o shot himself in the foot."
     KDamageImpulse=17000.000000
     KDeathVel=460.000000
     KDeathUpKick=220.000000
}
