//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseWeaponDamageType
//	Parent class:	 KFWeaponDamageType
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 28.06.2013 11:38
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseWeaponDamageType extends KFWeaponDamageType
	Abstract;

//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
	 bDirectDamage=True
	 bCheckForHeadShots=False
	 HeadShotDamageMult=1.0
	 bArmorStops=False // does regular armor provide protection against this damage
	 bInstantHit=False // done by trace hit weapon
	 bFastInstantHit=False // done by fast repeating trace hit weapon
     bLocationalHit=False
     bCausesBlood=False
     bExtraMomentumZ=False
}
