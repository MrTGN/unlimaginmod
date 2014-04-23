//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_HandGrenade
//	Parent class:	 UM_BaseExplosiveProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.05.2013 17:20
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_HandGrenade extends UM_BaseExplosiveProjectile
	Abstract;

//========================================================================
//[block] Variables

var		float				ExplodeTimer;
var		bool				bTimerSet;

var		AvoidMarker			FearMarker;
var		Class<AvoidMarker>	FearMarkerClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( FearMarkerClass != None )  {
		FearMarker = Spawn(FearMarkerClass, self);
		if ( FearMarker != None )  {
			FearMarker.SetBase(self);
			FearMarker.SetCollisionSize((DamageRadius * 1.04), (DamageRadius * 1.04));
			FearMarker.StartleBots();
		}
	}
}

simulated event PostNetBeginPlay()
{
	Super(UM_BaseExplosiveProjectile).PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, False);
		bTimerSet = True;
	}
	RandSpin(25000);
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	local	Vector	HitLocation;
	
	if ( Role == ROLE_Authority && !bTimerSet )  {
		bTimerSet = True;
		SetTimer(ExplodeTimer, False);
	}
	
	if ( CanTouchThisActor(Wall, HitLocation) )  {
		HurtWall = Wall;
		ProcessTouchActor(Wall, HitLocation, HitNormal);
		Return;
	}
	
	ProcessHitWall(HitNormal);
	RandSpin(100000);
	HurtWall = None;
}

simulated event Landed( Vector HitNormal )
{
	if ( bRotateToDesired )  {
		bRotateToDesired = False;
		DesiredRotation = Rotation;
		SetRotation(DesiredRotation);
	}
	Super.Landed(HitNormal);
}

simulated event Destroyed()
{
	if ( FearMarker != None )
		FearMarker.Destroy();
	
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // EST_Default
	 ImpactSurfaces(0)=(FrictionCoefficient=0.6,PlasticityCoefficient=0.4)
	 // EST_Rock
	 ImpactSurfaces(1)=(FrictionCoefficient=0.58,PlasticityCoefficient=0.5)
	 // EST_Dirt
	 ImpactSurfaces(2)=(FrictionCoefficient=0.42,PlasticityCoefficient=0.22)
	 // EST_Metal
	 ImpactSurfaces(3)=(FrictionCoefficient=0.64,PlasticityCoefficient=0.45)
	 // EST_Wood
	 ImpactSurfaces(4)=(FrictionCoefficient=0.51,PlasticityCoefficient=0.34)
	 // EST_Plant
	 ImpactSurfaces(5)=(FrictionCoefficient=0.44,PlasticityCoefficient=0.3)
	 // EST_Flesh
	 ImpactSurfaces(6)=(FrictionCoefficient=0.44,PlasticityCoefficient=0.29)
	 // EST_Ice
	 ImpactSurfaces(7)=(FrictionCoefficient=0.7,PlasticityCoefficient=0.45)
	 // EST_Snow
	 ImpactSurfaces(8)=(FrictionCoefficient=0.48,PlasticityCoefficient=0.31)
	 // EST_Water
	 ImpactSurfaces(9)=(FrictionCoefficient=0.6,PlasticityCoefficient=0.3)
	 // EST_Glass
	 ImpactSurfaces(10)=(FrictionCoefficient=0.64,PlasticityCoefficient=0.46)
	 // EST_Gravel
	 ImpactSurfaces(11)=(FrictionCoefficient=0.46,PlasticityCoefficient=0.34)
	 // EST_Concrete
	 ImpactSurfaces(12)=(FrictionCoefficient=0.55,PlasticityCoefficient=0.4)
	 // EST_HollowWood
	 ImpactSurfaces(13)=(FrictionCoefficient=0.5,PlasticityCoefficient=0.34)
	 // EST_Mud
	 ImpactSurfaces(14)=(FrictionCoefficient=0.4,PlasticityCoefficient=0.2)
	 // EST_MetalArmor
	 ImpactSurfaces(15)=(FrictionCoefficient=0.65,PlasticityCoefficient=0.5)
	 // EST_Paper
	 ImpactSurfaces(16)=(FrictionCoefficient=0.5,PlasticityCoefficient=0.34)
	 // EST_Cloth
	 ImpactSurfaces(17)=(FrictionCoefficient=0.45,PlasticityCoefficient=0.3)
	 // EST_Rubber
	 ImpactSurfaces(18)=(FrictionCoefficient=0.5,PlasticityCoefficient=0.4)
	 // EST_Poop
	 ImpactSurfaces(19)=(FrictionCoefficient=0.4,PlasticityCoefficient=0.2)
	 ProjectileDiameter=56.0
	 bRotateToDesired=True
	 FearMarkerClass=Class'AvoidMarker'
	 DisintegrateChance=0.950000
	 //Sounds
	 TransientSoundVolume=2.000000
	 DisintegrateSound=(Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplodeSound=(Vol=2.0,Radius=400.0,bUse3D=True)
	 //ExplodeTimer	 
	 ExplodeTimer=2.000000
	 //Shrapnel
	 //ShrapnelClass=Class'KFMod.KFShrapnel'
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 //Speed
	 SpeedDropInWaterCoefficient=0.600000
	 FullStopSpeedCoefficient=0.120000
	 //Ballistic performance randomization percent
	 BallisticRandPercent=20.000000
	 BounceEnergyReduction=0.350000
	 //ProjectileMass
	 ProjectileMass=0.400000	// kilograms
	 //MuzzleVelocity
     MuzzleVelocity=10.000000	// m/sec
     TossZ=100.000000
	 //HitEffects
	 HitSoundVolume=1.500000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //Damages
     Damage=340.000000
     DamageRadius=420.000000
	 MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeHandGrenade'
	 ImpactDamage=50.000000
	 ImpactMomentumTransfer=10000.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeHandGrenadeImpact'
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
	 StaticMesh=StaticMesh'KillingFloorStatics.FragProjectile'
	 //StaticMeshRef="KillingFloorStatics.FragProjectile"
	 //Booleans
	 bNetNotify=True
     bBlockHitPointTraces=False
     bUnlit=False
	 bNetTemporary=False
     //bFixedRotationDir=True
	 bFixedRotationDir=False
	 //Collision
	 bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
	 CollisionRadius=3.000000
     CollisionHeight=6.000000
	 //DrawScale
     DrawScale=0.400000
	 //Glow
     AmbientGlow=0
     FluidSurfaceShootStrengthMod=3.000000
     DesiredRotation=(Pitch=12000,Yaw=5666,Roll=2334)
	 //Physics
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bCanRebound=True
	 Physics=PHYS_Falling
}
