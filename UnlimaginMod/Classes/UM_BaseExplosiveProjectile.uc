//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseExplosiveProjectile
//	Parent class:	 UM_BaseProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 14.05.2013 21:08
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseExplosiveProjectile extends UM_BaseProjectile
	Abstract;

//========================================================================
//[block] Variables

// camera shakes
var(Shakes)		vector		ShakeRotMag;		// how far to rot view
var(Shakes)		vector		ShakeRotRate;		// how fast to rot view
var(Shakes)		float		ShakeRotTime;		// how much time to rot the instigator's view
var(Shakes)		vector		ShakeOffsetMag;		// max view offset vertically
var(Shakes)		vector		ShakeOffsetRate;	// how fast to offset view vertically
var(Shakes)		float		ShakeOffsetTime;	// how much time to offset view

var(Shakes)		float		ShakeRadiusScale;	// ShakeRadius = DamageRadius * ShakeRadiusScale;
var(Shakes)		float		MaxEpicenterShakeScale; // Maximum shake scale in explosion epicenter


// With DisintegrateDamageTypes array you can set damage types 
// that will Disintegrate Projectile instead of simple detonation
var		array< class<DamageType> >	DisintegrateDamageTypes;

// Use IgnoreVictims array to assign Victims that will be ignored in HurtRadius function
var		array< name >		IgnoreVictims;
var		bool				bIgnoreSameClassProj;	//Ignore projectiles with the same class in HurtRadius

//Shrapnel
var		class<Projectile>	ShrapnelClass;
var		int					MaxShrapnelAmount, MinShrapnelAmount;

//[block] Effects
var		bool				bDisintegrated;	// This Projectile has been disintegrated by a siren scream.
var		bool				bHasExploded; 	// This Projectile has Exploded.
//var		bool				bCanTakeDamage;	// This Projectile can Take Damage.

var		float				DisintegrateChance;	// Chance of this projectile to Disintegrate
var		float				DisintegrateDamageScale; // Scale damage by this multiplier when projectile disintegrating

//[block] Sounds
var		float				SoundEffectsVolume;

// DisintegrateSounds - disintegrating sounds of this projectile
var		array<sound>		DisintegrateSounds, ExplodeSounds;
var		array<string>		DisintegrateSoundsRef, ExplodeSoundsRef;

var		string				ImpactSoundRef;
//[end]

// Visual Effect
var		class<Emitter>		ExplosionVisualEffect, DisintegrationVisualEffect;
//[end]

var		float				SafeRange;	//In this range Projectile will not Explode

//DramaticEvents
var		float				SmallDramaticEventDuration, MediumDramaticEventDuration, LongDramaticEventDuration;
var		int					SmallDramaticEventKills, MediumDramaticEvenKills, LongDramaticEventKills;


// How much damage to do when this Projectile impacts something before exploding
var(Impact)		float		ImpactDamage, ImpactDamageRadius;
var(Impact)		float		HeadShotImpactDamageMult;	// headshot ImpactDamage multiplier
var(Impact)		float		ImpactMomentumTransfer;		// Momentum magnitude imparted by impacting projectile.
var		class<DamageType>	ImpactDamageType;	// Damagetype of this Projectile hitting something, before exploding


//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if ( ImpactDamage > 0.0 )
		ImpactDamage = default.ImpactDamage * GetRandMultByPercent(BallisticRandPercent);
		//ImpactDamage = default.ImpactDamage * RandMult;
	
	if ( Damage > 0.0 )
		Damage = default.Damage * GetRandMultByPercent(BallisticRandPercent);
}

