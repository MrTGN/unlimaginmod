//=============================================================================
// UM_HumanPawn
//=============================================================================
class UM_HumanPawn extends KFHumanPawn;

//========================================================================
//[block] Variables

// Constants
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';
//Todo: test this const!
const	MeterInUU = BaseActor.MeterInUU;
const	SquareMeterInUU = BaseActor.SquareMeterInUU;

var		bool						bDefaultPropertiesCalculated;

// Player Info
var		UM_SRClientPerkRepLink		PerkLink;
var		UM_PlayerReplicationInfo	UM_PlayerReplicationInfo;

// Replication triggers
var		bool						bPRIChangedTrigger, bClientPRIChangedTrigger;
var		bool						bVeterancyChangedTrigger, bClientVeterancyChangedTrigger;

// DyingMessage
var		int							DyingMessageHealth;
var		float						NextDyingMessageTime;

// Firing
var		float						FireSpeedModif;

// Bile Damaging
var		int							BileDamage;
var		range						BileDamageMultRandRange;
var		float						BileLifeSpan;
var		float						BileTimeLeft;
var		float						LastBileTime;

// Drowning Damage
var		range						DrowningDamageRandRange;
var		float						DrowningDamageFrequency;
var		class<DamageType>			DrowningDamageType;

// Burning Damage
var		range						BurningDamageRandRange;
var		float						BurningIntensity;
var		float						BurningFrequency, NextBurningTime, LastBurningTime;
var		class<DamageType>			BurningDamageType;

// Falling
var		class<DamageType>			FallingDamageType

// Movement Modifiers
var		float						HealthMovementModifier;
var		float						CarryWeightMovementModifier;
var		float						InventoryMovementModifier;
var		float						VeterancyMovementModifier;

// Healing
var		bool						bAllowedToChangeHealth;	// Prevents from changing Health by several functions at the same time
var		float						HealDelay, NextHealTime;
var		float						HealIntensity;		// How much health to heal at once
var		float						VeterancyHealPotency;	// Veterancy Heal Bonus

// Healing Message and score
var		string						SuccessfulHealedMessage;	// Message that You have healed somebody
var		float						AlphaAmountDecreaseFrequency;
var		float						NextAlphaAmountDecreaseTime;

// Overheal
var		int							OverhealedHealthMax;	// Max Overhealed Health for this Pawn
var		float						OverhealReductionPerSecond;
var		float						OverhealMovementBonus;	// Additional scalable movement modifier. Look into the SetHealth() calculation.
var		float						VeterancyOverhealBonus;	// Bonus to overheal somebody

// Overweight
var		float						MaxOverweightScale;
var		float						MaxCarryOverweight;
var		float						OverweightMovementModifier;
var		float						OverweightJumpModifier;

// Drugs effects
var		bool						bClientOnDrugs;	// Client-side bOnDrugs
var		float						DrugEffectHealIntensity;
var		float						LoseDrugEffectHealIntensity;
var		float						DrugsAimErrorScale;
var		float						DrugsMovementBonus;
var		float						DrugsDamageScale;
var		float						DrugsBlurDuration;
var		float						DrugsBlurIntensity;

// Jumping
var		name						LeftHandWeaponBone, RightHandWeaponBone;
var		float						RandJumpModif;
var		range						JumpRandRange;
var		float						VeterancyJumpBonus;
var		float						WeightJumpModifier;
var		float						CarryWeightJumpModifier;

// Bouncing from the walls and actors
var		Vector						BounceMomentum;
var		float						LowGravBounceMomentumScale, NextBounceTime, BounceDelay, BounceCheckDistance;
var		int							BounceRemaining;
var		Pawn						BounceVictim;

var		float						IntuitiveShootingRange;		// The distance in meters at which the shooter can shoot without aiming

var		class<MotionBlur>			UnderWaterBlurCameraEffectClass;

// Achievements (moved here from PlayerController)
// Survived 10 Seconds After Vomit
var		bool						bVomittedOn, bHasSurvivedAfterVomit;
var		float						SurvivedAfterVomitTime;

// Survived 10 Seconds After Scream
var		bool						bScreamedAt, bHasSurvivedAfterScream;
var		float						SurvivedAfterScreamTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		FireSpeedModif, bPRIChangedTrigger;
	
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetOwner )
		bVeterancyChangedTrigger, RandJumpModif;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	default.IntuitiveShootingRange *= MeterInUU;
	IntuitiveShootingRange = default.IntuitiveShootingRange;
	
	default.bDefaultPropertiesCalculated = True;
}

simulated event PreBeginPlay()
{
	if ( !default.bDefaultPropertiesCalculated )
		CalcDefaultProperties();
	
	// Server
	if ( Role == ROLE_Authority )  {
		Super.PreBeginPlay();
		RandJumpModif = GetRandRangeMult( JumpRandRange );
		// Issue #207
		SetTimer(1.5, True);
	}
}

simulated event PostBeginPlay()
{
	Super(UnrealPawn).PostBeginPlay();
	AssignInitialPose();
	
	if ( Level.NetMode != NM_DedicatedServer && bActorShadows && bPlayerShadows )  {
		if ( bDetailedShadows )
			PlayerShadow = Spawn(class'KFShadowProject', Self,'',Location);
		else
			PlayerShadow = Spawn(class'ShadowProjector', Self,'',Location);
		PlayerShadow.ShadowActor = self;
		PlayerShadow.bBlobShadow = bBlobShadow;
		PlayerShadow.LightDirection = Normal(vect(1,1,3));
		PlayerShadow.InitShadow();
	}
	
	DyingMessageHealth = HealthMax * 0.25;
}

// my PRI now has a new team
simulated function NotifyTeamChanged()
{
	bClientPRIChangedTrigger = bPRIChangedTrigger;
	
	if ( PlayerReplicationInfo != None )
		Setup(class'xUtil'.static.FindPlayerRecord(PlayerReplicationInfo.CharacterName));
	else if ( DrivenVehicle != None && DrivenVehicle.PlayerReplicationInfo != None )  {
		Setup(class'xUtil'.static.FindPlayerRecord(DrivenVehicle.PlayerReplicationInfo.CharacterName));
	
	UM_PlayerReplicationInfo = UM_PlayerReplicationInfo(PlayerReplicationInfo);
	if ( KFPC != KFPlayerController(Controller) )
		KFPC = KFPlayerController(Controller);
}

// This event is using here to notify clients about an important changes
simulated event ClientTrigger()
{
	// PlayerReplicationInfo has changed
	if ( bClientPRIChangedTrigger != bPRIChangedTrigger )
		NotifyTeamChanged();
	
	// Veterancy has changed (only client-owner receive this)
	if ( bClientVeterancyChangedTrigger != bVeterancyChangedTrigger )
		NotifyVeterancyChanged();
}

simulated event PostNetReceive() { }

simulated final function float GetRandRangeMult( range RR )
{
	Return	RR.Min + (RR.Max - RR.Min) * FRand();
}

simulated final function float GetRandMult( float MinMult, float MaxMult )
{
	Return	MinMult + (MaxMult - MinMult) * FRand();
}

simulated final function float GetRandExtraScale(
	range		ScaleRange,
	float		ExtraScaleChance,
	range		ExtraScaleRange )
{
	if ( FRand() <= ExtraScaleChance )
		Return ExtraScaleRange.Min + (ExtraScaleRange.Max - ExtraScaleRange.Min) * FRand();
	else
		Return ScaleRange.Min + (ScaleRange.Max - ScaleRange.Min) * FRand();
}

// GroundSpeed always replicated from the server to the client-owner
function UpdateGroundSpeed()
{
	GroundSpeed = default.GroundSpeed * HealthMovementModifier * CarryWeightMovementModifier * InventoryMovementModifier * VeterancyMovementModifier;
}

// Movement speed according to the healths
function UpdateHealthMovementModifiers()
{
	if ( Health > int(HealthMax) )
		HealthMovementModifier = ((float(Health) / HealthMax) * OverhealMovementBonus) + (1.0 - OverhealMovementBonus);
	else
		HealthMovementModifier = ((float(Health) / HealthMax) * HealthSpeedModifier) + (1.0 - HealthSpeedModifier);
}

// Sets the current Health
protected function SetHealth( int NewHealth )
{
	Health = Max(NewHealth, 0);
	if ( Health == 0 )
		Return;
	
	UpdateHealthMovementModifiers();
	UpdateGroundSpeed();
}

// Movement speed according to the carry weight
function UpdateCarryWeightMovementModifiers()
{
	local	float	WeightRatio;
	
	WeightRatio = CurrentWeight / MaxCarryWeight;
	// Overweight
	if ( CurrentWeight > MaxCarryWeight )  {
		CarryWeightJumpModifier = 1.0 - WeightRatio * OverweightJumpModifier;
		CarryWeightMovementModifier = 1.0 - WeightRatio * OverweightMovementModifier;
	}
	else  {
		CarryWeightJumpModifier = 1.0 - WeightRatio * WeightJumpModifier;
		CarryWeightMovementModifier = 1.0 - WeightRatio * WeightSpeedModifier;
	}
}

// Sets the current CarryWeight
function SetCarryWeight( float NewCarryWeight )
{
	CurrentWeight = NewCarryWeight;
	
	UpdateCarryWeightMovementModifiers();
	UpdateGroundSpeed();
}

function CheckVeterancyCarryWeightLimit()
{
	local	byte		t;
	local	Inventory	I;
	local	int			Count;
	
	if ( UM_PlayerReplicationInfo != None )
		MaxCarryWeight = UM_PlayerReplicationInfo.GetPawnMaxCarryWeight(default.MaxCarryWeight);
	else
		MaxCarryWeight = default.MaxCarryWeight;
	
	MaxCarryOverweight = MaxCarryWeight * MaxOverweightScale;
	
	// If we are carrying too much, drop something.
	while ( CurrentWeight > MaxCarryWeight && t < 6 )  {
		++t; // Incrementing up to 5 to restrict the number of attempts to drop weapon
		// Find the weapon to drop
		for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
			// If it's a weapon and it can be thrown
			if ( KFWeapon(I) != None && !KFWeapon(I).bKFNeverThrow )  {
				I.Velocity = Velocity;
				I.DropFrom(Location + VRand() * 10.0);
				Break;	// Stop searching
			}
			// To prevent the infinity loop because of the error in the LinkedList
			++Count;
		}
	}
}

