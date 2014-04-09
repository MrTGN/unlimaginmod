//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Bullet
//	Parent class:	 UM_BaseProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.03.2013 19:51
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Base bullet projectile class
//================================================================================
class UM_BaseProjectile_Bullet extends UM_BaseProjectile
	Abstract;

//========================================================================
//[block] Variables

const	CosMinBounceAngle = 0.999847;

//[block] Hedshot vars
var(Hedshots)	class<DamageType>	DamageTypeHeadShot;	// Headshot damage type
var(Hedshots)	float				HeadShotDamageMult;	// Headshot damage multiplication
//[end]

//[block] Ballistic performance

// Bullet Expansion Coefficient.
// For FMJ bullets ExpansionCoefficient less then 1.01 (approximately 1.0)
// For JHP and HP bullets ExpansionCoefficient more then 1.4
var(Ballistic)	float		ExpansionCoefficient;
var(Ballistic)	float		BounceChance;	// Chance to bounse. Ranged from 0.01 to 1.00
//[end]

var				Pawn		IgnoreImpactPawn; // Used for penitrations

struct SurfaceTypeData
{
	var	float	CosMaxBounceAngle;	// Cosine of maximum angle in degrees on which bullet still can bounce.
									// All CosMaxBounceAngle array indexes relevant to ESurfaceTypes enum keywords
	var	float	MaxEnergyLoss;		// Max bullet energy-loss when bounce
};

var		SurfaceTypeData		SurfaceTypeDataArray[20];	

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PreBeginPlay()
{
	Super(UM_BaseProjectile).PreBeginPlay();
	
	// Randomising Damage
	//Damage = default.Damage * RandMult;
	Damage = default.Damage * GetRandMultByPercent(BallisticRandPercent);
	
	/* if ( bEnableLogging )  {
		log(self$": PreBeginPlay ProjectileMass="$ProjectileMass);
		log(self$": PreBeginPlay MuzzleEnergy="$MuzzleEnergy);
		log(self$": PreBeginPlay ProjectileEnergy="$ProjectileEnergy);
		log(self$": PreBeginPlay MaxSpeed="$MaxSpeed);
		log(self$": PreBeginPlay Speed="$Speed);
	} */
}

/*
simulated event PostBeginPlay()
{
	Super(UM_BaseProjectile).PostBeginPlay();
		
	if ( bEnableLogging )
		log(self$": PostBeginPlay LifeSpan="$LifeSpan);
} */

simulated function float ApplyPenitrationBonus(float EnergyLoss)
{
	if ( ExpansionCoefficient > 1.0 )  {
		EnergyLoss *= ExpansionCoefficient;
		ExpansionCoefficient = FMax(1.05, (ExpansionCoefficient * 0.75));
		BallisticCoefficient = default.BallisticCoefficient * (ExpansionCoefficient / default.ExpansionCoefficient);
	}

	Return EnergyLoss;
}

simulated function float ApplyBounceBonus(float EnergyLoss)
{
	if ( ExpansionCoefficient > 1.0 )  {
		EnergyLoss *= ExpansionCoefficient;
		ExpansionCoefficient = FMax(1.05, (ExpansionCoefficient * 0.75));
		BallisticCoefficient = default.BallisticCoefficient * (ExpansionCoefficient / default.ExpansionCoefficient);
	}
	
	Return EnergyLoss;
}

// Called when projectile has lost all energy
simulated function LostAllEnergy()
{
	DestroyTrail();
	Destroy();
}

// Called when the projectile loses some of it's energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	Damage *= NewScale;
}

