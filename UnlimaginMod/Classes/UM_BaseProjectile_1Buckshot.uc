//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_BaseProjectile_1Buckshot
//	Parent class:	 UM_BaseProjectile_Buckshot
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 27.04.2013 02:19
//������������������������������������������������������������������������������
//	Comments:		 Pellet diameter: .30" (7.6 mm). Pellet weight: 40 grains (2.5920 grams).
//					 10-15 pellets in buckshot shell.
//					 ProjectileMass increased by 8.5 to save buckshot penetration.
//================================================================================
class UM_BaseProjectile_1Buckshot extends UM_BaseProjectile_Buckshot
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.041000
	 BallisticRandPercent=8.000000
	 EffectiveRange=760.000000
	 ProjectileMass=0.022032
	 MuzzleVelocity=380.000000
     PenitrationEnergyReduction=0.420000
	 // Damage for 10 pellets
     Damage=30.000000
	 MomentumTransfer=43200.000000
	 HitSoundVolume=0.470000
	 DrawScale=0.900000
}