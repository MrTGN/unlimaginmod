//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ExplosiveBullet
//	Parent class:	 UM_BaseProjectile_ElementalBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.05.2013 21:39
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ExplosiveBullet extends UM_BaseProjectile_ElementalBullet
	Abstract;



defaultproperties
{
     bIgnoreSameClassProj=True
	 ShrapnelClass=None
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 HeadShotImpactDamageMult=1.100000
	 //StaticMesh
	 DrawScale=1.000000
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
