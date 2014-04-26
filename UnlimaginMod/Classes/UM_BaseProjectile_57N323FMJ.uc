//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_57N323FMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 18:35
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 7.62x54mmR 57-N-323 FMJ
//					 Bullet diameter: 7.92 mm (0.312 in). Bullet Mass: 9.6 g (148.15 gr)
//================================================================================
class UM_BaseProjectile_57N323FMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=7.92
	 BallisticCoefficient=0.425000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=1500.000000
	 MaxEffectiveRange=1600.000000
	 ProjectileMass=0.009600		//kilograms
	 MuzzleVelocity=820.000000		//Meter/sec
     PenetrationEnergyReduction=0.420000
     HeadShotDamageMult=1.100000
   	 Damage=110.000000
	 MomentumTransfer=80000.000000
	 HitSoundVolume=0.900000
}
