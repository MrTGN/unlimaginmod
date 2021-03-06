//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_30_06Springfield
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 18.08.2013 14:13
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Hornady 30-06 Springfield 180 gr SST
//					 Bullet diameter: 7.8 mm (.308 in). Bullet Mass: 11.664 g (180 gr)
//================================================================================
class UM_BaseProjectile_30_06Springfield extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanRicochet=True
	 ProjectileDiameter=7.8
	 BallisticCoefficient=0.480000
	 BallisticRandRange=(Min=0.96,Max=1.04)
     EffectiveRange=1100.000000
	 MaxEffectiveRange=1200.000000
	 ExpansionCoefficient=1.600000
	 ProjectileMass=11.664		//grams
	 MuzzleVelocity=860.000000		//Meter/sec
     HeadShotDamageMult=1.200000
   	 ImpactDamage=140.000000
	 ImpactMomentum=130000.000000
}
