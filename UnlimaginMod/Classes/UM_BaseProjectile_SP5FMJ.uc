//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_SP5FMJ
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 01.05.2013 19:13
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 9x39mm SP-5 (7N8) FMJ sniper bullet
//					 Bullet diameter: 9.25 mm (0.364173 in). Bullet Mass: 16.1 g (248.46 gr)
//================================================================================
class UM_BaseProjectile_SP5FMJ extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.25
	 BallisticCoefficient=0.557000
	 BallisticRandRange=(Min=0.97,Max=1.03)
	 EffectiveRange=700.000000
	 MaxEffectiveRange=800.000000
	 ProjectileMass=16.1		//grams
	 MuzzleVelocity=290.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 ImpactDamage=60.000000
	 ImpactMomentum=80000.000000
	 HitSoundVolume=0.900000
}
