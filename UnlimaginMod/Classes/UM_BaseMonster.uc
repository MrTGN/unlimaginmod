//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseMonster
//	Parent class:	 KFMonster
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 06.10.2012 18:35
//================================================================================
class UM_BaseMonster extends KFMonster
	hidecategories(AnimTweaks,DeRes,Force,Gib,Karma,Udamage,UnrealPawn)
	Abstract;

#exec OBJ LOAD FILE=KF_EnemyGlobalSndTwo.uax
//#exec OBJ LOAD FILE=KFZED_Temp_UT.utx
#exec OBJ LOAD FILE=KFZED_FX_T.utx

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

// Animation channels 2 through 11 are used for animation updating by physics
const	MainAnimChannel = 0;
const	MajorAnimChannel = 12;	// ToDo: issue #478
const	MinorAnimChannel = 1;

var					bool				bRandomSizeAdjusted;

var					bool				bIsAlphaMonster;
var					EIntelligence		AlphaIntelligence;
var		transient	EIntelligence		OriginalIntelligence;	// Used to store default Intelligence because it changed when monster starts burning

var					range				MassScaleRange;
var					range				SoundsPitchRange;

//	Monster Size
var					range				SizeScaleRange;
var					float				ExtraSizeChance;
var					range				ExtraSizeScaleRange;

// Monster Speed
var					range				SpeedScaleRange;
var					float				AlphaSpeedChance;
var					range				AlphaSpeedScaleRange;

// Monster Health
var					range				HealthScaleRange;
var					range				HeadHealthScaleRange;
var					float				AlphaHealthChance;
var					range				AlphaHealthScaleRange;

// Monster Jump ZAxis height scale
var					range				JumpScaleRange; // Vertical jump speed (JumpZ) scale
var					float				JumpSpeed;	// Horizontal jump speed
// Monster MeleeRange
var					range				MeleeRangeScale;
// Monster Damage
var					range				DamageScaleRange;

var					float				MeshTestCollisionHeight;	// Height of test collision cyllinder in the Editor
var					float				MeshTestCollisionRadius;	// Radius of test collision cyllinder in the Editor

// BallisticCollision
struct BallisticCollisionData
{
	var		UM_BallisticCollision			Area;	// Reference to spawned BallisticCollision
	var		class<UM_BallisticCollision>	AreaClass;	// BallisticCollision area class
	var		float							AreaRadius;	// Radius of the area mesh collision cyllinder
	var		float							AreaHeight;	// Half-height area mesh collision cyllinder
	var		float							AreaSizeScale;
	var		name							AreaBone;	// Name of the bone area will be attached to
	var		vector							AreaOffset;	// Area offset from the bone
	var		rotator							AreaRotation;	// Area relative rotation from the bone
	var		float							AreaImpactStrength;	// J / mm2
	var		float							AreaHealth;	// Health amount of this body part
	var		float							AreaDamageScale;	// Amount to scale taken damage by this area
	var		bool							bArmoredArea;	// This area can be covered with armor
};

var		array<BallisticCollisionData>	BallisticCollision;
var		UM_PawnHeadCollision			HeadBallisticCollision;	// Reference to the Head Ballistic Collision

// Mesh Sockets attached to bones
var					name				LeftArmBone, RightArmBone;
var					name				LeftLegBone, RightLegBone;

var					name				HeadHitPointName;
var					sound				HeadHitSound;

var					float				HeadShotSlowMoChargeBonus;

var		transient	bool				bAddedToMonsterList;

var					float				ImpressiveKillChance;
var					float				ImpressiveKillDuration;

var					float				KilledWaveCountDownExtensionTime;

var					bool				bAllowRespawnIfLost;

var		transient	bool				bIsRelevant;
var		transient	float				LastRelevantTime;
var					float				RelevanceCheckDelay;
var		transient	float				NextRelevanceCheckTime;

var		transient	float				NextPlayersSeenCheckTime, LastPlayersSeenTime;
var					float				PlayersSeenCheckDelay;
var		transient	bool				bPlayersCanSeeMe;

var		transient	float				NextSpeedAdjustCheckTime;
var		transient	bool				bApplyHiddenGroundSpeed, bHiddenGroundSpeedApplied;
var					float				SpeedAdjustCheckDelay;

// Headshot debugging
var					vector              ServerHeadLocation;     // The location of the Zed's head on the server, used for debugging
var					vector              LastServerHeadLocation;

// Falling
var					class<DamageType>	FallingDamageType;
var					class<DamageType>	LavaDamageType;

// BurnDamage
var		transient	bool				bIsTakingBurnDamage;
var		transient	float				NextBurnDamageTime;
var					float				BurnDamageDelay;
var		transient	int					BurnCountDown;
var		transient	class<DamageType>	LastBurnDamageType;
var					Sound				BurningAmbientSound;

// AshenSkin
var		transient	bool				bCrispApplied;
var					Material			AshenSkin;
var		transient	bool				bAshenApplied;

// BileDamage
var		transient	bool				bIsTakingBileDamage;
var		transient	float				NextBileDamageTime;
var					float				BileDamageDelay;
var		transient	int					BileCountDown, LastBileDamage;
var		transient	class<DamageType>	LastBileDamageType;

// PlayHit Delays
var		transient	float				NextPainTime, NextPainAnimTime, NextPainSoundTime;

var		transient	bool				bMovingAttack;
var		transient	bool				bMovementDisabled;
// Animation
var					name				RunAnims[8];

// KnockDown
var					name				KnockDownAnim;
var					bool				bCanBeKnockedDown;
var					float				KnockedDownHealthPct;
var		transient	bool				bKnockedDown;

// CumulativeDamage - damage taked in the course of time
var					float				CumulativeDamageDuration;
var		transient	bool				bResetCumulativeDamage;
var		transient	int					CumulativeDamage;
var		transient	float				CumulativeDamageResetTime;
var		transient	PlayerController	LastDamagedByPlayer;

// DoorBashing
var					name				DoorBashAnim;
var					name				DistanceDoorAttackAnim;

// Decapitation
var					bool				bPlayDecapitationKnockDown;
var					name				DecapitationAnim;
var		transient	bool				bDecapitationPlayed;
// HeadlessAnim
var		transient	bool				bHeadlessAnimated, bBleedOut;
var					name				HeadlessIdleAnim;

// Replicates next rand num for animation array index
var					byte				NextWalkAnimNum;
var					byte				NextBurningWalkAnimNum;
var					byte				NextTauntAnimNum;
var					byte				NextMeleeAnimNum;
var					byte				NextHitAnimNum;

//ZombieMoan
var		transient	float				MoanPitch;
var					range				MoanPitchRange;
var					float				MoanRadius;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bIsAlphaMonster;
	
	reliable if ( Role == ROLE_Authority && bNetDirty )
		NextWalkAnimNum, NextBurningWalkAnimNum, NextMeleeAnimNum, NextTauntAnimNum, NextHitAnimNum;
	
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetOwner )
		JumpSpeed;
	
	// Headshot debugging
	reliable if ( Role == ROLE_Authority )
		ServerHeadLocation;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

function DropToGround()
{
	bCollideWorld = default.bCollideWorld;
	bInterpolating = False;
	if ( Health > 0 )  {
		SetCollision( default.bCollideActors, default.bBlockActors );
		SetPhysics(PHYS_Falling);
		AmbientSound = None;
		if ( IsHumanControlled() )
			Controller.GotoState(LandMovementState);
	}
}

/* //Backup
function RandomizeMonsterSizes()
{
	local	float	RandomSizeMult, NewDrawScale;
	
	// Not Extra
	if ( FRand() > ExtraSizeChance )
		RandomSizeMult = Lerp( FRand(), SizeScaleRange.Min, SizeScaleRange.Max );
	// Extra
	else
		RandomSizeMult = Lerp( FRand(), ExtraSizeScaleRange.Min, ExtraSizeScaleRange.Max );
	
	// DrawScale
	NewDrawScale = default.DrawScale * RandomSizeMult;
	SetDrawScale(NewDrawScale);
	
	MeleeRange = default.MeleeRange * RandomSizeMult * Lerp( FRand(), MeleeRangeScale.Min, MeleeRangeScale.Max );
	SeveredArmAttachScale = default.SeveredArmAttachScale * RandomSizeMult;
	SeveredLegAttachScale = default.SeveredLegAttachScale * RandomSizeMult;
	SeveredHeadAttachScale = default.SeveredHeadAttachScale * RandomSizeMult;
	SoundPitch = default.SoundPitch / RandomSizeMult * BaseActor.static.GetRandPitch( SoundsPitchRange );
	// Sizes
	Mass = default.Mass * RandomSizeMult * Lerp( FRand(), MassScaleRange.Min, MassScaleRange.Max );
	
	// CollisionSize scaled by DrawScale
	//PrePivot.Z = default.MeshTestCollisionHeight * DrawScale - default.CollisionHeight + default.PrePivot.Z + 12.0;
	SetCollisionSize( (default.MeshTestCollisionRadius * NewDrawScale), (default.MeshTestCollisionHeight * NewDrawScale) );
	//PrePivot.Z = default.MeshTestCollisionHeight * NewDrawScale - default.CollisionHeight + default.PrePivot.Z;
	PrePivot.Z = default.MeshTestCollisionHeight * NewDrawScale - default.MeshTestCollisionHeight + default.PrePivot.Z;
	// Camera EyeHeight scaled by DrawScale
	BaseEyeHeight = default.BaseEyeHeight * NewDrawScale;
	EyeHeight = default.EyeHeight * NewDrawScale;
		
	OnlineHeadshotScale = default.OnlineHeadshotScale * RandomSizeMult;
	//OnlineHeadshotOffset = default.OnlineHeadshotOffset * NewDrawScale;
	
	HeadHeight = default.HeadHeight * RandomSizeMult;
	
	//Collision - Note: un-crouching messes up the collision size
	//CrouchHeight = default.MeshTestCollisionHeight * NewDrawScale * 0.65;
	CrouchHeight = default.MeshTestCollisionHeight * NewDrawScale;
	CrouchRadius = default.MeshTestCollisionRadius * NewDrawScale;
	
	//SetPhysics(PHYS_Falling);
		
	bRandomSizeAdjusted = True;
} */

function RandomizeMonsterSizes()
{
	local	float	RandomSizeMult, NewDrawScale;
	
	if ( Role < ROLE_Authority )
		Return;
	
	// Not Extra
	if ( FRand() > ExtraSizeChance )
		RandomSizeMult = Lerp( FRand(), SizeScaleRange.Min, SizeScaleRange.Max );
	// Extra
	else
		RandomSizeMult = Lerp( FRand(), ExtraSizeScaleRange.Min, ExtraSizeScaleRange.Max );
	
	// DrawScale
	NewDrawScale = default.DrawScale * RandomSizeMult;
	SetDrawScale(NewDrawScale);
	
	// Landing on the Ground
	Move( Location + Vect(0.0, 0.0, 1.0) * (default.CollisionHeight * NewDrawScale - default.CollisionHeight + 1.0) );
	
	// MeleeRange
	MeleeRange = default.MeleeRange * RandomSizeMult * Lerp( FRand(), MeleeRangeScale.Min, MeleeRangeScale.Max );
	// BodyPartsScale
	SeveredArmAttachScale = default.SeveredArmAttachScale * RandomSizeMult;
	SeveredLegAttachScale = default.SeveredLegAttachScale * RandomSizeMult;
	SeveredHeadAttachScale = default.SeveredHeadAttachScale * RandomSizeMult;
	// MoanPitch
	MoanPitch = Lerp(FRand(), MoanPitchRange.Min, MoanPitchRange.Max) / RandomSizeMult;
	// Mass
	Mass = default.Mass * RandomSizeMult * Lerp( FRand(), MassScaleRange.Min, MassScaleRange.Max );
	
	/*
	if ( CollisionHeight < default.CollisionHeight )
		PrePivot.Z = (default.MeshTestCollisionHeight * NewDrawScale - default.MeshTestCollisionHeight + default.PrePivot.Z) * 2.0;
	*/
	// Camera EyeHeight scaled by DrawScale
	BaseEyeHeight = default.BaseEyeHeight * NewDrawScale;
	EyeHeight = default.EyeHeight * NewDrawScale;
	
	OnlineHeadshotScale = default.OnlineHeadshotScale * RandomSizeMult;
	//OnlineHeadshotOffset = default.OnlineHeadshotOffset * NewDrawScale;
	HeadHeight = default.HeadHeight * RandomSizeMult;
	
	//Collision - Note: un-crouching messes up the collision size
	CrouchHeight = default.CollisionHeight * NewDrawScale;
	CrouchRadius = default.CollisionRadius * NewDrawScale;
	
	// CollisionSize scaled by DrawScale
	SetCollisionSize( (default.CollisionRadius * NewDrawScale), (default.CollisionHeight * NewDrawScale) );
	
	// Landing to the Ground
	SetPhysics(PHYS_Falling);
	
	bRandomSizeAdjusted = True;
} 

