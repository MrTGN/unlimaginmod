//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_40SW_H180XTP
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.08.2013 20:11
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Hornady 40 S&W 180 gr XTP
//					 Bullet diameter: 10 mm (.4 in). Bullet Mass: 11.664 g (180 gr)
//================================================================================
class UM_BaseProjectile_40SW_H180XTP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=10.0
	 BallisticCoefficient=0.164000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=800.000000
	 MaxEffectiveRange=900.000000
	 ExpansionCoefficient=1.760000
	 ProjectileMass=11.664		//grams
	 // Barrel > 4"
	 MuzzleVelocity=295.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 ImpactDamage=42.500000
	 ImpactMomentum=30500.000000
	 HitSoundVolume=0.700000
}
