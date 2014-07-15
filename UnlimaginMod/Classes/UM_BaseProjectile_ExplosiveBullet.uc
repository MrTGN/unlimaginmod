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
	 HeadShotDamageMult=1.100000
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
	 TransientSoundVolume=2.000000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=200.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.ExpBullet.EB_Explode",Vol=2.0,Radius=200.0,bUse3D=True)
	 //Visual Effects
	 ExplosionVisualEffect=Class'UnlimaginMod.UM_ExpBulletExplosionEffect'
	 ExplosionDecal=Class'UnlimaginMod.UM_ExpBulletDecal'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
     //MuzzleVelocity
	 MuzzleVelocity=300.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=800.000000	// Meters
}