function BuildBallisticCollision()
{
	local	int		i;
	local	float	CurrentSizeScale;
	
	// Server only
	if ( Role < ROLE_Authority )
		Return;
		
	for ( i = 0; i < BallisticCollision.Length; ++i )  {
		if ( BallisticCollision[i].AreaClass != None )  {
			// Spawning
			BallisticCollision[i].Area = Spawn( BallisticCollision[i].AreaClass, Self );
			if ( BallisticCollision[i].Area == None || BallisticCollision[i].Area.bDeleteMe )
				Continue; // Skip if not exist
			
			// AreaSizeScale
			if ( BallisticCollision[i].AreaSizeScale > 0.0 )
				CurrentSizeScale = BallisticCollision[i].AreaSizeScale * DrawScale;
			else
				CurrentSizeScale = DrawScale;
			
			// HeadBallisticCollision
			if ( UM_PawnHeadCollision(BallisticCollision[i].Area) != None )
				HeadBallisticCollision = UM_PawnHeadCollision( BallisticCollision[i].Area );
			
			// CollisionSize
			BallisticCollision[i].Area.SetCollisionSize( (BallisticCollision[i].AreaRadius * CurrentSizeScale), (BallisticCollision[i].AreaHeight * CurrentSizeScale) );
			
			// Attaching
			if ( BallisticCollision[i].AreaBone != '' )
				AttachToBone( BallisticCollision[i].Area, BallisticCollision[i].AreaBone );
			else
				BallisticCollision[i].Area.SetBase( Self );
			
			// AreaOffset
			if ( BallisticCollision[i].AreaOffset != vect(0.0, 0.0, 0.0) )
				BallisticCollision[i].Area.SetRelativeLocation( BallisticCollision[i].AreaOffset * CurrentSizeScale );
			// AreaRotation
			if ( BallisticCollision[i].AreaRotation != rot(0, 0, 0) )
				BallisticCollision[i].Area.SetRelativeRotation( BallisticCollision[i].AreaRotation );
			
			//BallisticCollision[i].Area.bHardAttach = True;
			
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

function AddVelocity( vector NewVelocity )
{
	if ( bIgnoreForces || NewVelocity == vect(0,0,0) || VSizeSquared(NewVelocity) < 2500.0 )
		Return;
	
	if ( Physics == PHYS_Falling && AIController(Controller) != None )
		ImpactVelocity += NewVelocity;
	
	if ( Physics == PHYS_Walking || ((Physics == PHYS_Ladder || Physics == PHYS_Spider) && NewVelocity.Z > JumpZ) )
		SetPhysics(PHYS_Falling);
	
	if ( Velocity.Z > 380.0 && NewVelocity.Z > 0.0 )
		NewVelocity.Z *= 0.5;
	
	Velocity += NewVelocity;
}

function CalcAmbientRelevancyScale()
{
	// Make the zed only relevant by thier ambient sound out to a range of 10 meters
	CustomAmbientRelevancyScale = 500.0 / (100.0 * SoundRadius);
}

event PreBeginPlay()
{
	/*
	if ( !bRandomSizeAdjusted )
		RandomizeMonsterSizes();
	*/
	Super(Pawn).PreBeginPlay();
	CalcAmbientRelevancyScale();
}

// Rand next anim nums on the server
function ServerRandNextAnims()
{
	if ( Role < ROLE_Authority )
		Return;
	
	// AdditionalWalkAnim
	if ( AdditionalWalkAnims.Length > 0 )
		NextWalkAnimNum = Rand(AdditionalWalkAnims.Length);
	// BurningWalkAnim
	NextBurningWalkAnimNum = Rand(ArrayCount(BurningWalkFAnims));
	// TauntAnim
	NextTauntAnimNum = 3 + Rand(TauntAnims.Length - 3); // First 4 taunts are 'order' anims. Don't pick them.
	// MeleeAnim
	NextMeleeAnimNum = Rand(ArrayCount(meleeAnims));
	// HitAnims
	NextHitAnimNum = Rand(ArrayCount(HitAnims));
}

// Scales the damage this Zed deals by the difficulty level
function float DifficultyDamageModifer()
{
	local	float	AdjustedDamageModifier;

	if ( Level.Game.GameDifficulty >= 7.0 ) // Hell on Earth
		AdjustedDamageModifier = 1.75;
	else if ( Level.Game.GameDifficulty >= 5.0 ) // Suicidal
		AdjustedDamageModifier = 1.50;
	else if ( Level.Game.GameDifficulty >= 4.0 ) // Hard
		AdjustedDamageModifier = 1.25;
	else if ( Level.Game.GameDifficulty >= 2.0 ) // Normal
		AdjustedDamageModifier = 1.0;
	else //if ( GameDifficulty == 1.0 ) // Beginner
		AdjustedDamageModifier = 0.3;

	// Do less damage if we're alone
	if ( UM_BaseGameInfo(Level.Game) == None || UM_BaseGameInfo(Level.Game).NumActivePlayers < 2 )
		Return AdjustedDamageModifier * 0.75;

	Return AdjustedDamageModifier;
}

// Scales the health this Zed has by the difficulty level
function float DifficultyHealthModifer()
{
	if ( Level.Game.GameDifficulty >= 7.0 ) // Hell on Earth
		Return 1.75;
	else if ( Level.Game.GameDifficulty >= 5.0 ) // Suicidal
		Return 1.55;
	else if ( Level.Game.GameDifficulty >= 4.0 ) // Hard
		Return 1.35;
	else if ( Level.Game.GameDifficulty >= 2.0 ) // Normal
		Return 1.0;

	// Beginner
	Return 0.5;
}

// Scales the health this Zed has by number of players
function float NumPlayersHealthModifer()
{
	local	UM_BaseGameInfo		GameInfo;
	
	GameInfo = UM_BaseGameInfo(Level.Game);
	if ( GameInfo == None || GameInfo.NumActivePlayers < 2 )
		Return 1.0;
	
	Return 1.0 + FMin(float(GameInfo.NumActivePlayers - 1), 10.0) * PlayerCountHealthScale;
}

// Scales the head health this Zed has by the difficulty level
function float DifficultyHeadHealthModifer()
{
	if ( Level.Game.GameDifficulty >= 7.0 ) // Hell on Earth
		Return 1.75;
	else if ( Level.Game.GameDifficulty >= 5.0 ) // Suicidal
		Return 1.55;
	else if ( Level.Game.GameDifficulty >= 4.0 ) // Hard
		Return 1.35;
	else if ( Level.Game.GameDifficulty >= 2.0 ) // Normal
		Return 1.0;
	
	// Beginner
	Return 0.5;
}

// Scales the head health this Zed has by number of players
function float NumPlayersHeadHealthModifer()
{
	local	UM_BaseGameInfo		GameInfo;
	
	GameInfo = UM_BaseGameInfo(Level.Game);
	if ( GameInfo == None || GameInfo.NumActivePlayers < 2 )
		Return 1.0;
	
	Return 1.0 + FMin(float(GameInfo.NumActivePlayers - 1), 10.0) * PlayerNumHeadHealthScale;
}

// Difficulty Scaling
function AdjustGameDifficulty()
{
	local	float	RandMult, MovementSpeedDifficultyScale;
	
	if ( Role < ROLE_Authority || bDiffAdjusted || Level.Game == None )
		Return;
	
	bDiffAdjusted = True;
	if ( UM_BaseGameInfo(Level.Game) == None || UM_BaseGameInfo(Level.Game).NumActivePlayers < 4 )
		HiddenGroundSpeed = default.HiddenGroundSpeed;
	else if ( UM_BaseGameInfo(Level.Game).NumActivePlayers < 6 )
		HiddenGroundSpeed = default.HiddenGroundSpeed * 1.3;
	else
		HiddenGroundSpeed = default.HiddenGroundSpeed * 1.65;

	if ( Level.Game.GameDifficulty < 2.0 )
		MovementSpeedDifficultyScale = 0.9;
	else if( Level.Game.GameDifficulty < 4.0 )
		MovementSpeedDifficultyScale = 1.0;
	else if( Level.Game.GameDifficulty < 5.0 )
		MovementSpeedDifficultyScale = 1.1;
	else if( Level.Game.GameDifficulty < 7.0 )
		MovementSpeedDifficultyScale = 1.2;
	else // Hardest difficulty
		MovementSpeedDifficultyScale = 1.3;

	if ( CurrentDamType == None )
		CurrentDamType = ZombieDamType[NextMeleeAnimNum];
	
	//[block] Speed Randomization
	AirSpeed *= MovementSpeedDifficultyScale;
	if ( FRand() > AlphaSpeedChance )
		RandMult = Lerp( FRand(), SpeedScaleRange.Min, SpeedScaleRange.Max );
	else  {
		bIsAlphaMonster = True;
		RandMult = Lerp( FRand(), AlphaSpeedScaleRange.Min, AlphaSpeedScaleRange.Max );
	}
	GroundSpeed *= MovementSpeedDifficultyScale * RandMult;
	WaterSpeed *= MovementSpeedDifficultyScale * RandMult;
	JumpSpeed *= MovementSpeedDifficultyScale * RandMult;
	// Store the difficulty adjusted ground speed to restore if we change it elsewhere
	OriginalGroundSpeed = GroundSpeed;
	//[end]
	
	//[block] Healths Randomization
	// Health
	if ( FRand() > AlphaHealthChance )
		RandMult = Lerp( FRand(), HealthScaleRange.Min, HealthScaleRange.Max );
	else  {
		bIsAlphaMonster = True;
		RandMult = Lerp( FRand(), AlphaHealthScaleRange.Min, AlphaHealthScaleRange.Max );
	}
	Health = Round( float(default.Health) * DifficultyHealthModifer() * RandMult * NumPlayersHealthModifer() );
	HealthMax = float(Health);
	// HeadHealth
	if ( bIsAlphaMonster )
		RandMult *= Lerp( FRand(), HeadHealthScaleRange.Min, HeadHealthScaleRange.Max );
	else
		RandMult = Lerp( FRand(), HeadHealthScaleRange.Min, HeadHealthScaleRange.Max );
	HeadHealth = default.HeadHealth * DifficultyHeadHealthModifer() * RandMult * NumPlayersHeadHealthModifer();
	//[end]
		
	// Jump
	RandMult = Lerp( FRand(), JumpScaleRange.Min, JumpScaleRange.Max );
	JumpZ = default.JumpZ * RandMult;
	JumpSpeed = default.JumpSpeed * RandMult;
	
	//RandMult = Lerp( FRand(), DamageScaleRange.Min, DamageScaleRange.Max );
	SpinDamConst = FMax( (DifficultyDamageModifer() * default.SpinDamConst), 1.0 );
	SpinDamRand = FMax( (DifficultyDamageModifer() * default.SpinDamRand), 1.0 );
	// ints
	ScreamDamage = Max( Round(DifficultyDamageModifer() * float(default.ScreamDamage) * Lerp(FRand(), DamageScaleRange.Min, DamageScaleRange.Max)), 1 );
	MeleeDamage = Max( Round(DifficultyDamageModifer() * float(default.MeleeDamage) * Lerp(FRand(), DamageScaleRange.Min, DamageScaleRange.Max)), 1 );
	
	if ( bIsAlphaMonster && AlphaIntelligence > Intelligence )
		Intelligence = AlphaIntelligence;
	OriginalIntelligence = Intelligence;
	// MoanPitch
	MoanPitch = Lerp(FRand(), MoanPitchRange.Min, MoanPitchRange.Max);
}

simulated event PostBeginPlay()
{
	// Store default.MovementAnims[0] to AdditionalWalkAnims
	if ( AdditionalWalkAnims.Length > 0 )
		AdditionalWalkAnims[AdditionalWalkAnims.length] = default.MovementAnims[0];
	
	if ( ROLE == ROLE_Authority )  {
		if ( ControllerClass != None && Controller == None )
			Controller = Spawn(ControllerClass);

		if ( Controller != None )
			Controller.Possess(Self);

		SplashTime = 0;
		SpawnTime = Level.TimeSeconds;
		EyeHeight = BaseEyeHeight;
		OldRotYaw = Rotation.Yaw;
		
		if ( HealthModifer != 0 )
			Health = HealthModifer;
		
		BuildBallisticCollision();
		ServerRandNextAnims();
		/*
		if ( HeadBallisticCollision != None )
			OnlineHeadshotOffset = HeadBallisticCollision.Location - (Location - CollisionHeight * Vect(0.0, 0.0, 1.0));	*/
	}

	AssignInitialPose();
	// Let's randomly alter the position of our zombies' spines, to give their animations
	// the appearance of being somewhat unique.
	SetTimer(1.0, False);

	//Set Karma Ragdoll skeleton for this character.
	if ( KFRagdollName != "" )
		RagdollOverride = KFRagdollName; //ClotKarma
	//Log("Ragdoll Skeleton name is :"$RagdollOverride);

	if ( bActorShadows && bPlayerShadows && Level.NetMode != NM_DedicatedServer)  {
		// decide which type of shadow to spawn
		if (!bRealtimeShadows)  {
			PlayerShadow = Spawn(class'ShadowProjector',Self,'',Location);
			PlayerShadow.ShadowActor = self;
			PlayerShadow.bBlobShadow = bBlobShadow;
			PlayerShadow.LightDirection = Normal(vect(1,1,3));
			PlayerShadow.LightDistance = 320;
			PlayerShadow.MaxTraceDistance = 350;
			PlayerShadow.InitShadow();
		}
		else  {
			RealtimeShadow = Spawn(class'Effect_ShadowController',self,'',Location);
			RealtimeShadow.Instigator = self;
			RealtimeShadow.Initialize();
		}
	}

	bSTUNNED = False;
	DECAP = False;
	if ( Role == ROLE_Authority )  {
		AdjustGameDifficulty();
		if ( UM_InvasionGame(Level.Game) != None && !bAddedToMonsterList )
			bAddedToMonsterList = UM_InvasionGame(Level.Game).AddToMonsterList( self );
	}
}

function InitCheckAnimActions()
{
	// Check KnockDownAnim
	if ( bCanBeKnockedDown )
		bCanBeKnockedDown = KnockDownAnim != '' && HasAnim(KnockDownAnim);
	// Check DistanceDoorAttackAnim
	if ( bCanDistanceAttackDoors )
		bCanDistanceAttackDoors = DistanceDoorAttackAnim != '' && HasAnim(DistanceDoorAttackAnim);
	// Check DecapitationAnim
	if ( bPlayDecapitationKnockDown )
		bPlayDecapitationKnockDown = DecapitationAnim != '' && HasAnim(DecapitationAnim);
}

// called after PostBeginPlay() and after all init replication was received on net client
simulated event PostNetBeginPlay()
{
	local	PlayerController	PC;
	
	InitCheckAnimActions();
	AnimateDefault();
	EnableChannelNotify(MainAnimChannel, 1);
	EnableChannelNotify(MinorAnimChannel, 1);
	AnimBlendParams(MinorAnimChannel, 1.0, 0.0, , SpineBone1);
	AnimBlendParams(MinorAnimChannel, 1.0, 0.0, , HeadBone);
	
	if ( Level.bDropDetail || (Level.DetailMode == DM_Low) )
		MaxLights = Min(4,MaxLights);
	
	if ( Role == ROLE_Authority )
		Return;
	
	if ( bIsAlphaMonster && AlphaIntelligence > Intelligence )
		Intelligence = AlphaIntelligence;
	OriginalIntelligence = Intelligence;
	
	if ( Controller != None )  {
		if ( Controller.Pawn == None )
			Controller.Pawn = self;
		if ( PlayerController(Controller) != None && PlayerController(Controller).ViewTarget == Controller )
			PlayerController(Controller).SetViewTarget(self);
		
		if ( PlayerReplicationInfo != None && PlayerReplicationInfo.Owner == None )  {
			PlayerReplicationInfo.SetOwner(Controller);
			if ( left(PlayerReplicationInfo.PlayerName, 5) ~= "PRESS" )  {
				PC = Level.GetLocalPlayerController();
				if ( PC != None && PC.PlayerReplicationInfo != None && !(left(PlayerReplicationInfo.PlayerName, 5) ~= "PRESS") )
					bScriptPostRender = True;
			}
		}
	}
	
	if ( Role == ROLE_AutonomousProxy )
		bUpdateEyeHeight = True;
}

// Setters for extra collision cylinders
simulated function ToggleAuxCollision( bool NewbCollision ) { }

function bool MakeGrandEntry()
{
	Return False;
}

function bool SetBossLaught()
{
	Return False;
}

simulated event Destroyed()
{
	DestroyBallisticCollision();
	if ( Health > 0 )
		Suicide();
	
	Super.Destroyed();
}

function SetMovementPhysics()
{
	if ( Physics == PHYS_None )
		SetPhysics(PHYS_Falling);
	else if ( PhysicsVolume.bWaterVolume )
		SetPhysics(PHYS_Swimming);
	else
		SetPhysics(PHYS_Walking);
}

event FellOutOfWorld( eKillZType KillType )
{
	if ( Level.NetMode == NM_Client || (Controller != None && Controller.AvoidCertainDeath()) )
		Return;
	
	Health = 0;
	
	if ( KillType == KILLZ_Lava )
		Died( None, LavaDamageType, Location );
	else  {
		if ( KillType != KILLZ_Suicide && Physics != PHYS_Karma )
			SetPhysics(PHYS_None);
		Died( None, FallingDamageType, Location );
	}
}

// move karma objects by a kick
// The Kick animation will ONLY be called if the Zombie is On level ground with the KActor,
// and is facing it.
event Bump(actor Other)
{
	local Vector X,Y,Z;

	Super(Skaarj).Bump(Other);
	
	if ( KActor(Other) == None || KFMonsterController(Controller) == None || Base == Other || !Base.bStatic || Physics == PHYS_Falling )
		Return;

	GetAxes(Rotation, X, Y, Z);
	if ( Location.Z < (Other.Location.Z + CollisionHeight) 
		 && Location.Z > (Other.Location.Z - CollisionHeight * 0.5) 
		 && (Normal(X) dot Normal(Other.Location - Location)) >= 0.7
		 && KActor(Other).KGetMass() >= 0.5 && !CanAttack(Controller.Enemy) )  {
			// Store kick impact data
			ImpactVector = Vector(Controller.Rotation) * 15000.0 + (Velocity * (Mass * 0.5)); // 30
			KickLocation = Other.Location;
			KickTarget = Other;
			KFMonsterController(Controller).KickTarget = KActor(Other);
			SetAnimAction(PuntAnim);
	}
}

// Moved from Controller to here (so we don't need an own controller for each moan type).
function ZombieMoan()
{
	PlaySound( MoanVoice, SLOT_Misc, MoanVolume,, MoanRadius, MoanPitch );
}

simulated function bool IsRelevant()
{
	NextRelevanceCheckTime = Level.TimeSeconds + RelevanceCheckDelay;
	bIsRelevant = ((Level.NetMode == NM_DedicatedServer || Level.NetMode == NM_ListenServer) && (Level.TimeSeconds - LastReplicateTime) <= 0.5) 
					|| (Level.NetMode != NM_DedicatedServer && (Level.TimeSeconds - LastRenderTime) <= 3.0);
	// update skeleton (and attached actor positions) even if not rendered
	bForceSkelUpdate = bIsRelevant;
	if ( bIsRelevant )
		LastRelevantTime = Level.TimeSeconds;
	
	Return bIsRelevant;
}

function CheckPlayersCanSeeMe()
{
	NextPlayersSeenCheckTime = Level.TimeSeconds + PlayersSeenCheckDelay;
	bPlayersCanSeeMe = PlayerCanSeeMe();
	if ( bPlayersCanSeeMe )
		LastPlayersSeenTime = Level.TimeSeconds;
}

function bool NotSeenMoreThan( float NotSeenTime )
{
	if ( NotSeenTime <= 0.0 || bPlayersCanSeeMe )
		Return False;
	
	Return (Level.TimeSeconds - LastPlayersSeenTime) > NotSeenTime;
}

function SetGroundSpeed(float NewGroundSpeed)
{
	if ( NewGroundSpeed == GroundSpeed )
		Return;
	
	GroundSpeed = NewGroundSpeed;
}

// Return True if we can do the Zombie speed adjust that gets the Zeds
// to the player faster if they can't be seen
function bool CanSpeedAdjust()
{
	if ( Level.TimeSeconds < NextSpeedAdjustCheckTime )
		Return False;
	
	NextSpeedAdjustCheckTime = Level.TimeSeconds + SpeedAdjustCheckDelay;
	
	if ( bMovementDisabled || bDecapitated || bZapped || bBurnified )
		Return False;
	
	bApplyHiddenGroundSpeed = !bIsRelevant && !bPlayersCanSeeMe;
	
	Return bApplyHiddenGroundSpeed != bHiddenGroundSpeedApplied;
}

// Make Zeds move faster if they aren't net relevant, or noone has seen them
// in a while. This well get the Zeds to the player in larger groups, and
// quicker - Ramm
function AdjustGroundSpeed()
{
	bHiddenGroundSpeedApplied = bApplyHiddenGroundSpeed;
	if ( bApplyHiddenGroundSpeed )
		SetGroundSpeed(HiddenGroundSpeed);
	else
		SetGroundSpeed(OriginalGroundSpeed);
}

function ClientDying(class<DamageType> DamageType, vector HitLocation) { }

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	local	int				i;
	local	Vector			TossVel;
	local	Trigger			T;
	local	NavigationPoint	N;
	
	if ( bDeleteMe || Level.bLevelChange || Level.Game == None )
		Return; // already destroyed, or level is being cleaned up
	
	// making attached SealSquealProjectile explode when this pawn dies
	for ( i = 0; i < Attached.Length; ++i )  {
		if ( SealSquealProjectile(Attached[i]) != None )
			SealSquealProjectile(Attached[i]).HandleBasePawnDestroyed();
	}
	DestroyBallisticCollision();
	
	if ( DamageType.default.bCausedByWorld && (Killer == None || Killer == Controller) && LastHitBy != None )
		Killer = LastHitBy;
	
	// mutator hook to prevent deaths
	// WARNING - don't prevent bot suicides - they suicide when really needed
	if ( Level.Game.PreventDeath(self, Killer, DamageType, HitLocation) )  {
		Health = Max(Health, 1); //mutator should set this higher
		Return;
	}
	Health = Min(0, Health);
	
	if ( Weapon != None && (DrivenVehicle == None || DrivenVehicle.bAllowWeaponToss) )  {
		if ( Controller != None )
			Controller.LastPawnWeapon = Weapon.Class;
		Weapon.HolderDied();
		TossVel = Vector(GetViewRotation());
		TossVel = TossVel * ((Velocity Dot TossVel) + 500) + Vect(0,0,200);
		TossWeapon(TossVel);
	}

	if ( DrivenVehicle != None )  {
		Velocity = DrivenVehicle.Velocity;
		DrivenVehicle.DriverDied();
	}

	if ( Controller != None )  {
		Controller.WasKilledBy(Killer);
		Level.Game.Killed(Killer, Controller, self, DamageType);
	}
	else
		Level.Game.Killed(Killer, Controller(Owner), self, DamageType);
	
	DrivenVehicle = None;
	
	if ( Killer != None )
		TriggerEvent(Event, self, Killer.Pawn);
	else
		TriggerEvent(Event, self, None);

	// make sure to untrigger any triggers requiring player touch
	if ( IsPlayerPawn() || WasPlayerPawn() )  {
		PhysicsVolume.PlayerPawnDiedInVolume(self);
		ForEach TouchingActors(class'Trigger', T)
			T.PlayerToucherDied( self );
		// event for HoldObjectives
		//for ( N=Level.NavigationPointList; N!=None; N=N.NextNavigationPoint )
		//	if ( N.bStatic && N.bReceivePlayerToucherDiedNotify )
		ForEach TouchingActors(class'NavigationPoint', N)
			if ( N.bReceivePlayerToucherDiedNotify )
				N.PlayerToucherDied( Self );
	}
	
	// remove powerup effects, etc.
	RemovePowerups();

	Velocity.Z *= 1.3;
	if ( IsHumanControlled() )
		PlayerController(Controller).ForceDeathUpdate();
	if ( DamageType != None && DamageType.default.bAlwaysGibs )
		ChunkUp( Rotation, DamageType.default.GibPerterbation );
	else  {
		NetUpdateFrequency = Default.NetUpdateFrequency;
		PlayDying(DamageType, HitLocation);
		if ( Level.Game.bGameEnded )
			Return;
		if ( !bPhysicsAnimUpdate && !IsLocallyControlled() )
			ClientDying(DamageType, HitLocation);
	}
}

simulated function AttachEffect( class<xEmitter> xEmitterClass, Name BoneName, Vector EffectLocation, Rotator EffectRotation )
{
	local	Actor	a;
	local	int		i;

	if ( xEmitterClass == None || BoneName == '' )
		Return;

	for ( i = 0; i < Attached.Length; ++i )  {
		if ( Attached[i] == None || Attached[i].AttachmentBone != BoneName )
			continue;

		if ( ClassIsChildOf(xEmitterClass, Attached[i].Class) )
			Return;
	}

	if ( EffectLocation == vect(0, 0, 0) )
		EffectLocation = GetBoneCoords(BoneName).Origin;
	
	if ( EffectRotation == rot(0, 0, 0) )
		EffectRotation = GetBoneRotation(BoneName);
	
	a = Spawn( xEmitterClass,,, EffectLocation, EffectRotation );
	if ( a == None )
		Return;

	if ( !AttachToBone( a, BoneName ) )  {
		log( "Couldn't attach "$xEmitterClass$" to "$BoneName, 'Error' );
		a.Destroy();
		Return;
	}

	//???
	a.SetRelativeRotation( EffectRotation );
}

// Used to attach an emitter instead of an xemitter
simulated function AttachEmitterEffect( class<Emitter> EmitterClass, Name BoneName, Vector EffectLocation, Rotator EffectRotation )
{
	local	Actor	a;
	local	int		i;

	if ( EmitterClass == None || BoneName == '' )
		Return;

	for ( i = 0; i < Attached.Length; ++i )  {
		if ( Attached[i] == None || Attached[i].AttachmentBone != BoneName )
			continue;

		if ( ClassIsChildOf(EmitterClass, Attached[i].Class) )
			Return; // Out from function if found the same emitter
	}
	
	if ( EffectLocation == vect(0, 0, 0) )
		EffectLocation = GetBoneCoords(BoneName).Origin;
	
	if ( EffectRotation == rot(0, 0, 0) )
		EffectRotation = GetBoneRotation(BoneName);

	a = Spawn( EmitterClass,,, EffectLocation, EffectRotation );
	if ( a == None )
		Return;
	
	if ( !AttachToBone( a, BoneName ) )  {
		log( "Couldn't attach "$EmitterClass$" to "$BoneName, 'Error' );
		a.Destroy();
		Return;
	}
	
	//???
	a.SetRelativeRotation( EffectRotation );
}

simulated function SeveredAppendageAttachment SpawnSeveredArm(name BoneName)
{
	local	SeveredAppendageAttachment	SeveredArm;
	
	if ( BoneName == '' || SeveredArmAttachClass == None )
		Return None;
	
	SeveredArm = Spawn(SeveredArmAttachClass, self);
	if ( SeveredArm == None )
		Return None;
	
	SeveredArm.SetDrawScale(SeveredArmAttachScale);
	AttachEmitterEffect( LimbSpurtEmitterClass, BoneName, vect(0,0,0), rot(0,0,0) );
	AttachToBone(SeveredArm, BoneName);
	
	Return SeveredArm;
}

simulated function SeveredAppendageAttachment SpawnSeveredLeg(name BoneName)
{
	local	SeveredAppendageAttachment	SeveredLeg;
	
	if ( BoneName == '' || SeveredLegAttachClass == None )
		Return None;
	
	SeveredLeg = Spawn(SeveredLegAttachClass, self);
	if ( SeveredLeg == None )
		Return None;
	
	SeveredLeg.SetDrawScale(SeveredLegAttachScale);
	AttachEmitterEffect( LimbSpurtEmitterClass, BoneName, vect(0,0,0), rot(0,0,0) );
	AttachToBone(SeveredLeg, BoneName);
	
	Return SeveredLeg;
}

simulated function SpawnSeveredHead()
{
	if ( NeckBone == '' || SeveredHeadAttachClass == None )
		Return;
	
	SeveredHead = Spawn(SeveredHeadAttachClass, self);
	if ( SeveredHead == None )
		Return;
	
	SeveredHead.SetDrawScale(SeveredHeadAttachScale);
	if ( bNoBrainBitEmitter )
		AttachEmitterEffect( NeckSpurtNoGibEmitterClass, NeckBone, vect(0,0,0), rot(0,0,0) );
	else
		AttachEmitterEffect( NeckSpurtNoGibEmitterClass, NeckBone, vect(0,0,0), rot(0,0,0) );
	AttachToBone(SeveredHead, NeckBone);
}

simulated function HideBone(name BoneName)
{
	// Only hide the bone if it is one of the arms, legs, or head, don't hide other misc bones
	switch(BoneName)  {
		case LeftThighBone:
			if ( SeveredLeftLeg == None )
				SeveredLeftLeg = SpawnSeveredLeg( LeftLegBone );
			SetBoneScale(0, 0.0, BoneName);
			Break;
		
		case RightThighBon:
			if ( SeveredRightLeg == None )
				SeveredRightLeg = SpawnSeveredLeg( RightLegBone );
			SetBoneScale(1, 0.0, BoneName);
			Break;
		
		case LeftFArmBone:
			if ( SeveredLeftArm == None )
				SeveredLeftArm = SpawnSeveredArm( LeftArmBone );
			SetBoneScale(2, 0.0, BoneName);
			Break;
			
		case RightFArmBone:
			if ( SeveredRightArm == None )
				SeveredRightArm = SpawnSeveredArm( RightArmBone );
			SetBoneScale(3, 0.0, BoneName);
			Break;
			
		case HeadBone:
			SpawnSeveredHead();
			SetBoneScale(4, 0.0, BoneName);
			Break;
		
		case 'spine':
			SetBoneScale(5, 0.0, BoneName);
			Break;
	}
}

simulated function SpawnSeveredGiblet( class<SeveredAppendage> GibClass, Vector Location, Rotator Rotation, float GibPerterbation, rotator SpawnRotation )
{
	local	SeveredAppendage	Giblet;
	local	Vector				Direction, Dummy;

	if ( GibClass == None || class'GameInfo'.static.UseLowGore() )
		Return;

	Instigator = self;
	Giblet = Spawn( GibClass,,, Location, SpawnRotation );
	if ( Giblet == None )
		Return;
	
	Giblet.SpawnTrail();
	GibPerterbation *= 32768.0;
	Rotation.Pitch += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;
	Rotation.Yaw += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;
	Rotation.Roll += ( FRand() * 2.0 * GibPerterbation ) - GibPerterbation;
	GetAxes( Rotation, Dummy, Dummy, Direction );
	Giblet.Velocity = Velocity + Normal(Direction) * (Giblet.MaxSpeed + Giblet.MaxSpeed * 0.5 * FRand());

	// Give a little upward motion to the decapitated head
	if ( class<SeveredHead>(GibClass) != None )
		Giblet.Velocity.Z += 50.0;
}

// EnemyChanged() called by controller when current enemy changes
function EnemyChanged()
{
	if ( Controller != None )
		LookTarget = Controller.Enemy;
}

// Give zombies forward momentum with jumps.
function bool DoJump( bool bUpdating )
{
	if ( !bIsCrouched && !bWantsToCrouch && (Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider) )  {
		PlayOwnedSound(JumpSound, SLOT_Pain, GruntVolume,,80);
		if ( Role == ROLE_Authority )  {
			if ( Level.Game != None && Level.Game.GameDifficulty > 2 )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && Inventory != None )
				Inventory.OwnerEvent('Jumped');
		}
		
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else  {
			Velocity = Normal(Rotation) * JumpSpeed;
			Velocity.Z = JumpZ;
		}

		if ( Base != None && !Base.bWorldGeometry )  {
			Velocity.Z += Base.Velocity.Z;
			Velocity.X += Base.Velocity.X;
		}
		SetPhysics(PHYS_Falling);
		
		Return True;
	}
	
	Return False;
}

function bool MeleeDamageTarget(int HitDamage, vector PushDir)
{
	local	vector		HitLocation, HitNormal;
	local	Actor		HitActor;
	local	Name		TearBone;
	local	float		F;
	
	if ( Role < ROLE_Authority || Controller == None || Controller.Target == None || bSTUNNED || DECAP )
		Return False;
	
	if ( KFDoorMover(Controller.Target) != None )  {
		Controller.Target.TakeDamage(HitDamage, self , Location, PushDir, CurrentDamType);
		Return True;
	}
	
	F = FMax(CollisionHeight, Controller.Target.CollisionHeight) + 0.5 * FMin(CollisionHeight, Controller.Target.CollisionHeight);
	// check if still in melee range
	if ( (Physics == PHYS_Flying || Physics == PHYS_Swimming || Abs(Location.Z - Controller.Target.Location.Z) <= F) && 
		 VSize(Controller.Target.Location - Location) <= (float(MeleeRange) * 1.4 + Controller.Target.CollisionRadius + CollisionRadius) )  {
		// Trace to find a victim
		HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, (Location + EyePosition()), True);
		if ( HitActor == None )
			Return False;
		
		// If the trace wouldn't hit a pawn, check for the blocking mover or world geometry
		if ( Pawn(HitActor) == None )  {
			HitActor = Trace(HitLocation, HitNormal, Controller.Target.Location, Location, false);
			if ( HitActor != None )
				Return False;
		}

		// Do more damage if you are attacking another zed so that zeds don't just stand there whacking each other forever! - Ramm
		if ( KFMonster(Controller.Target) != None )  {
			Controller.Target.TakeDamage(Round(float(HitDamage) * DamageToMonsterScale), self, HitLocation, PushDir, CurrentDamType);
			Return True;
		}
		
		Controller.Target.TakeDamage(HitDamage, self, HitLocation, PushDir, CurrentDamType);
		// Check for killed Human
		if ( KFHumanPawn(Controller.Target) != None && KFHumanPawn(Controller.Target).Health < 1 )  {
			// Blood effects
			if ( !class'GameInfo'.static.UseLowGore() )  {
				Spawn(class'KFMod.FeedingSpray', self,, Controller.Target.Location, rotator(PushDir));
				KFHumanPawn(Controller.Target).SpawnGibs(rotator(PushDir), 1);
				TearBone = Controller.Target.GetClosestBone(HitLocation, PushDir, F);
				if ( TearBone != '' )
					KFHumanPawn(Controller.Target).HideBone(TearBone);
			}
			// Give us some Health back
			if ( Health <= (HealthMax * (1.0 - FeedThreshold)) )
				Health += Round(FeedThreshold * HealthMax * float(Health) / HealthMax);
		}

		Return True;
	}

	Return False;
}

