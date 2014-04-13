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

replication
{
    reliable if ( Role == ROLE_Authority && bNetDirty )
        ExplodeTimer;
}

//========================================================================
//[block] Functions

simulated function SetInitialVelocity()
{
	if ( Role == ROLE_Authority && Speed > 0.0 )  {
		if ( PhysicsVolume.bWaterVolume && SpeedDropInWaterCoefficient > 0.0 )
			Speed *= SpeedDropInWaterCoefficient;
		
		Velocity = Speed * Vector(Rotation);
		RandSpin(25000);
    }
}

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
		ProcessTouch(Wall, HitLocation);
		Return;
	}
	
	ProcessHitWall(HitNormal);
	RandSpin(100000);
	HurtWall = None;
}

simulated function ProcessLanded( vector HitNormal )
{
	if ( bRotateToDesired )  {
		bRotateToDesired = False;
		DesiredRotation = Rotation;
		SetRotation(DesiredRotation);
	}
	Super.ProcessLanded(HitNormal);
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
     ProjectileDiameter=56.0
	 bRotateToDesired=True
	 FearMarkerClass=Class'AvoidMarker'
	 DisintegrateChance=0.950000
	 //Sounds
	 TransientSoundVolume=2.000000
	 DisintegrateSound=(Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplodeSound=(Vol=2.0,Radius=400.0,bUse3D=True)
	 bIgnoreBulletWhipAttachment=True
	 //ExplodeTimer	 
	 ExplodeTimer=2.000000
	 //Shrapnel
	 //ShrapnelClass=Class'KFMod.KFShrapnel'
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 //Speed
	 SpeedDropInWaterCoefficient=0.600000
	 FullStopSpeedCoefficient=0.100000
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
