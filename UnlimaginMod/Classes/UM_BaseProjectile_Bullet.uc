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


//[block] Ballistic performance

// Bullet Expansion Coefficient.
// For FMJ bullets ExpansionCoefficient less then 1.01 (approximately 1.0)
// For JHP and HP bullets ExpansionCoefficient more then 1.4
var(Ballistic)	float		ExpansionCoefficient;
var(Ballistic)	float		BounceChance;	// Chance to bounse. Ranged from 0.01 to 1.00
//[end]

var				Pawn		IgnoreImpactPawn; // Used for penetrations

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

// Called when projectile has lost all energy
simulated function ZeroProjectileEnergy()
{
	DestroyTrail();
	Destroy();
}

// Called when the projectile loses some of it's energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	Damage *= NewScale;
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
		ZeroProjectileEnergy();
		Return;
	}
	ProcessHitWall(HitNormal);
	HurtWall = None;
}

//[end] Functions
//====================================================================

defaultproperties
{
     // Orient in the direction of current velocity.
	 bOrientToVelocity=True
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
	 PenetrationEnergyReduction=0.800000
	 bBounce=True
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