function ClawDamageTarget()
{
	local	vector	PushDir;
	local	float	UsedMeleeDamage;

	if ( Controller == None || Controller.Target == None )
		Return;
	
	if ( MeleeDamage < 20 )
		UsedMeleeDamage = MeleeDamage;
	// Melee damage +/- 5%
	else
		UsedMeleeDamage = Round( float(MeleeDamage) * Lerp(FRand(), 0.95, 1.05) );
	
	PushDir = damageForce * Normal(Controller.Target.Location - Location);
	if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);
}

//[Block] Animation functions
simulated function AnimateDefault()
{
	local	byte	i;
	
	if ( bDecapitated || bZapped || bCrispified )
		Return;
	
	for ( i = 0; i < ArrayCount(MovementAnims); ++i )
		MovementAnims[i] = default.MovementAnims[i];
	
	for ( i = 0; i < ArrayCount(WalkAnims); ++i )
		WalkAnims[i] = default.WalkAnims[i];
	
	if ( AdditionalWalkAnims.Length > 0 )  {
		// Moving forward Rand anim
		if ( AdditionalWalkAnims[NextWalkAnimNum] == '' )
			AdditionalWalkAnims.Remove(NextWalkAnimNum, 1);
		else if ( HasAnim(AdditionalWalkAnims[NextWalkAnimNum]) )  {
			MovementAnims[0] = AdditionalWalkAnims[NextWalkAnimNum];
			WalkAnims[0] = AdditionalWalkAnims[NextWalkAnimNum];
		}
		
		// Rand next anim num on the server
		if ( Role == ROLE_Authority )  {
			NextWalkAnimNum = Rand(AdditionalWalkAnims.Length);
			NetUpdateTime = Level.TimeSeconds - 1.0;
		}
	}
}

simulated function AnimateRuning()
{
	local	byte	i;
	
	for ( i = 0; i < ArrayCount(RunAnims); ++i )  {
		if ( RunAnims[i] != '' && HasAnim(RunAnims[i]) )
			MovementAnims[i] = RunAnims[i];
			WalkAnims[i] = RunAnims[i];
	}
}

simulated function AnimateBurning()
{
	if ( bHeadlessAnimated )
		Return;
	
	// Moving forward Rand anim
	if ( BurningWalkFAnims[NextBurningWalkAnimNum] != '' && HasAnim(BurningWalkFAnims[NextBurningWalkAnimNum]) )  {
		MovementAnims[0] = BurningWalkFAnims[NextBurningWalkAnimNum];
		WalkAnims[0] = BurningWalkFAnims[NextBurningWalkAnimNum];
	}
	// Moving back anim
	if ( BurningWalkAnims[0] != '' && HasAnim(BurningWalkAnims[0]) )  {
		MovementAnims[1] = BurningWalkAnims[0];
		WalkAnims[1] = BurningWalkAnims[0];
	}
	// Moving left anim
	if ( BurningWalkAnims[1] != '' && HasAnim(BurningWalkAnims[1]) )  {
		MovementAnims[2] = BurningWalkAnims[1];
		WalkAnims[2] = BurningWalkAnims[1];
	}
	// Moving right anim
	if ( BurningWalkAnims[2] != '' && HasAnim(BurningWalkAnims[2]) )  {
		MovementAnims[3] = BurningWalkAnims[2];
		WalkAnims[3] = BurningWalkAnims[2];
	}
	
	// Rand next anim num on the server
	if ( Role == ROLE_Authority )  {
		NextBurningWalkAnimNum = Rand(ArrayCount(BurningWalkFAnims));
		NetUpdateTime = Level.TimeSeconds - 1.0;
	}
}

simulated function AnimateHeadless()
{
	bHeadlessAnimated = True;
	// Moving forward anim
	if ( HeadlessWalkAnims[0] != '' && HasAnim(HeadlessWalkAnims[0]) )  {
		MovementAnims[0] = HeadlessWalkAnims[0];
		WalkAnims[0] = HeadlessWalkAnims[0];
	}
	// Moving back anim
	if ( HeadlessWalkAnims[1] != '' && HasAnim(HeadlessWalkAnims[1]) )  {
		MovementAnims[1] = HeadlessWalkAnims[1];
		WalkAnims[1] = HeadlessWalkAnims[1];
	}
	// Moving left anim
	if ( HeadlessWalkAnims[2] != '' && HasAnim(HeadlessWalkAnims[2]) )  {
		MovementAnims[2] = HeadlessWalkAnims[2];
		WalkAnims[2] = HeadlessWalkAnims[2];
	}
	// Moving right anim
	if ( HeadlessWalkAnims[3] != '' && HasAnim(HeadlessWalkAnims[3]) )  {
		MovementAnims[3] = HeadlessWalkAnims[3];
		WalkAnims[3] = HeadlessWalkAnims[3];
	}
	// HeadlessIdleAnim
	if ( HeadlessIdleAnim != '' && HasAnim(HeadlessIdleAnim) )  {
		IdleHeavyAnim = HeadlessIdleAnim;
		IdleRifleAnim = HeadlessIdleAnim;
		IdleCrouchAnim = HeadlessIdleAnim;
		IdleWeaponAnim = HeadlessIdleAnim;
		IdleRestAnim = HeadlessIdleAnim;
	}
}


