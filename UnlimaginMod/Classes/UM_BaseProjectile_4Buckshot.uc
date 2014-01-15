//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseProjectile_4Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 27.04.2013 02:50
//������������������������������������������������������������������������������
//	Comments:		 Pellet diameter: .24" (6 mm). Pellet weight: 20.6 grains (1.3349 grams).
//					 21-27 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_4Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.034000
	 BallisticRandPercent=10.000000
	 EffectiveRange=600.000000
	 ProjectileMass=0.011347
	 MuzzleVelocity=380.000000
     PenitrationEnergyReduction=0.210000
	 // Damage for 21 pellets
     Damage=18.000000
	 MomentumTransfer=28800.000000
	 HitSoundVolume=0.310000
	 DrawScale=0.710000
}