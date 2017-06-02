//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_0000Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.04.2014 23:23
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 9.4 mm (0.38"). Pellet weight: 85 grains (5.5079 grams).
//					 6 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_0000Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.4
	 BallisticCoefficient=0.057000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=840.000000
	 MaxEffectiveRange=940.000000
	 ProjectileMass=5.508 // grams
	 MuzzleVelocity=380.000000
     HeadShotDamageMult=1.500000
	 // Damage for 6 pellets
	 Damage=48.000000
	 MomentumTransfer=62000.000000
	 HitSoundVolume=0.660000
	 DrawScale=1.122000
}
