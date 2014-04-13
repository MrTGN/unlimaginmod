//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_000Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 21.08.2013 17:22
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 9.14 mm (0.360"). Pellet weight: 70 grains (4.5359 grams).
//					 8 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_000Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.14
	 BallisticCoefficient=0.050000
	 BallisticRandPercent=6.000000
	 EffectiveRange=910.000000
	 MaxEffectiveRangeScale=1.000000
	 ProjectileMass=0.038554
	 MuzzleVelocity=380.000000
     PenetrationEnergyReduction=0.720000
     HeadShotDamageMult=1.500000
	 // Damage for 7 pellets
	 Damage=40.000000
	 MomentumTransfer=60000.000000
	 HitSoundVolume=0.650000
	 DrawScale=1.080000
}