function CheckVeterancyAmmoLimit()
{
	local	int			MaxAmmo, Count;
	local	Inventory	I;
	
	// Make sure nothing is over the Max Ammo amount when changing Veterancy
	for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
		if ( Ammunition(I) != None )  {
			if ( UM_PlayerReplicationInfo != None )
				MaxAmmo = UM_PlayerReplicationInfo.GetMaxAmmoFor( Ammunition(I).Class );
			else
				MaxAmmo = Ammunition(I).default.MaxAmmo;
			
			if ( Ammunition(I).AmmoAmount > MaxAmmo )
				Ammunition(I).AmmoAmount = MaxAmmo;
		}
		// To prevent the infinity loop because of the error in the LinkedList
		++Count;
	}
}

// Notify that veterancy has been changed.
// Called on the server and replicated by the trigger to the client-owner.
simulated function NotifyVeterancyChanged()
{
	local	Inventory	I;
	local	int			Count;
	
	// client-owner trigger
	if ( Role < ROLE_Authority )
		bClientVeterancyChangedTrigger = bVeterancyChangedTrigger;
	
	BounceMomentum = default.BounceMomentum;
	if ( UM_PlayerReplicationInfo != None )  {
		OverhealedHealthMax = Round(HealthMax * UM_PlayerReplicationInfo.GetOverhealedHealthMaxModifier());
		VeterancyOverhealBonus = UM_PlayerReplicationInfo.GetOverhealingModifier();
		VeterancyHealPotency = UM_PlayerReplicationInfo.GetHealPotency();
		VeterancyMovementModifier = UM_PlayerReplicationInfo.GetMovementSpeedModifier();
		VeterancyJumpBonus = UM_PlayerReplicationInfo.GetPawnJumpModifier();
		BounceRemaining = UM_PlayerReplicationInfo.GetPawnMaxBounce();
		IntuitiveShootingRange = default.IntuitiveShootingRange * UM_PlayerReplicationInfo.GetIntuitiveShootingModifier();
	}
	else  {
		OverhealedHealthMax = int(HealthMax);
		VeterancyOverhealBonus = default.VeterancyOverhealBonus;
		VeterancyHealPotency = default.VeterancyHealPotency;
		VeterancyMovementModifier = default.VeterancyMovementModifier;
		VeterancyJumpBonus = default.VeterancyJumpBonus;
		BounceRemaining = default.BounceRemaining;
		IntuitiveShootingRange = default.IntuitiveShootingRange;
	}
	
	// Server
	if ( Role == ROLE_Authority )  {
		CheckVeterancyCarryWeightLimit();
		CheckVeterancyAmmoLimit();
	}
	// Server and client-owner
	UpdateHealthMovementModifiers();
	UpdateCarryWeightMovementModifiers();
	UpdateGroundSpeed();
	
	/*	If there is no UM_PlayerReplicationInfo, notifying the client-owner 
		about changes by ClientTrigger() event. 
		In other case NotifyVeterancyChanged() function will be called
		on the client-owner from UM_PlayerReplicationInfo.
		This logic used to be sure that client-owner has received all ReplicationInfo data. */
	if ( Role == ROLE_Authority && UM_PlayerReplicationInfo == None )  {
		bVeterancyChangedTrigger = !bVeterancyChangedTrigger;
		bClientTrigger = !bClientTrigger;
	}
	
	// Notify all weapons in the Inventory list
	// Inventory var exists only on the server and on the client-owner
	for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
		if ( UM_BaseWeapon(I) != None )
			UM_BaseWeapon(I).NotifyOwnerVeterancyChanged();
		// To prevent the infinity loop because of the error in the LinkedList
		++Count;
	}
}

// Clearing the old function
function VeterancyChanged() { }

/* PossessedBy()
 Pawn is possessed by Controller
*/
function PossessedBy( Controller C )
{
	if ( C == None )
		Return;
	
	Controller = C;
	OldController = Controller;
	KFPC = KFPlayerController(Controller);
	NetPriority = 3.0;
	NetUpdateFrequency = 100.0;
	NetUpdateTime = Level.TimeSeconds - 1.0;
	
	if ( C.PlayerReplicationInfo != None )  {
		PlayerReplicationInfo = C.PlayerReplicationInfo;
		UM_PlayerReplicationInfo = UM_PlayerReplicationInfo(PlayerReplicationInfo);
		OwnerName = PlayerReplicationInfo.PlayerName;
		// OwnerPRI from KFPawn does not used anywhere.
		//OwnerPRI = PlayerReplicationInfo;
	}
	
	if ( PlayerController(C) != None )  {
		if ( bSetPCRotOnPossess )
			C.SetRotation(Rotation);
		// Clien-owner
		if ( Level.NetMode != NM_Standalone )
			RemoteRole = ROLE_AutonomousProxy;
		BecomeViewTarget();
	}
	else
		RemoteRole = Default.RemoteRole;

	SetOwner(Controller);	// for network replication
	EyeHeight = BaseEyeHeight;
	ChangeAnimation();
	
	// Notifying clients about PlayerReplicationInfo changes by ClientTrigger() event
	bPRIChangedTrigger = !bPRIChangedTrigger;
	// If it is a Standalone game or ListenServer
	if ( Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer )
		NotifyTeamChanged();
	
	if ( UM_PlayerReplicationInfo != None )  {
		UM_PlayerReplicationInfo.SetHumanOwner(self);
		// To be sure that client-owner will receive all ReplicationInfo before the notification.
		UM_PlayerReplicationInfo.NotifyVeterancyChanged();
		// To send the bPRIChangedTrigger update.
		bClientTrigger = !bClientTrigger;
	}
	else
		NotifyVeterancyChanged();
}

function UnPossessed()
{
	NetUpdateTime = Level.TimeSeconds - 1.0;
	if ( DrivenVehicle != None )
		NetUpdateFrequency = 5.0;

	PlayerReplicationInfo = None;
	if ( UM_PlayerReplicationInfo != None )  {
		UM_PlayerReplicationInfo.SetHumanOwner(None);
		UM_PlayerReplicationInfo = None;
	}
	SetOwner(None);
	Controller = None;
	
	// Notifying clients about PlayerReplicationInfo changes by ClientTrigger() event
	bPRIChangedTrigger = !bPRIChangedTrigger;
	// If it is a Standalone game or ListenServer
	if ( Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer )
		NotifyTeamChanged();
	
	NotifyVeterancyChanged();
}

// Accessor function that returns Intuitive Shooting (not aiming) Range
function float GetIntuitiveShootingRange()
{
	if ( Region.Zone.bDistanceFog )
		Return Min( IntuitiveShootingRange, Region.Zone.DistanceFogEnd );
	else
		Return IntuitiveShootingRange;
}

simulated function rotator GetViewRotation()
{
	if ( Controller != None )
		Return Controller.GetViewRotation();
	
	Return Rotation;
}

simulated final function GetViewAxes( out vector XAxis, out vector YAxis, out vector ZAxis )
{
	GetAxes( GetViewRotation(), XAxis, YAxis, ZAxis );
}

// Find the target to fire
final function rotator GetFireAimRotation( UM_BaseProjectileWeaponFire WeaponFire, out vector SpawnLocation )
{
	local	vector		FireDirection, TraceEnd, TraceStart, TargetLocation, HitNormal;
	local	float		f;
	local	rotator		AimRotation;
	
	if ( WeaponFire.UMWeapon.bAimingRifle )
		f = WeaponFire.MaxRange();
	else
		f = GetIntuitiveShootingRange();
	
	if ( Controller != None && UM_PlayerController(Controller) != None )
		UM_PlayerController(Controller).GetCameraPosition( TraceStart, FireDirection );
	else  {
		TraceStart = EyePosition() + Location;
		FireDirection = vector(GetViewRotation());
	}
	TraceEnd = TraceStart + FireDirection * f;
	
	// Tracing from the player camera to find the target
	foreach TraceActors( Class'Actor', Target, TargetLocation, HitNormal, TraceEnd, TraceStart )  {
		if ( Target != Self && Target.Base != Self && (Target == Level || Target.bWorldGeometry || Target.bProjTarget || Target.bBlockActors) )
			Break;	// We have found the Target
		else
			Target = None;	// Target is not satisfy the conditions of the search
	}
	
	if ( Target != None )  {
		InstantWarnTarget( Target, WeaponFire.SavedFireProperties, FireDirection );
		ShotTarget = Pawn(Target);
	}
	// If we didn't find the Target just get the TraceEnd location
	else
		TargetLocation = TraceEnd;
	
	// If target is closer to the screen than the SpawnLocation
	if ( VSizeSquared(TargetLocation - TraceStart) <= VSizeSquared(SpawnLocation - TraceStart) )  {
		if ( WeaponFire.ProjClass != None )
			f = WeaponFire.ProjClass.default.CollisionExtentVSize + 6.0;
		else
			f = 6.0;
		// Change SpawnLocation
		SpawnLocation = TargetLocation + Normal(TraceStart - TargetLocation) * f;
	}
	
	AimRotation = rotator(TargetLocation - SpawnLocation);
	if ( bOnDrugs )
		f = WeaponFire.GetAimError() * DrugsAimErrorScale;
	else
		f = WeaponFire.GetAimError();
	// Adjusting AimError to the AimRotation
	if ( f > 0.0 )  {
		AimRotation.Yaw += f * (FRand() - 0.5);
		AimRotation.Pitch += f * (FRand() - 0.5);
	}
	
	Return AimRotation;
}

