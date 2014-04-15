//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_0Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.04.2013 22:43
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 8.13 mm (0.320"). Pellet weight: 49 grains (3.1751 grams).
//					 9-12 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_0Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.13
	 BallisticCoefficient=0.044000
	 BallisticRandPercent=7.400000
	 EffectiveRange=710.000000
	 MaxEffectiveRange=810.000000
	 ProjectileMass=0.026988
	 MuzzleVelocity=380.000000
     PenetrationEnergyReduction=0.510000
	 // Damage for 9 pellets
     Damage=32.000000
	 MomentumTransfer=48000.000000
	 HitSoundVolume=0.520000
	 DrawScale=0.960000
}