simulated function ProcessTouch(Actor Other, vector HitLocation)
{
	local	Vector		X, TraceEnd, TempHitLocation, HitNormal;
	local	array<int>	HitPoints;
	local	Pawn		Victim;
	local	float		PEL;

	if ( Instigator == None || Other == None || Other == Instigator || 
		 Other.Base == Instigator || !Other.bBlockHitPointTraces || 
         (IgnoreImpactPawn != None && (Other == IgnoreImpactPawn || 
			 Other.Base == IgnoreImpactPawn)) )
		Return;

	// KFBulletWhipAttachment/ROBulletWhipAttachment - Collision for projectiles whip sounds. We need to do a HitPointTrace.
	if ( KFBulletWhipAttachment(Other) != None || ROBulletWhipAttachment(Other) != None )  {
		TraceEnd = HitLocation + (MaxEffectiveRange * Vector(Rotation));
		Victim = Pawn(Instigator.HitPointTrace(TempHitLocation, HitNormal, TraceEnd, HitPoints, HitLocation,, 1));
		if ( HitPoints.Length < 1 )
			Return;
	}
	// ExtendedZCollision - Killing Floor hack for large zombies.
	else if ( ExtendedZCollision(Other) != None )
		Victim = Pawn(Other.Owner);
	else
		Victim = Pawn(Other);
	
	if ( Victim == None || Victim.bDeleteMe )
		Return;
	else
		IgnoreImpactPawn = Victim;	// Saving last touched Pawn
	
	// Do not damage a friendly Pawn
	if ( Instigator != Victim && Instigator.GetTeamNum() == Victim.GetTeamNum() &&
		 TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale <= 0.0 )
		Return;
	
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and Damage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	X = Normal(Velocity);
	SpawnHitEffects(Location, Normal(HitLocation - Other.Location), , , Other);
	PEL = 0.0;
	if ( KFPawn(Victim) != None )  {
		if ( Role == ROLE_Authority )
			KFPawn(Victim).ProcessLocationalDamage(Damage, Instigator, TempHitLocation, (MomentumTransfer * X), MyDamageType, HitPoints);
	}
	else {
		if ( Victim.IsHeadShot(HitLocation, X, 1.0) )  {
			// Finding out HeadShot penetration EnergyLoss
			if ( UM_KFMonster(Victim) != None )
				PEL = UM_KFMonster(Victim).GetPenetrationEnergyLoss(True);
		
			if ( Role == ROLE_Authority )  {
				if ( DamageTypeHeadShot != None )
					Victim.TakeDamage((Damage * HeadShotDamageMult), Instigator, HitLocation, (MomentumTransfer * X), DamageTypeHeadShot);
				else
					Victim.TakeDamage((Damage * HeadShotDamageMult), Instigator, HitLocation, (MomentumTransfer * X), MyDamageType);
			}
		}
		else {
			// Finding out penetration EnergyLoss
			if ( UM_KFMonster(IgnoreImpactPawn) != None )
				PEL = UM_KFMonster(IgnoreImpactPawn).GetPenetrationEnergyLoss(False);
			
			if ( Role == ROLE_Authority )
				Victim.TakeDamage(Damage, Instigator, HitLocation, (MomentumTransfer * X), MyDamageType);
		}
	}
	// Updating Bullet Performance after the hit
	UpdateProjectilePerformance(PEL, Victim);
	IgnoreImpactPawn = None;
}

simulated singular event HitWall( vector HitNormal, actor Wall )
{
	local	float			CosMaxBA, EL, CosBA;
	local	vector			HitLoc, HitNorm, TraceEnd;
	local	Material		HitMat;
	local	ESurfaceTypes	ST;

	// Updating bullet performance before hit the wall
	// Needed because bullet lose Speed and Damage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Wall != None && !Wall.bStatic && !Wall.bWorldGeometry 
		&& (Mover(Wall) == None || Mover(Wall).bDamageTriggered) )  {
		if ( Role == ROLE_Authority && Level.NetMode != NM_Client )  {
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController(InstigatorController);
			
			Wall.TakeDamage(Damage, Instigator, Location, (MomentumTransfer * Normal(Velocity)), MyDamageType);
			HurtWall = Wall;
			if ( Instigator != None )
				MakeNoise(1.0);
		}
		LostAllEnergy();
		Return;
	}
	
	if ( !bBounce || ArrayCount(SurfaceTypeDataArray) < 1 )  {
		SpawnHitEffects(Location, HitNormal);
		if ( Instigator != None && Level.NetMode != NM_Client )
			MakeNoise(0.3);
		LostAllEnergy();
		Return;
	}
	else {
		TraceEnd = Location + Vector(Rotation) * 20;
		Trace(HitLoc, HitNorm, TraceEnd, Location, false,, HitMat);
		if ( HitMat == None )
			ST = EST_Default;
		else
			ST = ESurfaceTypes(HitMat.SurfaceType);

		CosMaxBA = SurfaceTypeDataArray[ST].CosMaxBounceAngle;
		CosBA = 1.0 - Abs(Maths.static.CosBetweenVectors(Velocity, HitNormal));
		
		/* if ( bEnableLogging )  {
			log(self$": SurfaceType="$ST);
			log(self$": Cos of MaxBounceAngle="$CosMaxBA);
			log(self$": Cos of BounceAngle="$CosBA);
			log(self$": MaxEnergyLoss="$MaxEL);
		} */
		
		// Cos(80 deg) = 0,17364817766693034885171662676931
		// Cos(10 deg) = 0,98480775301220805936674302458952
		// Cos is the inversion function. The greater angle gives a lower value.
		if ( CosMaxBA < CosMinBounceAngle && CosBA >= CosMaxBA &&
			 CosBA < CosMinBounceAngle && FRand() <= BounceChance )  {
			/* if ( bEnableLogging )  {
				log(self$": Bullet Energy before Bounce = "$ProjectileEnergy);
				log(self$": Bullet Speed before Bounce = "$Speed);
				log(self$": Bullet Velocity before Bounce = "$Velocity);
				log(self$": Bullet Damage before Bounce = "$Damage);
			} */
			
			// 0.5 = Cos(60 deg)
			EL = SurfaceTypeDataArray[ST].MaxEnergyLoss * (0.5 / CosBA) * FMin(BCInverse, 1.000000);
			//Velocity = MirrorVectorByNormal(Velocity, HitNormal);
			// Updating Bullet Performance after hit the wall
			UpdateProjectilePerformance(EL,, MirrorVectorByNormal(Velocity, HitNormal));
			
			/* if ( bEnableLogging )  {
				log(self$": Bullet Energy after Bounce = "$ProjectileEnergy);
				log(self$": Bullet Speed after Bounce = "$Speed);
				log(self$": Bullet Velocity after Bounce = "$Velocity);
				log(self$": Bullet Damage after Bounce = "$Damage);
			} */
			SpawnHitEffects(Location, HitNormal);
			if( Instigator != None && Level.NetMode != NM_Client )
				MakeNoise(0.3);
		}
		else {
			/* if ( bEnableLogging )
				log(self$": Bullet has stuck in wall. Destroing."); */
			SpawnHitEffects(Location, HitNormal);
			if ( Instigator != None && Level.NetMode != NM_Client )
				MakeNoise(0.3);
			LostAllEnergy();
		}
	}
	HurtWall = None;
}