simulated event PlayJump();
simulated event PlayFalling();
simulated function PlayMoving();
simulated function PlayWaiting();

simulated event PlayLandingAnimation(float ImpactVel);

function PlayLanded(float ImpactVel)
{
	if ( !bPhysicsAnimUpdate )
		PlayLandingAnimation(ImpactVel);
}

// Take a Falling Damage
function TakeFallingDamage()
{
	local	float	FallingSpeedRatio;
	local	int		FallingDamage;
	
	// Server only
	if ( Role < ROLE_Authority || Velocity.Z > -(MaxFallSpeed * 0.5) )
		Return;
	
	// Calculating FallingSpeedRatio, taking into account PhysicsVolume gravity
	if ( TouchingWaterVolume() )
		FallingSpeedRatio = Abs( FMin((Velocity.Z + (GroundSpeed - WaterSpeed) * 2.0), 0.0) / (MaxFallSpeed * Class'PhysicsVolume'.default.Gravity.Z / PhysicsVolume.Gravity.Z) );
	else
		FallingSpeedRatio = Abs( Velocity.Z / (MaxFallSpeed * Class'PhysicsVolume'.default.Gravity.Z / PhysicsVolume.Gravity.Z) );

	if ( FallingSpeedRatio < 0.5 )
		Return;
	
	MakeNoise( FMin(FallingSpeedRatio, 1.0) );
	// Hurt monster if FallingSpeed is over the MaxFallSpeed
	if ( FallingSpeedRatio > 1.0 )  {
		FallingDamage = ProcessTakeDamage( Round(HealthMax * (FallingSpeedRatio - 1.0)), None, Location, vect(0, 0, 0), FallingDamageType );
		// Shake controller
		if ( Controller != None && FallingDamage > 0 )
			Controller.DamageShake( FallingDamage );
	}
}

event Landed(vector HitNormal)
{
	ImpactVelocity = vect(0,0,0);
	TakeFallingDamage();
	
	if ( Health > 0 )
		PlayLanded(Velocity.Z);
	
	if ( Velocity.Z < -200.0 && PlayerController(Controller) != None )  {
		bJustLanded = PlayerController(Controller).bLandingShake;
		OldZ = Location.Z;
	}
	
	LastHitBy = None;
}

function PlayVictoryAnimation()
{
	SetAnimAction( TauntAnims[NextTauntAnimNum] );
	// Rand NextTauntAnimNum on the server 
	if ( Role == ROLE_Authority )
		NextTauntAnimNum = 3 + Rand(TauntAnims.Length - 3); // First 4 taunts are 'order' anims. Don't pick them.
}

simulated event ChangeAnimation()
{
	if ( Controller != None && Controller.bControlAnimations )
		Return;
	
	// player animation - set up new idle and moving animations
	PlayWaiting();
	PlayMoving();
}

event SetWalking(bool bNewIsWalking)
{
	/* Comment from KFMonster.uc
	// this could have been responsible for making the zombies "lethargic" in wander state.
	// they should retain the same walk speed at all times.
	if ( bNewIsWalking != bIsWalking )  {
		bIsWalking = bNewIsWalking;
		ChangeAnimation();
	}	*/
}

simulated function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
	local	vector				shotDir, hitLocRel, deathAngVel, shotStrength;
	local	float				maxDim;
	local	string				RagSkelName;
	local	KarmaParamsSkel		skelParams;
	local	bool				PlayersRagdoll;

	if ( MyExtCollision != None )
		MyExtCollision.Destroy();
	
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( PlayerController(OldController) != None && PlayerController(OldController).ViewTarget == self )
			PlayersRagdoll = True;
		
		if ( Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && (bIsRelevant || bGibbed) )  {
			// Wait a tick on a listen server so the obliteration can replicate before the pawn is destroyed
			if ( Level.NetMode == NM_ListenServer )  {
				TimeSetDestroyNextTickTime = Level.TimeSeconds + 0.005;
				bDestroyNextTick = True;
			}
			else
				Destroy();
			
			Return;
		}

		// Try and obtain a rag-doll setup. Use optional 'override' one out of player record first, then use the species one.
		if ( RagdollOverride != "" )
			RagSkelName = RagdollOverride;
		else if ( Species != None )
			RagSkelName = Species.static.GetRagSkelName( GetMeshName() );
		else 
			RagSkelName = "Male1"; // Otherwise assume it is Male1 ragdoll were after here.

		KMakeRagdollAvailable();

		if ( KIsRagdollAvailable() && RagSkelName != "" )  {
			skelParams = KarmaParamsSkel(KParams);
			skelParams.KSkeleton = RagSkelName;

			// Stop animation playing.
			StopAnimating(True);

			// StopAnimating() resets the neck bone rotation, we have to set it again
			// if the zed was decapitated the cute way
			if ( class'GameInfo'.static.UseLowGore() && NeckRot != rot(0,0,0) )
				SetBoneRotation(NeckBone, NeckRot);

			if ( DamageType != None )  {
				if ( DamageType.default.bLeaveBodyEffect )
					TearOffMomentum = vect(0,0,0);

				if ( DamageType.default.bKUseOwnDeathVel )  {
					RagDeathVel = DamageType.default.KDeathVel;
					RagDeathUpKick = DamageType.default.KDeathUpKick;
					RagShootStrength = DamageType.default.KDamageImpulse;
				}
			}

			// Set the dude moving in direction he was shot in general
			shotDir = Normal(GetTearOffMomemtum());
			shotStrength = RagDeathVel * shotDir;
			// Calculate angular velocity to impart, based on shot location.
			hitLocRel = TakeHitLocation - Location;

			if ( DamageType.default.bLocationalHit )  {
				hitLocRel.X *= RagSpinScale;
				hitLocRel.Y *= RagSpinScale;
				
				if ( Abs(hitLocRel.X)  > RagMaxSpinAmount )  {
					if( hitLocRel.X < 0 )
						hitLocRel.X = FMax((hitLocRel.X * RagSpinScale), (RagMaxSpinAmount * -1));
					else
						hitLocRel.X = FMin((hitLocRel.X * RagSpinScale), RagMaxSpinAmount);
				}

				if ( Abs(hitLocRel.Y)  > RagMaxSpinAmount )  {
					if ( hitLocRel.Y < 0 )
						hitLocRel.Y = FMax((hitLocRel.Y * RagSpinScale), (RagMaxSpinAmount * -1));
					else
						hitLocRel.Y = FMin((hitLocRel.Y * RagSpinScale), RagMaxSpinAmount);
				}

			}
			else  {
				// We scale the hit location out sideways a bit, to get more spin around Z.
				hitLocRel.X *= RagSpinScale;
				hitLocRel.Y *= RagSpinScale;
			}

			//log("hitLocRel.X = "$hitLocRel.X$" hitLocRel.Y = "$hitLocRel.Y);
			//log("TearOffMomentum = "$VSize(GetTearOffMomemtum()));

			// If the tear off momentum was very small for some reason, make up some angular velocity for the pawn
			if ( VSize(GetTearOffMomemtum()) < 0.01 )
				deathAngVel = VRand() * 18000.0;
			else
				deathAngVel = RagInvInertia * (hitLocRel cross shotStrength);

			// Set initial angular and linear velocity for ragdoll.
			// Scale horizontal velocity for characters - they run really fast!
			if ( DamageType.Default.bRubbery )
				skelParams.KStartLinVel = vect(0,0,0);
			
			if ( Damagetype.default.bKUseTearOffMomentum )
				skelParams.KStartLinVel = GetTearOffMomemtum() + Velocity;
			else  {
				skelParams.KStartLinVel.X = 0.6 * Velocity.X;
				skelParams.KStartLinVel.Y = 0.6 * Velocity.Y;
				skelParams.KStartLinVel.Z = 1.0 * Velocity.Z;
				skelParams.KStartLinVel += shotStrength;
			}
			
			// If not moving downwards - give extra upward kick
			if ( !DamageType.default.bLeaveBodyEffect && !DamageType.Default.bRubbery && Velocity.Z > -10.0 )
				skelParams.KStartLinVel.Z += RagDeathUpKick;

			if ( DamageType.Default.bRubbery )  {
				Velocity = vect(0,0,0);
				skelParams.KStartAngVel = vect(0,0,0);
			}
			else  {
				skelParams.KStartAngVel = deathAngVel;
				// Set up deferred shot-bone impulse
				maxDim = Max(CollisionRadius, CollisionHeight);
				skelParams.KShotStart = TakeHitLocation - (1 * shotDir);
				skelParams.KShotEnd = TakeHitLocation + (2*maxDim*shotDir);
				skelParams.KShotStrength = RagShootStrength;
			}

			//log("RagDeathVel = "$RagDeathVel$" KShotStrength = "$skelParams.KShotStrength$" RagDeathUpKick = "$RagDeathUpKick);

			// If this damage type causes convulsions, turn them on here.
			if ( DamageType != None && DamageType.default.bCauseConvulsions )  {
				RagConvulseMaterial=DamageType.default.DamageOverlayMaterial;
				skelParams.bKDoConvulsions = True;
			}

			// Turn on Karma collision for ragdoll.
			KSetBlockKarma(true);
			// Set physics mode to ragdoll.
			// This doesn't actaully start it straight away, it's deferred to the first tick.
			SetPhysics(PHYS_KarmaRagdoll);
			// If viewing this ragdoll, set the flag to indicate that it is 'important'
			if ( PlayersRagdoll )
				skelParams.bKImportantRagdoll = True;

			skelParams.bRubbery = DamageType.Default.bRubbery;
			bRubbery = DamageType.Default.bRubbery;
			skelParams.KActorGravScale = RagGravScale;

			Return;
		}
	}
	
	// non-ragdoll death fallback
	Velocity += GetTearOffMomemtum();
	BaseEyeHeight = Default.BaseEyeHeight;
	SetTwistLook(0, 0);
	SetInvisibility(0.0);
	// We don't do this - Ramm
	//PlayDirectionalDeath(HitLoc);
	SetPhysics(PHYS_Falling);
}

simulated function CuteDecapFX()
{
	local int LeftRight;

	LeftRight = 1;

	if ( rand(10) > 5 )
		LeftRight = -1;

	NeckRot.Yaw = -clamp(rand(24000), 14000, 24000);
	NeckRot.Roll = LeftRight * clamp(rand(8000), 2000, 8000);
	NeckRot.Pitch =  LeftRight * clamp(rand(12000), 2000, 12000);

	SetBoneRotation('neck', NeckRot);
}

// Handle hiding the head when its been melee chopped off
simulated function SpecialHideHead()
{
	if ( SeveredHead != None )
		Return;
	
	// Only scale the bone down once
	SpawnSeveredHead();
	SetBoneScale(4, 0.0, BoneName);
}

// Handle doing the decapitation hit effects
simulated function DecapFX( Vector DecapLocation, Rotator DecapRotation, bool bSpawnDetachedHead, optional bool bNoBrainBits )
{
	local	float		GibPerterbation;
	local	BrainSplash	SplatExplosion;

	// Do the cute version of the Decapitation
	if ( class'GameInfo'.static.UseLowGore() )  {
		CuteDecapFX();
		Return;
	}

	bNoBrainBitEmitter = bNoBrainBits;
	GibPerterbation = 0.060000; // DamageType.default.GibPerterbation;

	if ( bSpawnDetachedHead )
		SpecialHideHead();
	else
		HideBone(HeadBone);

	if ( bSpawnDetachedHead )
		SpawnSeveredGiblet( DetachedHeadClass, DecapLocation, DecapRotation, GibPerterbation, GetBoneRotation(HeadBone) );
	
	if ( !bSpawnDetachedHead && !bNoBrainBits && EffectIsRelevant(DecapLocation,false) )  {
		KFSpawnGiblet( class 'KFMod.KFGibBrain',DecapLocation, self.Rotation, GibPerterbation, 250 ) ;
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',DecapLocation, self.Rotation, GibPerterbation, 250 ) ;
		KFSpawnGiblet( class 'KFMod.KFGibBrain',DecapLocation, self.Rotation, GibPerterbation, 250 ) ;
	}
	
	SplatExplosion = Spawn(class 'BrainSplash',self,, DecapLocation );
}

function PlayDyingSound()
{
	if ( Level.NetMode == NM_Client )
		Return;
	
	if ( bGibbed )  {
		// Do nothing for now
		PlaySound(GibGroupClass.static.GibSound(), SLOT_Pain, 2.0, True, 525.0);
		Return;
	}

	if ( bDecapitated )
		PlaySound(HeadlessDeathSound, SLOT_Pain, 1.50, True, 525.0);
	else
		PlaySound(DeathSound[0], SLOT_Pain, 1.50, True, 525.0);
}

// Maybe spawn some chunks when the player gets obliterated
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	local	float	RandFloat;
	bGibbed = True;
	PlayDyingSound();

	if ( class'GameInfo'.static.UseLowGore() )
		Return;

	if ( FlamingFXs != None )  {
		FlamingFXs.Emitters[0].SkeletalMeshActor = None;
		FlamingFXs.Destroy();
	}

	if ( ObliteratedEffectClass != None )
		Spawn( ObliteratedEffectClass,,, Location, HitRotation );
	
	RandFloat = FRand();
	if ( RandFloat < 0.1 )  {
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 );

		SpawnSeveredGiblet( DetachedLegClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		SpawnSeveredGiblet( DetachedLegClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		SpawnSeveredGiblet( DetachedArmClass, Location, HitRotation, ChunkPerterbation, HitRotation );

		if ( DetachedSpecialArmClass != None )
			SpawnSeveredGiblet( DetachedSpecialArmClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		else
			SpawnSeveredGiblet( DetachedArmClass, Location, HitRotation, ChunkPerterbation, HitRotation );
	}
	else if ( RandFloat < 0.25 )  {
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 );
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 );

		SpawnSeveredGiblet( DetachedLegClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		SpawnSeveredGiblet( DetachedLegClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		if ( FRand() < 0.5 )  {
			KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 ) ;
			SpawnSeveredGiblet( DetachedArmClass, Location, HitRotation, ChunkPerterbation, HitRotation );
		}
	}
	else if ( RandFloat < 0.35 )  {
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 ) ;
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 ) ;
		SpawnSeveredGiblet( DetachedLegClass, Location, HitRotation, ChunkPerterbation, HitRotation );
	}
	else if ( RandFloat < 0.5 )  {
		KFSpawnGiblet( class 'KFMod.KFGibBrainb',Location, HitRotation, ChunkPerterbation, 500 ) ;
		KFSpawnGiblet( class 'KFMod.KFGibBrain',Location, HitRotation, ChunkPerterbation, 500 ) ;
		SpawnSeveredGiblet( DetachedArmClass, Location, HitRotation, ChunkPerterbation, HitRotation );
	}
}

simulated function ProcessHitFX()
{
	local	Coords				boneCoords;
	local	class<xEmitter>		HitEffects[4];
	local	int					i, j;
	local	float				GibPerterbation;

	if ( Level.NetMode == NM_DedicatedServer || bSkeletized || Mesh == SkeletonMesh)  {
		SimHitFxTicker = HitFxTicker;
		Return;
	}

	for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )  {
		j++;
		if ( j > 30 )  {
			SimHitFxTicker = HitFxTicker;
			Return;
		}

		if ( HitFX[SimHitFxTicker].damtype == None || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime) > 3.0 && !IsHumanControlled()) )
			continue;

		//log("Processing effects for damtype "$HitFX[SimHitFxTicker].damtype);
		// Just destroy if exploaded
		if ( HitFX[SimHitFxTicker].bone == 'obliterate' && !class'GameInfo'.static.UseLowGore() )  {
			SpawnGibs( HitFX[SimHitFxTicker].rotDir, 1);
			bGibbed = True;
			// Wait a tick on a listen server so the obliteration can replicate before the pawn is destroyed
			if ( Level.NetMode == NM_ListenServer )  {
				TimeSetDestroyNextTickTime = Level.TimeSeconds + 0.005;
				bDestroyNextTick = True;
			}
			else
				Destroy();
			
			Return;
		}

		boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );
		// if UseLowGore() just remove head bone
		if ( class'GameInfo'.static.UseLowGore() )  {
			HitFX[SimHitFxTicker].bSever = False;
			if ( HitFX[SimHitFxTicker].bone == HeadBone && !bHeadGibbed )  {
				bHeadGibbed = True;
				if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false);
				else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false, true);
				else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, true);
			}
		}
		else if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() && !bSkeletized )  {
			//AttachEmitterEffect( BleedingEmitterClass, HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
			HitFX[SimHitFxTicker].damtype.static.GetHitEffects( HitEffects, Health );
			// don't attach effects under water
			if ( !PhysicsVolume.bWaterVolume )  {
				for ( i = 0; i < ArrayCount(HitEffects); ++i )  {
					if ( HitEffects[i] == None )
						continue;
					AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, vect(0, 0, 0), HitFX[SimHitFxTicker].rotDir );
				}
			}
		}
		
		if ( !HitFX[SimHitFxTicker].bSever )
			Continue; // Skip if UseLowGore()
				
		GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;
		switch( HitFX[SimHitFxTicker].bone )
		{
			case 'obliterate':
				Break;

			case LeftThighBone:
				if ( bLeftLegGibbed )
					Break;
				bLeftLegGibbed = True;
				SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				Break;

			case RightThighBone:
				if ( bRightLegGibbed )
					Break;
				bRightLegGibbed = True;
				SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				Break;

			case LeftFArmBone:
				if ( bLeftArmGibbed )
					Break;
				bLeftArmGibbed = True;
				SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;;
				Break;

			case RightFArmBone:
				if ( bRightArmGibbed )
					Break;
				bRightArmGibbed = True;
				SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
				KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
				Break;

			case HeadBone:
				if ( bHeadGibbed )
					Break;
				bHeadGibbed = True;
				if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false);
				else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false, true);
				else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
					DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, true);
				Break;
		}


		if ( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone && HitFX[SimHitFXTicker].bone != 'head' && Health < 1 )
			HideBone(HitFX[SimHitFxTicker].bone);
	}
}

