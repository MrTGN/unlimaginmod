//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGFragBulletB
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.09.2012 17:26
//================================================================================
class UM_KSGFragBulletB extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=1.7,Radius=250.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.ExpBullet.EB_Explode",Vol=1.7,Radius=250.0,bUse3D=True)
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeKSGFragImpact'
     ImpactDamage=40.000000
	 //MuzzleVelocity
	 MuzzleVelocity=400.000000		// m/sec
     Damage=40.000000
	 DamageRadius=50.000000
     MomentumTransfer=20000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeKSGFragBullet'
}
