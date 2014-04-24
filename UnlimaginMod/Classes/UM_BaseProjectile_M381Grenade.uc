//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_M381Grenade
//	Parent class:	 UM_BaseProjectile_LowVelocityGrenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 03.04.2014 19:26
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 http://www.inetres.com/gp/military/infantry/grenade/40mm_ammo.html
//================================================================================
class UM_BaseProjectile_M381Grenade extends UM_BaseProjectile_LowVelocityGrenade
	Abstract;


//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	Super.CalcDefaultProperties();
	
}

simulated event PostBeginPlay()
{
	
	Super.PostBeginPlay();
}

// Detonator is armed
simulated function bool IsArmed()
{
	if ( (Instigator != None && VSizeSquared(Instigator.Location - Location) < ArmingRange) )
		Return False;
	
	Return Super.IsArmed();
}

//[end] Functions
//====================================================================

defaultproperties
{
     BallisticCoefficient=0.132000
	 ProjectileDiameter=40.0
	 ArmingRange=5.000000
	 //Shrapnel
	 ShrapnelClass=None
	 DisintegrateChance=0.950000
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_PanzerfaustTrail',EmitterRotation=(Pitch=32768))
	 ProjectileMass=0.230000	// kilograms
	 //EffectiveRange in Meters
	 EffectiveRange=120.000000
	 MaxEffectiveRange=300.000000
	 MuzzleVelocity=70.000000	//m/s
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=360.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=360.0,bUse3D=True)
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //DisintegrateDamageTypes
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //StaticMesh
     DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'kf_generic_sm.40mm_Warhead'
	 //Collision
	 bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
	 CollisionRadius=1.000000
     CollisionHeight=2.000000
	 //DrawScale
     DrawScale=2.000000
}
