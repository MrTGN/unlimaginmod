//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_TriBallBuckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.04.2014 23:29
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Pellet diameter: 15.24 mm (0.60"). Pellet weight: 315 grains (20.412 grams).
//					 3 pellets in buckshot shell.
//================================================================================
class UM_BaseProjectile_TriBallBuckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     bCanRicochet=True
	 ProjectileDiameter=15.24
	 BallisticCoefficient=0.081000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=1400.000000
	 MaxEffectiveRange=1500.000000
	 ProjectileMass=20.412 // grams
	 MuzzleVelocity=380.000000
     HeadShotDamageMult=1.500000
	 // Damage for 3 pellets
	 Damage=94.000000
	 MomentumTransfer=70000.000000
	 HitSoundVolume=0.750000
	 DrawScale=1.820000
}
