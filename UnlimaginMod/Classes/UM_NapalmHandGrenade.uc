//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_NapalmHandGrenade
//	Parent class:	 UM_BaseProjectile_HandGrenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.07.2013 21:35
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_NapalmHandGrenade extends UM_BaseProjectile_HandGrenade;


defaultproperties
{
     ShrapnelClass=None
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFIncendiaryExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //Sounds
	 TransientSoundVolume=2.200000
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplosionSound=(Ref="KF_GrenadeSnd.FlameNade_Explode",Vol=3.0,Radius=400.0,bUse3D=True)
	 //Damage
     Damage=80.000000
     DamageRadius=420.000000
	 MomentumTransfer=10000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeNapalmHandGrenade'
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeNapalmHandGrenadeImpact'
}
