//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_Grenade
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
class UM_BaseProjectile_Grenade extends UM_BaseExplosiveProjectile
	Abstract;


//========================================================================
//[block] Variables

var		float		FlyingTime, TimeToStartFalling; 
var		float		ArmingDelay, ArmingTime;
var		bool		bDisarmed;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		TimeToStartFalling;
	/*	TimeToStartFalling, ArmingTime;

	reliable if ( Role == ROLE_Authority && bNetDirty )
		bDisarmed; */
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
		// ArmingDelay
		if ( default.ArmingRange > 0.0 )  {
			default.ArmingDelay = (default.ArmingRange * MeterInUU) / default.MaxSpeed;
			if ( default.bTrueBallistics && default.bInitialAcceleration )
				default.ArmingDelay += default.InitialAccelerationTime;
			
			ArmingDelay = default.ArmingDelay;
		}
	}
}

simulated function SetInitialVelocity()
{
	if ( FlyingTime > 0.0 )
		TimeToStartFalling = Level.TimeSeconds + FlyingTime;
	
	if ( ArmingDelay > 0.0 )
		ArmingTime = Level.TimeSeconds + ArmingDelay;
	
	Super.SetInitialVelocity();
}

simulated function ProjectileHasLostAllEnergy()
{
	bBounce = False;
	if ( Role == ROLE_Authority )
		Disarm();
	
	Super.ProjectileHasLostAllEnergy();
}

// Detonator is armed
function bool IsArmed()
{
	if ( bDisarmed || Level.TimeSeconds < ArmingTime )
		Return False;
	
	Return Super.IsArmed();
}

simulated event Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);

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
}

function Disarm()
{
	if ( !bDisarmed )  {
		bDisarmed = True;
		//NetUpdateTime = Level.TimeSeconds - 1;
	}
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority )  {
		if ( ImpactDamageType != None && ImpactDamage > 0.0 && !Wall.bStatic && !Wall.bWorldGeometry )  {
			if ( Instigator == None || Instigator.Controller == None )
				Wall.SetDelayedDamageInstigatorController(InstigatorController);

			Wall.TakeDamage(ImpactDamage, Instigator, Location, (ImpactMomentumTransfer * Normal(Velocity)), ImpactDamageType);

			if ( ImpactDamageRadius > 0.0 && Vehicle(Wall) != None && Vehicle(Wall).Health > 0 )
				Vehicle(Wall).DriverRadiusDamage(ImpactDamage, ImpactDamageRadius, InstigatorController, ImpactDamageType, ImpactMomentumTransfer, Location);

			HurtWall = Wall;
		}
		
		if ( IsArmed() )
			Explode((Location + ExploWallOut * HitNormal), HitNormal);
	}
	
	HurtWall = None;
	ProjectileHasLostAllEnergy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
	local	Vector		TempHitLocation, HitNormal, X, TraceEnd;
	local	array<int>	HitPoints;
	local	Pawn		Victim;
	
	// Don't let it hit this player, or blow up on another player
	// Don't collide with bullet whip attachments
	// Don't allow hits on poeple on the same team
	if ( Other == None || Other.bDeleteMe || Instigator == None || Other == Instigator ||
		 Other.Base == Instigator || !Other.bBlockHitPointTraces )
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
	
	// Do not damage a friendly Pawn
	if ( Victim != None && Instigator != Victim && TeamGame(Level.Game) != None
		 && TeamGame(Level.Game).FriendlyFireScale <= 0.0 && Instigator.GetTeamNum() == Victim.GetTeamNum() )
		Return;
	
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority )  {
		if ( ImpactDamageType != None && ImpactDamage > 0.0 )  {
			X = Normal(Velocity);
			if ( Victim != None )  {
				if ( KFPawn(Victim) != None )
					KFPawn(Victim).ProcessLocationalDamage(Damage, Instigator, TempHitLocation, (MomentumTransfer * X), MyDamageType, HitPoints);
				else  {
					if ( Victim.IsHeadShot(HitLocation, X, 1.0) )
						Victim.TakeDamage((ImpactDamage * HeadShotImpactDamageMult), Instigator, HitLocation, (ImpactMomentumTransfer * X), ImpactDamageType);
					else
						Victim.TakeDamage(ImpactDamage, Instigator, HitLocation, (ImpactMomentumTransfer * X), ImpactDamageType);
				}
			}
			else
				Other.TakeDamage(ImpactDamage, Instigator, HitLocation, (ImpactMomentumTransfer * X), ImpactDamageType);
		}
		
		if ( IsArmed() )
			Explode(HitLocation, Normal(HitLocation - Other.Location));
    }
	
	// Stop the grenade in its tracks if it hits an enemy.
	if ( Speed > 0.0 && !Other.bWorldGeometry && Other != Instigator && Other.Base != Instigator )
		ProjectileHasLostAllEnergy();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bIgnoreSameClassProj=True
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
	 bBounce=True
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
}
