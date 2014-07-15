//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseDamType_PoisonGas
//	Parent class:	 UM_BaseWeaponDamageType
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.02.2013 03:20
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseDamType_PoisonGas extends UM_BaseWeaponDamageType
	Abstract;


defaultproperties
{
     bCheckForHeadShots=False
     DeathString="%k poisoned %o (Poison Gas)."
     FemaleSuicide="%o poisoned herself."
     MaleSuicide="%o poisoned himself."
	 bArmorStops=False
	 bLocationalHit=False
}
