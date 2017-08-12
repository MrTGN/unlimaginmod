//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Bloat
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 22:54
//================================================================================
class UM_BaseMonster_Bloat extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

//========================================================================
//[block] Variables

var		BileJet					BloatJet;
var		transient	bool		bBileSplashPlayed, bPopDeath, bDoBarfAttack;

var		class<FleshHitEmitter>	BileExplosion;
var		class<FleshHitEmitter>	BileExplosionHeadless;
var		Class<Projectile>		BileProjectileClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

// Called from UM_MonsterController FireWeaponAt()
function bool CanAttack(Actor A)
{
	if ( A == None || Physics == PHYS_Swimming || bShotAnim || bSTUNNED || bShocked || bKnockedDown )
		Return False;

	if ( VSizeSquared(A.Location - Location) < Square(MeleeRange + CollisionRadius + A.CollisionRadius) )
		Return True;
	else if ( VSizeSquared(A.Location - Location) <= 62500.0 )  {
		bDoBarfAttack = True;
		Return True;
	}
	
	Return False;
}

function RangedAttack(Actor A)
{
	local	float	ChargeChance;

	if ( bDoBarfAttack )  {
		bDoBarfAttack = False;
		bShotAnim = True;
		if ( FRand() > GetMovingAttackChance() )  {
			DisableMovement(); // Must be called before SetAnimAction
			SetAnimAction('ZombieBarf');
		}
		else if ( UM_MonsterController(Controller) != None )  {
			SetAnimAction('ZombieBarf');
			UM_MonsterController(Controller).GotoState('MovingAttack');
		}
		
		// Randomly send out a message about Bloat Vomit burning(3% chance)
		if ( FRand() <= 0.05 && KFHumanPawn(A) != None && PlayerController(KFHumanPawn(A).Controller) != None )
			PlayerController(KFHumanPawn(A).Controller).Speech('AUTO', 7, "");
	}
	else
		Super.RangedAttack(A);
}

// Barf Time.
function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;

	if ( Controller != None && KFDoorMover(Controller.Target) != None )  {
		Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
		Return;
	}

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + (vect(30,0,64) >> Rotation) * DrawScale;
	if ( !SavedFireProperties.bInitialized )  {
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = BileProjectileClass;
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 500;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = False;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = True;
		SavedFireProperties.bInitialized = True;
	}

	// Turn off extra collision before spawning vomit, otherwise spawn fails
	//ToggleAuxCollision(False);
	if ( Controller != None )
		FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	else
		FireRotation = Rotation;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);

	FireStart -= 0.5 * CollisionRadius * Y;
	FireRotation.Yaw -= 1200;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);

	FireStart += CollisionRadius * Y;
	FireRotation.Yaw += 2400;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);
	// Turn extra collision back on
	//ToggleAuxCollision(True);
}

simulated event Tick( float DeltaTime )
{
	local	vector			BileExplosionLoc;
	local	FleshHitEmitter	GibBileExplosion;

	Super.Tick( DeltaTime );

	if ( Level.NetMode != NM_DedicatedServer && Health < 1 && !bBileSplashPlayed &&
		HitDamageType != BleedOutDamageType )  {
		if ( !class'GameInfo'.static.UseLowGore() )  {
			BileExplosionLoc = Location;
			BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));
			if ( bDecapitated )
				GibBileExplosion = Spawn(BileExplosionHeadless,self,, BileExplosionLoc );
			else
				GibBileExplosion = Spawn(BileExplosion,self,, BileExplosionLoc );
			bBileSplashPlayed = True;
	    }
	    else  {
			BileExplosionLoc = Location;
			BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));
			GibBileExplosion = Spawn(class 'LowGoreBileExplosion',self,, BileExplosionLoc );
			bBileSplashPlayed = True;
		}
	}
}

simulated function HideBone(name BoneName)
{
	if ( BoneName == SpineBone2 )
		SetBoneScale(6, 0.0, BoneName);
	else
		Super.HideBone(BoneName);
}

function BileBomb()
{
	BloatJet = Spawn(class'BileJet', self,,Location,Rotator(-PhysicsVolume.Gravity));
}

function PlayDyingSound()
{
	if ( Level.NetMode != NM_Client )  {
		if ( bGibbed || bPopDeath )  {
			PlaySound(GibbedDeathSound, SLOT_Pain,2.0,True,525);
			Return;
		}

		if( bDecapitated )
			PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,True,525);
		else
			PlaySound(DyingSound, SLOT_Pain,2.0,True,525);
	}
}

function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDyingAnimation(DamageType, HitLoc);

	// Don't blow up with bleed out
	if ( !bPopDeath )
		Return;

	if ( !class'GameInfo'.static.UseLowGore() )
		HideBone(SpineBone2);

	if ( Role == ROLE_Authority )
		BileBomb();
}

simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	bPopDeath = DamageType != BleedOutDamageType;
	Super.PlayDying(DamageType, HitLoc);
}

