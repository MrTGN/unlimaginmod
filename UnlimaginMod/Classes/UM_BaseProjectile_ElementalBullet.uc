//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_ElementalBullet
//	Parent class:	 UM_BaseExplosiveProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.05.2013 00:59
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_ElementalBullet extends UM_BaseExplosiveProjectile
	Abstract;

//========================================================================
//[block] Variables

var		bool		bCanDisintegrate;

//[end] Varibles
//====================================================================


//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		bCanDisintegrate;
}

//[end] Replication
//====================================================================


//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	if ( Role == ROLE_Authority )
		bCanDisintegrate = FRand() <= DisintegrateChance;
	
	Super.PostBeginPlay();
}

// Called when the projectile loses some of it's energy
simulated function ScaleProjectilePerformance(float NewScale)
{
	ImpactDamage *= NewScale;
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	bCanBeDamaged = False;
	bHasExploded = True;
	bShouldExplode = True;
	
	if ( Role == ROLE_Authority )
		BlowUp(HitLocation);
	
	// Explode effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExplodeSound.Snd != None )
			ClientPlaySoundData(ExplodeSound);
		// VFX
		if ( !Level.bDropDetail && EffectIsRelevant(Location, False) )  {
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		}
	}
	
	// Shrapnel
	if ( Role == ROLE_Authority )
		SpawnShrapnel();
	
	// Shake nearby players screens
	ShakePlayersView();
	
	Destroy();
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
	bCanBeDamaged = False;
	bDisintegrated = True;
	bHidden = True;
	
	if ( Role == ROLE_Authority )  {
		Damage *= DisintegrateDamageScale;
		MomentumTransfer *= DisintegrateDamageScale;
		BlowUp(HitLocation);
	}
	
	// Disintegrate effects
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( DisintegrateSound.Snd != None )
			ClientPlaySoundData(DisintegrateSound);
		// VFX
		if ( !Level.bDropDetail && DisintegrationVisualEffect != None && EffectIsRelevant(Location, False) )
			Spawn(DisintegrationVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
	}

	Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	LastTouched = A;
	ProcessHitActor(Other, HitLocation, ImpactDamage, ImpactMomentumTransfer, ImpactDamageType);
	Explode(HitLocation, Normal(HitLocation - Other.Location));
	LastTouched = None;
}

simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
	Explode(Location, HitNormal);
}

// TakeDamage must be simulated because it is a bNetTemporary actor
simulated event TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local	int		i;

	if ( Monster(InstigatedBy) != None || InstigatedBy == Instigator ||
		 (TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale > 0.0) )  {
		// Disintegrate this Projectile instead of simple detonation
		if ( DisintegrateDamageTypes.Length > 0 )  {
			for ( i = 0; i < DisintegrateDamageTypes.Length; ++i )  {
				if ( damageType == DisintegrateDamageTypes[i] )  {
					if ( bCanDisintegrate )
						Disintegrate(HitLocation, vect(0.0, 0.0, 1.0));
					
					Return;
				}
			}
		}
		
		Explode(HitLocation, vect(0.0, 0.0, 1.0));
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
     bIgnoreSameClassProj=True
	 ShrapnelClass=None
	 bCanDisintegrate=True
	 // Explosion camera shakes
	 ShakeRadiusScale=2.200000
	 MaxEpicenterShakeScale=1.500000
	 ShakeRotMag=(X=500.000000,Y=500.000000,Z=500.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeOffsetTime=3.500000
	 //Disintegration
	 DisintegrateChance=0.600000
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
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
	 //Speed Must be 0.00 because we use MuzzleVelocity
	 Speed=0.000000
	 MaxSpeed=0.000000
	 //MuzzleVelocity
	 MuzzleVelocity=100.000000	// m/sec
	 //BallisticRandPercent
	 BallisticRandPercent=2.000000
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 MaxEffectiveRangeScale=1.200000
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bOrientToVelocity=True	// Orient in the direction of current velocity.
	 bCanBounce=False
	 //Trail
	 Trail=(xEmitterClass=Class'UnlimaginMod.UM_BulletTracer')
	 //HitEffects
	 //You can use this varible to set new hit sound volume and radius
	 //HitSoundVolume=1.000000
     //HitSoundRadius=200.000000
	 HitEffectsClass=Class'UnlimaginMod.UM_BulletHitEffects'
	 //Damage
	 ImpactDamage=100.000000
	 ImpactMomentumTransfer=30000.000000
	 Damage=100.000000
	 DamageRadius=30.000000
	 MomentumTransfer=50000.000000
	 CullDistance=3200.000000
	 //Replication
	 bNetTemporary=True
	 bReplicateInstigator=True
     bNetInitialRotation=True
	 bReplicateMovement=True
	 bUpdateSimulatedPosition=False
	 bNetNotify=False
	 //Light
	 AmbientGlow=30		// Ambient brightness, or 255=pulsing.
	 bUnlit=True		// Lights don't affect actor.
	 //Collision
	 CollisionRadius=0.000000
     CollisionHeight=0.000000
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
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
	 DrawScale=1.000000
}
