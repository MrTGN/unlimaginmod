//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_9x19P_Speer124JHP
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 13.05.2013 22:29
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 9x19mm Parabellum Speer Gold Dot JHP +P
//					 Bullet diameter: 9.01 mm (0.355 in). Bullet Mass: 8.0 g (124 gr)
//================================================================================
class UM_BaseProjectile_9x19P_Speer124JHP extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=9.01
	 BallisticCoefficient=0.184000
	 BallisticRandPercent=10.000000
	 EffectiveRange=800.000000
	 ExpansionCoefficient=1.860000
	 ProjectileMass=0.008000		//kilograms
	 MuzzleVelocity=400.000000		//Meter/sec
     PenetrationEnergyReduction=0.100000
     HeadShotDamageMult=1.200000
   	 Damage=36.000000
	 MomentumTransfer=24000.000000
	 HitSoundVolume=0.600000
}