simulated function Fire( optional float F )
{
	if ( Weapon != None )  {
		if ( Weapon.bBerserk != bBerserk )  {
			if ( bBerserk )
				Weapon.StartBerserk();
			else
				Weapon.StopBerserk();
		}
		Weapon.Fire(F);
	}
}

simulated function AltFire( optional float F )
{
	if ( Weapon != None )  {
		if ( Weapon.bBerserk != bBerserk )  {
			if ( bBerserk )
				Weapon.StartBerserk();
			else
				Weapon.StopBerserk();
		}
		Weapon.AltFire(F);
	}
}

function DoDoubleJump( bool bUpdating )
{
	/*
	PlayDoubleJump();

	if ( !bIsCrouched && !bWantsToCrouch )  {
		if ( !IsLocallyControlled() || AIController(Controller) != None )
			MultiJumpRemaining -= 1;
		
		Velocity.Z = JumpZ + MultiJumpBoost;
		SetPhysics(PHYS_Falling);
		if ( !bUpdating )
			PlayOwnedSound(GetSound(EST_DoubleJump), SLOT_Pain, GruntVolume,,80);
	} */
}

function bool CanDoubleJump()
{
	//Return ( MultiJumpRemaining > 0 && Physics == PHYS_Falling );
}

function bool CanMultiJump()
{
	Return ( MaxMultiJump > 0 );
}

function bool CanBounce()
{
	local	Actor		A;
	local	Vector		HitLoc, HitNorm, H, R;
	
	BounceVictim = None;
	if ( BounceRemaining > 0 && Level.TimeSeconds >= NextBounceTime )  {
		H = CollisionHeight * Vect(0.0, 0.0, 1.0);
		R = (CollisionRadius + BounceCheckDistance) * Vect(1.0, 1.0, 0.0);
		foreach TraceActors( class 'Actor', A, HitLoc, HitNorm, (Location - R), (Location + R + H), (R * 2.0 + H) )  {
			if ( A != None && A != Self && (A == Level || A.bWorldGeometry || Pawn(A) != None) )  {
				BounceVictim = Pawn(A);
				Return True;
			}
		}
	}
	
	Return False;
}