simulated function ZombieCrispUp()
{
	if ( bAshenApplied )
		Return;
	
	bAshen = True;
	// Apply AshenSkin
	bAshenApplied = True;
	if ( Level.NetMode != NM_DedicatedServer || !class'GameInfo'.static.UseLowGore() )  {
		for ( i = 0; i < Skins.Length; ++i )
			Skins[i] = AshenSkin;
	}
}


simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	local	float		frame, rate;
	local	name		seq;
	local	LavaDeath	LD;
	local	MiscEmmiter	BE;

	AmbientSound = None;
	bCanTeleport = False; // sjs - fix karma going crazy when corpses land on teleporters
	bReplicateMovement = False;
	bTearOff = True;
	bPlayedDeath = True;
	StopBurnFX();

	if ( CurrentCombo != None )
		CurrentCombo.Destroy();

	HitDamageType = DamageType; // these are replicated to other clients
	TakeHitLocation = HitLoc;

	bSTUNNED = False;
	bMovable = True;

	if ( class<DamTypeBurned>(DamageType) != None || class<DamTypeFlamethrower>(DamageType) != None )
		ZombieCrispUp();

	ProcessHitFX();
	if ( DamageType != None )  {
		if ( DamageType.default.bSkeletize )  {
			SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 4.0, true);
			if ( !bSkeletized )  {
				if ( Level.NetMode != NM_DedicatedServer && SkeletonMesh != None )  {
					if ( DamageType.default.bLeaveBodyEffect )  {
						BE = spawn(class'MiscEmmiter', self);
						if ( BE != None )  {
							BE.DamageType = DamageType;
							BE.HitLoc = HitLoc;
							bFrozenBody = true;
						}
					}
					GetAnimParams( MainAnimChannel, seq, frame, rate );
					LinkMesh(SkeletonMesh, true);
					Skins.Length = 0;
					PlayAnim(seq, 0.0, 0.0, MainAnimChannel);
					SetAnimFrame(frame, MainAnimChannel);
				}
				
				if ( Physics == PHYS_Walking )
					Acceleration = vect(0, 0, 0);
					//Velocity = Vect(0,0,0);
				
				SetTearOffMomemtum(GetTearOffMomemtum() * 0.25);
				bSkeletized = True;
				
				if ( Level.NetMode != NM_DedicatedServer && DamageType == class'FellLava' )  {
					LD = spawn(class'LavaDeath', , , Location + vect(0, 0, 10), Rotation );
					if ( LD != None )
						LD.SetBase(self);
					//PlaySound( sound'WeaponSounds.BExplosion5', SLOT_None, 1.5*TransientSoundVolume );
				}
			}
		}
		else if ( DamageType.Default.DeathOverlayMaterial != None )
			SetOverlayMaterial(DamageType.Default.DeathOverlayMaterial, DamageType.default.DeathOverlayTime, true);
		else if ( DamageType.Default.DamageOverlayMaterial != None && Level.DetailMode != DM_Low && !Level.bDropDetail )
			SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, 2*DamageType.default.DamageOverlayTime, true);
	}

	// stop shooting
	AnimBlendParams(MinorAnimChannel, 0.0);
	FireState = FS_None;

	// Try to adjust around performance
	//log(Level.DetailMode);

	LifeSpan = RagdollLifeSpan;

	GotoState('ZombieDying');
	if ( BE != None )
		Return;
	
	PlayDyingAnimation(DamageType, HitLoc);
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == HitAnims[0] || AnimName == HitAnims[1] || AnimName == HitAnims[2] || AnimName == KFHitFront || AnimName == KFHitBack || AnimName == KFHitRight || AnimName == KFHitLeft )  {
		if ( !IsAnimating(MinorAnimChannel) && IsAnimating(MainAnimChannel) )  {
			AnimBlendParams(MinorAnimChannel, 0.0, 0.0,, SpineBone1);
			AnimBlendToAlpha(MinorAnimChannel, 1.0, 0.1);
		}
		else
			AnimBlendParams(MinorAnimChannel, 1.0, 0.0,, SpineBone1);
		
		PlayAnim(AnimName, , 0.1, MinorAnimChannel);
		Return MinorAnimChannel;
	}
	
	PlayAnim(AnimName, ,0.1, MainAnimChannel);
	Return MainAnimChannel;
}

simulated function bool AnimNeedsWait(name TestAnim)
{
	Return ExpectingChannel == MainAnimChannel;
}

// Choose AnimAction on the server and replicate it to the clients
function ServerSetAnimAction(out name NewAction)
{
	if ( NewAction == '' )  {
		bResetAnimAct = False;
		AnimAction = '';
		Return;
	}
	
	if ( NewAction == 'Claw' )  {
		NewAction = meleeAnims[NextMeleeAnimNum];
		CurrentDamtype = ZombieDamType[NextMeleeAnimNum];
		// Rand NextMeleeAnimNum on the server
		NextMeleeAnimNum = Rand(ArrayCount(meleeAnims));
	}
	else if ( NewAction == 'DoorBash' )  {
		CurrentDamtype = ZombieDamType[NextMeleeAnimNum];
		// Rand NextMeleeAnimNum on the server
		NextMeleeAnimNum = Rand(ArrayCount(meleeAnims));
	}
	
	AnimAction = NewAction;
	// Reset AnimAction variable to replicate any new value even if
	// it will be the same AnimAction as playing
	bResetAnimAct = True;
	ResetAnimActTime = Level.TimeSeconds + 0.3;
}

// Called on the clients when new value of AnimAction variable was received
simulated event SetAnimAction(name NewAction)
{
	if ( Role == ROLE_Authority )
		ServerSetAnimAction(NewAction);
	// Reset AnimAction variable on the clients to receive event SetAnimAction call
	// by any new value
	else
		AnimAction = '';
		
	if ( NewAction == '' )
		Return;
	
	ExpectingChannel = DoAnimAction(NewAction);
	bWaitForAnim = AnimNeedsWait(NewAction);
}

simulated event AnimEnd(int Channel)
{
	AnimAction = '';
	if ( bShotAnim && Channel == ExpectingChannel )  {
		bShotAnim = False;
		if ( Controller != None && !bMovementDisabled )
			Controller.bPreparingMove = Controller.default.bPreparingMove;
	}
	
	if ( Channel == MainAnimChannel )  {
		if ( !bPhysicsAnimUpdate )
			bPhysicsAnimUpdate = Default.bPhysicsAnimUpdate;
		if ( bKeepTaunting )
			PlayVictoryAnimation();
	}
	else if ( Channel == MinorAnimChannel )  {
		if ( FireState == FS_Ready )  {
			AnimBlendToAlpha(MinorAnimChannel, 0.0, 0.12);
			FireState = FS_None;
		}
		else if ( FireState == FS_PlayOnce )  {
			if ( HasAnim(IdleWeaponAnim) )
				PlayAnim(IdleWeaponAnim,, 0.2, MinorAnimChannel);
			FireState = FS_Ready;
			IdleTime = Level.TimeSeconds;
		}
		else
			AnimBlendToAlpha(MinorAnimChannel, 0.0, 0.12);
	}
}
//[End]

// Keep moving toward the target until anim finishes
state MovingAttack
{
	simulated event Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );
		
		// Keep monster moving toward its target when attacking
		if ( Role == ROLE_Authority && bMovingAttack && LookTarget != None )
		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
	}

Begin:
	bMovingAttack = True;
	if ( bShotAnim )
		FinishAnim(ExpectingChannel);

End:
	bMovingAttack = False;
	GotoState('');
}

function DisableMovement()
{
	if ( bMovementDisabled )
		Return;
	
	bMovementDisabled = True;
	Controller.bPreparingMove = True;
	AccelRate = 0.0;
	SetGroundSpeed(0.0);
	WaterSpeed = 0.0;
	Acceleration = vect(0,0,0);
}

function AdjustMovement()
{
	if ( bMovementDisabled )
		Return;
	
	if ( bZapped )  {
		AccelRate = default.AccelRate * ZappedSpeedMod;
		SetGroundSpeed(OriginalGroundSpeed * ZappedSpeedMod);
		AirSpeed = default.AirSpeed * ZappedSpeedMod;
		WaterSpeed = default.WaterSpeed * ZappedSpeedMod;
	}
	else if ( bDecapitated || bBurnified )  {
		AccelRate = default.AccelRate * 0.8;
		SetGroundSpeed(OriginalGroundSpeed * 0.8);
		AirSpeed = default.AirSpeed * 0.8;
		WaterSpeed = default.WaterSpeed * 0.8;
	}
	else  {
		AccelRate = default.AccelRate;
		AdjustGroundSpeed();
		AirSpeed = default.AirSpeed;
		WaterSpeed = default.WaterSpeed;
	}
}

function EnableMovement()
{
	if ( !bMovementDisabled )
		Return;
	
	Controller.bPreparingMove = False;
	bMovementDisabled = False;
	AdjustMovement();
}

// Called from UM_MonsterController
function bool CanCorpseAttack(Actor A)
{
	if ( A == None || Physics == PHYS_Swimming || bShotAnim || bSTUNNED || bDecapitated || bKnockedDown || float(Pawn.Health) >= (Pawn.Default.Health * 1.5) )
		Return False;
	
	Return True;
}

// Called from UM_MonsterController
function CorpseAttack(Actor A)
{
	DisableMovement();
	bShotAnim = True;
	SetAnimAction('ZombieFeed');
	Health = Min( (Health + 1 + Rand(3)), int(float(Default.Health) * 1.5) );
}

// Called from UM_MonsterController FireWeaponAt()
function bool CanAttack(Actor A)
{
	if ( A == None || Physics == PHYS_Swimming || bShotAnim || bSTUNNED || DECAP || bKnockedDown )
		Return False;

	if ( KFDoorMover(A) != None )
		Return True;
	
	if ( KFHumanPawn(A) != None && KFHumanPawn(A).Health < 1 )
		Return VSizeSquared(A.Location - Location) < Square(MeleeRange + CollisionRadius);
	else
		Return VSizeSquared(A.Location - Location) < Square(MeleeRange + CollisionRadius + A.CollisionRadius);
}

// Called from UM_MonsterController FireWeaponAt()
function RangedAttack(Actor A)
{
	DisableMovement();
	bShotAnim = True;
	SetAnimAction('Claw');
}

function bool CanAttackDoor(KFDoorMover Door)
{
	if ( Door == None || Physics == PHYS_Swimming || bShotAnim || bSTUNNED || bDecapitated || bKnockedDown )
		Return False;
	
	Return !Door.bHidden && Door.bSealed && !Door.bZombiesIgnore;
}

function SetDistanceDoorAttack(bool bDistanceDoorAttack)
{
	bDistanceAttackingDoor = bCanDistanceAttackDoors && bDistanceDoorAttack && !bDecapitated;
}

function DoorAttack(Actor A) { }

function AttackDoor()
{
	DisableMovement();
	bShotAnim = True;
	if ( bDistanceAttackingDoor )
		SetAnimAction(DistanceDoorAttackAnim);
	else
		SetAnimAction(DoorBashAnim);
	GotoState('DoorBashing');
}

state DoorBashing
{	
	function bool HitCanInterruptAction()
	{
		Return False;
	}
	
	function bool CanSpeedAdjust()
	{
		Return False;
	}
	
	simulated event Tick(float DeltaTime)
	{
		Global.Tick(DeltaTime);
	}
	
	function AttackDoor()
	{
		DisableMovement();
		bShotAnim = True;
		if ( bDistanceAttackingDoor )
			SetAnimAction(DistanceDoorAttackAnim);
		else
			SetAnimAction(DoorBashAnim);
	}
	
	event EndState()
	{
		bDistanceAttackingDoor = False;
	}
}

// extends Dying
state ZombieDying
{
	ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer, Died, RangedAttack;     //Tick

	simulated event BeginState()
	{
		if ( bDestroyNextTick )  {
			// If we've flagged this character to be destroyed next tick, handle that
			if ( Level.TimeSeconds > TimeSetDestroyNextTickTime )
				Destroy();
			else
				SetTimer(0.01, false);
		}
		else  {
			if ( bTearOff && (Level.NetMode == NM_DedicatedServer || class'GameInfo'.static.UseLowGore()) )
				LifeSpan = 1.0;
			else
				SetTimer(2.0, false);
		}

		SetPhysics(PHYS_Falling);
		if ( Controller != None )
			Controller.Destroy();
	}
	
	function bool CanGetOutOfWay()
	{
		Return False;
	}

	simulated event Landed(vector HitNormal)
	{
		//SetPhysics(PHYS_None);
		SetCollision(false, false, false);
		if ( !bDestroyNextTick )
			Disable('Tick');
	}

	simulated event Timer()
	{
		local	KarmaParamsSkel		skelParams;

		if ( bDestroyNextTick )  {
			// If we've flagged this character to be destroyed next tick, handle that
			if ( Level.TimeSeconds > TimeSetDestroyNextTickTime )
				Destroy();
			else
				SetTimer(0.01, false);

			Return;
		}

		if ( !PlayerCanSeeMe() )  {
			StartDeRes();
			Destroy();
		}
		// If we are running out of life, but we still haven't come to rest, force the de-res.
		// unless pawn is the viewtarget of a player who used to own it
		else if ( LifeSpan <= DeResTime && !bDeRes )  {
			skelParams = KarmaParamsSkel(KParams);
			skelParams.bKImportantRagdoll = False;
			// spawn derez
			bDeRes = True;
		}
		else
			SetTimer(1.0, false);
	}

	simulated event TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex )
	{
		local	Vector	HitNormal, shotDir;
		local	Vector	PushLinVel, PushAngVel;
		local	Name	HitBone;
		local	float	HitBoneDist;
		local	bool	bIsHeadshot;
		local	vector	HitRay;

		if ( bFrozenBody || bRubbery )
			Return;

		if ( Physics == PHYS_KarmaRagdoll )  {
			// Can't shoot corpses during de-res
			if ( bDeRes )
				Return;

			// Throw the body if its a rocket explosion or shock combo
			if ( DamageType.Default.bThrowRagdoll )  {
				shotDir = Normal(Momentum);
				PushLinVel = RagDeathVel * shotDir +  vect(0, 0, 250);
				PushAngVel = Normal(shotDir Cross vect(0, 0, 1)) * -18000.0;
				KSetSkelVel( PushLinVel, PushAngVel );
			}
			else if ( DamageType.Default.bRagdollBullet )  {
				if ( Momentum == vect(0,0,0) )
					Momentum = HitLocation - InstigatedBy.Location;
				
				if ( FRand() < 0.65 )  {
					if ( Velocity.Z <= 0 )
						PushLinVel = vect(0,0,40);
					PushAngVel = Normal(Normal(Momentum) Cross vect(0, 0, 1)) * -8000.0;
					PushAngVel.X *= 0.5;
					PushAngVel.Y *= 0.5;
					PushAngVel.Z *= 4;
					KSetSkelVel( PushLinVel, PushAngVel );
				}
				PushLinVel = RagShootStrength * Normal(Momentum);
				KAddImpulse(PushLinVel, HitLocation);
				if ( LifeSpan > 0.0 && LifeSpan < (DeResTime + 2) )
					LifeSpan += 0.2;
			}
			else  {
				PushLinVel = RagShootStrength * Normal(Momentum);
				KAddImpulse(PushLinVel, HitLocation);
			}
		}

		if ( Damage > 0 )  {
			Health = Max( (Health - Damage), 0 );
			if ( Role == ROLE_Authority && !bDecapitated && class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.bCheckForHeadShots && class<DamTypeBurned>(DamageType) == None )  {
				// Do larger headshot checks if it is a melee attach
				if ( class<DamTypeMelee>(DamageType) != None )
					bIsHeadShot = IsHeadShot(HitLocation, Normal(Momentum), 1.25);
				else
					bIsHeadShot = IsHeadShot(HitLocation, Normal(Momentum), 1.0);
				if ( bIsHeadShot )
					RemoveHead();
			}

			if ( InstigatedBy != None )  {
				HitRay = Normal( HitLocation - (InstigatedBy.Location + vect(0.0,0.0,1.0) * InstigatedBy.EyeHeight) );
				HitNormal = Normal( Normal(InstigatedBy.Location - HitLocation) + VRand() * 0.2 + vect(0.0,0.0,2.8) );
			}
			else  {
				HitRay = vect(0, 0, 0);
				HitNormal = Normal( VRand() * 0.2 + vect(0.0,0.0,3.8) );
			}

			CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );
			// Actually do blood on a client
			//PlayHit(Damage, InstigatedBy, hitLocation, DamageType, Momentum);
			DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );
		}

		if ( DamageType.Default.DamageOverlayMaterial != None && Level.DetailMode != DM_Low && !Level.bDropDetail )
			SetOverlayMaterial(DamageType.Default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, true);
	}
}

