//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_M80FMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 16:35
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 7.62x51mm NATO M80 FMJ
//					 Bullet diameter: 7.82 mm (0.308 in). Bullet Mass: 9.5254 g (147 gr)
//================================================================================
class UM_BaseProjectile_M80FMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     BallisticCoefficient=0.431000
	 BallisticRandPercent=6.000000
	 EffectiveRange=1400.000000
	 ProjectileMass=0.009525		//kilograms
	 MuzzleVelocity=830.000000		//Meter/sec
     PenetrationEnergyReduction=0.400000
     HeadShotDamageMult=1.100000
   	 Damage=105.000000
	 MomentumTransfer=80000.000000
	 HitSoundVolume=0.800000
}
