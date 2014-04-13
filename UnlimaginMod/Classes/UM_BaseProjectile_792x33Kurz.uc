//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_792x33Kurz
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.06.2013 14:19
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 7.92x33mm Kurz Ball
//					 Bullet diameter: 8.2 mm (0.32 in). Bullet Mass: 8.1 g (125 gr)
//================================================================================
class UM_BaseProjectile_792x33Kurz extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=8.2
	 BallisticCoefficient=0.345000
	 BallisticRandPercent=7.000000
	 EffectiveRange=1400.000000
	 ProjectileMass=0.008100		//kilograms
	 MuzzleVelocity=685.000000		//Meter/sec
     PenetrationEnergyReduction=0.400000
     HeadShotDamageMult=1.100000
   	 Damage=66.000000
	 MomentumTransfer=70000.000000
	 HitSoundVolume=0.850000
}
