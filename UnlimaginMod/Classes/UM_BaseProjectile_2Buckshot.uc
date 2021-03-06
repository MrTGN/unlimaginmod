//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_2Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 27.04.2013 02:29
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: 6.86 mm (0.270"). Pellet weight: 29.4 grains (1.9051 grams).
//					 15-18 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_2Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=6.86
	 BallisticCoefficient=0.037000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=590.000000
	 MaxEffectiveRange=690.000000
	 ProjectileMass=1.9051 // grams
	 MuzzleVelocity=380.000000
	 // Damage for 15 pellets
     ImpactDamage=24.000000
	 ImpactMomentum=36000.000000
	 HitSoundVolume=0.390000
	 DrawScale=0.820000
}
