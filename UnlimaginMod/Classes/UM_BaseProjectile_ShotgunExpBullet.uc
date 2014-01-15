//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ShotgunExpBullet
//	Parent class:	 UM_BaseProjectile_ExplosiveBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.05.2013 20:03
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ShotgunExpBullet extends UM_BaseProjectile_ExplosiveBullet
	Abstract;


defaultproperties
{
     //ImpactDamage
	 ImpactDamage=150.000000
	 HeadShotImpactDamageMult=1.250000
	 Damage=180.000000
     DamageRadius=150.000000
	 //BallisticCoefficient
	 BallisticCoefficient=0.200000
	 //Mesh
	 DrawScale=2.000000
	 DrawType=DT_StaticMesh
	 StaticMeshRef="EffectsSM.Ger_Tracer"
	 //StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 //Disintegration
	 DisintegrateChance=0.600000
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Sound Effects
	 SoundEffectsVolume=2.000000
	 //DisintegrateSoundsRef
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 //ExplodeSoundsRef
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.NadeBase.40mm_Explode01"
     ExplodeSoundsRef(1)="KF_GrenadeSnd.NadeBase.40mm_Explode02"
     ExplodeSoundsRef(2)="KF_GrenadeSnd.NadeBase.40mm_Explode03"
	 //Visual Effects
	 ExplosionVisualEffect=Class'UnlimaginMod.UM_ExpBulletExplosionEffect'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
     //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=800.000000	// Meters
}
