//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_00Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 11.04.2013 21:34
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: 8.38 mm (0.330"). Pellet weight: 53.8 grains (3.4862 grams).
//					 9 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_00Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.38
	 BallisticCoefficient=0.045000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=740.000000
	 MaxEffectiveRange=840.000000
	 ProjectileMass=3.4862 // grams
	 MuzzleVelocity=380.000000
	 // Damage for 8 pellets
     ImpactDamage=36.000000
	 ImpactMomentum=52800.000000
	 HitSoundVolume=0.570000
	 DrawScale=1.000000
}
