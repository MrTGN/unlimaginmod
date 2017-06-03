//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_DamTypeAA12MedGasImpact
//	Parent class:	 UM_BaseDamType_ElementalProjImpact
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.11.2012 22:22
//================================================================================
class UM_DamTypeAA12MedGasImpact extends UM_BaseDamType_ElementalProjImpact
	Abstract;


defaultproperties
{
     WeaponClass=Class'UnlimaginMod.UM_AA12AutoShotgun'
     DeathString="%k poisoned %o (MedGas)."
     FemaleSuicide="%o poisoned herself."
     MaleSuicide="%o poisoned himself."
     KDamageImpulse=2400.000000
     KDeathVel=100.000000
     KDeathUpKick=50.000000
}