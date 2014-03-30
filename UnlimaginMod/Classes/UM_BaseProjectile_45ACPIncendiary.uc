//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_45ACPIncendiary
//	Parent class:	 UM_BaseProjectile_IncendiaryBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.06.2013 19:21
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_45ACPIncendiary extends UM_BaseProjectile_IncendiaryBullet
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
	 ImpactDamage=24.000000
	 HeadShotImpactDamageMult=1.100000
	 ImpactDamageType=None
	 Damage=30.000000
	 DamageRadius=40.000000
	 MyDamageType=None
	 MomentumTransfer=10000.000000
	 //Sound Effects
	 TransientSoundVolume=1.000000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.0,Radius=200.0,bUse3D=True)
	 ExplodeSound=(Ref="KF_EnemiesFinalSnd.Husk.Husk_FireImpact",Vol=1.0,Radius=200.0,bUse3D=True)
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.FlameImpact_Weak'
	 ExplosionDecal=Class'KFMod.FlameThrowerBurnMark_Small'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
}
