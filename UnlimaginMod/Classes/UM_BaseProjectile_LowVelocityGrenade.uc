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
	SpawnLocation = Location;
	if ( FlyingTime > 0.0 )
		TimeToStartFalling = Level.TimeSeconds + FlyingTime;
	
	Super.SetInitialVelocity();
}

// Detonator is armed
function bool IsArmed()
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
	}
	*/
	// Time to start falling
	if ( Velocity != Vect(0.0, 0.0, 0.0) && Physics == default.Physics 
		 && TimeToStartFalling > 0.0 && Level.TimeSeconds >= TimeToStartFalling )
		SetPhysics(PHYS_Falling);
}

function Disarm()
{
	bDisarmed = True;
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	LastTouched = Other;
	ProcessHitActor(Other, HitLocation, ImpactDamage, ImpactMomentumTransfer, ImpactDamageType);
	if ( Role == ROLE_Authority && IsArmed() )
		Explode(HitLocation, Normal(HitLocation - Other.Location));
	
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
	
	ProcessHitWall(HitNormal);
	if ( Role == ROLE_Authority && IsArmed() )
		Explode((Location + ExploWallOut * HitNormal), HitNormal);
	
	HurtWall = None;
}

simulated function ProcessLanded( vector HitNormal )
{
	if ( Role == ROLE_Authority )
		Disarm();
	
	Super.ProcessLanded(HitNormal);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bIgnoreSameClassProj=True
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
	 //Physics
	 // If bBounce=True call HitWal() instead of Landed()
	 // when the actor has finished falling (Physics was PHYS_Falling).
	 bBounce=True
	 bOrientToVelocity=True	// Orient in the direction of current velocity.
	 bCanRebound=True
	 Physics=PHYS_Projectile
	 UpdateTimeDelay=0.100000
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 ProjectileMass=0.023000	// kilograms
	 //EffectiveRange in Meters
	 EffectiveRange=180.000000
	 MaxEffectiveRangeScale=1.250000
	 //TrueBallistics
	 bTrueBallistics=True
	 bInitialAcceleration=True
	 BallisticCoefficient=0.150000
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
}