//[block] Dynamic Loading
//static function PreloadAssets(Projectile Proj)
simulated static function PreloadAssets(Projectile Proj)
{
	local	int		i;
	local	UM_BaseExplosiveProjectile	EP;
	
	//[block] Loading Defaults
	if ( default.DisintegrateSoundsRef.length > 0 &&
		 default.DisintegrateSounds.length != default.DisintegrateSoundsRef.length )  {
		if ( default.DisintegrateSounds.length < default.DisintegrateSoundsRef.length )
			default.DisintegrateSounds.length = default.DisintegrateSoundsRef.length;
		
		for ( i = 0; i < default.DisintegrateSoundsRef.length; i++ )  {
			if ( default.DisintegrateSoundsRef[i] != "" )
				default.DisintegrateSounds[i] = sound(DynamicLoadObject(default.DisintegrateSoundsRef[i], class'Sound', True));
		}
		
	}
	
	if ( default.ExplodeSoundsRef.length > 0 && 
		 default.ExplodeSounds.length != default.ExplodeSoundsRef.length )  {
		if ( default.ExplodeSounds.length < default.ExplodeSoundsRef.length )
			default.ExplodeSounds.length = default.ExplodeSoundsRef.length;
		
		for ( i = 0; i < default.ExplodeSoundsRef.length; i++ )  {
			if ( default.ExplodeSoundsRef[i] != "" )
				default.ExplodeSounds[i] = sound(DynamicLoadObject(default.ExplodeSoundsRef[i], class'Sound', True));
		}
	}
	
	if ( default.ImpactSoundRef != "" && default.ImpactSound == None )
		default.ImpactSound = sound(DynamicLoadObject(default.ImpactSoundRef, class'Sound', True));
	//[end]
	
	if ( UM_BaseExplosiveProjectile(Proj) != None )  {
		EP = UM_BaseExplosiveProjectile(Proj);
		
		if ( default.DisintegrateSounds.length > 0 && 
			 EP.DisintegrateSounds.length != default.DisintegrateSounds.length )  {
			if ( EP.DisintegrateSounds.length < default.DisintegrateSounds.length )
				EP.DisintegrateSounds.length = default.DisintegrateSounds.length;
			
			for ( i = 0; i < default.DisintegrateSounds.length; i++ )  {
				if ( default.DisintegrateSounds[i] != None )
					EP.DisintegrateSounds[i] = default.DisintegrateSounds[i];
			}
			
		}
		
		if ( default.ExplodeSounds.length > 0 && 
			 EP.ExplodeSounds.length != default.ExplodeSounds.length )  {
			if ( EP.ExplodeSounds.length < default.ExplodeSounds.length )
				EP.ExplodeSounds.length = default.ExplodeSounds.length;
			
			for ( i = 0; i < default.ExplodeSounds.length; i++ )  {
				if ( default.ExplodeSounds[i] != None )
					EP.ExplodeSounds[i] = default.ExplodeSounds[i];
			}
			
		}
		
		if ( default.ImpactSound != None && EP.ImpactSound == None )
			EP.ImpactSound = default.ImpactSound;
	}
	
	Super.PreloadAssets(Proj);
}

//static function bool UnloadAssets()
simulated static function bool UnloadAssets()
{
	if ( default.DisintegrateSounds.length > 0 )
		default.DisintegrateSounds.length = 0;
	
	if ( default.ExplodeSounds.length > 0 )
		default.ExplodeSounds.length = 0;
	
	if ( default.ImpactSound != None )
		default.ImpactSound = None;

	Return Super.UnloadAssets();
}
//[end]

simulated event PostNetReceive()
{
    if ( bHidden && !bDisintegrated )
		Disintegrate(Location, vect(0,0,1));
}

simulated function bool InSafeRange()
{
	if ( VSize(Instigator.Location - Location) > SafeRange )
		Return False;
	else
		Return True;
}

// Called when projectile has lost all energy
simulated function ProjectileHasLostAllEnergy()
{
	Super.ProjectileHasLostAllEnergy();
	ImpactDamage = 0.0;
}

// Called when the projectile loses some of it's energy
simulated function ChangeOtherProjectilePerformance(float NewScale)
{
	ImpactDamage *= NewScale;
}

event Timer()
{
	Destroy();
}

