//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_45ACPExplosive
//	Parent class:	 UM_BaseProjectile_ExplosiveBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.06.2013 20:45
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
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
	 TransientSoundVolume=1.500000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.6,Radius=220.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.ExpBullet.EB_Explode",Vol=1.6,Radius=220.0,bUse3D=True)
	 //Visual Effects
	 ExplosionVisualEffect=Class'UnlimaginMod.UM_SmallExpBulletExplosionEffect'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
}
