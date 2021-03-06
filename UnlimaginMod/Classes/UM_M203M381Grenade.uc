//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_M203M381Grenade
//	Parent class:	 UM_BaseProjectile_M381Grenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 03.04.2014 21:02
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_M203M381Grenade extends UM_BaseProjectile_M381Grenade;


defaultproperties
{
     MuzzleVelocity=65.000000	//m/s
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=360.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=360.0,bUse3D=True)
     //Damages
     Damage=350.000000
     DamageRadius=390.000000
	 MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM203M381Grenade'
	 ImpactDamage=120.000000
	 ImpactMomentum=10000.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeM203M381GrenadeImpact'
}
