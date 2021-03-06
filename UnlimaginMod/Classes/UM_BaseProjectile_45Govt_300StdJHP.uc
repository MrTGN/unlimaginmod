//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_45Govt_300StdJHP
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 20.04.2013 16:42
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 .45-70 Government Standard Remingtonｮ Expressｮ 300 JHP
//					 Bullet diameter: .458 in (11.6 mm). Bullet Mass: 19.440 g (300 gr)
//================================================================================
class UM_BaseProjectile_45Govt_300StdJHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanRicochet=True
	 ProjectileDiameter=11.6
	 BallisticCoefficient=0.300000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=950.000000
	 MaxEffectiveRange=1000.000000
	 ExpansionCoefficient=1.700000
	 ProjectileMass=19.44		//grams
	 MuzzleVelocity=630.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 ImpactDamage=180.000000
	 ImpactMomentum=140000.000000
}
