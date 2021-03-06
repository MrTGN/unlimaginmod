//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_SS190APFMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 16:18
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 FN 5.7x28mm SS190 AP FMJ
//					 Bullet diameter: 5.7 mm (0.224 in). Bullet Mass: 31 gr (2 g)
//================================================================================
class UM_BaseProjectile_SS190APFMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=5.7
	 BallisticCoefficient=0.154000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=720.000000
	 MaxEffectiveRange=780.000000
	 ProjectileMass=2.0		//grams
	 MuzzleVelocity=710.000000		//Meter/sec
     HeadShotDamageMult=1.100000
   	 ImpactDamage=40.000000
	 ImpactMomentum=25000.000000
	 HitSoundVolume=0.500000
}
