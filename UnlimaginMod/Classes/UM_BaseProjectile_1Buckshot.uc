//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_1Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 27.04.2013 02:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 7.62 mm (0.300"). Pellet weight: 40.5 grains (2.6244 grams).
//					 10-15 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_1Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=7.62
	 BallisticCoefficient=0.041000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=660.000000
	 MaxEffectiveRange=760.000000
	 ProjectileMass=0.002624
	 MuzzleVelocity=380.000000
	 // Damage for 10 pellets
     Damage=30.000000
	 MomentumTransfer=43200.000000
	 HitSoundVolume=0.470000
	 DrawScale=0.900000
}