// HurtRadius()
// Hurt locally authoritative actors within the radius.
function HurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	local Actor			Victims;
	local float			damageScale, dist;
	local vector		dir, VictimHitLocation;
	local int			NumKilled, i;
	local KFMonster		KFMonsterVictim;
	local Pawn			P;
	local KFPawn		KFP;
	local array<Pawn>	CheckedPawns;
	local bool			bAlreadyChecked, bIgnoreThisVictim;

	if ( bHurtEntry )
		Return;

	bHurtEntry = True;
	
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		// Clearing varibles. Big thanks to PooSh for this fix.
		P = None;
		KFMonsterVictim = None;
		KFP = None;
		
		// don't let blast damage affect fluid - VisibleCollisingActors doesn't really work for them - jag
		if ( Victims != None && !Victims.bDeleteMe && Victims != Self && Victims != Hurtwall && 
			 Victims.Role == ROLE_Authority && !Victims.IsA('FluidSurfaceInfo') &&
			 ExtendedZCollision(Victims) == None )
		{
			if ( bIgnoreSameClassProj && Victims.Class == Class )
				Continue;
			
			if ( IgnoreVictims.length > 0 )
			{
				bIgnoreThisVictim = False;
				
				if ( IgnoreVictims.length > 1 )
				{
					for ( i = 0; i < IgnoreVictims.length; i++ )
					{
						if ( Victims.IsA(IgnoreVictims[i]) )
						{
							bIgnoreThisVictim = True;
							Break;
						}
					}
				}
				else if ( Victims.IsA(IgnoreVictims[0]) )
					Continue;
				
				// Skip this Victims if IgnoreVictims array contain this Victims.class
				if ( bIgnoreThisVictim )
					Continue;
			}
			
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0, ((dist - Victims.CollisionRadius) / DamageRadius));
			
			if ( Instigator == None || Instigator.Controller == None )
				Victims.SetDelayedDamageInstigatorController( InstigatorController );
				
			if ( Victims == LastTouched )
				LastTouched = None;
				
			//[block] Cheking damageScale modifiers
			P = Pawn(Victims);
			if ( P != None )
			{
				// Do not damage a friendly Pawn
				if ( Instigator != P && Instigator.GetTeamNum() == P.GetTeamNum() && 
					 TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale <= 0.0 )
					Continue;
				
				for (i = 0; i < CheckedPawns.Length; i++)
				{
					if ( CheckedPawns[i] == P )
					{
						bAlreadyChecked = True;
						Break;
					}
				}

				if ( bAlreadyChecked )
				{
					bAlreadyChecked = False;
					P = None;
					Continue;
				}

				if ( KFMonster(Victims) != None && KFMonster(Victims).Health > 0 )
				{
					KFMonsterVictim = KFMonster(Victims);
					damageScale *= KFMonsterVictim.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
				}
				else
				{
					KFMonsterVictim = None;
					if ( KFPawn(Victims) != None && KFPawn(Victims).Health > 0 )
					{
						KFP = KFPawn(Victims);
						damageScale *= KFP.GetExposureTo(Location + 15 * -Normal(PhysicsVolume.Gravity));
					}
					else
						KFP = None;
				}

				CheckedPawns[CheckedPawns.Length] = P;
				P = None;
				if ( damageScale <= 0.0 )
					Continue;
			}
			//[end]
			
			VictimHitLocation = Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir;
			Victims.TakeDamage
			(
				(damageScale * DamageAmount),
				Instigator,
				VictimHitLocation,
				(damageScale * Momentum * dir),
				DamageType
			);
			
			if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0 )
				Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
				
			// Calculating number of victims
			if ( Role == ROLE_Authority && KFMonsterVictim != None && 
				 KFMonsterVictim.Health <= 0 )
				NumKilled++;
		}
	}
	
	if ( LastTouched != None && LastTouched != self && 
		 LastTouched.Role == ROLE_Authority && !LastTouched.IsA('FluidSurfaceInfo') )
	{
		Victims = LastTouched;
		LastTouched = None;
		
		// Do not damage a friendly Pawn
		if ( (bIgnoreSameClassProj && Victims.Class == Class) || 
			 (Instigator != Pawn(Victims) && Instigator.GetTeamNum() == Pawn(Victims).GetTeamNum() && 
				TeamGame(Level.Game) != None && TeamGame(Level.Game).FriendlyFireScale <= 0.0) )
			Return;
				
		if ( IgnoreVictims.length > 0 )
		{
			bIgnoreThisVictim = False;
			
			if ( IgnoreVictims.length > 1 )
			{
				for ( i = 0; i < IgnoreVictims.length; i++ )
				{
					if ( Victims.IsA(IgnoreVictims[i]) )
					{
						bIgnoreThisVictim = True;
						Break;
					}
				}
			}
			else if ( Victims.IsA(IgnoreVictims[0]) )
				Return;
			
			// Skip this Victims if IgnoreVictims array contain this Victims.class
			if ( bIgnoreThisVictim )
				Return;
		}
		
		dir = Victims.Location - HitLocation;
		dist = FMax(1,VSize(dir));
		dir = dir/dist;
		damageScale = FMax((Victims.CollisionRadius / (Victims.CollisionRadius + Victims.CollisionHeight)),(1.0 - FMax(0, ((dist - Victims.CollisionRadius) / DamageRadius))));
		if ( damageScale <= 0.0 )
			Return;
		
		if ( Instigator == None || Instigator.Controller == None )
			Victims.SetDelayedDamageInstigatorController(InstigatorController);
		
		VictimHitLocation = Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir;
		Victims.TakeDamage
		(
			(damageScale * DamageAmount),
			Instigator,
			VictimHitLocation,
			(damageScale * Momentum * dir),
			DamageType
		);
		
		if ( Vehicle(Victims) != None && Vehicle(Victims).Health > 0 )
			Vehicle(Victims).DriverRadiusDamage(DamageAmount, DamageRadius, InstigatorController, DamageType, Momentum, HitLocation);
	}

	if ( Role == ROLE_Authority )
	{
		if ( NumKilled >= LongDramaticEventKills )
			KFGameType(Level.Game).DramaticEvent(0.08, LongDramaticEventDuration);
		else if ( NumKilled >= MediumDramaticEvenKills )
			KFGameType(Level.Game).DramaticEvent(0.05, MediumDramaticEventDuration);
		else if ( NumKilled >= SmallDramaticEventKills )
			KFGameType(Level.Game).DramaticEvent(0.03, SmallDramaticEventDuration);
	}
	
	bHurtEntry = False;
}

