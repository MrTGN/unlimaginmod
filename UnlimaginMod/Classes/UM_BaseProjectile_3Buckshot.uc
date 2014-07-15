//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_3Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 27.04.2013 02:43
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 6.35 mm (0.250"). Pellet weight: 23.4 grains (1.5163 grams).
//					 18-20 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_3Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=6.35
	 BallisticCoefficient=0.034000
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 EffectiveRange=540.000000
	 MaxEffectiveRange=640.000000
	 ProjectileMass=0.001516
	 MuzzleVelocity=380.000000
	 // Damage for 18 pellets
     Damage=22.000000
	 MomentumTransfer=31200.000000
	 HitSoundVolume=0.340000
	 DrawScale=0.760000
}