function DoBounce( bool bUpdating, float JumpModif )
{
	local	Vector		NewVel;
	local	float		MX;
	
	NextBounceTime = Level.TimeSeconds + BounceDelay * GetRandMult(0.95, 1.05);
	--BounceRemaining;
	if ( !bUpdating )
		PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
	
	//Low Gravity
	if ( PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
		JumpModif *= LowGravBounceMomentumScale;
	
	MX = default.BounceMomentum.X * JumpModif;
	NewVel = (BounceMomentum * JumpModif) >> GetViewRotation();
	NewVel.X = FClamp( (Velocity.X + NewVel.X), FMin(-MX, Velocity.X), FMax(MX, Velocity.X) );
	NewVel.Y = FClamp( (Velocity.Y + NewVel.Y), FMin(-MX, Velocity.Y), FMax(MX, Velocity.Y) );
	NewVel.Z = FClamp( (Velocity.Z + NewVel.Z), FMin(-(JumpZ * 1.25), Velocity.Z), FMax(JumpZ, Velocity.Z) );
	Velocity = NewVel;
	
	if ( BounceVictim != None )  {
		NewVel = -NewVel * FClamp((Mass / BounceVictim.Mass), 0.25, 1.25);
		if ( UM_Monster(BounceVictim) != None )
			UM_Monster(BounceVictim).PushAwayZombie(NewVel);
		else
			BounceVictim.AddVelocity(NewVel);
		
		BounceVictim = None;
	}
	
	BounceMomentum *= 0.50;
}

//Player Jumped
function bool DoJump( bool bUpdating )
{
	local	float	JumpModif;
	
	// This extra jump allows a jumping or dodging pawn to jump again mid-air
    // (via thrusters). The pawn must be within +/- 100 velocity units of the
    // apex of the jump to do this special move.
	/*
    if ( !bUpdating && CanDoubleJump() && Abs(Velocity.Z) < 100 && IsLocallyControlled() )  {
		if ( PlayerController(Controller) != None )
			PlayerController(Controller).bDoubleJump = True;
        
		DoDoubleJump(bUpdating);
        MultiJumpRemaining -= 1;
        
		Return True;
    } */
	// Do not allow to jump if somebody has grabbed this Pawn
	if ( !bIsCrouched && !bWantsToCrouch && !bMovementDisabled )  {
		// Used in DoBounce
		JumpModif = RandJumpModif * VeterancyJumpBonus;
		JumpZ = default.JumpZ * CarryWeightJumpModifier * JumpModif;
		
		if ( Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider )  {
			NextBounceTime = Level.TimeSeconds + BounceDelay * GetRandMult(0.95, 1.05);
			
			// Take you out of ironsights if you jump on a non-lowgrav map
			if ( KFWeapon(Weapon) != None && PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
				KFWeapon(Weapon).ForceZoomOutTime = Level.TimeSeconds + 0.01;
			
			if ( Role == ROLE_Authority )  {
				if ( Level.Game != None && Level.Game.GameDifficulty > 2 )
					MakeNoise((0.1 * Level.Game.GameDifficulty));
				
				if ( bCountJumps && Inventory != None )
					Inventory.OwnerEvent('Jumped');
			}
			
			if ( Physics == PHYS_Spider )
				Velocity = JumpZ * Floor;
			else if ( Physics == PHYS_Ladder )
				Velocity.Z = 0;
			else
				Velocity.Z = JumpZ;
			
			if ( Base != None && !Base.bWorldGeometry )
				Velocity.Z += Base.Velocity.Z;
			
			SetPhysics(PHYS_Falling);
			if ( !bUpdating )
				PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
			
			Return True;
		}
		else if ( Physics == PHYS_Falling && !bUpdating && CanBounce() )  {
			DoBounce(bUpdating, JumpModif);
			Return True;
		}
		
		if ( Role == ROLE_Authority )
			RandJumpModif = GetRandRangeMult( JumpRandRange );
	}
    
	Return False;
}

event Landed( vector HitNormal )
{
	BounceMomentum = default.BounceMomentum;
	if ( UM_PlayerReplicationInfo != None )
		BounceRemaining = UM_PlayerReplicationInfo.GetPawnMaxBounce();
	else
		BounceRemaining = default.BounceRemaining;
	
	ImpactVelocity = vect(0.0,0.0,0.0);
	TakeFallingDamage();
	if ( Health > 0 )
		PlayLanded(Velocity.Z);
		
	if ( Velocity.Z < -200 && PlayerController(Controller) != None )  {
		bJustLanded = PlayerController(Controller).bLandingShake;
		OldZ = Location.Z;
	}
	
	LastHitBy = None;
    //MultiJumpRemaining = MaxMultiJump;
    if ( Health > 0 && !bHidden && (Level.TimeSeconds - SplashTime) > 0.25 )
        PlayOwnedSound(GetSound(EST_Land), SLOT_Interact, FMin(1, (-0.3 * Velocity.Z / JumpZ)));
}


function name GetOffhandBoneFor(Inventory I)
{
	Return LeftHandWeaponBone;
}

function name GetWeaponBoneFor(Inventory I)
{
	Return RightHandWeaponBone;
}

// Play the pawn firing animations
simulated function StartFiringX(bool bAltFire, bool bRapid)
{
    local	name	FireAnim;
	local	float	FireAnimRate;
    local	int		AnimIndex;

    if ( HasUDamage() && (Level.TimeSeconds - LastUDamageSoundTime) > 0.25 )  {
        LastUDamageSoundTime = Level.TimeSeconds;
        PlaySound(UDamageSound, SLOT_None, (1.5 * TransientSoundVolume),, 700);
    }

    if ( Physics == PHYS_Swimming )
        Return;

    AnimIndex = Rand(4);
    if ( bAltFire )  {
        if ( bIsCrouched )
            FireAnim = FireCrouchAltAnims[AnimIndex];
        else
            FireAnim = FireAltAnims[AnimIndex];
    }
    else  {
        if ( bIsCrouched )
            FireAnim = FireCrouchAnims[AnimIndex];
        else
            FireAnim = FireAnims[AnimIndex];
    }

    AnimBlendParams(1, 1.0, 0.0, 0.2, FireRootBone);
	FireAnimRate = 1.0 * FireSpeedModif;
    if ( bRapid )  {
        if ( FireState != FS_Looping )  {
            LoopAnim(FireAnim, FireAnimRate, 0.0, 1);
            FireState = FS_Looping;
        }
    }
    else  {
        PlayAnim(FireAnim, FireAnimRate, 0.0, 1);
        FireState = FS_PlayOnce;
    }

    IdleTime = Level.TimeSeconds;
}

function bool CanCarry( float Weight )
{
	if ( Weight <= 0.0 )
		Return True;

	Return (CurrentWeight + Weight) <= MaxCarryOverweight;
}

// Add Item to this pawn's inventory.
// Returns true if successfully added, false if not.
function bool AddInventory( Inventory NewItem )
{
	if ( KFWeapon(NewItem) != None ) )  {
		if ( CanCarry( KFWeapon(NewItem).Weight ) && Super(Pawn).AddInventory(NewItem) )  {
			SetCarryWeight( CurrentWeight + KFWeapon(NewItem).Weight );
			Return True;
		}
		
		Return False;
	}
	
	Return Super(Pawn).AddInventory(NewItem);
}

function DeleteInventory( Inventory Item )
{
	// If this item is in our inventory chain, unlink it.
	local	Actor		Link;
	local	int			Count;
	
	if ( Item == Weapon )
		Weapon = None;
	
	if ( Item == SelectedItem )
		SelectedItem = None;
	
	for ( Link = Self; Link != None && Count < 1000; Link = Link.Inventory )  {
		if ( Link.Inventory == Item )  {
			if ( KFWeapon(Item) != None )
				SetCarryWeight( CurrentWeight - KFWeapon(Item).Weight );
			
			Link.Inventory = Item.Inventory;
			Link.NetUpdateTime = Level.TimeSeconds - 1.0;
			Item.Inventory = None;
			Item.NetUpdateTime = Level.TimeSeconds - 1.0;
			Break;
		}
		// To prevent the infinity loop because of the error in the LinkedList
		++Count;
	}
	
	Item.SetOwner(None);
}

// From the xPawn class
function SetWeaponOverlay( Material Mat, float Time, bool Override )
{
	if ( Weapon != None )  {
		Weapon.SetOverlayMaterial(Mat, Time, Override);
		if ( WeaponAttachment(Weapon.ThirdPersonActor) != None )
			WeaponAttachment(Weapon.ThirdPersonActor).SetOverlayMaterial(Mat, Time, Override);
	}
}

// Replicated to the server if was called on the client-side
function ServerChangedWeapon( Weapon OldWeapon, Weapon NewWeapon )
{
	local	float	InvisTime;

	// From the xPawn class
	if ( bInvis )  {
		if ( OldWeapon != None && OldWeapon.OverlayMaterial == InvisMaterial )
			InvisTime = OldWeapon.ClientOverlayCounter;
		else
			InvisTime = 20000.0;
		SetWeaponOverlay(None, 0.0, True);
	}
	else if ( HasUDamage() )
		SetWeaponOverlay(None, 0.0, True);
	
	// From the Pawn class
	if ( OldWeapon != None )  {
		OldWeapon.SetDefaultDisplayProperties();
		OldWeapon.DetachFromPawn(self);
		OldWeapon.GotoState('Hidden');
		OldWeapon.NetUpdateFrequency = 2;
	}

	Weapon = NewWeapon;
	PendingWeapon = None;
	if ( Controller != None )
		Controller.ChangedWeapon();
	
	if ( Weapon != None )  {
		Weapon.NetUpdateFrequency = 100;
		Weapon.AttachToPawn(self);
		Weapon.BringUp(OldWeapon);
		PlayWeaponSwitch(NewWeapon);
		
		if ( bInvis )
			SetWeaponOverlay(InvisMaterial, InvisTime, True);
		else if ( HasUDamage() )
			SetWeaponOverlay(UDamageWeaponMaterial, (UDamageTime - Level.TimeSeconds), False);
		
		// From the xPawn class
		if ( Weapon.bBerserk != bBerserk )  {
			if ( bBerserk )
				Weapon.StartBerserk();
			else
				Weapon.StopBerserk();
		}
		
		if ( UM_BaseWeapon(Weapon) != None )
			InventoryMovementModifier = UM_BaseWeapon(Weapon).OwnerMovementModifier;
		else if ( KFWeapon(Weapon) != None && KFWeapon(Weapon).bSpeedMeUp )
			InventoryMovementModifier = default.BaseMeleeIncrease;
		else
			InventoryMovementModifier = default.InventoryMovementModifier;
		
		if ( UM_PlayerReplicationInfo != None )
			InventoryMovementModifier *= UM_PlayerReplicationInfo.GetWeaponPawnMovementBonus(Weapon);
	}
	else
		InventoryMovementModifier = default.InventoryMovementModifier;
	
	// tell inventory that weapon changed (in case any effect was being applied)
	if ( Inventory != None )
		Inventory.OwnerEvent('ChangedWeapon');
	
	UpdateGroundSpeed();
}

// Returns true if this pawn is able to hold a weapon of the supplied type
simulated function bool AllowHoldWeapon( Weapon InWeapon )
{
    if ( UM_PlayerReplicationInfo != None )
		Return UM_PlayerReplicationInfo.CanUseThisWeapon( InWeapon );
	
	Return True;
}

// Called to change current weapon to the PendingWeapon
simulated function ChangedWeapon()
{
	local	Weapon	OldWeapon;
	
	if ( PendingWeapon != None && AllowHoldWeapon(PendingWeapon) )  {
		// From the Pawn class
		ServerChangedWeapon(Weapon, PendingWeapon);
		// Clients
		if ( Role < ROLE_Authority )  {
			OldWeapon = Weapon;
			Weapon = PendingWeapon;
			PendingWeapon = None;
			if ( Controller != None )
				Controller.ChangedWeapon();
			// BringUp weapon
			if ( Weapon != None )  {
				Weapon.BringUp(OldWeapon);
				// From the xPawn class
				if ( Weapon.bBerserk != bBerserk )  {
					if ( bBerserk )
						Weapon.StartBerserk();
					else
						Weapon.StopBerserk();
				}
			}			
		}
	}
	else
		PendingWeapon = None;
}

simulated function ClientCurrentWeaponSold()
{
	local	Inventory	I;
	local	int			Count;
	
	// Client
	if ( Role < ROLE_Authority )  {
		for ( I = Inventory; I != None && Count < 100; I = I.Inventory )  {
			if ( Weapon(I) != None && I != Weapon && I != PendingWeapon )  {
				PendingWeapon = Weapon(I);
				Break;
			}
			// To prevent the infinity loop because of the error in the LinkedList
			++Count;
		}
		ChangedWeapon();
	}
}

simulated function ClientForceChangeWeapon(Inventory NewWeapon)
{
	// Client
	if ( Role < ROLE_Authority )  {
		PendingWeapon = Weapon(NewWeapon);
		ChangedWeapon();
	}
}

// Quickly select syring, alt fire once, select old weapon again
//ToDo: issue #213.
// —сылка на Syringe должна хранитс€ в отдельной переменной.
exec function QuickHeal()
{
	local	Syringe		S;
	local	Inventory	I;
	local	int			Count;

	// Can't overheal or already overhealed to max
	if ( Health >= Round(HealthMax * VeterancyOverhealBonus) || Health >= OverhealedHealthMax )
		Return;
	
	// Find Syringe in the Inventory list
	for ( I = Inventory; I != None && Count < 250 ; I = I.Inventory )  {
		S = Syringe(I);
		if ( S != None )
			Break;
		++Count;
	}
	// Syringe wasn't found
	if ( S == None )
		Return;

	if ( S.ChargeBar() < 0.95 )  {
		if ( PlayerController(Controller) != None && HUDKillingFloor(PlayerController(Controller).myHud) != None )
			HUDKillingFloor(PlayerController(Controller).myHud).ShowQuickSyringe();
		// Can't heal now
		Return;
	}

	bIsQuickHealing = 1;
	if ( Weapon == None )  {
		PendingWeapon = S;
		// Client owner
		if ( Role < ROLE_Authority )
			ChangedWeapon();
	}
	else if ( Weapon != S )  {
		PendingWeapon = S;
		Weapon.PutDown();
	}
	// Syringe already selected, just start healing.
	else  {
		bIsQuickHealing = 0;
		S.HackClientStartFire();
	}
}

// Clearing this function
exec function ToggleFlashlight() { }

function ServerSellAmmo( Class<Ammunition> AClass );

final function bool HasWeaponClass( class<Inventory> IC )
{
	local	Inventory	I;
	local	int			Count;
	
	for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
		if ( I.Class == IC )
			Return True;
		// To prevent the infinity loop because of the error in the LinkedList
		++Count;
	}
	
	Return False;
}

final function UM_SRClientPerkRepLink FindStats()
{
	local LinkedReplicationInfo L;

	if ( Controller == None || Controller.PlayerReplicationInfo == None )
		Return None;
	
	for ( L = Controller.PlayerReplicationInfo.CustomReplicationInfo; L != None; L = L.NextReplicationInfo )  {
		if ( UM_SRClientPerkRepLink(L) != None )
			Return UM_SRClientPerkRepLink(L);
	}
	
	Return None;
}

