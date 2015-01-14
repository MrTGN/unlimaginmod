//=============================================================================
// UM_HumanPawn
//=============================================================================
class UM_HumanPawn extends KFHumanPawn
	DependsOn(UnlimaginMaths);

//========================================================================
//[block] Variables

// Constants
const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';
const	Maths = Class'UnlimaginMod.UnlimaginMaths';

var		bool						bDefaultPropertiesCalculated;

// Player Info
var		UM_SRClientPerkRepLink		PerkLink;
var		UM_PlayerReplicationInfo	UM_PlayerRepInfo;	// Reference to the Player Replication Info object

var		UM_Weapon_HandGrenade		HandGrenade;
var		UM_Syringe					Syringe;
var		float						VeterancySyringeChargeModifier;	// ToDo: переместить это в класс лечелки, после её полноценного перевода на мой базовый класс

// Replication triggers
var		byte						PRIChangedTrigger, ClientPRIChangedTrigger;
var		byte						VeterancyChangedTrigger, ClientVeterancyChangedTrigger;

// DyingMessage
var		int							DyingMessageHealth;
var		transient		float		NextDyingMessageTime;

// Firing
var		float						FireSpeedModif;

// Aiming
var		float						AimRotationDelay;	// Used to decrease the CPU load
var		transient	float			NextAimRotationTime;
var		transient	Actor			LastAimTarget;
var		transient	vector			LastAimTargetLocation;
var		transient	vector			LastCameraLocation, LastCameraDirection;
var		transient	rotator			LastCameraRotation;

var		float						ViewPositionUpdateDelay;
var		transient	float			NextViewPositionUpdateTime;
var		transient	vector			LastEyePosition, LastViewDirection;
var		transient	rotator			LastViewRotation;

// Drowning Damage
var		range						DrowningDamageRandRange;
var		float						DrowningDamageFrequency;
var		class<DamageType>			DrowningDamageType;

// Bile Damaging
var		range						BileDamageRandRange;
var		transient	float			BileIntensity;
var		transient	float			LastBileTime;
var	transient	class<DamageType>	LastBileDamageType;
var		transient	bool			bIsTakingBileDamage;

// Poison Damage
var		float						PoisonFrequency;
var		transient	float			PoisonIntensity;
var		transient	float			NextPoisonTime, LastPoisonTime;
var	transient	class<DamageType>	LastPoisonDamageType;
var		transient	Pawn			PoisonInstigator;
var		transient	bool			bIsTakingPoisonDamage;

// Burning Damage
var		range						BurningDamageRandRange;
var		float						BurningFrequency;
var		transient	float			BurningIntensity;
var		transient	float			NextBurningTime, LastBurningTime;
var		class<DamageType>			BurningDamageType;
var		transient	bool			bIsTakingBurnDamage;

// Falling
var		class<DamageType>			FallingDamageType;
var		class<DamageType>			LavaDamageType;

// Movement Modifiers
var		float						HealthMovementModifier;
var		float						CarryWeightMovementModifier;
var		float						InventoryMovementModifier;
var		float						VeterancyMovementModifier;

// Healing
var		bool						bAllowedToChangeHealth;	// Prevents from changing Health by several functions at the same time
var		float						HealDelay; 
var		transient	float			NextHealTime;
var		float						HealIntensity;		// How much health to heal at once
var		float						VeterancyHealPotency;	// Veterancy Heal Bonus
var		transient	bool			bIsHealing;

// Healing Message and score
var		string						HealedMessage;	// Message that You have healed somebody
var		float						HealedMessageDelay;	// Minimal delay between messages
var		transient	float			NextHealedMessageTime;
var		float						AlphaAmountDecreaseFrequency;
var		transient	float			NextAlphaAmountDecreaseTime;
var		float						DefaultMoneyPerHealedHealth;

// Overheal
var		int							OverhealedHealthMax;	// Max Overhealed Health for this Pawn
var		float						OverhealReductionPerSecond;
var		transient	float			NextOverhealReductionTime;
var		float						OverhealMovementModifier;	// Additional Overheal movement modifier. Look into the SetHealth() calculation.
var		float						NormalHealthMovementModifier;	// Additional Health movement modifier. Look into the SetHealth() calculation.
var		float						VeterancyOverhealPotency;	// Bonus to overheal somebody

// Overweight
var		float						WeightMovementModifier;
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
var		range						JumpRandRange;
var		float						VeterancyJumpBonus;
var		float						WeightJumpModifier;
var		float						CarryWeightJumpModifier;

// Bouncing from the walls and actors
var		Vector						BounceMomentum;
var		float						LowGravBounceMomentumScale, BounceDelay, BounceCheckDistance;
var		transient	float			NextBounceTime;
var		int							BounceRemaining;
var		Pawn						BounceVictim;

var		float						IntuitiveShootingRange;		// The distance in meters at which the shooter can shoot without aiming

var		class<MotionBlur>			UnderWaterBlurCameraEffectClass;

// Achievements (moved here from PlayerController)
// Survived 10 Seconds After Vomit
var		bool						bVomittedOn, bHasSurvivedAfterVomit;
var		transient	float			SurvivedAfterVomitTime;

// Survived 10 Seconds After Scream
var		bool						bScreamedAt, bHasSurvivedAfterScream;
var		transient	float			SurvivedAfterScreamTime;

var		class<PlayerDeathMark>		PlayerDeathMarkClass;

// BallisticCollision
struct BallisticCollisionData
{
	var	UM_BallisticCollision			Area;	// Reference to spawned BallisticCollision
	var	class<UM_BallisticCollision>	AreaClass;	// BallisticCollision area class
	var	float							AreaRadius;	// Radius of the area mesh collision cyllinder
	var	float							AreaHeight;	// Half-height area mesh collision cyllinder
	var	name							AreaBone;	// Name Of the bone area will be attached to
	var	vector							AreaOffset;	// Area offset from the bone
	var	rotator							AreaRotation;	// Area relative rotation from the bone
	var	float							AreaImpactStrength;	// J / mm2
	var	float							AreaHealth;	// Health amount of this body part
	var	float							AreaDamageScale;	// Amount to scale taken damage by this area
	var	bool							bArmoredArea;	// This area can be covered with armor
};

var	array<BallisticCollisionData>		BallisticCollision;
var		UM_PawnHeadCollision			HeadBallisticCollision;	// Reference to the Head Ballistic Collision

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	// Variable replication from the server to all clients
	reliable if ( Role == ROLE_Authority && bNetDirty )
		FireSpeedModif, PRIChangedTrigger;
	
	// Variable replication from the server to client-owner
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetOwner )
		VeterancyChangedTrigger;
	
	// Server to client-owner function call replication
	reliable if ( Role == ROLE_Authority )
		ClientAddPoisonEffects;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated function CalcDefaultProperties()
{
	default.IntuitiveShootingRange *= Maths.static.GetMeterInUU();
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
		// Issue #207
		SetTimer(1.5, True);
	}
}

/* FindInventoryType()
	returns the inventory item of the requested class
	if it exists in this pawn's inventory. 
	Saved this function for the third-party code. */
function Inventory FindInventoryType( class DesiredClass )
{
	local	Inventory	Inv;
	local	int			Count;

	for ( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
		if ( Inv.class == DesiredClass )
			Return Inv;
		++Count;
	}

	// Search for subclasses if exact class wasn't found
	Count = 0;
	for ( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
		if ( ClassIsChildOf(Inv.Class, DesiredClass) )
			Return Inv;
		++Count;
	}

	Return None;
}

/*	FindInventoryItem()
	Returns the inventory item of the requested class if it exists in this pawn's inventory. 
	Optional can search for subclassed items in this pawn's inventory.	*/
