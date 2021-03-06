//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_4Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 27.04.2013 02:50
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: 6.09 mm (0.240"). Pellet weight: 20.7 grains (1.3413 grams).
//					 21-27 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_4Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=6.09
	 BallisticCoefficient=0.033000
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 EffectiveRange=500.000000
	 MaxEffectiveRange=600.000000
	 ProjectileMass=1.3413 // grams
	 MuzzleVelocity=380.000000
	 // Damage for 21 pellets
     ImpactDamage=20.000000
	 ImpactMomentum=28800.000000
	 HitSoundVolume=0.310000
	 DrawScale=0.710000
}
