//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_00Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.04.2013 21:34
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 8.38 mm (0.330"). Pellet weight: 53.8 grains (3.4862 grams).
//					 9 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_00Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.38
	 BallisticCoefficient=0.045000
	 BallisticRandPercent=7.000000
	 EffectiveRange=740.000000
	 MaxEffectiveRange=840.000000
	 ProjectileMass=0.029633
	 MuzzleVelocity=380.000000
     PenetrationEnergyReduction=0.560000
	 // Damage for 8 pellets
     Damage=35.000000
	 MomentumTransfer=52800.000000
	 HitSoundVolume=0.570000
	 DrawScale=1.000000
}