function Inventory FindInventoryItem( class<Inventory> DesiredClass, optional bool bSearchForSubclasses )
{
	local	Inventory	Inv;
	local	int			Count;
	
	if ( DesiredClass == None )
		Return None;
	
	for ( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
		if ( Inv.Class == DesiredClass )
			Return Inv;
		++Count;
	}
	
	// Search for subclasses if exact class wasn't found
	if ( bSearchForSubclasses )  {
		Count = 0;
		for ( Inv = Inventory; Inv != None && Count < 1000; Inv = Inv.Inventory )  {
			if ( ClassIsChildOf(Inv.Class, DesiredClass) )
				Return Inv;
			++Count;
		}
	}
	
	Return None;
}

function CreateInventory( string InventoryClassName )
{
	local	Inventory			Inv;
	local	class<Inventory>	InventoryClass;

	if ( InventoryClassName == "" )
		Return;
	
	InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
	if ( InventoryClass != None && FindInventoryItem(InventoryClass) == None )  {
		Inv = Spawn(InventoryClass, self);
		if ( Inv != None )  {
			Inv.GiveTo(self);
			if ( Inv != None && !Inv.bDeleteMe )  {
				Inv.PickupFunction(self);
				// SellValue
				if ( KFWeapon(Inv) != None && Class<KFWeaponPickup>(Inv.PickupClass) != None )  {
					if ( UM_PlayerRepInfo != None )
						KFWeapon(Inv).SellValue = Round( Class<KFWeaponPickup>(Inv.PickupClass).default.Cost * UM_PlayerRepInfo.GetPickupCostScaling(Inv.PickupClass) );
					else
						KFWeapon(Inv).SellValue = Class<KFWeaponPickup>(Inv.PickupClass).default.Cost;
				}
			}
		}
	}
}

// Clearing unnecessary function
function CreateInventoryVeterancy( string InventoryClassName, float SellValue ) { }


// Server only function
function AddDefaultInventory()
{
	local	int	i;
	
	if ( IsLocallyControlled() )  {
		if ( UM_PlayerRepInfo == None || !UM_PlayerRepInfo.AddDefaultVeterancyInventory(self) )  {
			// RequiredEquipment
			for ( i = 0; i < ArrayCount(RequiredEquipment); ++i )  {
				if ( RequiredEquipment[i] != "" )
					CreateInventory(RequiredEquipment[i]);
			}
			// OptionalEquipment
			for ( i = 0; i < ArrayCount(OptionalEquipment); ++i )  {
				if ( SelectedEquipment[i] == 1 && OptionalEquipment[i] != "" )
					CreateInventory(OptionalEquipment[i]);
			}
		}
		// GameSpecificInventory
	    Level.Game.AddGameSpecificInventory(self);
	}
	// network player
	else  {
	    // GameSpecificInventory
		Level.Game.AddGameSpecificInventory(self);
		if ( UM_PlayerRepInfo == None || !UM_PlayerRepInfo.AddDefaultVeterancyInventory(self) )  {
			// OptionalEquipment
			for ( i = ArrayCount(OptionalEquipment); i > 0; --i )  {
				if ( SelectedEquipment[i] == 1 && OptionalEquipment[i] != "" )
					CreateInventory(OptionalEquipment[i]);
			}
			// RequiredEquipment
			for ( i = ArrayCount(RequiredEquipment); i > 0; --i )  {
				if ( RequiredEquipment[i] != "" )
					CreateInventory(RequiredEquipment[i]);
			}
		}
	}
	
	// HACK FIXME
	if ( Inventory != None )
		Inventory.OwnerEvent('LoadOut');

	Controller.ClientSwitchToBestWeapon();
}

function BuildBallisticCollision()
{
	local	int		i;
	
	// Server only
	if ( Role < ROLE_Authority )
		Return;
	
	for ( i = 0; i < BallisticCollision.Length; ++i )  {
		if ( BallisticCollision[i].AreaClass != None )  {
			// Spawning
			BallisticCollision[i].Area = Spawn( BallisticCollision[i].AreaClass, Self );
			if ( BallisticCollision[i].Area == None || BallisticCollision[i].Area.bDeleteMe )
				Continue; // Skip if not exist
			
			// HeadBallisticCollision
			if ( UM_PawnHeadCollision(BallisticCollision[i].Area) != None )
				HeadBallisticCollision = UM_PawnHeadCollision(BallisticCollision[i].Area);
			// CollisionSize
			BallisticCollision[i].Area.SetCollisionSize( (BallisticCollision[i].AreaRadius * DrawScale), (BallisticCollision[i].AreaHeight * DrawScale) );
			// Attaching
			if ( BallisticCollision[i].AreaBone != '' )
				AttachToBone( BallisticCollision[i].Area, BallisticCollision[i].AreaBone );
			else
				BallisticCollision[i].Area.SetBase( Self );
			// if attached
			if ( BallisticCollision[i].Area.Base != None )  {
				// AreaOffset
				if ( BallisticCollision[i].AreaOffset != vect(0.0, 0.0, 0.0) )
					BallisticCollision[i].Area.SetRelativeLocation( BallisticCollision[i].AreaOffset * DrawScale );
				// AreaRotation
				if ( BallisticCollision[i].AreaRotation != rot(0, 0, 0) )
					BallisticCollision[i].Area.SetRelativeRotation( BallisticCollision[i].AreaRotation );
			}
			// AreaImpactStrength
			if ( BallisticCollision[i].AreaImpactStrength > 0.0 )
				BallisticCollision[i].Area.SetImpactStrength( BallisticCollision[i].AreaImpactStrength * DrawScale );
			// AreaHealth
			if ( BallisticCollision[i].AreaHealth > 0.0 )
				BallisticCollision[i].Area.SetInitialHealth( BallisticCollision[i].AreaHealth * DrawScale );
		}
	}
}

function DestroyBallisticCollision()
{
	local	int		i;
	
	// Server only
	if ( Role < ROLE_Authority )
		Return;
	
	HeadBallisticCollision = None;
	while ( BallisticCollision.Length > 0 )  {
		i = BallisticCollision.Length - 1;
		if ( BallisticCollision[i].Area != None )  {
			BallisticCollision[i].Area.DisableCollision();
			BallisticCollision[i].Area.Destroy();
		}
		BallisticCollision.Remove(i, 1);
	}
}

simulated event PostBeginPlay()
{
	Super(Pawn).PostBeginPlay();
	
	if ( Role == ROLE_Authority )  {
		if ( Level.bStartup && !bNoDefaultInventory )
			AddDefaultInventory();
		// BallisticCollision
		BuildBallisticCollision();
	}
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

// Clearing old function
simulated function ToggleAuxCollision( bool NewbCollision ) { }

// my PRI now has a new team
simulated function NotifyTeamChanged()
{
	ClientPRIChangedTrigger = PRIChangedTrigger;
	
	if ( PlayerReplicationInfo != None )
		Setup(class'xUtil'.static.FindPlayerRecord(PlayerReplicationInfo.CharacterName));
	else if ( DrivenVehicle != None && DrivenVehicle.PlayerReplicationInfo != None )
		Setup(class'xUtil'.static.FindPlayerRecord(DrivenVehicle.PlayerReplicationInfo.CharacterName));
	
	UM_PlayerRepInfo = UM_PlayerReplicationInfo(PlayerReplicationInfo);
	if ( KFPC != KFPlayerController(Controller) )
		KFPC = KFPlayerController(Controller);
}

// This event is using here to notify clients about an important changes
simulated event ClientTrigger()
{
	// PlayerReplicationInfo has changed
	if ( ClientPRIChangedTrigger != PRIChangedTrigger )
		NotifyTeamChanged();
	
	// Veterancy has changed (only client-owner receive this)
	if ( ClientVeterancyChangedTrigger != VeterancyChangedTrigger )
		NotifyVeterancyChanged();
}

simulated event PostNetReceive() { }

// Movement speed according to the healths
function UpdateHealthMovementModifiers()
{
	// Overheal
	if ( Health > int(HealthMax) )
		HealthMovementModifier = ((float(Health) / HealthMax) * OverhealMovementModifier) + (1.0 - OverhealMovementModifier);
	// Normal Health
	else
		HealthMovementModifier = ((float(Health) / HealthMax) * NormalHealthMovementModifier) + (1.0 - NormalHealthMovementModifier);
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
		CarryWeightMovementModifier = 1.0 - WeightRatio * WeightMovementModifier;
	}
}

