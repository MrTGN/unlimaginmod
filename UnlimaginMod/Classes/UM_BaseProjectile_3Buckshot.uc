//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_3Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 27.04.2013 02:43
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Pellet diameter: .25" (6.4 mm). Pellet weight: 23.4 grains (1.5163 grams).
//					 18-20 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_3Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.034000
	 BallisticRandPercent=9.000000
	 EffectiveRange=640.000000
	 ProjectileMass=0.012889
	 MuzzleVelocity=380.000000
     PenitrationEnergyReduction=0.240000
	 // Damage for 18 pellets
     Damage=20.000000
	 MomentumTransfer=31200.000000
	 HitSoundVolume=0.340000
	 DrawScale=0.760000
}
