//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DamTypeAA12MedGas
//	Parent class:	 UM_BaseDamType_PoisonGas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.11.2012 22:20
//================================================================================
class UM_DamTypeAA12MedGas extends UM_BaseDamType_PoisonGas
	Abstract;


defaultproperties
{
	 WeaponClass=Class'UnlimaginMod.UM_AA12AutoShotgun'
     DeathString="%k poisoned %o (MedGas)."
     FemaleSuicide="%o poisoned herself."
     MaleSuicide="%o poisoned himself."
}