simulated event Landed(vector HitNormal)
{
	HitWall(HitNormal, None);
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
	 BounceChance=0.650000
	 BallisticRandPercent=2.000000
	 //EffectiveRange in Meters
	 EffectiveRange=500.000000
	 MaxEffectiveRangeScale=1.200000
	 //Expansion
	 ExpansionCoefficient=1.00000	// For FMJ
	 ProjectileMass=0.020000	// kilograms
     MuzzleVelocity=100.000000	// m/sec
	 InitialUpdateTimeDelay=0.200000
	 UpdateTimeDelay=0.100000
	 //[end]
	 HeadShotDamageMult=1.100000
	 PenitrationEnergyReduction=0.800000
	 bBounce=False
	 // EST_Default	MaxBounceAngle=60.00 deg
	 SurfaceTypeDataArray(0)=(CosMaxBounceAngle=0.500000,MaxEnergyLoss=1000.000000)
	 // EST_Rock	MaxBounceAngle=65.00 deg
	 SurfaceTypeDataArray(1)=(CosMaxBounceAngle=0.422618,MaxEnergyLoss=1050.000000)
	 // EST_Dirt	MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(2)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=400.000000)
	 // EST_Metal	MaxBounceAngle=70.00 deg
	 SurfaceTypeDataArray(3)=(CosMaxBounceAngle=0.342020,MaxEnergyLoss=700.000000)
	 // EST_Wood	MaxBounceAngle=10.00 deg
	 SurfaceTypeDataArray(4)=(CosMaxBounceAngle=0.984807,MaxEnergyLoss=340.000000)
	 // EST_Plant	MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(5)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=60.000000)
	 // EST_Flesh	MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(6)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=500.000000)
	 // EST_Ice		MaxBounceAngle=50.00 deg
	 SurfaceTypeDataArray(7)=(CosMaxBounceAngle=0.642787,MaxEnergyLoss=720.000000)
	 // EST_Snow	MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(8)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=160.000000)
	 // EST_Water	MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(9)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=500.000000)
	 // EST_Glass	MaxBounceAngle=60.00 deg
	 SurfaceTypeDataArray(10)=(CosMaxBounceAngle=0.500000,MaxEnergyLoss=450.000000)
	 // EST_Gravel	MaxBounceAngle=45.00 deg
	 SurfaceTypeDataArray(11)=(CosMaxBounceAngle=0.707106,MaxEnergyLoss=800.000000)
	 // EST_Concrete	MaxBounceAngle=60.00 deg
	 SurfaceTypeDataArray(12)=(CosMaxBounceAngle=0.500000,MaxEnergyLoss=1100.000000)
	 // EST_HollowWood	MaxBounceAngle=10.00 deg
	 SurfaceTypeDataArray(13)=(CosMaxBounceAngle=0.984807,MaxEnergyLoss=240.000000)
	 // EST_Mud			MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(14)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=320.000000)
	 // EST_MetalArmor	MaxBounceAngle=70.00 deg
	 SurfaceTypeDataArray(15)=(CosMaxBounceAngle=0.342020,MaxEnergyLoss=900.000000)
	 // EST_Paper		MaxBounceAngle=0.00 deg
	 SurfaceTypeDataArray(16)=(CosMaxBounceAngle=1.000000,MaxEnergyLoss=50.000000)
	 // EST_Cloth		MaxBounceAngle=5.00 deg
	 SurfaceTypeDataArray(17)=(CosMaxBounceAngle=0.996194,MaxEnergyLoss=120.000000)
	 // EST_Rubber		MaxBounceAngle=15.00 deg
	 SurfaceTypeDataArray(18)=(CosMaxBounceAngle=0.965925,MaxEnergyLoss=300.000000)
	 // EST_Poop		MaxBounceAngle=5.00 deg
	 SurfaceTypeDataArray(19)=(CosMaxBounceAngle=0.996194,MaxEnergyLoss=160.000000)
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 //HitEffects
	 //You can use this varible to set new hit sound volume and radius
	 //HitSoundVolume=1.000000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //Damage
	 Damage=100.000000
	 DamageRadius=0.000000
	 MomentumTransfer=50000.000000
	 CullDistance=3400.000000
	 //Light
	 AmbientGlow=30		// Ambient brightness, or 255=pulsing.
	 bUnlit=True		// Lights don't affect actor.
	 //Collision
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 //Physics
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