function SetDumbIntelligence()
{
	if ( bDecapitated )
		Return;
	
	Intelligence = BRAINS_Retarded; // burning dumbasses!
	// Make them less accurate
	if ( Controller != None )
		MonsterController(Controller).Accuracy = -5.0;  // More chance of missing.
}

function SetOriginalIntelligence()
{
	if ( bDecapitated || bZapped || bCrispified )
		Return;
	
	Intelligence = OriginalIntelligence;
	// Set normal accuracy
	if ( Controller != None )
		MonsterController(Controller).Accuracy = MonsterController(Controller).default.Accuracy;
}

simulated function SetZappedBehavior()
{
	if ( bOldZapped )
		Return;
	
	bOldZapped = True;
	// Set burning walk anim
	AnimateBurning();
	// Server code next
	if ( Role == ROLE_Authority )  {
		AdjustMovement();
		SetDumbIntelligence();
	}
}

simulated function UnSetZappedBehavior()
{
	if ( !bOldZapped )
		Return;
	
	bOldZapped = False;
	// restore regular anims
	AnimateDefault();
	// Server code next
	if ( Role == Role_Authority )  {
		AdjustMovement();
		SetOriginalIntelligence();
	}
}

// Set the zed to the on fire behavior
simulated function SetBurningBehavior()
{
	if ( bCrispApplied )
		Return;
	
	bCrispified = True;
	bCrispApplied = True;
	// Set burning walk anim
	AnimateBurning();
	// Server code next
	if ( Role == Role_Authority )
		SetDumbIntelligence();
}

// Turn off the on-fire behavior
simulated function UnSetBurningBehavior()
{
	if ( !bCrispApplied )
		Return;
	
	bCrispified = False;
	bCrispApplied = False;
	// restore regular anims
	AnimateDefault();
	// Server code next
	if ( Role == ROLE_Authority )
		SetOriginalIntelligence();
}

simulated function StartBurnFX()
{
	local	class<emitter>	Effect;

	if ( bBurnApplied )
		Return;
	
	bBurnApplied = True;
	if ( Role == ROLE_Authority )
		AmbientSound = BurningAmbientSound;
	
	if ( Level.NetMode == NM_DedicatedServer || bDeleteMe || bGibbed )
		Return;
	
	// No real flames when low gore, make them smoke, smoking kills
	if ( class'GameInfo'.static.UseLowGore() )
		Effect = AltBurnEffect;
	else
		Effect = BurnEffect;

	if ( FlamingFXs == None )
		FlamingFXs = Spawn(Effect);

	FlamingFXs.SetBase(Self);
	FlamingFXs.Emitters[0].SkeletalMeshActor = Self;
	FlamingFXs.Emitters[0].UseSkeletalLocationAs = PTSU_SpawnOffset;
	AttachEmitterEffect(Effect, HeadBone, vect(0,0,0), rot(0,0,0));
}

simulated function RemoveFlamingEffects()
{
	local	int		i;

	if ( Level.NetMode == NM_DedicatedServer )
		Return;

	for ( i = 0; i < Attached.length; ++i )  {
		if ( xEmitter(Attached[i]) != None )  {
			Attached[i].LifeSpan = 2;
			xEmitter(Attached[i]).mRegen = False;
		}
		else if ( Emitter(Attached[i]) != None && DismembermentJet(Attached[i]) == None )
			Emitter(Attached[i]).Kill();
	}
	
	if ( FlamingFXs != None )  {
		FlamingFXs.Kill();
		FlamingFXs = None;
	}
}

simulated function StopBurnFX()
{
	if ( !bBurnApplied )
		Return;
	
	bBurnApplied = False;
	if ( Role == ROLE_Authority )
		AmbientSound = default.AmbientSound;
	RemoveFlamingEffects();
	UnSetBurningBehavior();
}

function SetBurning(bool bBurning)
{
	if ( bBurning && Health < 1 )
		Return;
	
	bBurnified = bBurning;
	if ( bBurning )  {
		HeatAmount = 3;
		BurnCountDown = 10; // Inits burn tick count to 10
		if ( Level.TimeSeconds >= NextBurnDamageTime )
			NextBurnDamageTime = Level.TimeSeconds + BurnDamageDelay;
		bIsTakingBurnDamage = True;
		StartBurnFX();
	}
	else  {
		HeatAmount = 0;
		BurnCountDown = 0;
		LastBurnDamage = 0;
		CrispUpThreshhold = default.CrispUpThreshhold;
		StopBurnFX();
	}
	AdjustMovement();
}

function TakeBurnDamage()
{
	NextBurnDamageTime = Level.TimeSeconds + BurnDamageDelay;
	if ( bIsTakingBurnDamage )  {
		--BurnCountDown;
		HeatAmount = Min( BurnCountDown, 3 );
		bIsTakingBurnDamage = BurnCountDown > 0;
		ProcessTakeDamage( LastBurnDamage, BurnInstigator, Location, Vect(0, 0, 0), FireDamageClass );
		LastBurnDamage = Round( Lerp(FRand(), (float(LastBurnDamage) * 0.9), float(LastBurnDamage)) );
	}
	
	if ( !bIsTakingBurnDamage )  {
		SetBurning(False);
		Return;
	}
	
	// if still burning CrispUp Check
	if ( CrispUpThreshhold > 0 )  {
		--CrispUpThreshhold;
		if ( CrispUpThreshhold < 1 )  {
			ZombieCrispUp();
			SetBurningBehavior();
		}
	}
}

function TakeBileDamage()
{
	NextBileDamageTime = Level.TimeSeconds + BileDamageDelay;
	--BileCountDown;
	bIsTakingBileDamage = BileCountDown > 0;
	ProcessTakeDamage( LastBileDamage, BileInstigator, Location, Vect(0, 0, 0), LastBileDamageType );
	LastBileDamage = Round(float(LastBileDamage) * 0.65);
	if ( LastBileDamage < 1 )  {
		BileCountDown = 0;
		bIsTakingBileDamage = False;
	}
}

simulated function MakeInvisible()
{
	local	int		i;
	
	// Save the 'real' non-invis skin
	for ( i = 0; i < Skins.Length; ++i )
		RealSkins[i] = Skins[i];
	
	if ( InvisMaterial != '' )  {
		Skins.Remove(1, (Length - 1));
		Skins[0] = InvisMaterial;
	}

	// Remove/disallow projectors on invisible people
	Projectors.Remove(0, Projectors.Length);
	bAcceptsProjectors = False;

	// Invisible - no shadow
	if ( PlayerShadow != None )
		PlayerShadow.bShadowActive = False;

	// No giveaway flames either
	RemoveFlamingEffects();
}

simulated function MakeVisible()
{
	local	int		i;
	
	for ( i = 0; i < RealSkins.Length; ++i )
		Skins[i] = RealSkins[i];

	bAcceptsProjectors = Default.bAcceptsProjectors;

	if ( PlayerShadow != None )
		PlayerShadow.bShadowActive = True;
}

simulated function TickFX(float DeltaTime)
{
	if ( SimHitFxTicker != HitFxTicker )
		ProcessHitFX();

	if ( bInvis == bOldInvis )
		Return;
	
	bOldInvis = bInvis;
	// Going invisible
	if ( bInvis )
		MakeInvisible();
	else
		MakeVisible();
}

// Apply "Zap" to the Zed
function SetZapped(float ZapAmount, Pawn Instigator)
{
	LastZapTime = Level.TimeSeconds;
	TotalZap += ZapAmount;
	if ( TotalZap < ZapThreshold )
		Return;
	
	bZapped = True;
	RemainingZap = ZapDuration;
	SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', RemainingZap, True);
	ZappedBy = Instigator;
}

function TickZapped(float DeltaTime)
{
	if ( !bZapped )  {
		TotalZap = FMax((TotalZap - DeltaTime), 0.0);
		Return;
	}
	
	RemainingZap = FMax((RemainingZap - DeltaTime), 0.0);
	if ( RemainingZap > 0.0 )
		Return;
		
	bZapped = False;
	ZappedBy = None;
	// The Zed can take more zap each time they get zapped
	ZapThreshold *= ZapResistanceScale;
}

simulated event Tick( float DeltaTime )
{
	// If we've flagged this character to be destroyed next tick, handle that
	if ( bDestroyNextTick && Level.TimeSeconds > TimeSetDestroyNextTickTime )
		Destroy();
	
	if ( bDecapitated && !bHeadlessAnimated )
		AnimateHeadless();
	
	// Server side code
	if ( Role == ROLE_Authority )  {
		// Reset AnimAction variable to replicate any new value even if
		// it will be the same AnimAction as playing
		if ( bResetAnimAct && Level.TimeSeconds >= ResetAnimActTime )  {
			bResetAnimAct = False;
			AnimAction = '';
		}
		// ResetCumulativeDamage
		if ( bResetCumulativeDamage && Level.TimeSeconds > CumulativeDamageResetTime )  {
			bResetCumulativeDamage = False;
			CumulativeDamage = 0;
		}
		// Chech Relevance
		if ( Level.TimeSeconds >= NextRelevanceCheckTime )
			IsRelevant();
		if ( Level.TimeSeconds >= NextPlayersSeenCheckTime )
			CheckPlayersCanSeeMe();
		// Tick Damages
		if ( bIsTakingBileDamage && Level.TimeSeconds >= NextBileDamageTime )
			TakeBileDamage();
		if ( bIsTakingBurnDamage && Level.TimeSeconds >= NextBurnDamageTime )
			TakeBurnDamage();
		// Hidden monster SpeedAdjust
		if ( CanSpeedAdjust() )
			AdjustGroundSpeed();
		// If the Zed has been bleeding long enough, make it die
		if ( bBleedOut && Level.TimeSeconds > BleedOutTime )  {
			bBleedOut = False;
			Died( LastDamagedBy.Controller, class'DamTypeBleedOut', Location );
		}
		if ( TotalZap > 0.0 )
			TickZapped(DeltaTime);
	}
	
	if ( bZapped != bOldZapped )  {
		if ( bZapped )
			SetZappedBehavior();
		else
			UnSetZappedBehavior();
	}
	
	/*
	if ( bHarpoonStunned != bOldHarpoonStunned )  {
		bOldHarpoonStunned = bHarpoonStunned;
		if ( bHarpoonStunned )
			SetBurningBehavior();
		else
			UnSetBurningBehavior();
	}	*/
	
	if ( Level.NetMode != NM_DedicatedServer )  {
		TickFX(DeltaTime);
		if ( bBurnified != bBurnApplied )  {
			if ( bBurnified )
				StartBurnFX();
			else
				StopBurnFX();
		}
		if ( bCrispified && !bCrispApplied )
			SetBurningBehavior();
		if ( bAshen && !bAshenApplied )
			ZombieCrispUp();
	}
	
	if ( DECAP && Level.TimeSeconds > (DecapTime + 2.0) && Controller != None )  {
		DECAP = False;
		MonsterController(Controller).ExecuteWhatToDoNext(); //Todo: �碣瑣� ��� � #UM_MonsterController!!!
	}
}

// Actually execute the kick (this is notified in the ZombieKick animation)
function KickActor()
{
	KickTarget.Velocity.Z += Mass * 5.0 + KGetMass() * 10.0;
	KickTarget.KAddImpulse(ImpactVector, KickLocation);
	Acceleration = vect(0,0,0);
	Velocity = vect(0,0,0);
	if ( KFMonsterController(Controller) != None )
		KFMonsterController(controller).GotoState('Kicking');
	bShotAnim = True;
}

function bool FlipOver()
{
	Return False;
}

simulated function DoDamageFX( Name BoneName, int Damage, class<DamageType> DamageType, Rotator FXRot )
{
	local	float	DismemberProbability;
	local	bool	bDidSever;

	//log("DamageFX bonename = "$BoneName$" "$Level.TimeSeconds$" Damage "$Damage);

	if ( bDecapitated && !bPlayBrainSplash )  {
		if ( class<DamTypeMelee>(DamageType) != None && Class<Whisky_DamTypeHammerHeadShot>(DamageType) == None && Class<Whisky_DamTypeHammerSecondaryHeadShot>(DamageType) == None )
			HitFX[HitFxTicker].damtype = class'DamTypeMeleeDecapitation';
		else if( class<DamTypeNailGun>(DamageType) != None )
			HitFX[HitFxTicker].damtype = class'DamTypeProjectileDecap';
		else
			HitFX[HitFxTicker].damtype = class'DamTypeDecapitation';

		if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore()
			|| (Level.Game != None && Level.Game.PreventSever(self, BoneName, Damage, DamageType)) )
			HitFX[HitFxTicker].bSever = False;
		else
			HitFX[HitFxTicker].bSever = True;

		HitFX[HitFxTicker].bone = HeadBone;
		HitFX[HitFxTicker].rotDir = FXRot;
		HitFxTicker = HitFxTicker + 1;
		
		if ( HitFxTicker > ArrayCount(HitFX)-1 )
			HitFxTicker = 0;

		bPlayBrainSplash = True;

		if ( !(Damage > DamageType.default.HumanObliterationThreshhold && Damage != 1000) )
			Return;
	}

	if ( FRand() > 0.3f || Damage > 30 || Health < 1 )  {
		HitFX[HitFxTicker].damtype = DamageType;
		if ( Health < 1 )  {
			switch( BoneName )
			{
				case NeckBone:
					BoneName = HeadBone;
					Break;

				case LeftLegBone:
				case LeftFootBone:
					BoneName = LeftThighBone;
					Break;

				case RightLegBone:
				case RightFootBone:
					BoneName = RightThighBone;
					Break;

				case LeftShoulderBone:
				case LeftArmBone:
				case LeftHandBone:
					BoneName = LeftFArmBone;
					Break;
				
				case RightShoulderBone:
				case RightArmBone:
				case RightHandBone:
					BoneName = RightFArmBone;
					Break;

				case '':
				case 'spine':
					BoneName = FireRootBone;
					Break;
			}

			if ( DamageType.default.bAlwaysSevers || Damage == 1000 )  {
				HitFX[HitFxTicker].bSever = True;
				bDidSever = True;
				if ( BoneName == '' )
					BoneName = FireRootBone;
			}
			else if ( DamageType.Default.GibModifier > 0.0 )  {
	            DismemberProbability = Abs( (Health - Damage * DamageType.Default.GibModifier) / 130.0f );
				if ( FRand() < DismemberProbability )  {
					HitFX[HitFxTicker].bSever = True;
					bDidSever = True;
				}
			}
		}

		if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore() 
			 || (Level.Game != None && Level.Game.PreventSever(self, BoneName, Damage, DamageType)) )  {
			HitFX[HitFxTicker].bSever = False;
			bDidSever = False;
		}

		if ( HitFX[HitFxTicker].bSever )  {
	        if ( !DamageType.default.bLocationalHit && 
				 (BoneName == '' || BoneName == FireRootBone || BoneName == 'Spine' ))  {
				switch( Rand(5) )
	            {
	                case 0:
						BoneName = LeftThighBone;
						Break;
	                case 1:
						BoneName = RightThighBone;
						Break;
	                case 2:
						BoneName = LeftFArmBone;
	                    Break;
	                case 3:
						BoneName = RightFArmBone;
	                    Break;
	                case 4:
						BoneName = HeadBone;
	                    Break;
	                default:
	                	BoneName = LeftThighBone;
	            }
	        }
		}

		if ( Health < 0 && Damage > DamageType.default.HumanObliterationThreshhold && 
			 Damage != 1000 && !class'GameInfo'.static.UseLowGore() )
			BoneName = 'obliterate';

		HitFX[HitFxTicker].bone = BoneName;
		HitFX[HitFxTicker].rotDir = FXRot;
		HitFxTicker = HitFxTicker + 1;
		if( HitFxTicker > ArrayCount(HitFX)-1 )
			HitFxTicker = 0;

		// If this was a really hardcore damage from an explosion, randomly spawn some arms and legs
		if ( bDidSever && !DamageType.default.bLocationalHit && Damage > 200 && Damage != 1000 && !class'GameInfo'.static.UseLowGore() )  {
			if ((Damage > 400 && FRand() < 0.3) || FRand() < 0.1 )  {
				DoDamageFX(HeadBone,1000,DamageType,FXRot);
				DoDamageFX(LeftThighBone,1000,DamageType,FXRot);
				DoDamageFX(RightThighBone,1000,DamageType,FXRot);
				DoDamageFX(LeftFArmBone,1000,DamageType,FXRot);
				DoDamageFX(RightFArmBone,1000,DamageType,FXRot);
			}
			
			if ( FRand() < 0.25 )  {
				DoDamageFX(LeftThighBone,1000,DamageType,FXRot);
				DoDamageFX(RightThighBone,1000,DamageType,FXRot);
				if ( FRand() < 0.5 )
					DoDamageFX(LeftFArmBone,1000,DamageType,FXRot);
				else
					DoDamageFX(RightFArmBone,1000,DamageType,FXRot);
			}
			else if ( FRand() < 0.35 )
				DoDamageFX(LeftThighBone,1000,DamageType,FXRot);
			else if ( FRand() < 0.5 )
				DoDamageFX(RightThighBone,1000,DamageType,FXRot);
			else if ( FRand() < 0.75 )  {
				if ( FRand() < 0.5 )
					DoDamageFX(LeftFArmBone,1000,DamageType,FXRot);
				else
					DoDamageFX(RightFArmBone,1000,DamageType,FXRot);
			}
		}
	}
}

