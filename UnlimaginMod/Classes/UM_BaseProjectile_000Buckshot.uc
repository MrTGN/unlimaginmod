//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_000Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 21.08.2013 17:22
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: 9.14 mm (0.360"). Pellet weight: 70 grains (4.5359 grams).
//					 8 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_000Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.14
	 BallisticCoefficient=0.050000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=810.000000
	 MaxEffectiveRange=910.000000
	 ProjectileMass=4.536 // grams
	 MuzzleVelocity=380.000000
     HeadShotDamageMult=1.500000
	 // Damage for 7 pellets
	 ImpactDamage=40.000000
	 ImpactMomentum=60000.000000
	 HitSoundVolume=0.650000
	 DrawScale=1.080000
}