function ServerBuyWeapon( Class<Weapon> WClass, float ItemWeight )
{
	local float Price,Weight;
	local Inventory I;

	if( !CanBuyNow() || Class<KFWeapon>(WClass)==None || Class<KFWeaponPickup>(WClass.Default.PickupClass)==None || HasWeaponClass(WClass) )
		Return;

	// Validate if allowed to buy that weapon.
	if ( PerkLink == None )
		PerkLink = FindStats();
	
	if ( PerkLink != None && !PerkLink.CanBuyPickup(Class<KFWeaponPickup>(WClass.Default.PickupClass)) )
		Return;

	Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

	if ( UM_PlayerReplicationInfo != None )
		Price *= UM_PlayerReplicationInfo.GetPickupCostScaling( WClass.Default.PickupClass );

	Weight = Class<KFWeapon>(WClass).Default.Weight;

	if( WClass==class'DualDeagle' || WClass==class'Dual44Magnum' || WClass==class'DualMK23Pistol' || WClass.Default.DemoReplacement!=None )
	{
		if ( (WClass==class'DualDeagle' && HasWeaponClass(class'Deagle'))
		 || (WClass==class'Dual44Magnum' && HasWeaponClass(class'Magnum44Pistol'))
		 || (WClass==class'DualMK23Pistol' && HasWeaponClass(class'MK23Pistol'))
		 || (WClass.Default.DemoReplacement!=None && HasWeaponClass(WClass.Default.DemoReplacement)) )
		{
			if( WClass==class'DualDeagle' )
				Weight-=class'Deagle'.Default.Weight;
			else if( WClass==class'Dual44Magnum' )
				Weight-=class'Magnum44Pistol'.Default.Weight;
			else if( WClass==class'DualMK23Pistol' )
				Weight-=class'MK23Pistol'.Default.Weight;
			else Weight-=class<KFWeapon>(WClass.Default.DemoReplacement).Default.Weight;
			Price*=0.5f;
		}
	}
	else if( WClass==class'Single' || WClass==class'Deagle' || WClass==class'Magnum44Pistol' || WClass==class'MK23Pistol' )
	{
		if ( (WClass==class'Deagle' && HasWeaponClass(class'DualDeagle'))
		 || (WClass==class'Magnum44Pistol' && HasWeaponClass(class'Dual44Magnum'))
		 || (WClass==class'MK23Pistol' && HasWeaponClass(class'DualMK23Pistol'))
		 || (WClass==class'Dualies' && HasWeaponClass(class'Single')) )
			return; // Has the dual weapon.
	}
	else // Check for custom dual weapon mode
	{
		for ( I=Inventory; I!=None; I=I.Inventory )
			if( Weapon(I)!=None && Weapon(I).DemoReplacement==WClass )
				return;
	}

	Price = int(Price); // Truncuate price.

	if ( (Weight>0 && !CanCarry(Weight)) || PlayerReplicationInfo.Score<Price )
		Return;

	I = Spawn(WClass);
	if ( I != none )
	{
		if ( KFGameType(Level.Game) != none )
			KFGameType(Level.Game).WeaponSpawned(I);

		KFWeapon(I).UpdateMagCapacity(PlayerReplicationInfo);
		KFWeapon(I).FillToInitialAmmo();
		KFWeapon(I).SellValue = Price * 0.75;
		I.GiveTo(self);
		PlayerReplicationInfo.Score -= Price;
        ClientForceChangeWeapon(I);
    }
	else ClientMessage("Error: Weapon failed to spawn.");

	SetTraderUpdate();
}

function ServerSellWeapon( Class<Weapon> WClass )
{
	local Inventory I;
	local Weapon NewWep;
	local float Price;

	if ( !CanBuyNow() || Class<KFWeapon>(WClass) == none || Class<KFWeaponPickup>(WClass.Default.PickupClass)==none
		|| Class<KFWeapon>(WClass).Default.bKFNeverThrow )  {
		SetTraderUpdate();
		Return;
	}

	for ( I = Inventory; I != none; I = I.Inventory )
	{
		if ( I.Class==WClass )
		{
			if ( KFWeapon(I) != none && KFWeapon(I).SellValue != -1 )
				Price = KFWeapon(I).SellValue;
			else
			{
				Price = (class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75);

				if ( UM_PlayerReplicationInfo != None )
					Price *= UM_PlayerReplicationInfo.GetPickupCostScaling( WClass.default.PickupClass );
			}

			if ( I.Class==Class'Dualies' )
			{
				NewWep = Spawn(class'Single');
				Price*=2.f;
			}
			else if ( I.Class==Class'DualDeagle' )
				NewWep = Spawn(class'Deagle');
			else if ( I.Class==Class'Dual44Magnum' )
				NewWep = Spawn(class'Magnum44Pistol');
			else if ( I.Class==Class'DualMK23Pistol' )
				NewWep = Spawn(class'MK23Pistol');
			else if( Weapon(I).DemoReplacement!=None )
				NewWep = Spawn(Weapon(I).DemoReplacement);
			if( NewWep!=None )
			{
				Price *= 0.5f;
				NewWep.GiveTo(self);
			}

			if ( I==Weapon || I==PendingWeapon )
			{
				ClientCurrentWeaponSold();
			}

			PlayerReplicationInfo.Score += int(Price);

			I.Destroy();

			SetTraderUpdate();

			if ( KFGameType(Level.Game)!=none )
				KFGameType(Level.Game).WeaponDestroyed(WClass);
			return;
		}
	}
}

simulated function AddBlur( float BlurDuration, float Intensity )
{
	if ( KFPC != None && Viewport(KFPC.Player) != None && !bUsingHitBlur && bUseBlurEffect )  {
		StartingBlurFadeOutTime = BlurDuration;
		BlurFadeOutTime = StartingBlurFadeOutTime;
		if ( CurrentBlurIntensity < Intensity )
			CurrentBlurIntensity = Intensity;
		
		if ( KFPC.PostFX_IsReady() )
			KFPC.SetBlur(CurrentBlurIntensity);
		else if ( UnderWaterBlurCameraEffectClass != None )  {
			if ( CameraEffectFound == None )
				FindCameraEffect(UnderWaterBlurCameraEffectClass);
			
			if ( MotionBlur(CameraEffectFound) != None )
				MotionBlur(CameraEffectFound).BlurAlpha = UnderWaterBlurCameraEffectClass.default.BlurAlpha;
		}
	}
}

simulated function DoHitCamEffects( vector HitDirection, float JarrScale, float BlurDuration, float JarDurationScale )
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )
		Super.DoHitCamEffects(HitDirection, JarrScale, BlurDuration, JarDurationScale);
}

simulated function StopHitCamEffects()
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )  {
		CurrentBlurIntensity = 0.0;
		if ( CameraEffectFound != None )
			RemoveCameraEffect(RemoveCameraEffect);
		
		KFPC.StopViewShaking();
		KFPC.SetBlur(0);
	}
}

//ToDo: issue #204
function ArmorAbsorbDamage( out int Damage, Pawn instigatedBy, out Vector Momentum, class<DamageType> DamageType )
{
	if ( DamageType.default.bArmorStops )
		Damage = ShieldAbsorb( Damage );
}