// Overridden so that anims don't get interrupted on the server if one is already playing
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	local	vector	HeadLoc, B, M, diff;
	local	float	t, DotMM, Distance;
	local	int		look;
	local	bool	bUseAltHeadShotLocation;

	if ( bDecapitated || HeadBone == '' )
		Return False;

	// If we are a dedicated server estimate what animation is most likely playing on the client
	if ( Level.NetMode == NM_DedicatedServer && !IsAnimating(MainAnimChannel) && !IsAnimating(MinorAnimChannel) )  {
		if ( Physics == PHYS_Falling )
			PlayAnim(AirAnims[0], 1.0, 0.0, MainAnimChannel);
		else if ( Physics == PHYS_Swimming )
			PlayAnim(SwimAnims[0], 1.0, 0.0, MainAnimChannel);
		else if ( Physics == PHYS_Walking )  {
			if ( bIsCrouched )
				PlayAnim(IdleCrouchAnim, 1.0, 0.0, MainAnimChannel);
			else
				bUseAltHeadShotLocation = True;
		}
		SetAnimFrame(0.5);
	}

	if ( bUseAltHeadShotLocation )  {
		HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
		AdditionalScale *= OnlineHeadshotScale;
	}
	else
		HeadLoc = GetBoneCoords(HeadHitPointName).Origin;
	
	// Headshot debugging
	if ( Role == ROLE_Authority )
		ServerHeadLocation = HeadLoc;

	// Express snipe trace line in terms of B + tM
	B = loc;
	M = ray * (2.0 * CollisionHeight + 2.0 * CollisionRadius);

	// Find Point-Line Squared Distance
	diff = HeadLoc - B;
	t = M Dot diff;
	if ( t > 0 )  {
		DotMM = M dot M;
		if ( t < DotMM )  {
			t = t / DotMM;
			diff = diff - (t * M);
		}
		else  {
			t = 1;
			diff -= M;
		}
	}
	else
		t = 0;

	Distance = Sqrt(diff Dot diff);

	Return Distance < (HeadRadius * HeadScale * AdditionalScale);
}

/* ToDo: ��裔�褪 蒡�珮����! ﾏ��� 鈞���褊�齏.
function bool IsHeadShot( vector Loc, vector Ray, float AdditionalScale )
{
	local	vector	TraceHitLoc, TraceHitNorm, TraceExtetnt;
	local	int		look;
	local	bool	bWasAnimating;
		
	if ( HeadBallisticCollision == None )
		Return False;
	
	// If we are a dedicated server estimate what animation is most likely playing on the client
	if ( Level.NetMode == NM_DedicatedServer )  {
		if ( Physics == PHYS_Falling )
			PlayAnim(AirAnims[0], 1.0, 0.0);
		else if ( Physics == PHYS_Walking )  {
			// Only play the idle anim if we're not already doing a different anim.
			// This prevents anims getting interrupted on the server and borking things up - Ramm
			if ( !IsAnimating(0) && !IsAnimating(1) )  {
				if ( bIsCrouched )
					PlayAnim(IdleCrouchAnim, 1.0, 0.0);
			}
			else
				bWasAnimating = True;

			if ( bDoTorsoTwist )  {
				SmoothViewYaw = Rotation.Yaw;
				SmoothViewPitch = ViewPitch;
				look = (256 * ViewPitch) & 65535;
				if ( look > 32768 )
					look -= 65536;
				SetTwistLook(0, look);
			}
		}
		else if ( Physics == PHYS_Swimming )
			PlayAnim(SwimAnims[0], 1.0, 0.0);

		if ( !bWasAnimating )
			SetAnimFrame(0.5);
	}
	
	Ray *= HeadBallisticCollision.GetCollisionVSize();
	if ( AdditionalScale > 1.0 )
		TraceExtetnt = vect(1.0, 1.0, 1.0) * AdditionalScale;
	
	// TraceThisActor returns True if did not hit this actor.
	Return !HeadBallisticCollision.TraceThisActor( TraceHitLoc, TraceHitNorm, (Loc + Ray), (Loc - Ray), TraceExtetnt );
}	*/

function RemoveHead()
{
	bDecapitated = True;
	DECAP = True;
	DecapTime = Level.TimeSeconds;
	Intelligence = BRAINS_Retarded; // Headless dumbasses!
	//Velocity = vect(0.0, 0.0, 0.0);
	AnimateHeadless();
	AdjustMovement();
	AmbientSound = MiscSound; // No more raspy breathin'...cuz he has no throat or mouth :S
	if ( UM_MonsterController(Controller) != None )
		UM_MonsterController(Controller).NotifyMonsterDecapitated();
	
	// Destroy HeadBallisticCollision
	if ( HeadBallisticCollision != None )  {
		HeadBallisticCollision.DisableCollision();
		HeadBallisticCollision.Destroy();
		HeadBallisticCollision = None;
	}
}

//[block] KnockDown
function PlayDecapitationKnockDown()
{
	bDecapitationPlayed = True;
	bPlayDecapitationKnockDown = False;
	bShotAnim = True;
	SetAnimAction(DecapitationAnim);
	
	// PlayHit times
	NextPainTime = Level.TimeSeconds + 0.1;
	NextPainAnimTime = Level.TimeSeconds + MinTimeBetweenPainAnims;
	NextPainSoundTime = Level.TimeSeconds + MinTimeBetweenPainSounds;
	
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = True;
	PlaySound(DecapitationSound, SLOT_Misc, 2.5, True, 600.0,, True);
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = LastDamagedByPlayer.default.bAcuteHearing;
}

function PlayKnockDown()
{
	bShotAnim = True;
	SetAnimAction(KnockDownAnim);
	
	// PlayHit times
	NextPainTime = Level.TimeSeconds + 0.1;
	NextPainAnimTime = Level.TimeSeconds + MinTimeBetweenPainAnims;
	
	if ( bDecapitated )
		Return; // Don't play HitSound if Decapitated
	
	NextPainSoundTime = Level.TimeSeconds + MinTimeBetweenPainSounds;
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = True;
	PlaySound(HitSound[0], SLOT_Pain, 2.0, True, 600.0,, True); // Louder hit sound
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = LastDamagedByPlayer.default.bAcuteHearing;
}

function SendToKnockDown()
{
	if ( UM_MonsterController(Controller) == None )
		Return;
	
	bKnockedDown = True;
	CumulativeDamage = 0; // Reset CumulativeDamage
	DisableMovement();
	if ( bDecapitated && bPlayDecapitationKnockDown )
		PlayDecapitationKnockDown();
	else
		PlayKnockDown();
	UM_MonsterController(Controller).GoToState('KnockedDown');
	GoToState('KnockedDown');
}

// High damage was taken, make em fall over.
function bool CheckForKnockDown( int Damage, class<DamageType> DamageType )
{
	Return Damage >= int(HealthMax * KnockedDownHealthPct) 
			|| CumulativeDamage >= int(HealthMax * KnockedDownHealthPct);
}

state KnockedDown
{
	function bool HitCanInterruptAction()
	{
		Return False;
	}
	
	function bool CanSpeedAdjust()
	{
		Return False;
	}
	
	function bool CanAttack(Actor A)
	{
		Return False;
	}
	
	function bool CanCorpseAttack(Actor A)
	{
		Return False;
	}
	
	function bool CanAttackDoor(KFDoorMover TargetDoor)
	{
		Return False;
	}
	
	function SendToKnockDown()
	{
		if ( UM_MonsterController(Controller) == None )
			Return;
		
		CumulativeDamage = 0; // Reset CumulativeDamage
		PlayKnockDown();
		UM_MonsterController(Controller).GoToState('KnockedDown', 'WaitForAnim');
	}
	
	event EndState()
	{
		bKnockedDown = False;
		EnableMovement();
	}
}
//[end] KnockDown

simulated function CalcHitLoc( Vector HitLoc, Vector HitRay, out Name BoneName, out float Dist )
{
	BoneName = GetClosestBone( HitLoc, HitRay, Dist );
}

// clear old function
function OldPlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, optional int HitIndex) { }

// Implemented in subclasses - return false if there is some action that we don't want the direction hit to interrupt
function bool HitCanInterruptAction()
{
	Return !bShotAnim;
}

//ToDo: issue #477
function bool CanPlayDirectionalHit(int Damage, class<DamageType> DamageType)
{
	Return Damage > 4;
}

function PlayDirectionalHit(Vector HitLoc)
{
	local	Vector	X,Y,Z, Dir;
	
	GetAxes(Rotation, X,Y,Z);
	HitLoc.Z = Location.Z;
	
	if ( VSizeSquared(Location - HitLoc) < 1.0 )
		Dir = vect(0, 0, 0);
	else
		Dir = -Normal(Location - HitLoc);

	// HitFront
	if ( Dir == vect(0, 0, 0) || Dir dot X > 0.7 )  {
		if ( LastDamagedBy != None && LastDamageAmount > 0 )  {
			bSTUNNED = StunsRemaining > 0 && (LastDamageAmount >= (0.5 * default.Health) ||
				 (VSizeSquared(LastDamagedBy.Location - Location) <= Square(MeleeRange * 2.0) && class<DamTypeMelee>(LastDamagedbyType) != None && KFPawn(LastDamagedBy) != None && LastDamageAmount > (default.Health * 0.1)));
			if ( bSTUNNED )  {
				SetAnimAction(HitAnims[NextHitAnimNum]);
				if ( Role == Role_Authority )
					NextHitAnimNum = Rand(ArrayCount(HitAnims));
				SetTimer(StunTime, false);
				--StunsRemaining;
			}
			else
				SetAnimAction(KFHitFront);
		}
	}
	// HitBack
	else if ( Dir dot X < -0.7 )
		SetAnimAction(KFHitBack);
	// HitRight
	else if ( Dir dot Y > 0 )
		SetAnimAction(KFHitRight);
	// HitLeft
	else
		SetAnimAction(KFHitLeft);
}

function PlayDecapitation()
{
	if ( bDecapitationPlayed )
		Return;
	
	bDecapitationPlayed = True;
	bPlayDecapitationKnockDown = False;
	// HitAnims
	bShotAnim = True;
	SetAnimAction(HitAnims[NextHitAnimNum]);
	NextHitAnimNum = Rand(ArrayCount(HitAnims));
	
	// PlayHit times
	NextPainTime = Level.TimeSeconds + 0.1;
	NextPainAnimTime = Level.TimeSeconds + MinTimeBetweenPainAnims;
	NextPainSoundTime = Level.TimeSeconds + MinTimeBetweenPainSounds;
	
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = True;
	PlaySound(DecapitationSound, SLOT_Misc, 2.5, True, 600.0,, True);
	// makes playercontroller hear much better
	if ( LastDamagedByPlayer != None )
		LastDamagedByPlayer.bAcuteHearing = LastDamagedByPlayer.default.bAcuteHearing;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	NextPainTime = Level.TimeSeconds + 0.1;
	// No anim if we're burning, we're already playing an anim
	if ( Level.TimeSeconds >= NextPainAnimTime && !bCrispified )  {
		NextPainAnimTime = Level.TimeSeconds + MinTimeBetweenPainAnims;
		if ( Damage > 4 && HitCanInterruptAction() )
			PlayDirectionalHit(HitLocation);
	}
	
	if ( !bDecapitated && DamageType.default.bDirectDamage && Level.TimeSeconds >= NextPainSoundTime )  {
		NextPainSoundTime = Level.TimeSeconds + MinTimeBetweenPainSounds;
		// makes playercontroller hear much better
		if ( DamageType.default.bDirectDamage && LastDamagedByPlayer != None )
			LastDamagedByPlayer.bAcuteHearing = True;
		PlaySound(HitSound[0], SLOT_Pain, 1.25,, 400.0);
		// makes playercontroller hear much better
		if ( LastDamagedByPlayer != None )
			LastDamagedByPlayer.bAcuteHearing = LastDamagedByPlayer.default.bAcuteHearing;
	}
}

// New Hit FX for Zombies!
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> DamageType, vector Momentum, optional int HitIdx )
{
	local	Name						HitBone;
	local	float						HitBoneDist;
	local	Vector						HitNormal, EffectsLocation;
	local	class<Effects>				DesiredEffect;
	local	class<Emitter>				DesiredEmitter;
	local	KFSteamStatsAndAchievements	KFSteamStats;

	if ( Damage < 1 || DamageType == None 
		|| (Level.NetMode == NM_Standalone && !bIsRelevant && !bPlayersCanSeeMe 
			 && LastDamagedByPlayer == None && PlayerController(Controller) == None) )
		Return;

	// Locational Hit
	if ( DamageType.default.bLocationalHit )  {
		// calc HitNormal
		if ( Momentum != Vect(0, 0, 0) )
			HitNormal = -Normal(Momentum);
		else if ( InstigatedBy != None )
			HitNormal = Normal((InstigatedBy.Location + vect(0,0,1) * InstigatedBy.EyeHeight) - HitLocation);
		else
			HitNormal = Normal(HitLocation - Location);
		// Blood hit effects
		if ( EffectIsRelevant(HitLocation, True) )  {
			// Spawn any preset Effect
			EffectsLocation = HitLocation + CollisionRadius * 0.25 * HitNormal;
			DesiredEffect = DamageType.static.GetPawnDamageEffect(HitLocation, Damage, Momentum, self, (Level.bDropDetail || Level.DetailMode == DM_Low));
			if ( DesiredEffect != None )
				Spawn(DesiredEffect, self,, EffectsLocation, rotator(-HitNormal));
			// Spawn any preset emitter
			if ( !bZapped )  {
				DesiredEmitter = DamageType.Static.GetPawnDamageEmitter(HitLocation, Damage, Momentum, self, (Level.bDropDetail || Level.DetailMode == DM_Low));
				if ( DesiredEmitter != None )
					Spawn(DesiredEmitter, self,, EffectsLocation, rotator(HitNormal));
			}
			// Do a zapped effect is someone shoots us and we're zapped to help show that the zed is taking more damage
			else if ( DamageType.name != 'DamTypeZEDGun' )  {
				PlaySound(class'ZedGunProjectile'.default.ExplosionSound,, class'ZedGunProjectile'.default.ExplosionSoundVolume);
				Spawn(class'ZedGunProjectile'.default.ExplosionEmitter,self,, EffectsLocation, rotator(HitNormal));
			}
			// Spawn BloodSplat Projectile
			if ( DamageType.Default.bCausesBlood && !class'GameInfo'.static.NoBlood() 
				 && !class'GameInfo'.static.UseLowGore() 
				 && (Level.TimeSeconds > NextPainTime || FRand() > 0.8) )
				Spawn(ProjectileBloodSplatClass, InstigatedBy,, EffectsLocation, rotator(-HitNormal));
		}
		// Find hit bone
		CalcHitLoc( HitLocation, -HitNormal, HitBone, HitBoneDist );
	}
	else  {
		HitLocation = Location;
		HitBone = FireRootBone;
	}
	
	if ( Health < 1 )  {
		// Destructive Volume
		if ( PhysicsVolume.bDestructive && PhysicsVolume.ExitActor != None )
			Spawn(PhysicsVolume.ExitActor);
		// KFSteamStatsAndAchievements
		KFSteamStats = KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements);
		if ( KFSteamStats != None && Damage >= DamageType.default.HumanObliterationThreshhold && Damage != 1000 
			 && (!bDecapitated || bPlayBrainSplash) )  {
			KFSteamStats.AddGibKill(class<DamTypeM79Grenade>(DamageType) != None);
			// AddFleshpoundGibKill
			if ( IsA('UM_BaseMonster_FleshPound') )
				KFSteamStats.AddFleshpoundGibKill();
		}
	}
	else  {
		if ( (bDecapitated && bPlayDecapitationKnockDown) || (bCanBeKnockedDown && CheckForKnockDown(Damage, DamageType)) )
			SendToKnockDown();
		else if ( bDecapitated && !bDecapitationPlayed )
			PlayDecapitation();
		else if ( Level.TimeSeconds >= NextPainTime )
			PlayTakeHit(HitLocation, Damage, DamageType);
	}
	
	if ( DamageType.default.bAlwaysSevers && DamageType.default.bSpecial )
		HitBone = HeadBone;

	DoDamageFX( HitBone, Damage, DamageType, rotator(HitNormal) );

	if ( DamageType.default.DamageOverlayMaterial != None && Damage > 0 ) // additional check in case shield absorbed
		SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, false );
}

function AddCumulativeDamage(int NewDamage)
{
	if ( NewDamage < 1 )
		Return;
	
	if ( !bResetCumulativeDamage )  {
		CumulativeDamageResetTime = Level.TimeSeconds + CumulativeDamageDuration;
		bResetCumulativeDamage = True;
	}
	
	CumulativeDamage += NewDamage;
}

// Use this function to modify taken damage in subclasses
function int AdjustTakenDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, bool bIsHeadShot )
{
	Return Damage;
}

