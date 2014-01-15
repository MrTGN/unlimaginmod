//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ShotgunIncBullet
//	Parent class:	 UM_BaseProjectile_IncendiaryBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.05.2013 20:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ShotgunIncBullet extends UM_BaseProjectile_IncendiaryBullet
	Abstract;


defaultproperties
{
     //ImpactDamage
	 ImpactDamage=100.000000
	 HeadShotImpactDamageMult=1.250000
	 ImpactDamageType=None
	 Damage=100.000000
	 DamageRadius=140.000000
     MomentumTransfer=10000.000000
     MyDamageType=None
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
	 AmbientSoundRef="KF_BaseHusk.husk_fireball_loop"
	 //DisintegrateSoundsRef
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 //ExplodeSoundsRef
	 ExplodeSoundsRef(0)="KF_EnemiesFinalSnd.Husk.Husk_FireImpact"
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.FlameImpact_Medium'
	 ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Medium'
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
