//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_TungstenShrapnel
//	Parent class:	 UM_BaseProjectile_Shrapnel
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 27.04.2014 17:58
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Small shrapnel ball
//================================================================================
class UM_TungstenShrapnel extends UM_BaseProjectile_Shrapnel;


defaultproperties
{
     //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_TungstenBulletTracer')
	 BallisticCoefficient=0.092000
	 ProjectileDiameter=10.0
	 ProjectileMass=10.0	// grams
	 MuzzleVelocity=120.000000	// m/sec
	 // EffectiveRange in Meters
	 EffectiveRange=1000.000000
	 MaxEffectiveRange=1200.000000
	 ImpactDamage=50.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeTungstenShrapnel'
	 ImpactMomentum=64000.000000
	 HitSoundVolume=0.700000
	 DrawScale=1.125000
}
