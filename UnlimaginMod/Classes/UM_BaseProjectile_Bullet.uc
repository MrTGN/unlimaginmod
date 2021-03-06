//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_Bullet
//	Parent class:	 UM_BaseProjectile
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 26.03.2013 19:51
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Base bullet projectile class
//================================================================================
class UM_BaseProjectile_Bullet extends UM_BaseProjectile
	Abstract;

//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// Called when projectile has lost all energy
simulated function SetNoKineticEnergy()
{
	bNoKineticEnergy = True;
	ImpactDamage = 0.0;
	ImpactMomentum = 0.0;
	DestroyTrail();
	StopProjectile();
	SetPhysics(PHYS_None);
	Destroy();
}

simulated event Landed( Vector HitNormal )
{
	SetNoKineticEnergy();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // Simple not-elemental bullets don't need to take damage from something
	 bCanBeDamaged=False
	 //bEnableLogging=True
	 bAutoLifeSpan=True
	 // Ballistic calculator: http://www.ada.ru/guns/ballistic/bc/BC_pejsa.htm
	 //[block] From ROBallisticProjectile class
	 BallisticCoefficient=0.300000
     bTrueBallistics=True
     bInitialAcceleration=True
     SpeedFudgeScale=1.000000
     MinFudgeScale=0.025000
     InitialAccelerationTime=0.100000
     TossZ=0.000000
	 //[end]
	 //[block] Ballistic performance
	 Speed=0.000000
	 MaxSpeed=0.000000
	 BallisticRandRange=(Min=0.98,Max=1.02)
	 //EffectiveRange in Meters
	 EffectiveRange=500.000000
	 MaxEffectiveRange=600.000000
	 //Expansion
	 ExpansionCoefficient=1.00000	// For FMJ
	 ProjectileMass=20.0	// grams
     MuzzleVelocity=100.000000	// m/sec
	 InitialUpdateTimeDelay=0.200000
	 UpdateTimeDelay=0.100000
	 //[end]
	 HeadShotDamageMult=1.100000
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 //HitEffects
	 //You can use this varible to set new hit sound volume and radius
	 //HitSoundVolume=1.000000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //ImpactDamage
	 ImpactDamage=100.000000
	 ImpactMomentum=50000.000000
	 CullDistance=3400.000000
	 //Light
	 AmbientGlow=30		// Ambient brightness, or 255=pulsing.
	 bUnlit=True		// Lights don't affect actor.
	 //Collision
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 //Physics
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bCanRicochet=False
	 bOrientToVelocity=True
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 //LifeSpan
	 LifeSpan=8.000000
     // Style for rendering sprites, meshes.
	 Style=STY_Alpha
	 // Whether to apply ambient attenuation.
	 bFullVolume=True
}
