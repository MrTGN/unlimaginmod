//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_45ACPIncendiary
//	Parent class:	 UM_BaseProjectile_IncendiaryBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.06.2013 19:21
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_45ACPIncendiary extends UM_BaseProjectile_IncendiaryBullet
	Abstract;


defaultproperties
{
     ProjectileDiameter=11.5
	 DrawScale=0.650000
	 //BallisticCoefficient
	 BallisticCoefficient=0.125000
	 //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=700.000000	// Meters
	 //Disintegration
	 DisintegrationChance=0.600000
	 ///ImpactDamage
	 ImpactDamage=24.000000
	 HeadShotDamageMult=1.100000
	 ImpactDamageType=None
	 Damage=30.000000
	 DamageRadius=40.000000
	 MyDamageType=None
	 MomentumTransfer=1000.000000
	 //Sound Effects
	 TransientSoundVolume=1.000000
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.0,Radius=220.0,bUse3D=True)
	 ExplosionSound=(Ref="KF_EnemiesFinalSnd.Husk.Husk_FireImpact",Vol=1.0,Radius=220.0,bUse3D=True)
}