// Process the damage taking and return the taken damage value
function int ProcessTakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType )
{
	local	Controller	Killer;
	
	// Only server
	if ( Role < ROLE_Authority || Health < 1 || Damage < 1 )
		Return 0;
	
	if ( DamageType == None )  {
		if ( InstigatedBy != None && InstigatedBy.Weapon != None )
			Warn("No damagetype for damage by "$InstigatedBy$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}
	
	if ( (InstigatedBy == None || InstigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None )
		InstigatedBy = DelayedDamageInstigatorController.Pawn;
	
	if ( Physics == PHYS_None && DrivenVehicle == None )
		SetMovementPhysics();
	
	// Momentum
	if ( Physics == PHYS_Walking && damageType.default.bExtraMomentumZ )
		Momentum.Z = FMax( (0.4 * VSize(Momentum)), Momentum.Z );
	if ( InstigatedBy == self )
		Momentum *= 0.75;
	Momentum /= Mass;
	
	//[block] Damage modifiers
	// Owner takes damage while holding this weapon - used by shield gun
	if ( Weapon != None )
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	
	// Modify Damage if Pawn is driving a vehicle
	if ( DrivenVehicle != None )
		DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	
	if ( InstigatedBy != None && InstigatedBy.HasUDamage() )
		Damage *= 2;
	
	if ( UM_PlayerReplicationInfo != None )
		Damage = Round( float(Damage) * UM_PlayerReplicationInfo.GetHumanTakenDamageModifier(self, InstigatedBy, DamageType) );
	
	if ( bOnDrugs )
		Damage = Round( float(Damage) * DrugsDamageScale );
	
	if ( Level.Game != None )
		Damage = Level.Game.ReduceDamage( Damage, self, instigatedBy, HitLocation, Momentum, DamageType );
	
	//ToDo: issue #204
	// if ( Armor != None )
		ArmorAbsorbDamage( Damage, instigatedBy, Momentum, DamageType );
	//[end]
	
	// Just return if this wouldn't even damage us.
	if ( Damage < 1 )
		Return 0;
	
	bAllowedToChangeHealth = False;
	// Achievements Helper
	if ( KFMonster(InstigatedBy) != None )
		KFMonster(InstigatedBy).bDamagedAPlayer = True;
	
	LastHitDamType = DamageType;
	LastDamagedBy = InstigatedBy;
	
	if ( HitLocation == vect(0.0, 0.0, 0.0) )
		HitLocation = Location;
	
	SetHealth( Health - Damage );
	PlayHit( Damage, InstigatedBy, HitLocation, DamageType, Momentum );
	// Pawn died
	if ( Health < 1 )  {
		if ( InstigatedBy != None && InstigatedBy != self )
			Killer = InstigatedBy.Controller;
		else if ( DamageType.default.bCausedByWorld && LastHitBy != None )
			Killer = LastHitBy;
		// if no Killer
		if ( Killer == None && DelayedDamageInstigatorController != None )
			Killer = DelayedDamageInstigatorController;
		
		if ( bPhysicsAnimUpdate )
			SetTearOffMomemtum( Momentum );
		
		Died( Killer, DamageType, HitLocation );
	}
	// Paw has lost some Health
	else  {
		AddVelocity( Momentum );
		if ( Controller != None )
			Controller.NotifyTakeHit( InstigatedBy, HitLocation, Damage, DamageType, Momentum );
		if ( InstigatedBy != None && InstigatedBy != self )
			LastHitBy = InstigatedBy.Controller;
		
		if ( KFPC != None && Level.Game.NumPlayers > 1 && Health <= DyingMessageHealth && Level.TimeSeconds > NextDyingMessageTime )  {
			NextDyingMessageTime = Level.TimeSeconds + DyingMessageDelay;
			// Tell everyone we're dying
			KFPC.Speech('AUTO', 6, "");
		}
	}
	MakeNoise(1.0);
	bAllowedToChangeHealth = True;
	
	Return Damage;
}

// server only
event TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	// GodMode or FriendlyFire
	if ( (Controller != None && Controller.bGodMode) || Damage < 1
		 || (InstigatedBy != None && InstigatedBy != Self && UM_GameReplicationInfo(Level.GRI) != None 
			 && UM_GameReplicationInfo(Level.GRI).FriendlyFireScale <= 0.0 && InstigatedBy.GetTeamNum() == GetTeamNum()) )
		Return;
	
	// Burnified if the burn damage was significant enough
	if ( (class<DamTypeBurned>(DamageType) != None || class<DamTypeFlamethrower>(DamageType) != None || class<UM_BaseDamType_Flame>(DamageType) != None) && Damage > 2 )  {
		// Update timers only if we are not already burning
		if ( NextBurningTime < Level.TimeSeconds )  {
			LastBurningTime = Level.TimeSeconds;
			NextBurningTime = LastBurningTime + BurningFrequency;
		}
		
		BurningIntensity += float(Damage);
		BurnInstigator = InstigatedBy;
		bBurnified = BurningIntensity > 0.0;
		
		Return; // Burning does not cause an instant damage
	}
	
	// Start to taking a BileDamage if damage was significant enough
	if ( Class<DamTypeVomit>(DamageType) != None && Damage > 2 )  {
		// Update timers only if we are not already taking a bile damage
		if ( NextBileTime < Level.TimeSeconds )  {
			LastBileTime = Level.TimeSeconds;
			NextBileTime = LastBileTime + BileFrequency;
			BileDamage = Damage;
		}
		else
			BileDamage = Max(Damage, BileDamage);
		
		BileInstigator = InstigatedBy;
		BileTimeLeft += BileLifeSpan;
		
		// Survived 10 Seconds After Vomit Achievement
		if ( Level.Game != None && Level.Game.GameDifficulty >= 4.0 && !bVomittedOn )  {
			SurvivedAfterVomitTime = Level.TimeSeconds + 10.0;
			bVomittedOn = True;
		}
		
		Return;	// Bile does not cause an instant damage
	}
	
	// Survived 10 Seconds After Scream Achievement
	if ( (Class<UM_ZombieDamType_SirenScream>(DamageType) != None || Class<SirenScreamDamage>(DamageType) != None) 
			 && Level.Game != None && Level.Game.GameDifficulty >= 4.0 && !bScreamedAt )  {
		SurvivedAfterScreamTime = Level.TimeSeconds + 10.0;
		bScreamedAt = True;
	}
	
	ProcessTakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	
	//Todo: Issue #189
	/*
	//Simulated Bloody Overlays
	if ( (Health - Damage) <= (HealthMax * 0.4) )
		SetOverlayMaterial(InjuredOverlay, 0, true); */
}

// Reward for healing someone
function RewardForHealing( int HealthHealed, float MoneyPerHealedHealth, UM_HumanPawn Patient )
{
	if ( Role < ROLE_Authority || Patient == None || Patient.bDeleteMe || UM_PlayerReplicationInfo == None )
		Return;
	
	// Add HealthHealed to the StatsAndAchievements
	if ( KFSteamStatsAndAchievements(UM_PlayerReplicationInfo.SteamStatsAndAchievements) != None )
		KFSteamStatsAndAchievements(UM_PlayerReplicationInfo.SteamStatsAndAchievements).AddDamageHealed( HealthHealed );
	
	// Give the reward money as a percentage of how much of the person's health they healed
	HealthHealed = Round( 100.0 * float(HealthHealed) / Patient.HealthMax * MoneyPerHealedHealth );
	UM_PlayerReplicationInfo.Score += HealthHealed;
	UM_PlayerReplicationInfo.ThreeSecondScore += HealthHealed;
	UM_PlayerReplicationInfo.Team.Score += HealthHealed;
	// Score AlphaAmount
	NextAlphaAmountDecreaseTime = Level.TimeSeconds + AlphaAmountDecreaseFrequency;
	AlphaAmount = 255;
	
	// Successful Healed Message
	if ( KFPC != None && Patient.PlayerReplicationInfo != None )
		KFPC.ClientMessage( SuccessfulHealedMessage @ Patient.PlayerReplicationInfo.PlayerName, 'CriticalEvent' );
}

// Heal me!
function bool Heal( out int HealAmount, int HealMax )
{
	// Don't let heal more than the max overhealed health
	if ( bCanBeHealed && Health > 0 && Health < HealMax )  {
		// Updating timers
		if ( NextHealTime < Level.TimeSeconds )  {
			LastHealTime = Level.TimeSeconds;
			NextHealTime = LastHealTime + HealDelay;
		}
		HealIntensity += FMax( (float(HealAmount) * 0.5), 0.505 ); // to guarantee rounding to 1
		if ( !bOnDrugs && HealIntensity >= DrugEffectHealIntensity )
			SetOnDrugs();
		// Calculating out HealAmount for the healing reward
		HealAmount = Min( (HealMax - Health), HealAmount );
		
		Return HealAmount > 0;
	}
	
	Return False;
}

// Left this function for the old or third-party healing logic
function bool GiveHealth( int HealAmount, int HealMax )
{
	Return Heal( HealAmount, HealMax );
}

// Overheal Reduction
protected function ReduceOverheal()
{
	NextOverhealReductionTime = Level.TimeSeconds + 1.0 / OverhealReductionPerSecond;
	SetHealth( Max( (Health - 1), int(HealthMax) ) );
}

// Healing with HealIntensity decreasing
protected function AddHealth()
{
	local	int		DeltaHealIntensity;
	
	NextHealTime = Level.TimeSeconds + HealDelay;
	if ( Health > 0 )  {
		// Rounding HealIntensity per delay
		DeltaHealIntensity = Round(HealIntensity * (Level.TimeSeconds - LastHealTime));
		if ( DeltaHealIntensity > 0 )  {
			LastHealTime = Level.TimeSeconds;
			if ( Health < OverhealedHealthMax )
				SetHealth( Min((Health + DeltaHealIntensity), OverhealedHealthMax) );
			HealIntensity = FMax( (HealIntensity - float(DeltaHealIntensity) * 0.5), 0.0 );
		}
		// turn off drug effects
		if ( bOnDrugs && HealIntensity <= LoseDrugEffectHealIntensity )
			SetNotOnDrugs();
		// Checking HealIntensity
		if ( Round(HealIntensity) < 1 )
			HealIntensity = 0.0;
	}
	else
		HealIntensity = 0.0;
}

// Take a Bile Damage (called from the Tick)
function TakeBileDamage()
{
	local	vector	BileCamVect;
	local	int		DeltaBileDamage;
	
	NextBileTime = Level.TimeSeconds + BileFrequency;
	BileTimeLeft = FMax( (BileTimeLeft - BileFrequency), 0.0 );
	
	DeltaBileDamage = Round(float(BileDamage) * GetRandRangeMult(BileDamageMultRandRange) * (Level.TimeSeconds - LastBileTime));
	if ( DeltaBileDamage > 0 )  {
		DeltaBileDamage = ProcessTakeDamage( DeltaBileDamage, BileInstigator, Location, vect(0.0, 0.0, 0.0), LastBileDamagedByType );
		if ( DeltaBileDamage > 0 )  {
			LastBileTime = Level.TimeSeconds;
			// CamEffects
			if ( Controller != None && PlayerController(Controller) != None )  {
				BileCamVect = vect( FRand(), FRand(), FRand() );
				if ( class<DamTypeBileDeckGun>(LastBileDamagedByType) != None )
					DoHitCamEffects( BileCamVect, 0.25, 0.75, 0.5 );
				else
					DoHitCamEffects( BileCamVect, 0.35, 2.0,1.0 );
			}
		}
	}
}

// Clearing old function
function TakeFireDamage( int Damage, pawn BInstigator ) { }

// Take a Burning Damage (called from the Tick)
function TakeBurningDamage()
{
	local	int		DeltaBurningDamage;
	
	NextBurningTime = Level.TimeSeconds + BurningFrequency;
	// Rounding BurningIntensity per delay
	DeltaBurningDamage = Round(FMin(BurningIntensity, GetRandRangeMult(BurningDamageRandRange)) * (Level.TimeSeconds - LastBurningTime));
	if ( DeltaBurningDamage > 0 )  {
		BurningIntensity = FMax( (BurningIntensity - float(DeltaBurningDamage)), 0.0 );
		DeltaBurningDamage = ProcessTakeDamage( DeltaBurningDamage, BurnInstigator, Location, vect(0.0, 0.0, 0.0), BurningDamageType );
		if ( DeltaBurningDamage > 0 )  {
			LastBurningTime = Level.TimeSeconds;
			// Shake controller
			if ( Controller != None )
				Controller.DamageShake( DeltaBurningDamage );
		}
	}
	// Checking BurningIntensity
	if ( Round(BurningIntensity) < 1 )  {
		BurningIntensity = 0.0;
		bBurnified = False;
	}
}

// Take a Falling Damage
function TakeFallingDamage()
{
	local	float	FallingSpeedRatio;
	local	int		FallingDamage;
	
	// Calculating FallingSpeedRatio, taking into account PhysicsVolume gravity
	if ( TouchingWaterVolume() )
		FallingSpeedRatio = (Abs(Velocity.Z) - (GroundSpeed - WaterSpeed) * 2.0) / (MaxFallSpeed * Abs(Class'PhysicsVolume'.default.Gravity.Z) / Abs(PhysicsVolume.Gravity.Z));
	else
		FallingSpeedRatio = Abs(Velocity.Z) / (MaxFallSpeed * Abs(Class'PhysicsVolume'.default.Gravity.Z) / Abs(PhysicsVolume.Gravity.Z));
	
	if ( FallingSpeedRatio > 0.5 )  {
		FallingDamage = Round(HealthMax * FallingSpeedRatio - HealthMax);
		// Server
		if ( Role == ROLE_Authority )  {
			MakeNoise( FMin(FallingSpeedRatio, 1.0) );
			// Hurt pawn if FallingSpeed is over the MaxFallSpeed
			if ( FallingSpeedRatio > 1.0 )
				ProcessTakeDamage( FallingDamage, None, Location, vect(0.0, 0.0, 0.0), FallingDamageType );
		}
		// Shake controller
		if ( Controller != None )
			Controller.DamageShake( FallingDamage );
	}
}

// Take a Drowning Damage (called from the BreathTimer)
function TakeDrowningDamage()
{
	ProcessTakeDamage( Round(GetRandRangeMult(DrowningDamageRandRange)), None, EyePosition(), vect(0.0, 0.0, 0.0), DrowningDamageType );
	if ( Health > 0 )
		BreathTime = DrowningDamageFrequency;
}

event BreathTimer()
{
	if ( Health < 1 || Level.NetMode == NM_Client || DrivenVehicle != None )
		Return;
	
	TakeDrowningDamage();
}

// Clearing
function Drugs() { }

simulated function SetOnDrugs()
{
	bBerserk = True;
	if ( Role == ROLE_Authority )  {
		bOnDrugs = True;
		PlaySound(BreathingSound, SLOT_Talk, TransientSoundVolume,, TransientSoundRadius,, True);
	}
	// Client NetOwner
	else
		bClientOnDrugs = True;
	
	if ( IsLocallyControlled() )
		AddBlur(DrugsBlurDuration, DrugsBlurIntensity);
		
	if ( Weapon != None )
		Weapon.StartBerserk();
}

simulated function SetNotOnDrugs()
{
	bBerserk = False;
	if ( Role == ROLE_Authority )
		bOnDrugs = False;
	// Client NetOwner
	else
		bClientOnDrugs = False;
		
	if ( Weapon != None )
		Weapon.StopBerserk();
}

simulated function StartBurnFX()
{
	if ( ItBUURRNNNS == None && !bGibbed && !bDeleteMe )  {
		ItBUURRNNNS = Spawn(BurnEffect);
		ItBUURRNNNS.SetBase(Self);
		ItBUURRNNNS.Emitters[0].SkeletalMeshActor = self;
		ItBUURRNNNS.Emitters[0].UseSkeletalLocationAs = PTSU_SpawnOffset;
	}

	bBurnApplied = True;
}

simulated function RemoveFlamingEffects()
{
    local	int		i;

    if ( Level.NetMode == NM_DedicatedServer )
        Return;

    for ( i = 0; i < Attached.Length; ++i )  {
        if ( xEmitter(Attached[i]) != None && BloodJet(Attached[i]) == None )
			xEmitter(Attached[i]).mRegen = False;
		else if ( KFMonsterFlame(Attached[i]) != None )
			Attached[i].LifeSpan = 0.1;
    }
}

simulated function StopBurnFX()
{
	RemoveFlamingEffects();
	if ( ItBUURRNNNS != None )
		ItBUURRNNNS.Kill();
    
	bBurnApplied = False;
}

simulated function UpdateCameraBlur()
{
	local	float	BlurAmount;
	
	BlurFadeOutTime	-= DeltaTime;
	BlurAmount = BlurFadeOutTime / StartingBlurFadeOutTime * CurrentBlurIntensity;

	if ( BlurFadeOutTime <= 0.0 )  {
		BlurFadeOutTime = 0.0;
		StopHitCamEffects();
	}
	else if ( bUseBlurEffect )  {
		if ( KFPC != None && KFPC.PostFX_IsReady() )
			KFPC.SetBlur(BlurAmount);
		else if( CameraEffectFound != None )
			UnderWaterBlur(CameraEffectFound).BlurAlpha = Lerp( BlurAmount, 255, UnderWaterBlur(CameraEffectFound).default.BlurAlpha );
	}
}

simulated event Tick( float DeltaTime )
{
	// Server
	if ( Role == ROLE_Authority )  {
		// Enable Movement
		if ( bMovementDisabled && Level.TimeSeconds >= StopDisabledTime )  {
			bMovementDisabled = False;
			NetUpdateTime = Level.TimeSeconds - 1.0;
		}
		// Operations with Pawn Health
		if ( bAllowedToChangeHealth )  {
			// Overheal Reduction
			if ( Health > int(HealthMax) && Level.TimeSeconds >= NextOverhealReductionTime )
				ReduceOverheal();
			
			// Healing
			if ( HealIntensity > 0.0 && Level.TimeSeconds >= NextHealTime )
				AddHealth();
			
			// Bile Damage
			if ( BileTimeLeft > 0.0 && Level.TimeSeconds >= NextBileTime )
				TakeBileDamage();
			
			// Burning Damage
			if ( BurningIntensity > 0.0 && Level.TimeSeconds >= NextBurningTime )
				TakeBurningDamage();
		}
		//ToDo: перенести эти ачивки в таймер поcле выполнени€ Issue #207
		// Survived 10 Seconds After Vomit Achievement
		if ( !bHasSurvivedAfterVomit && bVomittedOn && Health > 0 && Level.TimeSeconds >= SurvivedAfterVomitTime )  {
			if ( PlayerReplicationInfo != None && KFSteamStatsAndAchievements(PlayerReplicationInfo.SteamStatsAndAchievements) != None )  {
				bHasSurvivedAfterVomit = True;
				KFSteamStatsAndAchievements(PlayerReplicationInfo.SteamStatsAndAchievements).Survived10SecondsAfterVomit();
			}
			else
				bVomittedOn = False;
		}
		// Survived 10 Seconds After Scream Achievement
		if ( !bHasSurvivedAfterScream && bScreamedAt && Health > 0 && Level.TimeSeconds >= SurvivedAfterScreamTime )  {
			if ( PlayerReplicationInfo != None && KFSteamStatsAndAchievements(PlayerReplicationInfo.SteamStatsAndAchievements) != None )  {
				bHasSurvivedAfterScream = True;
				KFSteamStatsAndAchievements(PlayerReplicationInfo.SteamStatsAndAchievements).Survived10SecondsAfterScream();
			}
			else
				bScreamedAt = False;
		}
		// Score AlphaAmount replicated from the server to the client-owner
		if ( AlphaAmount > 0 && Level.TimeSeconds >= NextAlphaAmountDecreaseTime )  {
			NextAlphaAmountDecreaseTime = Level.TimeSeconds + AlphaAmountDecreaseFrequency;
			AlphaAmount -= 5;
			if ( AlphaAmount <= 0 || UM_PlayerReplicationInfo == None || UM_PlayerReplicationInfo.ThreeSecondScore <= 0 )  {
				AlphaAmount = 0;
				if ( UM_PlayerReplicationInfo != None )
					UM_PlayerReplicationInfo.ThreeSecondScore = 0;
				ScoreCounter = 0;	// WTF is this?
			}
		}
	}
	// Client
	else  {
		// From KFPawn
		if ( bThrowingNade )  {
			if ( NadeThrowTimeout > 0.0 )
				NadeThrowTimeout -= DeltaTime;
			/* This is a hack to clear this flag on the client after a bit of time. 
				This fixes a bug where you could get stuck unable to use weapons */
			if ( NadeThrowTimeout <= 0.0 )  {
				NadeThrowTimeout = 0.0;
				ThrowGrenadeFinished();
			}
		}
		// Drugs effects on the client-side
		if ( bOnDrugs != bClientOnDrugs )  {
			if ( bOnDrugs )
				SetOnDrugs();
			else
				SetNotOnDrugs();
		}
	}
	
	// Burning effects
	if ( Level.NetMode != NM_DedicatedServer && bBurnified != bBurnApplied )  {
		if ( bBurnified )
			StartBurnFX();
		else
			StopBurnFX();
	}
	
	// Reset AnimAction replication.
	if ( bResetingAnimAct && Level.TimeSeconds > AnimActResetTime )  {
		bResetingAnimAct = False;
		AnimAction = '';
	}
	
	if ( bDestroyAfterRagDollTick && Physics == PHYS_KarmaRagdoll
		 && !bProcessedRagTickDestroy && GetRagDollFrames() > 0 )  {
		bProcessedRagTickDestroy = True;
		Destroy();
	}
	// If we've flagged this character to be destroyed next tick, handle that
	else if ( bDestroyNextTick && Level.TimeSeconds > TimeSetDestroyNextTickTime )
		Destroy();
	
	Super(xPawn).Tick(DeltaTime);
	
	// Locally controlled client camera Blur Effect
	if ( !bUsingHitBlur && BlurFadeOutTime > 0.0 && IsLocallyControlled() )
		UpdateCameraBlur();
}

event Timer()
{
	//ToDo: выпилить это! Issue #207
	// Flashlight Drain
	if ( KFWeapon(Weapon) != None && KFWeapon(Weapon).FlashLight != None )  {
		// Increment / Decrement battery life
		if ( KFWeapon(Weapon).FlashLight.bHasLight && TorchBatteryLife > 0 )
			TorchBatteryLife -= 10;
		else if ( !KFWeapon(Weapon).FlashLight.bHasLight && TorchBatteryLife < default.TorchBatteryLife )  {
			TorchBatteryLife += 20;
			if ( TorchBatteryLife > default.TorchBatteryLife )
				TorchBatteryLife = default.TorchBatteryLife;
		}
	}
	else if ( TorchBatteryLife < default.TorchBatteryLife )  {
		TorchBatteryLife += 20;
		if ( TorchBatteryLife > default.TorchBatteryLife )
			TorchBatteryLife = default.TorchBatteryLife;
	}

	// Instantly set the animation to arms at sides Idle if we've got no weapon (rather than Pointing an invisible gun!)
	if ( Weapon == None || (WeaponAttachment(Weapon.ThirdPersonActor) == None && VSizeSquared(Velocity) <= 0.0) )
		IdleWeaponAnim = IdleRestAnim;
}

// Don't let this pawn move for a certain amount of time
function DisableMovement( float DisableDuration )
{
    StopDisabledTime = Level.TimeSeconds + DisableDuration;
    bMovementDisabled = True;
	NetUpdateTime = Level.TimeSeconds - 1.0;
}

/*	Modify velocity called by physics before applying new velocity for this tick.
	Velocity,Acceleration, etc. have been updated by the physics, but location hasn't.	*/
simulated event ModifyVelocity( float DeltaTime, vector OldVelocity )
{
	if ( bMovementDisabled && Physics == PHYS_Walking )
		Velocity = Vect(0.0, 0.0, 0.0);
}

function ExtendedCreateInventoryVeterancy(
			string	InventoryClassName, 
			float	SellValueScale, 
 optional	int		AddExtraAmmo,
 optional	int		FireModeNum)
{
	local Inventory			Inv;
	local class<Inventory>	InventoryClass;

	InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
	
	if ( InventoryClass != None && FindInventoryType(InventoryClass) == None )  {
		Inv = Spawn(InventoryClass);
		if ( Inv != none )  {
			Inv.GiveTo(self);
			
			if ( Inv != None )
				Inv.PickupFunction(self);
			
			if ( KFGameType(Level.Game) != none )
				KFGameType(Level.Game).WeaponSpawned(Inv);
			
			if ( KFWeapon(Inv) != none )  {
				KFWeapon(Inv).SellValue = float(class<KFWeaponPickup>(InventoryClass.default.PickupClass).default.Cost) * SellValueScale * 0.75;
				
				if ( AddExtraAmmo > 0 )  {
					if ( FireModeNum <= 0 )
						FireModeNum = 0;
					else
						FireModeNum = 1;
					
					if ( KFWeapon(Inv).AmmoAmount(FireModeNum) < KFWeapon(Inv).MaxAmmo(FireModeNum) )  {
						if ( AddExtraAmmo > (KFWeapon(Inv).MaxAmmo(FireModeNum) - KFWeapon(Inv).AmmoAmount(FireModeNum)) )
							AddExtraAmmo = KFWeapon(Inv).MaxAmmo(FireModeNum) - KFWeapon(Inv).AmmoAmount(FireModeNum);
						
						KFWeapon(Inv).AddAmmo(AddExtraAmmo, FireModeNum);
					}
				}
			}
		}
	}
}

//ToDo: вынести гранату в отдельную переменную
function ThrowGrenade()
{
	local	Inventory	Inv;
	local	int			Count;

	if ( AllowGrenadeTossing() )  {
		for ( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
			if ( Frag(Inv) != None && Frag(Inv).HasAmmo() && !bThrowingNade
				 && KFWeapon(Weapon) != None 
				 && (!KFWeapon(Weapon).bIsReloading || KFWeapon(Weapon).InterruptReload())
				 && (Weapon.GetFireMode(0).NextFireTime - Level.TimeSeconds) <= 0.1 )  {
				KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
				Weapon.PutDown();
				Break;
			}
			// To prevent the infinity loop because of the error in the LinkedList
			++Count;
		}
	}
}

function WeaponDown()
{
    local	Inventory	Inv;
	local	int			Count;

    for( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
        if ( Frag(Inv) != None && Frag(Inv).HasAmmo() )  {
            SecondaryItem = Frag(Inv);
            Frag(Inv).StartThrow();
        }
		// To prevent the infinity loop because of the error in the LinkedList
		++Count;
    }
}

simulated function ThrowGrenadeFinished()
{
	SecondaryItem = None;
	KFWeapon(Weapon).ClientGrenadeState = GN_BringUp;
	Weapon.BringUp();
	bThrowingNade = false;
}

exec function SwitchToLastWeapon()
{
    if ( Weapon != None && Weapon.OldWeapon != None )  {
        PendingWeapon = Weapon.OldWeapon;
        Weapon.PutDown();
    }
}

//[end] Functions
//====================================================================

defaultproperties
{
     SuccessfulHealedMessage="You have healed"
	 // Decrease AlphaAmount every 60 milliseconds
	 AlphaAmountDecreaseFrequency=0.06
	 RandJumpModif=1.0
	 VeterancyHealPotency=1.0
	 VeterancyOverhealBonus=1.0
	 GroundSpeed=200.000000
     WaterSpeed=180.000000
     AirSpeed=230.000000
     // Damaging
	 BileFrequency=0.5
	 BileLifeSpan=4.0
	 BileDamageMultRandRange=(Min=0.7,Max=1.3)
	 // Drowning
	 DrowningDamageRandRange=(Min=3.0,Max=6.0)
	 DrowningDamageFrequency=1.0
     DrowningDamageType=Class'Drowned'
	 // Burning
	 BurningDamageRandRange=(Min=4.0,Max=6.0)
	 BurningFrequency=0.5
	 BurningDamageType=Class'DamTypeBurned'
	 // Falling
	 FallingDamageType=Class'Fell'
	 // CarryWeight
	 WeightSpeedModifier=0.14
	 WeightJumpModifier=0.07
	 MaxOverweightScale=1.2
	 OverweightMovementModifier=0.3
	 OverweightJumpModifier=0.2
	 // Healing
	 HealDelay=0.1
	 OverhealReductionPerSecond=2.0
	 OverhealMovementBonus=0.2
	 // Drugs
	 DrugsBlurDuration=5.0
	 DrugsBlurIntensity=0.5
	 DrugEffectHealIntensity=30.0
	 LoseDrugEffectHealIntensity=20.0
	 DrugsAimErrorScale=1.15
	 DrugsMovementBonus=1.2
	 DrugsDamageScale=0.85
	 // Veterancy
	 VeterancyJumpBonus=1.0
	 VeterancyMovementModifier=1.0
	 // Default values for the modifiers
	 HealthMovementModifier=1.0
	 InventoryMovementModifier=1.0
	 CarryWeightMovementModifier=1.0
	 CarryWeightJumpModifier=1.0
	 BaseMeleeIncrease=1.2
	 //
	 IntuitiveShootingRange=150.000000
	 JumpRandRange=(Min=0.95,Max=1.05)
	 BounceRemaining=0
	 BounceCheckDistance=9.000000
	 BounceMomentum=(X=380.000000,Z=140.000000)
	 LowGravBounceMomentumScale=2.000000
	 BounceDelay=0.200000
	 LeftHandWeaponBone="WeaponL_Bone"
     RightHandWeaponBone="WeaponR_Bone"
	 RequiredEquipment(0)="KFMod.Knife"
     RequiredEquipment(1)="KFMod.Single"
     RequiredEquipment(2)="UnlimaginMod.UM_Weapon_HandGrenade"
     RequiredEquipment(3)="KFMod.Syringe"
     RequiredEquipment(4)="KFMod.Welder"
	 bNetNotify=False
	 UnderWaterBlurCameraEffectClass=Class'KFMod.UnderWaterBlur'
}