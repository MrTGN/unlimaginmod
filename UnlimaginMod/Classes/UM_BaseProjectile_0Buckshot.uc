//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_0Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.04.2013 22:43
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: 8.13 mm (0.320"). Pellet weight: 49 grains (3.1751 grams).
//					 9-12 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_0Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.13
	 BallisticCoefficient=0.044000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=710.000000
	 MaxEffectiveRange=810.000000
	 ProjectileMass=3.1751 // grams
	 MuzzleVelocity=380.000000
	 // Damage for 9 pellets
     ImpactDamage=33.000000
	 ImpactMomentum=48000.000000
	 HitSoundVolume=0.520000
	 DrawScale=0.960000
}
