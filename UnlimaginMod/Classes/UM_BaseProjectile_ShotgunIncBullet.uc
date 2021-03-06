//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_ShotgunIncBullet
//	Parent class:	 UM_BaseProjectile_IncendiaryBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.05.2013 20:30
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ShotgunIncBullet extends UM_BaseProjectile_IncendiaryBullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=18.5
	 //ImpactDamage
	 ImpactDamage=100.000000
	 HeadShotDamageMult=1.250000
	 ImpactDamageType=None
	 Damage=100.000000
	 DamageRadius=140.000000
     MomentumTransfer=1000.000000
     MyDamageType=None
	 //BallisticCoefficient
	 BallisticCoefficient=0.200000
	 //Mesh
	 DrawScale=2.000000
	 DrawType=DT_StaticMesh
	 StaticMeshRef="EffectsSM.Ger_Tracer"
	 //StaticMesh=StaticMesh'kf_generic_sm.Shotgun_Pellet'
	 //Disintegration
	 DisintegrationChance=0.600000
	 DisintegrationDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrationDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrationDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Sound Effects
	 TransientSoundVolume=2.000000
	 AmbientSoundRef="KF_BaseHusk.husk_fireball_loop"
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.8,Radius=250.0,bUse3D=True)
	 ExplosionSound=(Ref="KF_EnemiesFinalSnd.Husk.Husk_FireImpact",Vol=1.8,Radius=250.0,bUse3D=True)
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
