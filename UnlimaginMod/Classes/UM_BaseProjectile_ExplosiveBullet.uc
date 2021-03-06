//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_ExplosiveBullet
//	Parent class:	 UM_BaseProjectile_ElementalBullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 24.05.2013 21:39
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ExplosiveBullet extends UM_BaseProjectile_ElementalBullet
	Abstract;


defaultproperties
{
     bCanHurtSameTypeProjectile=False
	 ShrapnelClass=None
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 HeadShotDamageMult=1.100000
	 //StaticMesh
	 DrawScale=1.000000
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
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=200.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.ExpBullet.EB_Explode",Vol=2.0,Radius=200.0,bUse3D=True)
	 //Visual Effects
	 ExplosionVisualEffect=Class'UnlimaginMod.UM_ExpBulletExplosionEffect'
	 ExplosionDecal=Class'UnlimaginMod.UM_ExpBulletDecal'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
     //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=800.000000	// Meters
}