State Dying
{
	event Tick( float DeltaTime )
	{
		if ( BloatJet != None )  {
			BloatJet.SetLocation(Location);
			BloatJet.SetRotation(GetBoneRotation(FireRootBone));
		}
		Super.Tick( DeltaTime );
	}
}

function RemoveHead()
{
	bCanDistanceAttackDoors = False;
	Super.RemoveHead();
}

function AdjustTakenDamage( 
	out		int					Damage, 
			Pawn				InstigatedBy, 
			vector				HitLocation, 
	out		vector				Momentum, 
			class<DamageType>	DamageType, 
			bool				bIsHeadShot )
{
	// Bloats are volatile. They burn faster than other zeds.
	if ( DamageType == class 'DamTypeBurned' )
		Damage = Round( float(Damage) * 1.5 );
	else if ( DamageType == class 'DamTypeBlowerThrower' )  {
		Damage = Round( float(Damage) * 0.25 );	// Reduced damage from the blower thrower bile, but lets not zero it out entirely
		Momentum *= 0.25;
	}
	else if ( DamageType == Class'DamTypeVomit' )  {
		Damage = 0;
		Momentum = vect(0,0,0);
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 JumpAttackChance=0.05
	 MovingAttackChance=0.2
	 
	 // Explosion parametrs
	 KilledExplodeChance=1.0
	 ExplosionDamage=240
	 ExplosionRadius=320.0
	 ExplosionMomentum=9000.0
	 ExplosionShrapnelClass=Class'UnlimaginMod.UM_BloatVomit'
	 ExplosionShrapnelAmount=(Min=2,Max=4)
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Strong'
	 
	 KnockDownHealthPct=0.65
	 ExplosiveKnockDownHealthPct=0.7
	 
	 ImpressiveKillChance=0.15
	 HeadShotSlowMoChargeBonus=0.25
	 KilledWaveCountDownExtensionTime=5.0
	 
	 BileExplosion=Class'KFMod.BileExplosion'
	 BileExplosionHeadless=Class'KFMod.BileExplosionHeadless'
	 BileProjectileClass=Class'UnlimaginMod.UM_BloatVomit'
	 AlphaSpeedScaleRange=(Max=2.8)
	 MeleeAnims(0)="BloatChop2"
	 MeleeAnims(1)="BloatChop2"
	 MeleeAnims(2)="BloatChop2"
	 DistanceDoorAttackAnim="ZombieBarf"
	 BleedOutDuration=6.000000
	 ZapThreshold=0.500000
	 ZappedDamageMod=1.500000
	 bHarpoonToBodyStuns=False
	 ZombieFlag=1
	 MeleeDamage=14
	 damageForce=70000
	 bFatAss=True
	 KFRagdollName="Bloat_Trip"
	 PuntAnim="BloatPunt"
	 Intelligence=BRAINS_Stupid
	 AlphaIntelligence=BRAINS_Mammal
	 bCanDistanceAttackDoors=True
	 SeveredArmAttachScale=1.100000
	 SeveredLegAttachScale=1.300000
	 SeveredHeadAttachScale=1.700000
	 AmmunitionClass=Class'KFMod.BZombieAmmo'
	 ScoringValue=17
	 IdleHeavyAnim="BloatIdle"
	 IdleRifleAnim="BloatIdle"
	 MeleeRange=30.000000
	 GroundSpeed=75.000000
	 WaterSpeed=102.000000
	 
	 // JumpZ
	 JumpZ=320.0
	 JumpSpeed=120.0
	 AirControl=0.15
	 HeadHeight=2.500000
	 HeadScale=1.500000
	 AmbientSoundScaling=8.000000
	 MenuName="Bloat"
	 // MovementAnims
	 MovementAnims(0)="WalkBloat"
	 MovementAnims(1)="WalkBloat"
	 MovementAnims(2)="RunL"
	 MovementAnims(3)="RunR"
	 // WalkAnims
	 WalkAnims(0)="WalkBloat"
	 WalkAnims(1)="WalkBloat"
	 WalkAnims(2)="RunL"
	 WalkAnims(3)="RunR"
	 // AirAnims
	 AirAnims(0)="InAir"
	 AirAnims(1)="InAir"
	 AirAnims(2)="InAir"
	 AirAnims(3)="InAir"
	 // LandAnims
	 LandAnims(0)="Landed"
	 LandAnims(1)="Landed"
	 LandAnims(2)="Landed"
	 LandAnims(3)="Landed"
	 IdleCrouchAnim="BloatIdle"
	 IdleWeaponAnim="BloatIdle"
	 IdleRestAnim="BloatIdle"
	 HeadlessIdleAnim="BloatIdle_Headless"
	 SoundVolume=200
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 GibbedDeathSound=Sound'KF_EnemiesFinalSnd.Bloat_DeathPop'
	 
	 HealthMax=525.0
	 Health=525
	 HeadHealth=40.0
	 DecapitatedRandDamage=(Min=100.0,Max=200.0)
	 //PlayerCountHealthScale=0.25
	 PlayerCountHealthScale=0.2
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.05
	 Mass=460.000000
}
