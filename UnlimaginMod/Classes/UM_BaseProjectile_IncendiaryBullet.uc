//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_IncendiaryBullet
//	Parent class:	 UM_BaseProjectile_ElementalBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.05.2013 20:22
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_IncendiaryBullet extends UM_BaseProjectile_ElementalBullet
	Abstract;



defaultproperties
{
     bIgnoreSameClassProj=True
	 ShrapnelClass=None
	 //xEmitterTrailClasses
	 xEmitterTrailClasses(0)=Class'UnlimaginMod.UM_IncBulletTracer'
	 ///ImpactDamage
	 ImpactDamage=50.000000
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
	 SoundEffectsVolume=1.000000
	 AmbientSoundRef="KF_BaseHusk.husk_fireball_loop"
	 //DisintegrateSoundsRef
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 //ExplodeSoundsRef
	 ExplodeSoundsRef(0)="KF_EnemiesFinalSnd.Husk.Husk_FireImpact"
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.FlameImpact_Weak'
	 ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Small'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
     //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=800.000000	// Meters
	 //Light
	 LightType=LT_Steady
     LightHue=15
     LightSaturation=169
     LightBrightness=90.000000
     LightRadius=16.000000
     LightCone=16
	 AmbientGlow=254
	 bUnlit=True
}