function UpdateInventoryMovementModifiers()
{
	if ( UM_BaseWeapon(Weapon) != None )
		InventoryMovementModifier = UM_BaseWeapon(Weapon).OwnerMovementModifier;
	else if ( KFWeapon(Weapon) != None && KFWeapon(Weapon).bSpeedMeUp )
		InventoryMovementModifier = default.BaseMeleeIncrease;
	else
		InventoryMovementModifier = default.InventoryMovementModifier;
	
	if ( UM_PlayerRepInfo != None && Weapon != None )
		InventoryMovementModifier *= UM_PlayerRepInfo.GetWeaponPawnMovementBonus(Weapon);
}

function UpdateGroundSpeed()
{
	// GroundSpeed always replicated from the server to the client-owner
	if ( Role == ROLE_Authority )  {
		GroundSpeed = default.GroundSpeed * HealthMovementModifier * CarryWeightMovementModifier * InventoryMovementModifier * VeterancyMovementModifier;
		NetUpdateTime = Level.TimeSeconds - 1.0;
	}
}

function UpdateJumpZ()
{
	// JumpZ always replicated from the server to the client-owner
	if ( Role == ROLE_Authority )  {
		JumpZ = default.JumpZ * CarryWeightJumpModifier * VeterancyJumpBonus * BaseActor.static.GetRandRangeFloat( JumpRandRange );
		NetUpdateTime = Level.TimeSeconds - 1.0;
	}
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

// Sets the current CarryWeight
function SetCarryWeight( float NewCarryWeight )
{
	CurrentWeight = NewCarryWeight;
	
	UpdateCarryWeightMovementModifiers();
	UpdateGroundSpeed();
	UpdateJumpZ();
}

function CheckVeterancyCarryWeightLimit()
{
	local	byte		t;
	local	Inventory	I;
	local	int			Count;
	local	vector		DropLocation;
	
	if ( UM_PlayerRepInfo != None )
		MaxCarryWeight = UM_PlayerRepInfo.GetPawnMaxCarryWeight(default.MaxCarryWeight);
	else
		MaxCarryWeight = default.MaxCarryWeight;
	
	MaxCarryOverweight = MaxCarryWeight * MaxOverweightScale;
	
	DropLocation = Location + CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0);
	// If we are carrying too much, drop something.
	while ( CurrentWeight > MaxCarryOverweight && t < 6 )  {
		++t; // Incrementing up to 5 to restrict the number of attempts to drop weapon
		// Find the weapon to drop
		for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
			// If it's a weapon and it can be thrown
			if ( KFWeapon(I) != None && !KFWeapon(I).bKFNeverThrow )  {
				I.DropFrom(DropLocation + VRand() * 12.0);
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
			if ( UM_PlayerRepInfo != None )
				MaxAmmo = UM_PlayerRepInfo.GetMaxAmmoFor( Ammunition(I).Class );
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
	ClientVeterancyChangedTrigger = VeterancyChangedTrigger;
	
	BounceMomentum = default.BounceMomentum;
	if ( UM_PlayerRepInfo != None )  {
		// Overhealed Health Maximum
		OverhealedHealthMax = Round(HealthMax * UM_PlayerRepInfo.GetOverhealedHealthMaxModifier());
		// HealPotency
		VeterancyHealPotency = UM_PlayerRepInfo.GetHealPotency();
		// On how much this human can overheal somebody
		VeterancyOverhealPotency = UM_PlayerRepInfo.GetOverhealPotency();
		// MovementModifier
		VeterancyMovementModifier = UM_PlayerRepInfo.GetMovementSpeedModifier();
		// JumpBonus
		VeterancyJumpBonus = UM_PlayerRepInfo.GetPawnJumpModifier();
		BounceRemaining = UM_PlayerRepInfo.GetPawnMaxBounce();
		IntuitiveShootingRange = default.IntuitiveShootingRange * UM_PlayerRepInfo.GetIntuitiveShootingModifier();
		VeterancySyringeChargeModifier = UM_PlayerRepInfo.GetSyringeChargeModifier();
	}
	else  {
		OverhealedHealthMax = int(HealthMax);
		VeterancyHealPotency = default.VeterancyHealPotency;
		VeterancyOverhealPotency = default.VeterancyOverhealPotency;
		VeterancyMovementModifier = default.VeterancyMovementModifier;
		VeterancyJumpBonus = default.VeterancyJumpBonus;
		BounceRemaining = default.BounceRemaining;
		IntuitiveShootingRange = default.IntuitiveShootingRange;
		VeterancySyringeChargeModifier = default.VeterancySyringeChargeModifier;
	}
	
	// Server
	if ( Role == ROLE_Authority )  {
		CheckVeterancyCarryWeightLimit();
		CheckVeterancyAmmoLimit();
		UpdateHealthMovementModifiers();
		UpdateCarryWeightMovementModifiers();
		UpdateInventoryMovementModifiers();
		UpdateGroundSpeed();
		UpdateJumpZ();
	
		/*	If there is no UM_PlayerRepInfo, notifying the client-owner about changes by ClientTrigger() event. 
			In other case NotifyVeterancyChanged() function will be called on the client-owner from UM_PlayerRepInfo.
			This logic used to be sure that client-owner will receive all ReplicationInfo data.	*/
		if ( UM_PlayerRepInfo == None )  {
			if ( VeterancyChangedTrigger < 255 )
				++VeterancyChangedTrigger;
			else
				VeterancyChangedTrigger = 0;
			bClientTrigger = !bClientTrigger;
		}
	}
	
	// Notify all weapons in the Inventory list
	// Inventory var exists only on the server and on the client-owner
	for ( I = Inventory; I != None && Count < 1000; I = I.Inventory )  {
		if ( I.Instigator != Self )
			I.Instigator = Self;
		if ( UM_BaseWeapon(I) != None )
			UM_BaseWeapon(I).NotifyOwnerVeterancyChanged();
		// To prevent the infinity loop
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
		UM_PlayerRepInfo = UM_PlayerReplicationInfo(PlayerReplicationInfo);
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
	if ( PRIChangedTrigger < 255 )
		++PRIChangedTrigger;
	else
		PRIChangedTrigger = 0;
	// If it is a Standalone game or ListenServer
	if ( Level.NetMode == NM_Standalone || Level.NetMode == NM_ListenServer )
		NotifyTeamChanged();
	
	if ( UM_PlayerRepInfo != None )  {
		UM_PlayerRepInfo.SetHumanOwner(self);
		// To be sure that client-owner will receive all ReplicationInfo before the notification.
		UM_PlayerRepInfo.NotifyVeterancyChanged();
		// To send the PRIChangedTrigger update.
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
	if ( UM_PlayerRepInfo != None )  {
		UM_PlayerRepInfo.SetHumanOwner(None);
		UM_PlayerRepInfo = None;
	}
	SetOwner(None);
	Controller = None;
	
	// Notifying clients about PlayerReplicationInfo changes by ClientTrigger() event
	if ( PRIChangedTrigger < 255 )
		++PRIChangedTrigger;
	else
		PRIChangedTrigger = 0;
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

simulated function vector GetViewDirection()
{
	Return vector( GetViewRotation() );
}

simulated final function GetViewAxes( out vector XAxis, out vector YAxis, out vector ZAxis )
{
	GetAxes( GetViewRotation(), XAxis, YAxis, ZAxis );
}

simulated function UpdateViewPosition()
{
	if ( Level.TimeSeconds < NextViewPositionUpdateTime )
		Return;
	
	NextViewPositionUpdateTime = Level.TimeSeconds + ViewPositionUpdateDelay;
	LastEyePosition = Location + EyePosition();
	LastViewRotation = GetViewRotation();
	LastViewDirection = vector(LastViewRotation);
}

// Find the target to fire at
final function rotator GetAimRotation( UM_BaseProjectileWeaponFire WeaponFire, out vector SpawnLocation )
{
	local	vector		TraceEnd, HitLocation, HitNormal;
	local	float		f, SquaredDistToTarget, BestAim, TargetDist;
	local	rotator		AimRotation;
	local	Actor		SpawnBlocker;
	
	UpdateViewPosition();
	SpawnBlocker = Trace(HitLocation, HitNormal, SpawnLocation, LastEyePosition, True, vect(4.0, 4.0, 4.0));
	if ( SpawnBlocker != None )  {
		//Log("SpawnBlocker found!", Name);
		LastAimTarget = SpawnBlocker;
		//SpawnLocation = LastEyePosition;
	}
	// Decreasing CPU load
	else if ( Level.TimeSeconds >= NextAimRotationTime )  {
		NextAimRotationTime = Level.TimeSeconds + AimRotationDelay;
		// Trace Range
		if ( WeaponFire.UMWeapon.bAimingRifle )
			f = WeaponFire.MaxRange();
		else
			f = GetIntuitiveShootingRange();
		// TraceEnd
		if ( UM_PlayerController(Controller) != None )
			UM_PlayerController(Controller).GetCameraPosition( LastCameraLocation, LastCameraDirection, LastCameraRotation );
		else  {
			LastCameraLocation = LastEyePosition;
			LastCameraRotation = LastViewRotation;
			LastCameraDirection = LastViewDirection;
		}
		TraceEnd = LastCameraLocation + LastCameraDirection * f;
		
		// adjust aim based on FOV
        if ( Controller != None )  {
			BestAim = 0.90;
			LastAimTarget = Controller.PickTarget( BestAim, TargetDist, LastCameraDirection, LastCameraLocation, f );
		}
		
		if ( LastAimTarget == None )  {
			// Tracing from the player camera to find the target
			foreach TraceActors( Class'Actor', LastAimTarget, LastAimTargetLocation, HitNormal, TraceEnd, LastCameraLocation, Vect(2.0, 2.0, 2.0) )  {
				if ( LastAimTarget != None && LastAimTarget != Self && LastAimTarget.Base != Self /*&& !LastAimTarget.bHidden */
					 && (LastAimTarget == Level || LastAimTarget.bWorldGeometry || LastAimTarget.bProjTarget || LastAimTarget.bBlockActors) )  {
					Break;	// We have found the Target
				}
				else
					LastAimTarget = None;	// Target is not satisfy the conditions of search
			}
		}
		
		// If we didn't find the Target just get the TraceEnd location
		if ( LastAimTarget == None )
			LastAimTargetLocation = TraceEnd;
	}
	
	if ( LastAimTarget != None && Controller != None )  {
		if ( UM_BallisticCollision(LastAimTarget) == None )  {
			Controller.InstantWarnTarget( LastAimTarget, WeaponFire.SavedFireProperties, LastCameraDirection );
			Controller.ShotTarget = Pawn(LastAimTarget);
		}
		else if ( LastAimTarget.Base != None )  {
			Controller.InstantWarnTarget( LastAimTarget.Base, WeaponFire.SavedFireProperties, LastCameraDirection );
			Controller.ShotTarget = Pawn(LastAimTarget.Base);
		}
	}

	//SquaredDistToTarget = VSizeSquared(LastAimTargetLocation - LastCameraLocation);
	SquaredDistToTarget = VSizeSquared(LastAimTargetLocation - LastEyePosition);
	// If target is closer to the screen than the SpawnLocation
	// or if it closer than 1600.0 uu (~= 0.67 m)
	//if ( SquaredDistToTarget <= 900.0 || SpawnBlocker != None || SquaredDistToTarget <= VSizeSquared(SpawnLocation - LastCameraLocation) )  {
	if ( SpawnBlocker != None || SquaredDistToTarget <= 1600.0 || SquaredDistToTarget <= VSizeSquared(SpawnLocation - LastEyePosition) )  {
		/*
		if ( WeaponFire.ProjClass != None )
			f = WeaponFire.ProjClass.default.CollisionExtentVSize + 12.0;
		else
			f = 12.0;
		// Change SpawnLocation
		SpawnLocation = LastCameraLocation - Normal(LastCameraLocation - LastAimTargetLocation) * f;
		*/
		/*
		SpawnLocation = LastCameraLocation - LastCameraDirection * (CollisionRadius + 12.0);
		AimRotation = LastCameraRotation;
		*/
		SpawnLocation = LastEyePosition - LastViewDirection * (CollisionRadius + 12.0);
		AimRotation = LastViewRotation;
	}
	else
		AimRotation = rotator(Normal(LastAimTargetLocation - SpawnLocation));
	
	if ( bOnDrugs )
		f = WeaponFire.GetAimError() * DrugsAimErrorScale;
	else
		f = WeaponFire.GetAimError();
	// Adjusting AimError to the AimRotation
	if ( f > 0.0 )  {
		AimRotation.Yaw += f * (FRand() - 0.5);
		AimRotation.Pitch += f * (FRand() - 0.5);
		AimRotation.Roll += f * (FRand() - 0.5);
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
	Return ( MultiJumpRemaining > 0 && Physics == PHYS_Falling );
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

function DoBounce( bool bUpdating )
{
	local	Vector		NewVel;
	local	float		MX, JumpModif;
	
	NextBounceTime = Level.TimeSeconds + BounceDelay * BaseActor.static.GetRandFloat(0.95, 1.05);
	--BounceRemaining;
	if ( !bUpdating )
		PlayOwnedSound(GetSound(EST_Jump), SLOT_Pain, GruntVolume,,80);
	
	//Low Gravity
	if ( PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
		JumpModif = JumpZ / default.JumpZ * LowGravBounceMomentumScale;
	else
		JumpModif = JumpZ / default.JumpZ;
	
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
	
	BounceMomentum *= 0.6;
}

//ToDo: issue #214
function bool DoDirectionalJump( bool bUpdating, vector Direction )
{
	/*
		Эта функция должна вызываться из UM_PlayerController и получать оттуда вектор
		направления прыжка. Логика такая: производится нажатия пробела, потом ожидание
		нажатия каких кнопок курсора, т.е. некий аналог логики "комбо". 
		От кнопок курсора в UM_PlayerController высчитывается вектор направления прыжка
		и вызывается эта функция.
	*/
	Return False;
}

//Player Jumped
function bool DoJump( bool bUpdating )
{
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
		if ( Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider )  {
			NextBounceTime = Level.TimeSeconds + BounceDelay * BaseActor.static.GetRandFloat(0.95, 1.05);
			
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
			DoBounce(bUpdating);
			Return True;
		}
		UpdateJumpZ();
	}
    
	Return False;
}

function name GetOffhandBoneFor( Inventory I )
{
	Return LeftHandWeaponBone;
}

function name GetWeaponBoneFor( Inventory I )
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
	if ( KFWeapon(NewItem) != None )  {
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
	
	Weapon = NewWeapon;
	if ( Controller != None )
		Controller.ChangedWeapon();
	
	PendingWeapon = None;
	// From the Pawn class
	if ( OldWeapon != None )  {
		OldWeapon.SetDefaultDisplayProperties();
		OldWeapon.DetachFromPawn(self);
		OldWeapon.GotoState('Hidden');
		OldWeapon.NetUpdateFrequency = 2;
	}
	
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
	}
	
	// tell inventory that weapon changed (in case any effect was being applied)
	if ( Inventory != None )
		Inventory.OwnerEvent('ChangedWeapon');
	
	UpdateInventoryMovementModifiers();
	UpdateGroundSpeed();
}

// Returns true if this pawn is able to hold a weapon of the supplied type
simulated function bool AllowHoldWeapon( Weapon InWeapon )
{
    if ( UM_PlayerRepInfo != None )
		Return UM_PlayerRepInfo.CanUseThisWeapon( InWeapon );
	
	Return True;
}

// The player wants to switch to weapon group number F.
simulated function SwitchWeapon( byte F )
{
	local	Weapon	NewWeapon;

	if ( Level.Pauser != None || Inventory == None )
		Return;

	if ( Weapon != None && Weapon.Inventory != None )
		NewWeapon = Weapon.Inventory.WeaponChange(F, False);
	else
		NewWeapon = None;

	if ( NewWeapon == None )
		NewWeapon = Inventory.WeaponChange(F, True);

	if ( NewWeapon == None )  {
		if ( F == 10 )
			ServerNoTranslocator();

		Return;
	}

	if ( (PendingWeapon != None && PendingWeapon.bForceSwitch) || !AllowHoldWeapon(NewWeapon) )
		Return;

	if ( Weapon == None )  {
		PendingWeapon = NewWeapon;
		ChangedWeapon();
	}
	else if ( Weapon != NewWeapon || PendingWeapon != None )  {
		PendingWeapon = NewWeapon;
		Weapon.PutDown();
	}
	else if ( Weapon == NewWeapon )
		Weapon.Reselect(); // sjs
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
	//if ( Role < ROLE_Authority )  {
		for ( I = Inventory; I != None && Count < 100; I = I.Inventory )  {
			if ( Weapon(I) != None && I != Weapon && I != PendingWeapon )  {
				PendingWeapon = Weapon(I);
				Break;
			}
			// To prevent the infinity loop because of the error in the LinkedList
			++Count;
		}
		ChangedWeapon();
	//}
}

simulated function ClientForceChangeWeapon( Inventory NewWeapon )
{
	PendingWeapon = Weapon(NewWeapon);
	ChangedWeapon();
}

/*	Simulated because this function may be called from
	SimulatedProxy weapons, projectiles etc.	*/
simulated function bool CanSelfHeal( bool bMedicamentCanOverheal )
{
	if ( bMedicamentCanOverheal )
		Return Health < Round(HealthMax * VeterancyOverhealPotency);
	else
		Return Health < int(HealthMax);
}

// Quickly select syring, alt fire once, select old weapon again
exec function QuickHeal()
{
	// Syringe Link
	if ( Syringe == None )
		Syringe = UM_Syringe( FindInventoryItem(Class'UnlimaginMod.UM_Syringe', True) );
	
	// Syringe wasn't found
	if ( Syringe == None || !CanSelfHeal( Syringe.bCanOverheal ) )
		Return;

	if ( Syringe.ChargeBar() < 0.95 )  {
		if ( PlayerController(Controller) != None && HUDKillingFloor(PlayerController(Controller).myHud) != None )
			HUDKillingFloor(PlayerController(Controller).myHud).ShowQuickSyringe();
		// Can't heal now
		Return;
	}

	bIsQuickHealing = 1;
	if ( Weapon == None )  {
		PendingWeapon = Syringe;
		ChangedWeapon();
	}
	// Syringe already selected, just start healing.
	else if ( Weapon == Syringe )  {
		bIsQuickHealing = 0;
		Syringe.HackClientStartFire();
	}
	else  {
		PendingWeapon = Syringe;
		Weapon.PutDown();
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

//ToDo: Issue #239
function ServerBuyWeapon( Class<Weapon> WClass, float ItemWeight )
{
	local	float		Price, Weight;
	local	Inventory	I;

	if ( !CanBuyNow() || Class<KFWeapon>(WClass) == None 
		 || Class<KFWeaponPickup>(WClass.Default.PickupClass) == None || HasWeaponClass(WClass) )
		Return;

	// Validate if allowed to buy that weapon.
	if ( PerkLink == None )
		PerkLink = FindStats();
	
	if ( PerkLink != None && !PerkLink.CanBuyPickup( Class<KFWeaponPickup>(WClass.Default.PickupClass) ) )
		Return;

	if ( UM_PlayerRepInfo != None )
		Price = Round( class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost * UM_PlayerRepInfo.GetPickupCostScaling( WClass.Default.PickupClass ) );
	else
		Price = class<KFWeaponPickup>(WClass.Default.PickupClass).Default.Cost;

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

//ToDo: Issue #239
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
		if ( I.Class == WClass )
		{
			if ( KFWeapon(I) != None && KFWeapon(I).SellValue > 0 )
				Price = KFWeapon(I).SellValue;
			else if ( UM_PlayerRepInfo != None )
				Price = Round( class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75 * UM_PlayerRepInfo.GetPickupCostScaling( WClass.default.PickupClass ) );
			else
				Price = Round( class<KFWeaponPickup>(WClass.default.PickupClass).default.Cost * 0.75 );

			if ( I.Class==Class'Dualies' )
			{
				NewWep = Spawn(class'Single');
				Price *= 2.0;
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
				Price *= 0.5;
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

// Clien-owner AutonomousProxy function
function AddBlur( float BlurDuration, float Intensity )
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

// Clien-owner AutonomousProxy function
// ToDo: issue #256
// нужно перписать эту функцию. Уж слишком много ненужной информации она пересылает с сервера.
function DoHitCamEffects( vector HitDirection, float JarrScale, float BlurDuration, float JarDurationScale )
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )
		Super.DoHitCamEffects(HitDirection, JarrScale, BlurDuration, JarDurationScale);
}

// ToDo: issue #256
// Clien-owner AutonomousProxy function
function StopHitCamEffects()
{
	if ( KFPC != None && Viewport(KFPC.Player) != None )  {
		CurrentBlurIntensity = 0.0;
		if ( CameraEffectFound != None )
			RemoveCameraEffect(CameraEffectFound);
		
		KFPC.StopViewShaking();
		KFPC.SetBlur(0);
	}
}

function ThrowInventoryBeforeDying()
{
	local	Inventory			I;
	local	int					c;
	local	vector				DropLocation;
	local	array<KFWeapon>		DropedWeapons;
	
	if ( Role < ROLE_Authority || (DrivenVehicle != None && !DrivenVehicle.bAllowWeaponToss) )
		Return;
	
	if ( Controller != None && Weapon != None )
		Controller.LastPawnWeapon = Weapon.Class;
	
	// Find weapons to drop
	for ( I = Inventory; I != None && c < 1000; I = I.Inventory )  {
		// If it's a weapon and it can be thrown
		if ( KFWeapon(I) != None && !KFWeapon(I).bKFNeverThrow )
			DropedWeapons[DropedWeapons.Length] = KFWeapon(I);
		// To prevent the infinity loop because of the error in the LinkedList
		++c;
	}

	DropLocation = Location + CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0);
	while ( DropedWeapons.Length > 0 )  {
		c = DropedWeapons.Length - 1;
		if ( DropedWeapons[c] != None )  {
			DropedWeapons[c].HolderDied();
			DropedWeapons[c].DropFrom(DropLocation + VRand() * 12.0);
		}
		DropedWeapons.Remove(c, 1);
	}
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	local	int				i;
	local	Trigger			T;
	local	NavigationPoint	N;
	local	PlayerDeathMark	D;
	
	// if already destroyed, or level is being cleaned up
	if ( bDeleteMe || Level.Game == None || Level.bLevelChange )
		Return;
	
	if ( DamageType.default.bCausedByWorld && (Killer == None || Killer == Controller) && LastHitBy != None )
		Killer = LastHitBy;
	
	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.PreventDeath(self, Killer, DamageType, HitLocation) )  {
		SetHealth( Max(Health, 1) );	// mutator should set this higher
		Return;
	}
	
	StopHitCamEffects(); // ToDo: issue #256
	DestroyBallisticCollision();
	ThrowInventoryBeforeDying();
	SetHealth(0);
	
	// PlayerDeathMark
	if ( PlayerDeathMarkClass != None )  {
		D = Spawn(PlayerDeathMarkClass);
		if ( D != None )
			D.Velocity = Velocity;
	}
	
	if ( DrivenVehicle != None )  {
		Velocity = DrivenVehicle.Velocity;
		DrivenVehicle.DriverDied();
		DrivenVehicle = None;
	}
	
	if ( Controller != None )  {
		Controller.WasKilledBy(Killer);
		Level.Game.Killed(Killer, Controller, self, DamageType);
	}
	else
		Level.Game.Killed(Killer, Controller(Owner), self, DamageType);
	
	if ( Killer != None )
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);
	
	// make sure to untrigger any triggers requiring player touch
	if ( IsPlayerPawn() || WasPlayerPawn() )  {
		PhysicsVolume.PlayerPawnDiedInVolume(self);
		ForEach TouchingActors( Class'Trigger', T )
			T.PlayerToucherDied( Self );
		// event for HoldObjectives
		ForEach TouchingActors( Class'NavigationPoint', N )  {
			if ( N.bReceivePlayerToucherDiedNotify )
				N.PlayerToucherDied( Self );
		}
	}
	
	// remove powerup effects, etc.
	RemovePowerups();
	
	// making attached SealSquealProjectile explode when this pawn dies
	for ( i = 0; i < Attached.Length; ++i )  {
		if ( SealSquealProjectile(Attached[i]) != None )
			SealSquealProjectile(Attached[i]).HandleBasePawnDestroyed();
	}
	
	Velocity.Z *= 1.3;
	if ( IsHumanControlled() )
		PlayerController(Controller).ForceDeathUpdate();
	
	/*	// From the Pawn class
	if ( DamageType != None && DamageType.default.bAlwaysGibs )
		ChunkUp( Rotation, DamageType.default.GibPerterbation );
	else  {
		NetUpdateFrequency = default.NetUpdateFrequency;
		PlayDying(DamageType, HitLocation);
		if ( Level.Game.bGameEnded )
			Return;
		// ClientDying
		if ( !bPhysicsAnimUpdate && !IsLocallyControlled() )
			ClientDying(DamageType, HitLocation);
	}	*/
	
	// From the KFPawn class
	NetUpdateFrequency = default.NetUpdateFrequency;
	PlayDying(DamageType, HitLocation);
	if ( Level.Game.bGameEnded )
		Return;
	// ClientDying
	if ( !bPhysicsAnimUpdate && !IsLocallyControlled() )
		ClientDying(DamageType, HitLocation);
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
	if ( Physics == PHYS_Walking && DamageType.default.bExtraMomentumZ )
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
	
	if ( UM_PlayerRepInfo != None )
		Damage = Round( float(Damage) * UM_PlayerRepInfo.GetHumanTakenDamageModifier(self, InstigatedBy, DamageType) );
	
	if ( bOnDrugs )
		Damage = Round( float(Damage) * DrugsDamageScale );
	
	if ( Level.Game != None )
		Damage = Level.Game.ReduceDamage( Damage, self, instigatedBy, HitLocation, Momentum, DamageType );
	
	//ToDo: issue #204
	// if ( Armor != None )
		//ArmorAbsorbDamage( Damage, instigatedBy, Momentum, DamageType );
	if ( DamageType.default.bArmorStops )
		Damage = ShieldAbsorb( Damage );
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
	
	if ( class<DamTypeBurned>(DamageType) != None || class<DamTypeFlamethrower>(DamageType) != None || class<UM_BaseDamType_Flame>(DamageType) != None )  {
		// Burnified if the burn damage was significant enough
		if ( Damage > 2 )  {
			bAllowedToChangeHealth = False;
			// Updating timers
			LastBurningTime = Level.TimeSeconds;
			NextBurningTime = LastBurningTime + BurningFrequency;
			// Damage Info
			BurnInstigator = InstigatedBy;
			BurningIntensity = FMin( (BurningIntensity + float(Damage)), float(OverhealedHealthMax) );
			// Start to taking BurnDamage
			bIsTakingBurnDamage = True;
			// Allow operations with Health
			bAllowedToChangeHealth = True;
			// Burning does not cause an instant damage
			Return;
		}
	}
	else if ( Class<UM_ZombieDamType_Poison>(DamageType) != None )  {
		if ( ShieldStrength > 0.0 )
			Damage = ShieldAbsorb( Damage );
		// Start to taking a PoisonDamage if damage was significant enough
		if ( Damage > 2 )  {
			bAllowedToChangeHealth = False;
			// Updating timers
			LastPoisonTime = Level.TimeSeconds;
			NextPoisonTime = LastPoisonTime + PoisonFrequency;
			// Damage Info
			LastPoisonDamageType = DamageType;
			PoisonInstigator = InstigatedBy;
			PoisonIntensity = FMin( (PoisonIntensity + float(Damage) * 0.5), float(OverhealedHealthMax) );
			// Start to taking PoisonDamage
			bIsTakingPoisonDamage = True;
			// Allow operations with Health
			bAllowedToChangeHealth = True;
			// Poison does not cause an instant damage
			Return;
		}
	}
	else if ( Class<DamTypeVomit>(DamageType) != None )  {
		// Start to taking a BileDamage if damage was significant enough
		if ( Damage > 2 )  {
			bAllowedToChangeHealth = False;
			// Updating timers
			LastBileTime = Level.TimeSeconds;
			NextBileTime = LastBileTime + BileFrequency;
			// Damage Info
			LastBileDamageType = DamageType;
			BileInstigator = InstigatedBy;
			BileIntensity = FMin( (BileIntensity + float(Damage)), float(OverhealedHealthMax) );
			// Start to taking BileDamage
			bIsTakingBileDamage = True;
			// Allow operations with Health
			bAllowedToChangeHealth = True;
			// Bile does not cause an instant damage
			Return;
		}
	}	
	// Survived 10 Seconds After Scream Achievement
	else if ( (Class<UM_ZombieDamType_SirenScream>(DamageType) != None || Class<SirenScreamDamage>(DamageType) != None) 
		 && !bHasSurvivedAfterScream && Level.Game != None && Level.Game.GameDifficulty >= 4.0 && !bScreamedAt )  {
		SurvivedAfterScreamTime = Level.TimeSeconds + 10.0;
		bScreamedAt = True;
	}
	
	ProcessTakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
}


// Can Healer heal this human or not
simulated function bool CanBeHealed( bool bMedicamentCanOverheal, UM_HumanPawn Healer, optional out int HealMax )
{
	if ( Role < ROLE_Authority || bDeleteMe || !bCanBeHealed || Health < 1 )
		Return False;
	
	// if optional HealMax incoming value is zero
	if ( HealMax < 1 )  {
		if ( Healer != None && bMedicamentCanOverheal )
			HealMax = Round( HealthMax * Healer.VeterancyOverhealPotency );	// Veterancy bonus
		else
			HealMax = int(HealthMax);
	}
	
	Return Health < HealMax;
}

function SetAlphaAmount( int NewAlphaAmount )
{
	if ( NewAlphaAmount > 0 )  {
		NextAlphaAmountDecreaseTime = Level.TimeSeconds + AlphaAmountDecreaseFrequency;
		AlphaAmount = Min( NewAlphaAmount, 255 );
	}
	else
		AlphaAmount = 0;
}

function AddScoreForHealing( int AddScore )
{
	if ( UM_PlayerRepInfo == None || AddScore < 1 )
		Return;
	
	UM_PlayerRepInfo.Score += AddScore;
	UM_PlayerRepInfo.ThreeSecondScore += AddScore;
	//UM_PlayerRepInfo.Team.Score += AddScore;
	// Score AlphaAmount
	SetAlphaAmount( 255 );
}

function ShowHealedMessage( string PatientName )
{
	if ( KFPC == None || PatientName == "" || Level.TimeSeconds < NextHealedMessageTime )
		Return;
	
	NextHealedMessageTime = Level.TimeSeconds + HealedMessageDelay;
	KFPC.ClientMessage( HealedMessage @ PatientName, 'CriticalEvent' );
}

/* Heal this Human.
	HealAmount - how much healths to heal.
	bMedicamentCanOverheal - can be healed over the max Health.
	Healer - reference to the human-healer.
	MoneyPerHealedHealth - optional cash value per each healed Health for the healing reward.
	HealMax - optional max healing Health limit (bMedicamentCanOverheal will be ignored and will be used this value).
*/
function bool Heal( 
			int				HealAmount,
			bool			bMedicamentCanOverheal,
			UM_HumanPawn	Healer, 
 optional	float			MoneyPerHealedHealth,
 optional	int				HealMax )
{
	// Apply Veterancy bonus
	if ( Healer != None )
		HealAmount = Round( HealAmount * Healer.VeterancyHealPotency );
	
	if ( HealAmount > 0 && CanBeHealed(bMedicamentCanOverheal, Healer, HealMax) )  {
		// Updating timers
		LastHealTime = Level.TimeSeconds;
		NextHealTime = LastHealTime + HealDelay;
		// How much health was healed
		HealAmount = Min( (HealMax - (Health + int(HealIntensity * 0.5))), HealAmount );
		// Adding HealIntensity
		HealIntensity += FMax( (float(HealAmount) * 0.5), 0.505 ); // to guarantee rounding to 1
		bIsHealing = True;
		// Drugs Effect
		if ( !bOnDrugs && HealIntensity >= DrugEffectHealIntensity )
			SetOnDrugs();
		
		// Rewarding the Healer
		if ( Healer != None && Healer.UM_PlayerRepInfo != None )  {
			// Self-Healing
			if ( Healer == self  )  {
				// Add SelfHeal to the StatsAndAchievements
				if ( Level.NetMode != NM_StandAlone && Level.Game.NumPlayers > 1
					 && KFSteamStatsAndAchievements(UM_PlayerRepInfo.SteamStatsAndAchievements) != None )
					KFSteamStatsAndAchievements(UM_PlayerRepInfo.SteamStatsAndAchievements).AddSelfHeal();
			}
			// Reward for healing someone
			else  {
				// Add Healed Health to the StatsAndAchievements
				if ( KFSteamStatsAndAchievements(Healer.UM_PlayerRepInfo.SteamStatsAndAchievements) != None )
					KFSteamStatsAndAchievements(Healer.UM_PlayerRepInfo.SteamStatsAndAchievements).AddDamageHealed( HealAmount );
				
				// Checking optional var
				if ( MoneyPerHealedHealth <= 0.0 )
					MoneyPerHealedHealth = DefaultMoneyPerHealedHealth;
				// Less money for overheal
				if ( Health >= int(HealthMax) )
					MoneyPerHealedHealth *= 0.5;
				// Calculating money reward as a percentage of how much health was healed
				Healer.AddScoreForHealing( Round(100.0 * float(HealAmount) / HealthMax * MoneyPerHealedHealth) );
				
				// Successful Healed Message. Replicated from the server to the client-owner in the controller object.
				if ( PlayerReplicationInfo != None )
					Healer.ShowHealedMessage( PlayerReplicationInfo.PlayerName );
			}
		}
		
		Return True;
	}
	
	Return False;
}

// Left this function for the old or third-party healing logic
function bool GiveHealth( int HealAmount, int HealMax )
{
	Return Heal( HealAmount, False, None,, HealMax );
}

// Overheal Reduction
protected function ReduceOverheal()
{
	NextOverhealReductionTime = Level.TimeSeconds + 1.0 / OverhealReductionPerSecond;
	SetHealth( Max( (Health - 1), int(HealthMax) ) );
}

// Clearing old function
function AddHealth() { }

// Healing with HealIntensity decreasing
protected function IncreaseHealth()
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
		if ( Round(HealIntensity) < 1 )  {
			bIsHealing = False;
			HealIntensity = 0.0;
		}
	}
	else  {
		bIsHealing = False;
		HealIntensity = 0.0;
	}
}

// Clien-owner AutonomousProxy function
function ClientAddPoisonEffects( int DeltaPoisonDamage )
{
	if ( !IsLocallyControlled() )
		Return;
	
	AddBlur( (float(DeltaPoisonDamage) * 0.25), FMin((float(DeltaPoisonDamage) * 0.2), 1.0) );
	// Shake controller
	if ( Controller != None )
		Controller.DamageShake( DeltaPoisonDamage );
}

// Take a Poison Damage (called from the Tick)
function TakePoisonDamage()
{
	local	int		DeltaPoisonDamage;
	
	NextPoisonTime = Level.TimeSeconds + PoisonFrequency;
	// Rounding PoisonIntensity per delay
	DeltaPoisonDamage = Round( PoisonIntensity * (Level.TimeSeconds - LastPoisonTime) );
	if ( DeltaPoisonDamage > 0 )  {
		// Decreasing PoisonIntensity
		PoisonIntensity = FMax( (PoisonIntensity - float(DeltaPoisonDamage) * 0.5), 0.0 );
		// Damaging
		DeltaPoisonDamage = ProcessTakeDamage( DeltaPoisonDamage, PoisonInstigator, Location, vect(0.0, 0.0, 0.0), LastPoisonDamageType );
		// if has taken damage
		if ( DeltaPoisonDamage > 0 )  {
			LastPoisonTime = Level.TimeSeconds;
			// Do Poison Effects
			ClientAddPoisonEffects(DeltaPoisonDamage);
		}
	}
	// Checking PoisonIntensity
	if ( Round(PoisonIntensity) < 1 )  {
		bIsTakingPoisonDamage = False;
		PoisonIntensity = 0.0;
	}
}

// Take a Bile Damage (called from the Tick)
function TakeBileDamage()
{
	local	vector	BileCamVect;
	local	int		DeltaBileDamage;
	
	NextBileTime = Level.TimeSeconds + BileFrequency;
	// Rounding BileIntensity per delay
	DeltaBileDamage = Round( FMin(BileIntensity, BaseActor.static.GetRandRangeFloat(BileDamageRandRange)) * (Level.TimeSeconds - LastBileTime) );
	if ( DeltaBileDamage > 0 )  {
		// Decreasing BileIntensity
		BileIntensity = FMax( (BileIntensity - float(DeltaBileDamage)), 0.0 );
		// Damaging
		DeltaBileDamage = ProcessTakeDamage( DeltaBileDamage, BileInstigator, Location, vect(0.0, 0.0, 0.0), LastBileDamageType );
		// if has taken damage
		if ( DeltaBileDamage > 0 )  {
			LastBileTime = Level.TimeSeconds;
			// Survived 10 Seconds After Vomit Achievement
			if ( !bHasSurvivedAfterVomit && Level.Game != None && Level.Game.GameDifficulty >= 4.0 && !bVomittedOn )  {
				SurvivedAfterVomitTime = Level.TimeSeconds + 10.0;
				bVomittedOn = True;
			}
			// CamEffects
			if ( Controller != None && PlayerController(Controller) != None )  {
				BileCamVect.X = FRand();
				BileCamVect.Y = FRand();
				BileCamVect.Z = FRand();
				if ( class<DamTypeBileDeckGun>(LastBileDamageType) != None )
					DoHitCamEffects( BileCamVect, 0.25, 0.75, 0.5 );
				else
					DoHitCamEffects( BileCamVect, 0.35, 2.0, 1.0 );
			}
		}
	}
	// Checking BileIntensity
	if ( Round(BileIntensity) < 1 )  {
		bIsTakingBileDamage = False;
		BileIntensity = 0.0;
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
	DeltaBurningDamage = Round( FMin(BurningIntensity, BaseActor.static.GetRandRangeFloat(BurningDamageRandRange)) * (Level.TimeSeconds - LastBurningTime) );
	if ( DeltaBurningDamage > 0 )  {
		// Decreasing BurningIntensity
		BurningIntensity = FMax( (BurningIntensity - float(DeltaBurningDamage)), 0.0 );
		// Damaging
		DeltaBurningDamage = ProcessTakeDamage( DeltaBurningDamage, BurnInstigator, Location, vect(0.0, 0.0, 0.0), BurningDamageType );
		// if has taken damage
		if ( DeltaBurningDamage > 0 )  {
			LastBurningTime = Level.TimeSeconds;
			// Burning Effects
			if ( !bBurnified )
				bBurnified = True;
			// Shake controller
			if ( Controller != None )
				Controller.DamageShake( DeltaBurningDamage * 2 );
		}
	}
	// Checking BurningIntensity
	if ( Round(BurningIntensity) < 1 )  {
		bIsTakingBurnDamage = False;
		BurningIntensity = 0.0;
		// Burning Effects
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
	
	//if ( FallingSpeedRatio > 0.5 )  {
		// Server
		if ( FallingSpeedRatio > 0.5 && Role == ROLE_Authority )  {
			MakeNoise( FMin(FallingSpeedRatio, 1.0) );
			// Hurt pawn if FallingSpeed is over the MaxFallSpeed
			if ( FallingSpeedRatio > 1.0 )  {
				FallingDamage = ProcessTakeDamage( Round(HealthMax * FallingSpeedRatio - HealthMax), None, Location, vect(0.0, 0.0, 0.0), FallingDamageType );
				// Shake controller
				if ( Controller != None )
					Controller.DamageShake( FallingDamage );
			}
		}
	//}
}

// Take a Drowning Damage (called from the BreathTimer)
function TakeDrowningDamage()
{
	ProcessTakeDamage( Round(BaseActor.static.GetRandRangeFloat(DrowningDamageRandRange)), None, EyePosition(), vect(0.0, 0.0, 0.0), DrowningDamageType );
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

// Clien-owner AutonomousProxy function
function UpdateCameraBlur( float DeltaTime )
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
			if ( bIsHealing && Level.TimeSeconds >= NextHealTime )
				IncreaseHealth();
			
			// Poison Damage
			if ( bIsTakingPoisonDamage && Level.TimeSeconds >= NextPoisonTime )
				TakePoisonDamage();
			
			// Bile Damage
			if ( bIsTakingBileDamage && Level.TimeSeconds >= NextBileTime )
				TakeBileDamage();
			
			// Burning Damage
			if ( bIsTakingBurnDamage && Level.TimeSeconds >= NextBurningTime )
				TakeBurningDamage();
		}
		//ToDo: перенести эти ачивки в таймер поcле выполнения Issue #207
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
			if ( AlphaAmount <= 0 || UM_PlayerRepInfo == None || UM_PlayerRepInfo.ThreeSecondScore <= 0 )  {
				AlphaAmount = 0;
				if ( UM_PlayerRepInfo != None )
					UM_PlayerRepInfo.ThreeSecondScore = 0;
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
		UpdateCameraBlur(DeltaTime);
}

event Landed( vector HitNormal )
{
	BounceMomentum = default.BounceMomentum;
	if ( UM_PlayerRepInfo != None )
		BounceRemaining = UM_PlayerRepInfo.GetPawnMaxBounce();
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

event FellOutOfWorld( eKillZType KillType )
{
	if ( Level.NetMode == NM_Client || (Controller != None && Controller.AvoidCertainDeath()) )
		Return;
	
	SetHealth(0);
	
	if ( KillType == KILLZ_Lava )
		Died( None, LavaDamageType, Location );
	else  {
		if ( KillType != KILLZ_Suicide && Physics != PHYS_Karma )
			SetPhysics(PHYS_None);
		Died( None, FallingDamageType, Location );
	}
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
	if ( Weapon == None || (WeaponAttachment(Weapon.ThirdPersonActor) == None && Velocity == vect(0.0, 0.0, 0.0)) )
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

function bool AllowGrenadeTossing()
{
	// HandGrenade Link
	if ( HandGrenade == None )
		HandGrenade = UM_Weapon_HandGrenade( FindInventoryItem(Class'UnlimaginMod.UM_Weapon_HandGrenade', True) );
	
	if ( HandGrenade == None || !HandGrenade.HasAmmo() || bThrowingNade || KFWeapon(Weapon) == None
		 || (KFWeapon(Weapon).bIsReloading && !KFWeapon(Weapon).InterruptReload())
		 || (UM_BaseWeapon(Weapon) != None && !UM_BaseWeapon(Weapon).FireModesReadyToFire())
		 || (Weapon.GetFireMode(0) != None && (Weapon.GetFireMode(0).NextFireTime - Level.TimeSeconds) > 0.1) )
		Return False;
	
	Return True;
}

function ThrowGrenade()
{
	if ( AllowGrenadeTossing() )  {
		KFWeapon(Weapon).ClientGrenadeState = GN_TempDown;
		Weapon.PutDown();
	}
}

function StartToThrowGrenade()
{
	bThrowingNade = True;
	SecondaryItem = HandGrenade;
	HandGrenade.StartThrow();
}

// Left this for the old code from the KFWeapon
function WeaponDown()
{
    StartToThrowGrenade();
}

function ThrowGrenadeFinished()
{
	SecondaryItem = None;
	KFWeapon(Weapon).ClientGrenadeState = GN_BringUp;
	Weapon.BringUp();
	bThrowingNade = False;
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
     PlayerDeathMarkClass=Class'PlayerDeathMark'
	 ViewPositionUpdateDelay=0.001
	 // 1 ms AimRotation delay
	 AimRotationDelay=0.001
	 // HealedMessage
	 HealedMessage="You have healed"
	 HealedMessageDelay=0.1
	 // Decrease AlphaAmount every 60 milliseconds
	 AlphaAmountDecreaseFrequency=0.06
	 VeterancyHealPotency=1.0
	 VeterancyOverhealPotency=1.0
	 VeterancySyringeChargeModifier=1.0
	 GroundSpeed=200.000000
     WaterSpeed=180.000000
     AirSpeed=230.000000
     // PoisonDamage
	 PoisonFrequency=0.5
	 // BileDamage
	 BileFrequency=0.5
	 BileDamageRandRange=(Min=3.0,Max=6.0)
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
	 LavaDamageType=Class'FellLava'
	 // CarryWeight
	 WeightMovementModifier=0.14
	 WeightJumpModifier=0.06
	 MaxOverweightScale=1.2
	 OverweightMovementModifier=0.3
	 OverweightJumpModifier=0.2
	 // Healing
	 DefaultMoneyPerHealedHealth=0.6
	 HealDelay=0.1
	 OverhealReductionPerSecond=2.0
	 OverhealMovementModifier=0.2
	 NormalHealthMovementModifier=0.3
	 // Drugs
	 DrugsBlurDuration=6.0
	 DrugsBlurIntensity=0.6
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
     RequiredEquipment(3)="UnlimaginMod.UM_Syringe"
     RequiredEquipment(4)="KFMod.Welder"
	 bNetNotify=False
	 UnderWaterBlurCameraEffectClass=Class'KFMod.UnderWaterBlur'
	 JumpZ=330.000000
}