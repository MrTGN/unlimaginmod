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
var		bool				bCanHitOwner, bTimerSet;

var		AvoidMarker				FearMarker;
var		Class<AvoidMarker>		FearMarkerClass;

//[end] Varibles
//====================================================================

replication
{
    reliable if ( bNetDirty && Role == ROLE_Authority )
        ExplodeTimer;
}

//========================================================================
//[block] Functions

simulated function SetInitialVelocity()
{
	if ( Role == ROLE_Authority && Speed > 0.0 )  {
		bCanHitOwner = False;
		if ( PhysicsVolume.bWaterVolume && SpeedDropInWaterCoefficient > 0.0 )
			Speed *= SpeedDropInWaterCoefficient;
		
		Velocity = Speed * Vector(Rotation);
		RandSpin(25000);
    }
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( FearMarkerClass != None )
	{
		FearMarker = Spawn(FearMarkerClass, self);
		if ( FearMarker != None )
		{
			FearMarker.SetBase(self);
			FearMarker.SetCollisionSize((DamageRadius * 1.04), (DamageRadius * 1.04));
			FearMarker.StartleBots();
		}
	}
}

simulated event PostNetBeginPlay()
{
	Super(UM_BaseExplosiveProjectile).PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )
	{
		SetTimer(ExplodeTimer, False);
		bTimerSet = True;
	}
}

simulated function ProjectileHasLostAllEnergy()
{
	Super.ProjectileHasLostAllEnergy();
	bBounce = False;
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	local	Vector		TempHitLocation, HitNormal, X;
	local	array<int>	HitPoints;
    local	KFPawn		HitPawn;
	
	// Don't allow hits on poeple on the same team
	if ( KFBulletWhipAttachment(Other) != None ||
		 KFHumanPawn(Other) != none && Instigator != none &&
		 KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex )
		Return;
	
	// Updating Projectile Performance before hit the victim
	// Needed because Projectile lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	SpawnHitEffects(Location, Normal(HitLocation - Other.Location), , , Other);
	
	if ( Other.IsA('NetKActor') )
		KAddImpulse(Velocity,HitLocation,);
		
	if ( Role == ROLE_Authority && ImpactDamage > 0.0 && ImpactDamageType != None )
	{
		X = Normal(Velocity);
		
		if ( ROBulletWhipAttachment(Other) != None )
		{
			if ( !Other.Base.bDeleteMe )
			{
				Other = Instigator.HitPointTrace(TempHitLocation, HitNormal, HitLocation + (200 * Vector(Rotation)), HitPoints, HitLocation,, 1);
				if ( Other == None || HitPoints.Length == 0 )
					Return;

				HitPawn = KFPawn(Other);
				if ( HitPawn != None && !HitPawn.bDeleteMe )
					HitPawn.ProcessLocationalDamage(ImpactDamage, Instigator, TempHitLocation, (ImpactMomentumTransfer * X), ImpactDamageType, HitPoints);
			}
    	}
        else
        {
            if ( Pawn(Other) != None && Pawn(Other).IsHeadShot(HitLocation, X, 1.0) )
				Pawn(Other).TakeDamage((ImpactDamage * HeadShotImpactDamageMult), Instigator, HitLocation, (ImpactMomentumTransfer * X), ImpactDamageType);
            else
                Other.TakeDamage(ImpactDamage, Instigator, HitLocation, (ImpactMomentumTransfer * X), ImpactDamageType);
		}
    }
	
	// Stop the grenade in its tracks if it hits an enemy.
	if ( Speed > 0.0 && !Other.bWorldGeometry && 
		 ( (Other != Instigator && Other.Base != Instigator) || bCanHitOwner ) )
		ProjectileHasLostAllEnergy();
}

simulated event Landed( vector HitNormal )
{
	UpdateProjectilePerformance();
	if ( bBounce && Speed > (MaxSpeed * FullStopSpeedCoefficient) )
		HitWall(HitNormal, None);
	else
	{
		//SpawnHitEffects(Location, HitNormal);
		if ( bBounce )
			bBounce = False;
		PrePivot.Z = -1.5;
		if ( Physics != PHYS_None )
			SetPhysics(PHYS_None);
		DestroyTrail();
	}
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	local	float	CosBA, EL;

	if ( Role == ROLE_Authority && ImpactDamage > 0.0 && ImpactDamageType != None )
	{
		if ( !Wall.bStatic && !Wall.bWorldGeometry )
		{
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController(InstigatorController);

			Wall.TakeDamage(ImpactDamage, Instigator, Location, (ImpactMomentumTransfer * Normal(Velocity)), ImpactDamageType);

			if ( ImpactDamageRadius > 0.0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0 )
				Vehicle(Wall).DriverRadiusDamage(ImpactDamage, ImpactDamageRadius, InstigatorController, ImpactDamageType, ImpactMomentumTransfer, Location);

			HurtWall = Wall;
		}
		MakeNoise(1.0);
	}
	
	if ( Role == ROLE_Authority && !bTimerSet )
	{
		SetTimer(ExplodeTimer, False);
		bTimerSet = True;
	}
	
	CosBA = FMax((1.0 - Abs(Maths.static.CosBetweenVectors(Velocity, HitNormal))), 0.25);
	EL = MuzzleEnergy * (1.0 - BounceEnergyReduction) * (0.5 / CosBA);
	//log(self$": Cos of the BounceAngle="$CosBA);
	//Velocity = MirrorVectorByNormal(Velocity, HitNormal);
	// 0.5 = Cos(60 deg)
	UpdateProjectilePerformance(EL,, MirrorVectorByNormal(Velocity, HitNormal));

	RandSpin(100000);
	DesiredRotation.Roll = 0;
	RotationRate.Roll = 0;

	if ( Speed > (MaxSpeed * FullStopSpeedCoefficient) )
    {
		SpawnHitEffects(Location, HitNormal);
		bFixedRotationDir = False;
		bRotateToDesired = True;
		DesiredRotation.Pitch = 0;
		RotationRate.Pitch = 50000;
    }
	else
	{
		bBounce = False;
		DesiredRotation = Rotation;
		DesiredRotation.Roll = 0;
		DesiredRotation.Pitch = 0;
		SetRotation(DesiredRotation);
	}
	
	HurtWall = None;
}

simulated event Destroyed()
{
	if ( FearMarker != None )
		FearMarker.Destroy();
	
	Super.Destroyed();
}

event Timer()
{
	//if ( !bHidden )
		//Explode(Location, vect(0,0,1));
	//else
		Destroy();
}

//[end] Functions
//====================================================================

defaultproperties
{
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
     Damage=320.000000
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
	 bBounce=True
     bFixedRotationDir=True
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
	 Physics=PHYS_Falling
}
