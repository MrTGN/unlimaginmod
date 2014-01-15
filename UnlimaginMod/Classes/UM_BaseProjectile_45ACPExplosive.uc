//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_45ACPExplosive
//	Parent class:	 UM_BaseProjectile_ExplosiveBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.06.2013 20:45
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_45ACPExplosive extends UM_BaseProjectile_ExplosiveBullet
	Abstract;


defaultproperties
{
     DrawScale=0.650000
	 //BallisticCoefficient
	 BallisticCoefficient=0.125000
	 //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=700.000000	// Meters
	 //Disintegration
	 DisintegrateChance=0.600000
	 ///ImpactDamage
	 ImpactDamage=30.000000
	 HeadShotImpactDamageMult=1.100000
	 ImpactDamageType=None
	 Damage=65.000000
	 DamageRadius=40.000000
	 MyDamageType=None
	 MomentumTransfer=15000.000000
	 //Sound Effects
	 SoundEffectsVolume=1.500000
	 //DisintegrateSoundsRef
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 //ExplodeSoundsRef
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.NadeBase.40mm_Explode01"
     ExplodeSoundsRef(1)="KF_GrenadeSnd.NadeBase.40mm_Explode02"
     ExplodeSoundsRef(2)="KF_GrenadeSnd.NadeBase.40mm_Explode03"
	 //Visual Effects
	 ExplosionVisualEffect=Class'UnlimaginMod.UM_SmallExpBulletExplosionEffect'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
}