// HurtRadius()
// Hurt locally authoritative actors within the radius.
function DelayedHurtRadius( float DamageAmount, float DamageRadius, class<DamageType> DamageType, float Momentum, vector HitLocation )
{
	HurtRadius(DamageAmount, DamageRadius, DamageType, Momentum, HitLocation);
}

function BlowUp(vector HitLocation)
{
	if ( bCanBeDamaged )
		bCanBeDamaged = False;
	//DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
	//if ( Role == ROLE_Authority )
		MakeNoise(1.0);
}

simulated function ShakePlayersView()
{
	local	PlayerController	PC;
	local	float				Dist, ShakeScale, ShakeRadius;
	
	PC = Level.GetLocalPlayerController();
	
	if ( PC != None && PC.ViewTarget != None )  {
		ShakeRadius = DamageRadius * ShakeRadiusScale;
		Dist = VSize(Location - PC.ViewTarget.Location);
		
		if ( Dist < ShakeRadius )  {
			ShakeScale = FClamp(((ShakeRadius - Dist) / DamageRadius), 0.001, MaxEpicenterShakeScale);
			PC.ShakeView((ShakeRotMag * ShakeScale), 
						ShakeRotRate, 
						ShakeRotTime, 
						(ShakeOffsetMag * ShakeScale), 
						ShakeOffsetRate, 
						ShakeOffsetTime);
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local	int			i;
	local	Rotator		ShrapnelSpawnRot;
	local	Projectile	ShrapnelProj;
	local	Actor		SpawnBlocker;
	local	Vector		THitLoc, THitNorm, TraceEnd;

	bHasExploded = True;
	
	if ( Role == ROLE_Authority )
		BlowUp(HitLocation);
	
	if ( !Level.bDropDetail && Level.NetMode != NM_DedicatedServer )  {
		if ( ExplodeSounds.length > 1 )
			PlaySound(ExplodeSounds[Rand(ExplodeSounds.length)],, SoundEffectsVolume);
		else if ( ExplodeSounds.length == 1 )
			PlaySound(ExplodeSounds[0],, SoundEffectsVolume);
		
		if ( EffectIsRelevant(Location, False) )  {
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
			
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		}
	}
	
	// Shrapnel
	if ( Role == ROLE_Authority && ShrapnelClass != None && MaxShrapnelAmount > 0 )  {
		if ( MaxShrapnelAmount > 1 )  {
			for ( i = Rand(Max((MaxShrapnelAmount - MinShrapnelAmount), 2)); i < MaxShrapnelAmount; i++ )  {
				ShrapnelSpawnRot = RotRand(True);
				// Number 30 here is a distance in unreal units and nothing more =)
				TraceEnd = Location + Vector(ShrapnelSpawnRot) * 30;
				SpawnBlocker = Trace(THitLoc, THitNorm, TraceEnd, Location, false);
				// If something blocking shrapnel spawn location
				if ( SpawnBlocker != None )  {
					THitLoc = (2.0 + FMax(ShrapnelClass.default.CollisionRadius, ShrapnelClass.default.CollisionHeight)) * -Normal(THitLoc - Location) + THitLoc;
					ShrapnelProj = Spawn(ShrapnelClass, Instigator,, THitLoc, ShrapnelSpawnRot);
				}
				else
					ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, ShrapnelSpawnRot);
			}
		}
		else  {
			ShrapnelSpawnRot = RotRand(True);
			// Number 30 here is a distance in unreal units and nothing more =)
			TraceEnd = Location + Vector(ShrapnelSpawnRot) * 30;
			SpawnBlocker = Trace(THitLoc, THitNorm, TraceEnd, Location, false);
			// If something blocking shrapnel spawn location
			if ( SpawnBlocker != None )  {
				THitLoc = (2.0 + FMax(ShrapnelClass.default.CollisionRadius, ShrapnelClass.default.CollisionHeight)) * -Normal(THitLoc - Location) + THitLoc;
				ShrapnelProj = Spawn(ShrapnelClass, Instigator,, THitLoc, ShrapnelSpawnRot);
			}
			else
				ShrapnelProj = Spawn(ShrapnelClass, Instigator,, Location, ShrapnelSpawnRot);
		}
	}
	// Shake nearby players screens
	ShakePlayersView();
	Destroy();
}

// Make the projectile distintegrate, instead of explode
simulated function Disintegrate(vector HitLocation, vector HitNormal)
{
	bDisintegrated = True;
	bHidden = True;
	
	if ( Role == ROLE_Authority )  {
		Damage *= DisintegrateDamageScale;
		MomentumTransfer *= DisintegrateDamageScale;
		BlowUp(HitLocation);
		SetTimer(0.1, false);
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	if ( !Level.bDropDetail && Level.NetMode != NM_DedicatedServer )  {
		if ( DisintegrateSounds.length > 1 )
			PlaySound(DisintegrateSounds[Rand(DisintegrateSounds.length)],, SoundEffectsVolume);
		else if ( DisintegrateSounds.length == 1 )
			PlaySound(DisintegrateSounds[0],, SoundEffectsVolume);

		if ( EffectIsRelevant(Location, False) && DisintegrationVisualEffect != None )
			Spawn(DisintegrationVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
	}
}

// Shoot nades in mid-air
// Alex
event TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local	int		i;
	local	bool	bDisintegrate;

	//if ( bCanTakeDamage && (Monster(instigatedBy) != None || instigatedBy == Instigator) )
	if ( Monster(instigatedBy) != None || instigatedBy == Instigator )
	{
		// Disintegrate this Projectile instead of simple detonation
		if ( DisintegrateDamageTypes.length > 0 )
		{
			for ( i = 0; i < DisintegrateDamageTypes.length; i++ )
			{
				if ( damageType == DisintegrateDamageTypes[i] )
				{
					bDisintegrate = True;
					Break;
				}
			}
		}
		
		if ( bDisintegrate )
		{
			if ( FRand() <= DisintegrateChance )
			{
				bCanBeDamaged = False;
				//bCanTakeDamage = False;
				Disintegrate(HitLocation, vect(0,0,1));
			}
		}
		else
		{
			bCanBeDamaged = False;
			//bCanTakeDamage = False;
			Explode(HitLocation, vect(0,0,1));
		}
	}
}

simulated event Destroyed()
{
	if ( !bHasExploded && !bHidden )
		Explode(Location,vect(0,0,1));
	
	if ( bHidden && !bDisintegrated )
		Disintegrate(Location,vect(0,0,1));
	
	Super.Destroyed();
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	// Updating bullet Performance before hit the victim
	// Needed because bullet lose Speed and ImpactDamage while flying
	if ( Level.TimeSeconds > NextProjectileUpdateTime )
		UpdateProjectilePerformance();
	
	if ( Role == ROLE_Authority && ImpactDamageType != None && ImpactDamage > 0.0 )
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
	
	Explode((Location + ExploWallOut * HitNormal), HitNormal);
	HurtWall = None;
}


simulated event Landed( vector HitNormal )
{
	SetPhysics(PHYS_None);
}

// Server function
function bool FriendlyPawnIsInRadius( float FriendlyPawnSearchRadius )
{
	local	KFHumanPawn	HP;
	
	foreach VisibleCollidingActors( Class 'KFHumanPawn', HP, FriendlyPawnSearchRadius, Location )  {
		if ( HP != None && HP.Health > 0 && (HP == Instigator || (TeamGame(Level.Game) != None 
			 && TeamGame(Level.Game).FriendlyFireScale > 0.0 && HP.GetTeamNum() == Instigator.GetTeamNum())) )
			Return True;
	}
	
	Return False;
}

function bool MonsterIsInRadius( float MonsterSearchRadius )
{
	local	KFMonster	M;
	
	foreach VisibleCollidingActors( Class 'KFMonster', M, MonsterSearchRadius, Location )  {
		if ( M != None && M.Health > 0 )
			Return True;
	}
	
	Return False;
}

//[end] Functions
//====================================================================

defaultproperties
{
     bCanBeDamaged=True
	 bIgnoreSameClassProj=False
	 DisintegrateDamageScale=0.100000
	 //bCanTakeDamage=True
	 ImpactDamageRadius=0.00000
	 //Shrapnel
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 // Explosion camera shakes
	 ShakeRadiusScale=2.250000
	 MaxEpicenterShakeScale=1.500000
	 ShakeRotMag=(X=650.000000,Y=650.000000,Z=650.000000)
     ShakeRotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     ShakeOffsetRate=(X=325.000000,Y=325.000000,Z=325.000000)
     ShakeOffsetTime=3.500000
	 //DramaticEvents
	 SmallDramaticEventDuration=2.000000
	 MediumDramaticEventDuration=3.000000
	 LongDramaticEventDuration=4.000000
	 SmallDramaticEventKills=2
	 MediumDramaticEvenKills=4
	 LongDramaticEventKills=8
	 //Disintegration
	 DisintegrateChance=0.950000
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Sound Effects
	 SoundEffectsVolume=2.000000
	 //DisintegrateSounds(0)=Sound'Inf_Weapons.panzerfaust60.faust_explode_distant02'
	 //DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 //ExplodeSoundsRef(0)="KF_GrenadeSnd.Nade_Explode_1"
     //ExplodeSoundsRef(1)="KF_GrenadeSnd.Nade_Explode_2"
     //ExplodeSoundsRef(2)="KF_GrenadeSnd.Nade_Explode_3"
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFMod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //Replication
	 bReplicateInstigator=True
     bNetInitialRotation=True
	 bNetNotify=True
	 //Light
	 bUnlit=True
	 //Collision
	 bBlockHitPointTraces=False
	 bSwitchToZeroCollision=True
	 //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
}
