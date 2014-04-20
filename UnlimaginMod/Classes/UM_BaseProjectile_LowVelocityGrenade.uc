//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_LowVelocityGrenade
//	Parent class:	 UM_BaseExplosiveProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 21:23
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_LowVelocityGrenade extends UM_BaseExplosiveProjectile
	Abstract;


//========================================================================
//[block] Variables

var		float		FlyingTime, TimeToStartFalling; 
var		bool		bDisarmed;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		TimeToStartFalling;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	Super.CalcDefaultProperties();
	
	if ( default.MaxSpeed > 0.0 )  {
		// FlyingTime
		if ( default.EffectiveRange > 0.0 )  {
			default.FlyingTime = default.EffectiveRange / default.MaxSpeed;
			if ( default.bTrueBallistics )  {
				default.FlyingTime += 1.0 - FMin(default.BallisticCoefficient, 1.0);
				if ( default.bInitialAcceleration )
					default.FlyingTime += default.InitialAccelerationTime;
			}
			
			FlyingTime = default.FlyingTime;
		}
	}
}

simulated function SetInitialVelocity()
{
	if ( FlyingTime > 0.0 )
		TimeToStartFalling = Level.TimeSeconds + FlyingTime;
	
	Super.SetInitialVelocity();
}

// Detonator is armed
simulated function bool IsArmed()
{
	if ( bDisarmed || VSizeSquared(SpawnLocation - Location) < ArmingRange )
		Return False;
	
	Return Super.IsArmed();
}

simulated event Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);
	
	/*
	if ( Velocity != Vect(0.0, 0.0, 0.0)
		 && (Physics == default.Physics || Physics == PHYS_Falling)
		 && Level.TimeSeconds > NextProjectileUpdateTime )  {
		// Updating Projectile
		UpdateProjectilePerformance();
		// Time to start falling
		if ( Physics == default.Physics && TimeToStartFalling > 0.0 
			 && Level.TimeSeconds >= TimeToStartFalling )
			SetPhysics(PHYS_Falling);
	} */
	if ( Velocity != Vect(0.0, 0.0, 0.0) && Physics == default.Physics 
		 && TimeToStartFalling > 0.0 && Level.TimeSeconds >= TimeToStartFalling )
		SetPhysics(PHYS_Falling);
}

simulated function Disarm()
{
	if ( !bDisarmed )  {
		bDisarmed = True;
		LifeSpan = 1.0;
	}
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	LastTouched = Other;
	if ( CanHitThisActor(Other) )  {
		ProcessHitActor(Other, HitLocation, ImpactDamage, ImpactMomentumTransfer, ImpactDamageType);
		if ( IsArmed() )
			Explode(HitLocation, Normal(HitLocation - Other.Location));
	}
	LastTouched = None;
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	local	Vector	HitLocation;
	
	if ( CanTouchThisActor(Wall, HitLocation) )  {
		HurtWall = Wall;
		ProcessTouch(Wall, HitLocation);
		Return;
	}
	
	if ( IsArmed() )
		Explode((Location + ExploWallOut * HitNormal), HitNormal);
	else
		ProcessHitWall(HitNormal);
	
	HurtWall = None;
}

simulated function ProcessLanded( vector HitNormal )
{
	Disarm();
	Super.ProcessLanded(HitNormal);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // EST_Default
	 ImpactSurfaces(0)=(FrictionCoefficient=0.6,PlasticityCoefficient=0.4)
	 // EST_Rock
	 ImpactSurfaces(1)=(FrictionCoefficient=0.6,PlasticityCoefficient=0.5)
	 // EST_Dirt
	 ImpactSurfaces(2)=(FrictionCoefficient=0.42,PlasticityCoefficient=0.22)
	 // EST_Metal
	 ImpactSurfaces(3)=(FrictionCoefficient=0.64,PlasticityCoefficient=0.45)
	 // EST_Wood
	 ImpactSurfaces(4)=(FrictionCoefficient=0.52,PlasticityCoefficient=0.34)
	 // EST_Plant
	 ImpactSurfaces(5)=(FrictionCoefficient=0.47,PlasticityCoefficient=0.3)
	 // EST_Flesh
	 ImpactSurfaces(6)=(FrictionCoefficient=0.46,PlasticityCoefficient=0.29)
	 // EST_Ice
	 ImpactSurfaces(7)=(FrictionCoefficient=0.7,PlasticityCoefficient=0.48)
	 // EST_Snow
	 ImpactSurfaces(8)=(FrictionCoefficient=0.48,PlasticityCoefficient=0.32)
	 // EST_Water
	 ImpactSurfaces(9)=(FrictionCoefficient=0.6,PlasticityCoefficient=0.3)
	 // EST_Glass
	 ImpactSurfaces(10)=(FrictionCoefficient=0.64,PlasticityCoefficient=0.48)
	 // EST_Gravel
	 ImpactSurfaces(11)=(FrictionCoefficient=0.49,PlasticityCoefficient=0.34)
	 // EST_Concrete
	 ImpactSurfaces(12)=(FrictionCoefficient=0.56,PlasticityCoefficient=0.4)
	 // EST_HollowWood
	 ImpactSurfaces(13)=(FrictionCoefficient=0.52,PlasticityCoefficient=0.34)
	 // EST_Mud
	 ImpactSurfaces(14)=(FrictionCoefficient=0.4,PlasticityCoefficient=0.2)
	 // EST_MetalArmor
	 ImpactSurfaces(15)=(FrictionCoefficient=0.66,PlasticityCoefficient=0.5)
	 // EST_Paper
	 ImpactSurfaces(16)=(FrictionCoefficient=0.5,PlasticityCoefficient=0.34)
	 // EST_Cloth
	 ImpactSurfaces(17)=(FrictionCoefficient=0.4,PlasticityCoefficient=0.3)
	 // EST_Rubber
	 ImpactSurfaces(18)=(FrictionCoefficient=0.5,PlasticityCoefficient=0.4)
	 // EST_Poop
	 ImpactSurfaces(19)=(FrictionCoefficient=0.4,PlasticityCoefficient=0.2)
	 bIgnoreSameClassProj=True
	 bReplicateSpawnLocation=True
	 ProjectileDiameter=40.0
	 //Shrapnel
	 ShrapnelClass=None
	 DisintegrateChance=0.950000
	 //DisintegrateDamageTypes
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 CullDistance=5000.000000
	 //Physics
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bCanRebound=True
	 bOrientToVelocity=True
	 Physics=PHYS_Projectile
	 bIgnoreBulletWhipAttachment=True
	 UpdateTimeDelay=0.100000
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 ProjectileMass=0.230000	// kilograms
	 //EffectiveRange in Meters
	 EffectiveRange=140.000000
	 MaxEffectiveRange=300.000000
	 //TrueBallistics
	 bTrueBallistics=True
	 bInitialAcceleration=True
	 BallisticCoefficient=0.132000
	 SpeedFudgeScale=1.000000
     MinFudgeScale=0.025000
     InitialAccelerationTime=0.100000
	 //Trail
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_PanzerfaustTrail',EmitterRotation=(Pitch=32768))
	 //HitEffects
	 HitSoundVolume=1.250000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=360.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=360.0,bUse3D=True)
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //Booleans
     bBlockHitPointTraces=False
     bUnlit=False
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
	 LifeSpan=0.0
}
