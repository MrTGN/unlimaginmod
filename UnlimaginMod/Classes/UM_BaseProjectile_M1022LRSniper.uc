//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_M1022LRSniper
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 26.05.2013 01:42
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 .50 BMG or 12.7x99mm NATO
//					 Bullet diameter: .510 in (12.95 mm). Bullet Mass: 42.443g (655 gr)
//================================================================================
class UM_BaseProjectile_M1022LRSniper extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=12.95
	 bCanRicochet=True
	 //Ballistic
	 BallisticCoefficient=0.876000
	 BallisticRandRange=(Min=0.98,Max=1.02)
	 EffectiveRange=1800.000000
	 MaxEffectiveRange=1950.000000
	 ProjectileMass=42.443		//grams
	 MuzzleVelocity=920.000000	// m/s
   	 HeadShotDamageMult=2.800000
	 ImpactDamage=720.000000
	 ImpactMomentum=150000.000000
	 HitSoundVolume=1.250000
}