// Process the damaging and Return the amount of taken damage
function int ProcessTakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType )
{
	local	bool						bIsHeadShot;
	local	Controller					Killer;
	local	KFPlayerReplicationInfo		KFPRI;
	local	KFSteamStatsAndAchievements	KFSteamStats;
	
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
	
	Momentum = Momentum / Mass * FMin(float(Damage) / float(Health), 1.0);
	
	if ( HitLocation == vect(0, 0, 0) )
		HitLocation = Location;
	
	//[block] Damage modifiers
	// Scale damage if the Zed has been zapped
	if ( bZapped )
		Damage = Round( float(Damage) * ZappedDamageMod );
		
	// Owner takes damage while holding this weapon - used by shield gun
	if ( Weapon != None )
		Weapon.AdjustPlayerDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	
	// Modify Damage if Pawn is driving a vehicle
	if ( DrivenVehicle != None )
		DrivenVehicle.AdjustDriverDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
	
	if ( InstigatedBy != None )  {
		if ( InstigatedBy.HasUDamage() )
			Damage *= 2;
		KFPRI = KFPlayerReplicationInfo(InstigatedBy.PlayerReplicationInfo);
	}
	
	// Check for headshot
	if ( !bDecapitated && class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.bCheckForHeadShots && class<DamTypeBurned>(DamageType) == None )  {
		// Do larger headshot checks if it is a melee attach
		if ( class<DamTypeMelee>(DamageType) != None )
			bIsHeadShot = IsHeadShot(HitLocation, normal(Momentum), 1.25);
		else
			bIsHeadShot = IsHeadShot(HitLocation, normal(Momentum), 1.0);
		
		if ( bIsHeadShot )  {
			if ( class<DamTypeMelee>(DamageType) == None && KFPRI != None &&
				 KFPRI.ClientVeteranSkill != None )
				Damage = Round( float(Damage) * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult * KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(InstigatedBy), DamageType) );
			else
				Damage = Round( float(Damage) * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult );
		}
	}
	
	// Scale damage by VeteranSkill
	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None )
		Damage = KFPRI.ClientVeteranSkill.static.AddDamage(KFPRI, self, KFPawn(InstigatedBy), Damage, DamageType);
	
	// ReduceDamage
	if ( Level.Game != None )
		Damage = Level.Game.ReduceDamage(Damage, self, InstigatedBy, HitLocation, Momentum, DamageType);
	
	//ToDo: issue #204
	// if ( Armor != None )
		//ArmorAbsorbDamage( Damage, InstigatedBy, Momentum, DamageType );
	if ( DamageType.default.bArmorStops )
		Damage = ShieldAbsorb( Damage );
	
	Damage = AdjustTakenDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, bIsHeadShot);
	//[end]
	
	// Just Return if this wouldn't even damage us.
	if ( Damage < 1 )
		Return 0;
	
	if ( !bDecapitated && bIsHeadShot )  {
		PlaySound(HeadHitSound, SLOT_None, 1.3, True, 500, , True); // HeadShot Sound
		// Calc Head damage
		HeadHealth = Max( (HeadHealth - Damage), 0 );
		// Decapitate
		if ( HeadHealth < 1 || Damage >= Health )  {
			RemoveHead();
			// Head explodes, causing additional hurty.
			Damage += Damage + int(HealthMax * 0.25);
			// Bonuses
			if ( UM_HumanPawn(InstigatedBy) != None )  {
				// SlowMoCharge
				UM_HumanPawn(InstigatedBy).AddSlowMoCharge( HeadShotSlowMoChargeBonus );
				// ImpressiveKill
				if ( UM_BaseGameInfo(Level.Game) != None && Damage >= Health )
					UM_BaseGameInfo(Level.Game).CheckForImpressiveKill( UM_PlayerController(InstigatedBy.Controller), Self );
			}
			// Award headshot here, not when zombie died.
			KFSteamStats = KFSteamStatsAndAchievements(PlayerController(InstigatedBy.Controller).SteamStatsAndAchievements);
			if ( KFSteamStats != None )  {
				bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(InstigatedBy.Weapon) != None && M14EBRBattleRifle(InstigatedBy.Weapon).bLaserActive;
				// ScoredHeadshot
				Class<KFWeaponDamageType>(DamageType).Static.ScoredHeadshot( KFSteamStats, Class, bLaserSightedEBRM14Headshotted );
				if ( bIsTakingBurnDamage )
					KFSteamStats.AddBurningDecapKill( class'KFGameType'.static.GetCurrentMapName(Level) );
			}
		}
	}
	
	AddCumulativeDamage(Damage);
	// Last Damage
	LastDamageAmount = Damage;
	LastDamagedBy = InstigatedBy;
	LastDamagedByPlayer = PlayerController(InstigatedBy.Controller);
	LastDamagedByType = DamageType;
	LastHitLocation = HitLocation;
	LastMomentum = Momentum;
	// Add KillAssistant
	if ( LastDamagedByPlayer != None && KFMonsterController(Controller) != None )
		KFMonsterController(Controller).AddKillAssistant( LastDamagedByPlayer, FMin(Health, LastDamageAmount) );
	
	Health = Max( (Health - Damage), 0 );
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
		
		// KilledShouldExplode
		if ( KFPRI != None && KFPRI.ClientVeteranSkill != None && KFPRI.ClientVeteranSkill.static.KilledShouldExplode(KFPRI, KFPawn(InstigatedBy)) )
			HurtRadius( 500.0, 1000.0, class'DamTypeFrag', 100000.0, Location );
		
		Died( Killer, DamageType, HitLocation );
	}
	// Paw has lost some Health
	else  {
		// Decapitated BleedOutTime
		if ( bDecapitated && !bBleedOut )  {
			bBleedOut = True;
			BleedOutTime = Level.TimeSeconds + BleedOutDuration;
		}
		AddVelocity( Momentum );
		if ( Controller != None )
			Controller.NotifyTakeHit( InstigatedBy, HitLocation, Damage, DamageType, Momentum );
		if ( InstigatedBy != None && InstigatedBy != self )
			LastHitBy = InstigatedBy.Controller;
	}
	MakeNoise(1.0);
	bBackstabbed = False;
	
	Return Damage;
}

event TakeDamage( int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	// GodMode
	if ( Role < ROLE_Authority || Damage < 1 || (Controller != None && Controller.bGodMode) )
		Return;

	// Fire damage
	if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) != None || class<UM_BaseDamType_Flame>(DamageType) != None || (class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.bDealBurningDamage) )  {
		if ( !bIsTakingBurnDamage || Damage > LastBurnDamage )  {
			LastBurnDamage = Damage;
			if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) != None ||
				 class<UM_BaseDamType_Flame>(DamageType) != None || class<DamTypeTrenchgun>(DamageType) != None || class<DamTypeFlareRevolver>(DamageType) != None || class<DamTypeMAC10MPInc>(DamageType) != None )
				LastBurnDamageType = DamageType;
			else
				LastBurnDamageType = class'DamTypeFlamethrower';
		}
		
		if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) == None )
			Damage = float(Damage) * 1.5; // Increase burn damage 1.5 times, except all Incendiary Bullets.
		
		if ( Damage >= 15 )
			HeatAmount = 4;
		else
			++HeatAmount;
		
		// if enough Heat
		if ( HeatAmount > 3 )  {
			BurnInstigator = InstigatedBy;
			SetBurning(True);
		}
	}

	// Same rules apply to zombies as players.
	if ( class<DamTypeVomit>(DamageType) != None )  {
		BileCountDown = 6;
		LastBileDamage = Round(float(Damage) * 0.65);
		BileInstigator = InstigatedBy;
		LastBileDamageType = DamageType;
		bIsTakingBileDamage = True;
		if ( Level.TimeSeconds >= NextBileDamageTime )
			NextBileDamageTime = Level.TimeSeconds + BileDamageDelay;
	}

	ProcessTakeDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
}

function TakeFireDamage( int Damage, Pawn FireDamageInstigator ) { }

simulated event Timer()
{
	// bSTUNNED variable actually indicates flinching, not stunning! So don't get confused.
	bSTUNNED = False;
	SetTimer(0.0, False);  // Disable timer
}

function PushAwayZombie(Vector NewVelocity)
{
	AddVelocity(NewVelocity);
	bNoJumpAdjust = True;
	if ( Controller != None )
		Controller.SetFall();
}

function Dazzle(float TimeScale)
{
	AnimEnd(1);
	bShotAnim = True;
	SetAnimAction('KnockDown');
	//bNoJumpAdjust = True;
	Acceleration = vect(0, 0, 0);
	Velocity.X = 0;
	Velocity.Y = 0;
	if ( Controller != None && UM_MonsterController(Controller) != None
			&& !Controller.IsInState('IamDazzled') )
		Controller.GoToState('IamDazzled');
	UM_MonsterController(Controller).bUseFreezeHack = True;
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bAllowRespawnIfLost=True
	 RelevanceCheckDelay=0.5
	 SpeedAdjustCheckDelay=0.5
	 PlayersSeenCheckDelay=2.0
	 HeadHitPointName="HitPoint_Head"
	 HeadHitSound=sound'KF_EnemyGlobalSndTwo.Impact_Skull'
	 //MoanSound
	 MoanVolume=1.5
	 MoanRadius=300.0
	 MoanPitchRange=(Min=0.95,Max=1.05)
	 
	 CumulativeDamageDuration=0.05
	 
	 Intelligence=BRAINS_Mammal
	 
	 ImpressiveKillChance=0.03
	 ImpressiveKillDuration=4.0
	 
	 KilledWaveCountDownExtensionTime=4.0
	 
	 HealthMax=150.0
	 Health=150
	 HeadHealth=25.0
	 
	 HeadShotSlowMoChargeBonus=0.2
	 AshenSkin=Combiner'PatchTex.Common.BurnSkinEmbers_cmb'
	 //BileDamage
	 BileDamageDelay=1.0
	 //BurnDamage
	 BurningAmbientSound=Sound'Amb_Destruction.Krasnyi_Fire_House02'
	 BurnDamageDelay=1.0
	 //ZedGun Zapped
	 ZapDuration=4.000000
	 ZappedSpeedMod=0.500000
	 ZapThreshold=0.250000
	 ZappedDamageMod=2.000000
	 ZapResistanceScale=2.000000
	 // Falling
	 FallingDamageType=Class'Fell'
	 LavaDamageType=Class'FellLava'
	 // SoundsPitchRange
	 SoundsPitchRange=(Min=0.9,Max=1.1)
	 PlayerCountHealthScale=0.1
	 PlayerNumHeadHealthScale=0.1
	 MassScaleRange=(Min=0.95,Max=1.05)
	 // Monster Size
	 SizeScaleRange=(Min=0.85,Max=1.15)
	 // Extra Sizes
	 ExtraSizeChance=0.150000
	 ExtraSizeScaleRange=(Min=0.6,Max=1.3)
	 // Monster Speed
	 SpeedScaleRange=(Min=0.9,Max=1.1)
	 // Extra Speed
	 AlphaSpeedChance=0.2
	 AlphaSpeedScaleRange=(Min=1.2,Max=2.0)
	 // Monster Health
	 HealthScaleRange=(Min=0.9,Max=1.1)
	 // Extra Health
	 AlphaHealthChance=0.2
	 AlphaHealthScaleRange=(Min=1.2,Max=2.0)
	 // Monster HeadHealth
	 HeadHealthScaleRange=(Min=0.92,Max=1.08)
	 
	 // Movement
	 GroundSpeed=140.0  // The maximum ground speed.
	 HiddenGroundSpeed=300.0  // The maximum ground speed when monster is hidden from the players.
	 WaterSpeed=120.0  // The maximum swimming speed.
	 AirSpeed=300.0  // The maximum flying speed.
	 LadderSpeed=80.0  // Ladder climbing speed
	 // JumpZ
	 JumpZ=320.0  // Vertical acceleration when jump
	 JumpSpeed=180.0  // Horizontal acceleration when jump
	 JumpScaleRange=(Min=1.0,Max=1.2)  // Random jump acceleration scale range
	 AirControl=0.2  // Amount of AirControl available to the pawn
	 WalkingPct=1.0  // pct. of running speed that walking speed is
	 CrouchedPct=1.0  // pct. of running speed that crouched walking speed is
	 SprintPct=1.5  // Relative speed for sprint movement
	 MaxFallSpeed=2000.0  // max speed pawn can land without taking damage (also limits what paths AI can use)
	 
	 // MeleeRange
	 MeleeRangeScale=(Min=0.95,Max=1.05)
	 // DamageScale
	 DamageScaleRange=(Min=0.9,Max=1.1)
	 bPhysicsAnimUpdate=True
	 bDoTorsoTwist=True
	 // Mesh Sockets attached to bones
	 HeadBone="head"
	 NeckBone="neck"
	 LeftShoulderBone="lshoulder"
	 RightShoulderBone="rshoulder"
	 LeftArmBone="larm"
	 RightArmBone="rarm"
	 LeftFArmBone="lfarm"
	 RightFArmBone="rfarm"
	 LeftHandBone="lefthand"
	 RightHandBone="righthand"
	 LeftLegBone="lleg"
	 RightLegBone="rleg"
	 LeftThighBone="lthigh"
	 RightThighBone="rthigh"
	 LeftFootBone="lfoot"
	 RightFootBone="rfoot"
	 
	 // Bone Names
	 RootBone="CHR_Pelvis"
	 FireRootBone="CHR_Spine1"
	 SpineBone1="CHR_Spine2"
	 SpineBone2="CHR_Spine3"
	 // MinTimeBetweenPain
	 MinTimeBetweenPainSounds=0.350000
	 MinTimeBetweenPainAnims=0.500000
	 // KnockDownAnim
	 bCanBeKnockedDown=True
	 KnockDownAnim="KnockDown"
	 KnockedDownHealthPct=0.65
	 // DecapitationAnim
	 //DecapitationAnim="HeadLoss"
	 //bPlayDecapitationKnockDown=True
	 // DoorBash
	 DoorBashAnim="DoorBash"
	 // MeleeAnims
	 MeleeAnims(0)="Claw"
	 MeleeAnims(1)="Claw2"
	 MeleeAnims(2)="Claw3"
	 // HitAnims
	 HitAnims(0)="HitF"
	 HitAnims(1)="HitF2"
	 HitAnims(2)="HitF3"
	 KFHitFront="HitReactionF"
	 KFHitBack="HitReactionB"
	 KFHitLeft="HitReactionL"
	 KFHitRight="HitReactionR"
	 // MovementAnims
	 MovementAnims(0)="RunF"
	 MovementAnims(1)="RunB"
	 MovementAnims(2)="RunL"
	 MovementAnims(3)="RunR"
	 TurnLeftAnim="TurnLeft"
	 TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="WalkF"
	 WalkAnims(1)="WalkB"
	 WalkAnims(2)="WalkL"
	 WalkAnims(3)="WalkR"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Headless"
	 HeadlessWalkAnims(1)="WalkB_Headless"
	 HeadlessWalkAnims(2)="WalkL_Headless"
	 HeadlessWalkAnims(3)="WalkR_Headless"
	 // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
	 BurningWalkFAnims(1)="WalkF_Fire"
	 BurningWalkFAnims(2)="WalkF_Fire"
	 // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
	 BurningWalkAnims(1)="WalkL_Fire"
	 BurningWalkAnims(2)="WalkR_Fire"
	 // CrouchAnims
	 CrouchAnims(0)="Crouch"
	 CrouchAnims(1)="Crouch"
	 CrouchAnims(2)="Crouch"
	 CrouchAnims(3)="Crouch"
	 // SwimAnims
	 SwimAnims(0)="SwimF"
	 SwimAnims(1)="SwimB"
	 SwimAnims(2)="SwimL"
	 SwimAnims(3)="SwimR"
	 // AirAnims
	 AirAnims(0)="InAir"
	 AirAnims(1)="InAir"
	 AirAnims(2)="InAir"
	 AirAnims(3)="InAir"
	 AirStillAnim="InAir"
	 // TakeoffAnims
	 TakeoffAnims(0)="Jump"
	 TakeoffAnims(1)="Jump"
	 TakeoffAnims(2)="Jump"
	 TakeoffAnims(3)="Jump"
	 TakeoffStillAnim="Jump"
	 // LandAnims
	 LandAnims(0)="Landed"
	 LandAnims(1)="Landed"
	 LandAnims(2)="Landed"
	 LandAnims(3)="Landed"
	 // DoubleJumpAnims
	 DoubleJumpAnims(0)="Jump"
	 DoubleJumpAnims(1)="Jump"
	 DoubleJumpAnims(2)="Jump"
	 DoubleJumpAnims(3)="Jump"
	 // DodgeAnims
	 DodgeAnims(0)="DodgeF"
	 DodgeAnims(1)="DodgeB"
	 DodgeAnims(2)="DodgeL"
	 DodgeAnims(3)="DodgeR"
	 // IdleAnim
	 HeadlessIdleAnim="Idle_Headless"
	 IdleHeavyAnim="Idle_LargeZombie"
	 IdleRifleAnim="Idle_LargeZombie"
	 IdleCrouchAnim="Idle_LargeZombie"
	 IdleWeaponAnim="Idle_LargeZombie"
	 IdleRestAnim="Idle_LargeZombie"
	 // FireAnim
	 FireHeavyRapidAnim="MeleeAttack"
	 FireHeavyBurstAnim="MeleeAttack"
	 FireRifleRapidAnim="MeleeAttack"
	 FireRifleBurstAnim="MeleeAttack"
	 // ZombieDamType
	 ZombieDamType(0)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ZombieDamType(1)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ZombieDamType(2)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ControllerClass=Class'UnlimaginMod.UM_MonsterController'
	 // Collision flags
	 //SurfaceType=EST_Flesh
	 bCollideActors=True
	 bCollideWorld=True
	 bBlockActors=True
	 bUseCylinderCollision=True
	 // This collision flags was moved to the BallisticCollision
	 bBlockProjectiles=False
	 bProjTarget=False
	 bBlockZeroExtentTraces=True
	 bBlockNonZeroExtentTraces=True
	 
	 DrawScale=1.000000
	 //MeshTestCollisionHeight=50.0
	 //MeshTestCollisionRadius=25.0
	 CollisionHeight=50.0
	 CollisionRadius=25.0
	 CrouchHeight=32.0
	 CrouchRadius=25.0
	 
	 PrePivot=(X=0.0,Y=0.0,Z=0.0)
	 
	 Mass=200.0
}