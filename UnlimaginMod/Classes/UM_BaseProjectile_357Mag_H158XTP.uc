//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_357Mag_H158XTP
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 23.08.2013 21:54
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Hornady 357 Mag 158 gr XTP
//					 Bullet diameter: 9.1 mm (.357 in). Bullet Mass: 10.238 g (158 gr)
//================================================================================
class UM_BaseProjectile_357Mag_H158XTP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
	 ProjectileDiameter=9.1
	 BallisticCoefficient=0.206000
	 BallisticRandRange=(Min=0.95,Max=1.05)
	 EffectiveRange=900.000000
	 MaxEffectiveRange=1000.000000
	 ExpansionCoefficient=1.500000
	 ProjectileMass=10.238		//grams
	 MuzzleVelocity=380.000000		//Meter/sec
     HeadShotDamageMult=1.200000
   	 ImpactDamage=43.000000
	 ImpactMomentum=28000.000000
	 HitSoundVolume=0.700000
}
