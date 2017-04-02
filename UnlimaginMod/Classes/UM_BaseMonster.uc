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

// Falling
var		class<DamageType>				FallingDamageType;
var		class<DamageType>				LavaDamageType;

var					bool				bRandomSizeAdjusted, bThisIsMiniBoss;

var					range				MassScaleRange;
var					range				SoundsPitchRange;
//	Monster Size
var					float				ExtraSizeChance;
var					range				SizeScaleRange, ExtraSizeScaleRange;
// Monster Speed
var					float				ExtraSpeedChance;
var					range				SpeedScaleRange, ExtraSpeedScaleRange;
// Monster Health
var					float				ExtraHealthChance;
var					range				HealthScaleRange, ExtraHealthScaleRange;
var					range				HeadHealthScaleRange, ExtraHeadHealthScaleRange;
// Monster Jump ZAxis height scale
var					range				JumpZScaleRange;
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
var		name							HeadHitPointName;

var		float							HeadShotSlowMoChargeBonus;

var		transient	bool				bAddedToMonsterList;

var					float				ImpressiveKillChance;
var					float				ImpressiveKillDuration;

var		transient	float				LastSeenCheckTime;

// Headshot debugging
var					vector              ServerHeadLocation;     // The location of the Zed's head on the server, used for debugging
var					vector              LastServerHeadLocation;

// Animation
var		transient	bool				bHeadlessWalkingAnimated;

// Replicates next rand num for animation array index
var					byte				NextWalkAnimNum;
var					byte				NextBurningWalkAnimNum;
var					byte				NextTauntAnimNum;
var					byte				NextMeleeAnimNum;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bThisIsMiniBoss;
	
	reliable if ( Role == ROLE_Authority && bNetDirty )
		NextWalkAnimNum, NextBurningWalkAnimNum, NextMeleeAnimNum, NextTauntAnimNum;
	
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
	
	RandomSizeMult = BaseActor.static.GetExtraRandRangeFloat( SizeScaleRange, ExtraSizeChance, ExtraSizeScaleRange );
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
	
	RandomSizeMult = BaseActor.static.GetExtraRandRangeFloat( SizeScaleRange, ExtraSizeChance, ExtraSizeScaleRange );
	
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
	// SoundPitch
	SoundPitch = default.SoundPitch / RandomSizeMult * BaseActor.static.GetRandPitch( SoundsPitchRange );
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
	
	if ( Physics == PHYS_Walking || ((Physics == PHYS_Ladder || Physics == PHYS_Spider) && NewVelocity.Z > Default.JumpZ) )
		SetPhysics(PHYS_Falling);
	
	if ( Velocity.Z > 380.0 && NewVelocity.Z > 0.0 )
		NewVelocity.Z *= 0.5;
	
	Velocity += NewVelocity;
}

event PreBeginPlay()
{
	LastSeenCheckTime = Level.TimeSeconds;
	AdditionalWalkAnims[AdditionalWalkAnims.length] = default.MovementAnims[0];
	/*
	if ( !bRandomSizeAdjusted )
		RandomizeMonsterSizes();
	*/
	Super.PreBeginPlay();
}

function bool NotRelevantMoreThan( float NotSeenTime )
{
	Return (Level.TimeSeconds - LastSeenCheckTime) > NotSeenTime && (Level.TimeSeconds - LastSeenOrRelevantTime) > NotSeenTime;
}

// Rand next anim nums on the server
function ServerRandAnims()
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
}

simulated event PostBeginPlay()
{
	local	float	RandMult;
	local	float	MovementSpeedDifficultyScale;
	
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
		ServerRandAnims();
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
		
		// Difficulty Scaling
		if ( !bDiffAdjusted && Level.Game != None )  {
			//log(self$" Beginning ground speed "$default.GroundSpeed);
			if ( Level.Game.NumPlayers <= 3 )
				HiddenGroundSpeed = default.HiddenGroundSpeed;
			else if ( Level.Game.NumPlayers <= 5 )
				HiddenGroundSpeed = default.HiddenGroundSpeed * 1.3;
			else if ( Level.Game.NumPlayers >= 6 )
				HiddenGroundSpeed = default.HiddenGroundSpeed * 1.65;

			if( Level.Game.GameDifficulty < 2.0 )
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
				CurrentDamType = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
			
			//[block] Speed Randomization
			AirSpeed *= MovementSpeedDifficultyScale;
			RandMult = BaseActor.static.GetExtraRandRangeFloat( SpeedScaleRange, ExtraSpeedChance, ExtraSpeedScaleRange );
			if ( RandMult > SpeedScaleRange.Max )
				bThisIsMiniBoss = True;
			GroundSpeed *= MovementSpeedDifficultyScale * RandMult;
			WaterSpeed *= MovementSpeedDifficultyScale * RandMult;
			// Store the difficulty adjusted ground speed to restore if we change it elsewhere
			OriginalGroundSpeed = GroundSpeed;
			//log(self$" Scaled ground speed "$GroundSpeed$" Difficulty "$Level.Game.GameDifficulty$" MovementSpeedDifficultyScale "$MovementSpeedDifficultyScale);
			//[end]
			
			//[block] Healths Randomization
			// Health
			RandMult = BaseActor.static.GetExtraRandRangeFloat( HealthScaleRange, ExtraHealthChance, ExtraHealthScaleRange );
			Health = Round( float(default.Health) * DifficultyHealthModifer() * RandMult * NumPlayersHealthModifer() );
			HealthMax = float(Health);
			
			// HeadHealth
			if ( RandMult > HealthScaleRange.Max )  {
				bThisIsMiniBoss = True;
				RandMult = Lerp( FRand(), ExtraHeadHealthScaleRange.Min, ExtraHeadHealthScaleRange.Max );
			}
			else
				RandMult = Lerp( FRand(), HeadHealthScaleRange.Min, HeadHealthScaleRange.Max );

			HeadHealth = FMin( (default.HeadHealth * DifficultyHeadHealthModifer() * RandMult * NumPlayersHeadHealthModifer()), (HealthMax - 10.0) );
			//[end]
				
			//floats
			//RandMult = Lerp( FRand(), DamageScaleRange.Min, DamageScaleRange.Max );
			//SpinDamConst = FMax( (DifficultyDamageModifer() * default.SpinDamConst * RandMult), 1.0 );
			//SpinDamRand = FMax( (DifficultyDamageModifer() * default.SpinDamRand * RandMult), 1.0 );
			//JumpZ = default.JumpZ * DrawScale * Lerp( FRand(), JumpZScaleRange.Min, JumpZScaleRange.Max );
			JumpZ = default.JumpZ * Lerp( FRand(), JumpZScaleRange.Min, JumpZScaleRange.Max );
			//int
			ScreamDamage = Max( Round(DifficultyDamageModifer() * default.ScreamDamage * Lerp(FRand(), DamageScaleRange.Min, DamageScaleRange.Max)), 1 );
			MeleeDamage = Max( Round(DifficultyDamageModifer() * default.MeleeDamage * Lerp(FRand(), DamageScaleRange.Min, DamageScaleRange.Max)), 1 );

			
			//log(self$" HealthMax "$HealthMax$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
			//log(self$" Health "$Health$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
			//log(self$" HeadHealth "$HeadHealth$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
			
			// ToDo: need to somehow distinguish a miniboss among other monsters
			/*
			if ( bThisIsMiniBoss )  {
				
			} */

			bDiffAdjusted = True;
		}
		
		/*
		// Landing to the Ground
		Move( Location + Vect(0.0, 0.0, 12.0) );
		SetPhysics(PHYS_Falling);
		*/
		
		if ( UM_InvasionGame(Level.Game) != None && !bAddedToMonsterList )
			bAddedToMonsterList = UM_InvasionGame(Level.Game).AddToMonsterList( self );
	}
}

simulated event PostNetBeginPlay()
{
	AnimateWalking();
	EnableChannelNotify(1, 1);
	AnimBlendParams(1, 1.0, 0.0, , SpineBone1);
	AnimBlendParams(1, 1.0, 0.0, , HeadBone);
	
	Super(Pawn).PostNetBeginPlay();
}

// Setters for extra collision cylinders
simulated function ToggleAuxCollision( bool NewbCollision )
{
	/*
	if ( !NewbCollision )  {
		SavedExtCollision = ExtendedCollision.bCollideActors;
		ExtendedCollision.SetCollision(False);
	}
	else
		ExtendedCollision.SetCollision(SavedExtCollision);
	*/
}

/*
simulated function PlayDyingAnimation( Class<DamageType> DamageType, Vector HitLoc )
{
	Super.PlayDyingAnimation(DamageType, HitLoc );
} */

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
	if ( Health > 0 )
		Suicide();
	
	DestroyBallisticCollision();
	
	Super.Destroyed();
}

// Scales the damage this Zed deals by the difficulty level
function float DifficultyDamageModifer()
{
	local float AdjustedDamageModifier;

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
	if ( Level.Game.NumPlayers == 1 )
		AdjustedDamageModifier *= 0.75;

	Return AdjustedDamageModifier;
}

// Scales the health this Zed has by the difficulty level
function float DifficultyHealthModifer()
{
	local float AdjustedModifier;

	if ( Level.Game.GameDifficulty >= 7.0 ) // Hell on Earth
		AdjustedModifier = 1.75;
	else if ( Level.Game.GameDifficulty >= 5.0 ) // Suicidal
		AdjustedModifier = 1.55;
	else if ( Level.Game.GameDifficulty >= 4.0 ) // Hard
		AdjustedModifier = 1.35;
	else if ( Level.Game.GameDifficulty >= 2.0 ) // Normal
		AdjustedModifier = 1.0;
	else //if ( GameDifficulty == 1.0 ) // Beginner
		AdjustedModifier = 0.5;

	Return AdjustedModifier;
}

// Scales the health this Zed has by number of players
function float NumPlayersHealthModifer()
{
	local float AdjustedModifier;
	local int NumEnemies;
	local Controller C;

	AdjustedModifier = 1.0;

	for ( C = Level.ControllerList; C != None; C = C.NextController )  {
		if( C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 )
			NumEnemies++;
	}

	if ( NumEnemies > 1 )
		AdjustedModifier += (Min(NumEnemies, 9) - 1) * PlayerCountHealthScale;

	Return AdjustedModifier;
}

// Scales the head health this Zed has by the difficulty level
function float DifficultyHeadHealthModifer()
{
	local float AdjustedModifier;

	if ( Level.Game.GameDifficulty >= 7.0 ) // Hell on Earth
		AdjustedModifier = 1.75;
	else if ( Level.Game.GameDifficulty >= 5.0 ) // Suicidal
		AdjustedModifier = 1.55;
	else if ( Level.Game.GameDifficulty >= 4.0 ) // Hard
		AdjustedModifier = 1.35;
	else if ( Level.Game.GameDifficulty >= 2.0 ) // Normal
		AdjustedModifier = 1.0;
	else //if ( GameDifficulty == 1.0 ) // Beginner
		AdjustedModifier = 0.5;

	Return AdjustedModifier;
}

// Scales the head health this Zed has by number of players
function float NumPlayersHeadHealthModifer()
{
	local float AdjustedModifier;
	local int NumEnemies;
	local Controller C;

	AdjustedModifier = 1.0;

	for( C = Level.ControllerList; C != None; C = C.NextController )  {
		if( C.bIsPlayer && C.Pawn != None && C.Pawn.Health > 0 )
			NumEnemies++;
	}

	if ( NumEnemies > 1 )
		AdjustedModifier += (Min(NumEnemies, 9) - 1) * PlayerNumHeadHealthScale;

	Return AdjustedModifier;
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

	GetAxes(Rotation, X,Y,Z);

	Super(Skaarj).Bump(Other);
	
	if ( Other == None )
		Return;

	if ( Other.IsA('NetKActor') && Physics != PHYS_Falling 
		 && Location.Z < (Other.Location.Z + CollisionHeight) 
		 && Location.Z > (Other.Location.Z - CollisionHeight * 0.5) 
		 && Base != Other && Base.bStatic 
		 && (Normal(X) dot Normal(Other.Location - Location)) >= 0.7 )  {
		if ( KActor(Other).KGetMass() >= 0.5 
			 && !MonsterController(Controller).CanAttack(Controller.Enemy) )  {
			// Store kick impact data
			ImpactVector = Vector(controller.Rotation)*15000 + (velocity * (Mass / 2) )  ;   // 30
			KickLocation = Other.Location;
			KickTarget = Other;
			
			if ( UM_MonsterController(Controller) != None )
				UM_MonsterController(Controller).KickTarget = KActor(Other);
			else if ( KFMonsterController(Controller) != None )
				KFMonsterController(Controller).KickTarget = KActor(Other);
			
			SetAnimAction(PuntAnim);
		}
	}
}

// Return True if we can do the Zombie speed adjust that gets the Zeds
// to the player faster if they can't be seen
function bool CanSpeedAdjust()
{
	Return !bDecapitated && !bZapped;
}

function StandaloneRelevantCheck()
{
	local	PlayerController	P;
	local	float				DistSquared;
	
	if ( (Level.TimeSeconds - LastRenderTime) > 5.0 )  {
		if ( (Level.TimeSeconds - LastViewCheckTime) > 1.0 )  {
			P = Level.GetLocalPlayerController();
			if ( P != None && P.Pawn != None )  {
				LastViewCheckTime = Level.TimeSeconds;
				DistSquared = VSizeSquared(P.Pawn.Location - Location);
				if ( (!P.Pawn.Region.Zone.bDistanceFog || (DistSquared < Square(P.Pawn.Region.Zone.DistanceFogEnd))) &&
					FastTrace((Location + EyePosition()), (P.Pawn.Location + P.Pawn.EyePosition())) )  {
					LastSeenOrRelevantTime = Level.TimeSeconds;
					SetGroundSpeed(GetOriginalGroundSpeed());
				}
				else
					SetGroundSpeed(default.GroundSpeed * (HiddenGroundSpeed / default.GroundSpeed));
			}
		}
	}
	else  {
		LastSeenOrRelevantTime = Level.TimeSeconds;
		SetGroundSpeed(GetOriginalGroundSpeed());
	}
}

function ListenServerRelevantCheck()
{
	local	PlayerController	P;
	local	float				DistSquared;
	
	if ( (Level.TimeSeconds - LastReplicateTime) > 0.5 && (Level.TimeSeconds - LastRenderTime) > 5.0 )  {
		if ( (Level.TimeSeconds - LastViewCheckTime) > 1.0 )  {
			P = Level.GetLocalPlayerController();
			if ( P != None && P.Pawn != None )  {
				LastViewCheckTime = Level.TimeSeconds;
				DistSquared = VSizeSquared(P.Pawn.Location - Location);
				if ( (!P.Pawn.Region.Zone.bDistanceFog || (DistSquared < Square(P.Pawn.Region.Zone.DistanceFogEnd))) &&
					FastTrace((Location + EyePosition()), (P.Pawn.Location + P.Pawn.EyePosition())) )  {
					LastSeenOrRelevantTime = Level.TimeSeconds;
					SetGroundSpeed(GetOriginalGroundSpeed());
				}
				else
					SetGroundSpeed(default.GroundSpeed * (300.0 / default.GroundSpeed));
			}
		}
	}
	else  {
		LastSeenOrRelevantTime = Level.TimeSeconds;
		SetGroundSpeed(GetOriginalGroundSpeed());
	}
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	local	int		i;
	
	// making attached SealSquealProjectile explode when this pawn dies
	for ( i = 0; i < Attached.Length; ++i )  {
		if ( SealSquealProjectile(Attached[i]) != None )
			SealSquealProjectile(Attached[i]).HandleBasePawnDestroyed();
	}
	DestroyBallisticCollision();
	
	Super(Pawn).Died( Killer, DamageType, HitLocation );
}

//[Block] Animation functions
simulated function AnimateWalking()
{
	local	byte	i;
	
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

simulated function AnimateBurningWalking()
{
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

simulated function AnimateHeadlessWalking()
{
	bHeadlessWalkingAnimated = True;
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
}


simulated event PlayJump();
simulated event PlayFalling();
simulated function PlayMoving();
simulated function PlayWaiting();

simulated event PlayLandingAnimation(float ImpactVel);

function PlayLanded(float impactVel)
{
	if ( !bPhysicsAnimUpdate )
		PlayLandingAnimation(impactvel);
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
	/*
	// this could have been responsible for making the zombies "lethargic" in wander state.
	// they should retain the same walk speed at all times. Comment from KFMonster.uc.
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
	local	PlayerController	pc;

	if ( MyExtCollision != None )
		MyExtCollision.Destroy();
	
	if ( Level.NetMode != NM_DedicatedServer )  {
		// Is this the local player's ragdoll?
		if ( OldController != None )
			pc = PlayerController(OldController);
		
		if ( pc != None && pc.ViewTarget == self )
			PlayersRagdoll = True;
		
		// Wait a tick on a listen server so the obliteration can replicate before the pawn is destroyed
		// For a listen server, use LastSeenOrRelevantTime instead of render time so
		// monsters don't disappear for other players that the host can't see - Ramm
		if ( Level.NetMode == NM_ListenServer && Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && ((Level.TimeSeconds - LastSeenOrRelevantTime) > 3.0 || bGibbed) )  {
			bDestroyNextTick = True;
			TimeSetDestroyNextTickTime = Level.TimeSeconds;
			Return;
		}
		else if ( Level.NetMode != NM_ListenServer && Level.PhysicsDetailLevel != PDL_High && !PlayersRagdoll && ((Level.TimeSeconds - LastRenderTime) > 3.0 || bGibbed) ) {
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
			StopAnimating(true);

			// StopAnimating() resets the neck bone rotation, we have to set it again
			// if the zed was decapitated the cute way
			if ( class'GameInfo'.static.UseLowGore() && NeckRot != rot(0,0,0) )
				SetBoneRotation('neck', NeckRot);

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

//Stops the green shit when a player dies.
simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
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
					GetAnimParams( 0, seq, frame, rate );
					LinkMesh(SkeletonMesh, true);
					Skins.Length = 0;
					PlayAnim(seq, 0, 0);
					SetAnimFrame(frame);
				}
				
				if ( Physics == PHYS_Walking )
					Velocity = Vect(0,0,0);
				
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
	AnimBlendParams(1, 0.0);
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
		AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
		PlayAnim(AnimName, , 0.1, 1);
		
		Return 1;
	}

	PlayAnim(AnimName, ,0.1, 0);
	
	Return 0;
}

simulated function bool AnimNeedsWait(name TestAnim)
{
	Return ExpectingChannel == 0;
}

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == '' )
		Return;
	
	if ( NewAction == 'Claw' )  {
		NewAction = meleeAnims[NextMeleeAnimNum];
		CurrentDamtype = ZombieDamType[NextMeleeAnimNum];
		// Rand NextMeleeAnimNum on the server
		if ( Role == ROLE_Authority )
			NextMeleeAnimNum = Rand(ArrayCount(meleeAnims));
	}
	else if ( NewAction == 'DoorBash' )
		CurrentDamtype = ZombieDamType[Rand(3)];
	
	ExpectingChannel = DoAnimAction(NewAction);
	bWaitForAnim = AnimNeedsWait(NewAction);
	
	/*
	if ( Level.NetMode != NM_Client )  {
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
	}	*/
}

simulated event AnimEnd(int Channel)
{
	AnimAction = '';
	if ( bShotAnim && Channel == ExpectingChannel )  {
		bShotAnim = False;
		if ( Controller != None )
			Controller.bPreparingMove = False;
	}
	
	if ( !bPhysicsAnimUpdate && Channel == 0 )
		bPhysicsAnimUpdate = Default.bPhysicsAnimUpdate;
	
	if ( Channel == 1 )  {
		if ( FireState == FS_Ready )  {
			AnimBlendToAlpha(1, 0.0, 0.12);
			FireState = FS_None;
		}
		else if ( FireState == FS_PlayOnce )  {
			PlayAnim(IdleWeaponAnim,, 0.2, 1);
			FireState = FS_Ready;
			IdleTime = Level.TimeSeconds;
		}
		else
			AnimBlendToAlpha(1, 0.0, 0.12);
	}
	else if ( bKeepTaunting && Channel == 0 )
		PlayVictoryAnimation();
}
//[End]

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
	if ( Role == Role_Authority )  {
		Intelligence = BRAINS_Retarded; // burning dumbasses!
		SetGroundSpeed(OriginalGroundSpeed * ZappedSpeedMod);
		AirSpeed *= ZappedSpeedMod;
		WaterSpeed *= ZappedSpeedMod;
		// Make them less accurate while they are burning
		if ( Controller != None )
		   MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's burning now, after all) :-D
	}
	// Set burning walk anim
	AnimateBurningWalking();
}

// Turn off the on-fire behavior
simulated function UnSetZappedBehavior()
{
	if ( Role == Role_Authority )  {
		Intelligence = default.Intelligence;
		if ( bBurnified )
			SetGroundSpeed(GetOriginalGroundSpeed() * 0.80);
		else
			SetGroundSpeed(GetOriginalGroundSpeed());
		AirSpeed = default.AirSpeed;
		WaterSpeed = default.WaterSpeed;
		// Set normal accuracy
		if ( Controller != None )
		   MonsterController(Controller).Accuracy = MonsterController(Controller).default.Accuracy;
	}
	// restore regular anims
	AnimateWalking();
}

// Set the zed to the on fire behavior
simulated function SetBurningBehavior()
{
	if ( Role == Role_Authority )  {
		Intelligence = BRAINS_Retarded; // burning dumbasses!
		SetGroundSpeed(OriginalGroundSpeed * 0.8);
		AirSpeed *= 0.8;
		WaterSpeed *= 0.8;

		// Make them less accurate while they are burning
		if ( Controller != None )
		   MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's burning now, after all) :-D
	}
	// Set burning walk anim
	AnimateBurningWalking();
}

simulated function StartBurnFX()
{
	local	class<emitter>	Effect;

	if ( bDeleteMe || bBurnApplied )
		Return;
	
	bBurnApplied = True;
	
	if ( Level.NetMode == NM_DedicatedServer )
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
	AttachEmitterEffect(Effect, HeadBone, Location, Rotation);
}

// Turn off the on-fire behavior
simulated function UnSetBurningBehavior()
{
	// Don't turn off this behavior until the harpoon stun is over
	if ( bHarpoonStunned )
		Return;

	if ( Role == Role_Authority )  {
		Intelligence = default.Intelligence;
		if ( !bZapped )  {
			SetGroundSpeed(GetOriginalGroundSpeed());
			AirSpeed = default.AirSpeed;
			WaterSpeed = default.WaterSpeed;
		}

		// Set normal accuracy
		if ( Controller != None )
		   MonsterController(Controller).Accuracy = MonsterController(Controller).default.Accuracy;
	}

	bAshen = False;
	// restore regular anims
	AnimateWalking();
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
}

simulated function StopBurnFX()
{
	UnSetBurningBehavior();
	if ( Level.NetMode != NM_DedicatedServer )  {
		RemoveFlamingEffects();
		if ( FlamingFXs != None )
			FlamingFXs.Kill();
	}
	bBurnApplied = False;
}

simulated event Tick( float DeltaTime )
{
	// If we've flagged this character to be destroyed next tick, handle that
	if ( bDestroyNextTick && TimeSetDestroyNextTickTime < Level.TimeSeconds )
		Destroy();
	
	// Make Zeds move faster if they aren't net relevant, or noone has seen them
	// in a while. This well get the Zeds to the player in larger groups, and
	// quicker - Ramm
	if ( Level.NetMode != NM_Client && CanSpeedAdjust() )  {
		if ( Level.NetMode == NM_Standalone )
			StandaloneRelevantCheck();
		else if ( Level.NetMode == NM_DedicatedServer )  {
			if ( Level.TimeSeconds - LastReplicateTime > 0.5 )
				SetGroundSpeed(default.GroundSpeed * (300.0 / default.GroundSpeed));
			else  {
				LastSeenOrRelevantTime = Level.TimeSeconds;
				SetGroundSpeed(GetOriginalGroundSpeed());
			}
		}
		else if ( Level.NetMode == NM_ListenServer )
			ListenServerRelevantCheck();
	}
	
	/*
	if ( bResetAnimAct && Level.TimeSeconds >= ResetAnimActTime )  {
		AnimAction = '';
		bResetAnimAct = False;
	}	*/
	
	if ( Controller != None )
		LookTarget = Controller.Enemy;
	
	// If the Zed has been bleeding long enough, make it die
	if ( Role == ROLE_Authority && bDecapitated && BleedOutTime > 0.0 && (Level.TimeSeconds - BleedOutTime) >= 0.0 )  {
		Died( LastDamagedBy.Controller, class'DamTypeBleedOut', Location );
		BleedOutTime = 0.0;
	}
	
	if ( bDecapitated && !bHeadlessWalkingAnimated )
		AnimateHeadlessWalking();
	
	//SPLATTER!!!!!!!!!
	//TODO - can we work this into Epic's gib code?
	//Will we see enough improvement in efficiency to be worth the effort?
	if ( Level.NetMode != NM_DedicatedServer )  {
		TickFX(DeltaTime);
		if ( !bBurnified && bBurnApplied )
			StopBurnFX();
		else if ( bBurnified && !bBurnApplied && !bGibbed )
			StartBurnFX();

		if ( bAshen && Level.NetMode == NM_Client && !class'GameInfo'.static.UseLowGore() )  {
			ZombieCrispUp();
			bAshen = False;
		}
	}
	
	if ( DECAP && Level.TimeSeconds > (DecapTime + 2.0) && Controller != None )  {
		DECAP = False;
		MonsterController(Controller).ExecuteWhatToDoNext();
	}
	
	if ( BileCount > 0 && NextBileTime < level.TimeSeconds )  {
		--BileCount;
		NextBileTime += BileFrequency;
		TakeBileDamage();
	}
	
	if ( bZapped && Role == ROLE_Authority )  {
		RemainingZap -= DeltaTime;
		if ( RemainingZap <= 0 )  {
			RemainingZap = 0;
			bZapped = False;
			ZappedBy = None;
			// The Zed can take more zap each time they get zapped
			ZapThreshold *= ZapResistanceScale;
		}
	}
	
	if ( !bZapped && TotalZap > 0 && (Level.TimeSeconds - LastZapTime) > 0.1 )
		TotalZap -= DeltaTime;
	
	if ( bZapped != bOldZapped )  {
		if ( bZapped )
			SetZappedBehavior();
		else
			UnSetZappedBehavior();

		bOldZapped = bZapped;
	}
	
	if ( bHarpoonStunned != bOldHarpoonStunned )  {
		if ( bHarpoonStunned )
			SetBurningBehavior();
		else
			UnSetBurningBehavior();

		bOldHarpoonStunned = bHarpoonStunned;
	}
}

// Actually execute the kick (this is notified in the ZombieKick animation)
function KickActor()
{
	KickTarget.Velocity.Z += (Mass * 5 + (KGetMass() * 10));
	KickTarget.KAddImpulse(ImpactVector, KickLocation);
	Acceleration = vect(0,0,0);
	Velocity = vect(0,0,0);
	if ( UM_MonsterController(Controller) != None )
		UM_MonsterController(controller).GotoState('Kicking');
	else if ( KFMonsterController(Controller) != None )
		KFMonsterController(controller).GotoState('Kicking');
	bShotAnim = True;
}

// High damage was taken, make em fall over.
function bool FlipOver()
{
	if ( Physics == PHYS_Falling )
		SetPhysics(PHYS_Walking);

	bShotAnim = True;
	SetAnimAction('KnockDown');
	Acceleration = vect(0, 0, 0);
	Velocity.X = 0;
	Velocity.Y = 0;
	Controller.GoToState('WaitForAnim');
	
	if ( UM_MonsterController(Controller) != None )
		UM_MonsterController(Controller).bUseFreezeHack = True;
	else if ( KFMonsterController(Controller) != None )
		KFMonsterController(Controller).bUseFreezeHack = True;
	
	Return True;
}

simulated function DoDamageFX( Name boneName, int Damage, class<DamageType> DamageType, Rotator r )
{
	local float DismemberProbability;
	local int RandBone;
	local bool bDidSever;

	//log("DamageFX bonename = "$boneName$" "$Level.TimeSeconds$" Damage "$Damage);

	if( bDecapitated && !bPlayBrainSplash )
	{
		if ( class<DamTypeMelee>(DamageType) != None &&
			 Class<Whisky_DamTypeHammerHeadShot>(DamageType) == None &&
			 Class<Whisky_DamTypeHammerSecondaryHeadShot>(DamageType) == None )
			HitFX[HitFxTicker].damtype = class'DamTypeMeleeDecapitation';
		else if( class<DamTypeNailGun>(DamageType) != None )
			HitFX[HitFxTicker].damtype = class'DamTypeProjectileDecap';
		else
			HitFX[HitFxTicker].damtype = class'DamTypeDecapitation';

		if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore()
			|| (Level.Game != None && Level.Game.PreventSever(self, boneName, Damage, DamageType)) )
			HitFX[HitFxTicker].bSever = False;
		else
			HitFX[HitFxTicker].bSever = True;

		HitFX[HitFxTicker].bone = HeadBone;
		HitFX[HitFxTicker].rotDir = r;
		HitFxTicker = HitFxTicker + 1;
		
		if( HitFxTicker > ArrayCount(HitFX)-1 )
			HitFxTicker = 0;

		bPlayBrainSplash = True;

		if ( Damage <= DamageType.default.HumanObliterationThreshhold && Damage == 1000 )
			Return;
	}

	if ( FRand() > 0.3f || Damage > 30 || Health <= 0 /*|| DamageType == class 'DamTypeCrossbowHeadshot'*/)
	{
		HitFX[HitFxTicker].damtype = DamageType;

		if( Health <= 0 /*|| DamageType == class 'DamTypeCrossbowHeadshot'*/)
		{
			switch( boneName )
			{
				case 'neck':
					boneName = HeadBone;
					Break;

				case LeftFootBone:
				case 'lleg':
					boneName = LeftThighBone;
					Break;

				case RightFootBone:
				case 'rleg':
					boneName = RightThighBone;
					Break;

				case RightHandBone:
				case RightShoulderBone:
				case 'rarm':
					boneName = RightFArmBone;
					Break;

				case LeftHandBone:
				case LeftShoulderBone:
				case 'larm':
					boneName = LeftFArmBone;
					Break;

				case 'None':
				case 'spine':
					boneName = FireRootBone;
					Break;
			}

			if ( DamageType.default.bAlwaysSevers || Damage == 1000 )  {
				HitFX[HitFxTicker].bSever = True;
				bDidSever = True;
				if ( boneName == 'None' )
					boneName = FireRootBone;
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
			 || (Level.Game != None && Level.Game.PreventSever(self, boneName, Damage, DamageType)) )  {
			HitFX[HitFxTicker].bSever = False;
			bDidSever = False;
		}

		if ( HitFX[HitFxTicker].bSever )  {
	        if ( !DamageType.default.bLocationalHit && 
				 (boneName == 'None' || boneName == FireRootBone || boneName == 'Spine' ))  {
	        	RandBone = Rand(4);

				switch( RandBone )
	            {
	                case 0:
						boneName = LeftThighBone;
						Break;
	                case 1:
						boneName = RightThighBone;
						Break;
	                case 2:
						boneName = LeftFArmBone;
	                    Break;
	                case 3:
						boneName = RightFArmBone;
	                    Break;
	                case 4:
						boneName = HeadBone;
	                    Break;
	                default:
	                	boneName = LeftThighBone;
	            }
	        }
		}

		if ( Health < 0 && Damage > DamageType.default.HumanObliterationThreshhold && 
			 Damage != 1000 && !class'GameInfo'.static.UseLowGore() )
			boneName = 'obliterate';

		HitFX[HitFxTicker].bone = boneName;
		HitFX[HitFxTicker].rotDir = r;
		HitFxTicker = HitFxTicker + 1;
		if( HitFxTicker > ArrayCount(HitFX)-1 )
			HitFxTicker = 0;

		// If this was a really hardcore damage from an explosion, randomly spawn some arms and legs
		if ( bDidSever && !DamageType.default.bLocationalHit && 
			 Damage > 200 && Damage != 1000 && !class'GameInfo'.static.UseLowGore() )  {
			if ((Damage > 400 && FRand() < 0.3) || FRand() < 0.1 )  {
				DoDamageFX(HeadBone,1000,DamageType,r);
				DoDamageFX(LeftThighBone,1000,DamageType,r);
				DoDamageFX(RightThighBone,1000,DamageType,r);
				DoDamageFX(LeftFArmBone,1000,DamageType,r);
				DoDamageFX(RightFArmBone,1000,DamageType,r);
			}
			
			if ( FRand() < 0.25 )  {
				DoDamageFX(LeftThighBone,1000,DamageType,r);
				DoDamageFX(RightThighBone,1000,DamageType,r);
				if ( FRand() < 0.5 )
					DoDamageFX(LeftFArmBone,1000,DamageType,r);
				else
					DoDamageFX(RightFArmBone,1000,DamageType,r);
			}
			else if ( FRand() < 0.35 )
				DoDamageFX(LeftThighBone,1000,DamageType,r);
			else if ( FRand() < 0.5 )
				DoDamageFX(RightThighBone,1000,DamageType,r);
			else if ( FRand() < 0.75 )  {
				if ( FRand() < 0.5 )
					DoDamageFX(LeftFArmBone,1000,DamageType,r);
				else
					DoDamageFX(RightFArmBone,1000,DamageType,r);
			}
		}
	}
}

function RangedAttack(Actor A)
{
	if ( bShotAnim || Physics == PHYS_Swimming )
		Return;
	else if ( CanAttack(A) )  {
		bShotAnim = True;
		SetAnimAction('Claw');
		//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
		Return;
	}
}

// Overridden so that anims don't get interrupted on the server if one is already playing
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	local coords C;
	local vector HeadLoc, B, M, diff;
	local float t, DotMM, Distance;
	local int look;
	local bool bUseAltHeadShotLocation;
	local bool bWasAnimating;

	if ( bDecapitated || HeadBone == '' )
		Return False;

	// If we are a dedicated server estimate what animation is most likely playing on the client
	if ( Level.NetMode == NM_DedicatedServer )  {
		if ( Physics == PHYS_Falling )
			PlayAnim(AirAnims[0], 1.0, 0.0);
		else if ( Physics == PHYS_Swimming )
			PlayAnim(SwimAnims[0], 1.0, 0.0);
		else if ( Physics == PHYS_Walking )  {
			// Only play the idle anim if we're not already doing a different anim.
			// This prevents anims getting interrupted on the server and borking things up - Ramm
			if ( !IsAnimating(0) && !IsAnimating(1) )  {
				if ( bIsCrouched )
					PlayAnim(IdleCrouchAnim, 1.0, 0.0);
				else
					bUseAltHeadShotLocation = True;
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

		if ( !bWasAnimating )
			SetAnimFrame(0.5);
	}

	if ( bUseAltHeadShotLocation )  {
		HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
		AdditionalScale *= OnlineHeadshotScale;
	}
	else  {
		//C = GetBoneCoords(HeadBone);
		//HeadLoc = C.Origin + (HeadHeight * HeadScale * AdditionalScale * C.XAxis);
		C = GetBoneCoords(HeadHitPointName);
		HeadLoc = C.Origin;
	}
	
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

// Return True if head was removed
function bool ProcessTakeHeadShotDamage( int Damage )
{
	HeadHealth = Max( (HeadHealth - Damage), 0 );
	if ( HeadHealth > 0 || Damage < Health )  {
		PlaySound(sound'KF_EnemyGlobalSndTwo.Impact_Skull', SLOT_None, 2.0, True, 500);
		Return False;	// Don't remove head
	}
	
	bDecapitated  = True;
	DECAP = True;
	DecapTime = Level.TimeSeconds;
	Intelligence = BRAINS_Retarded; // Headless dumbasses!
	Velocity = vect(0.0, 0.0, 0.0);
	SetAnimAction('HitF');
	SetGroundSpeed(GroundSpeed *= 0.8);
	AirSpeed *= 0.8;
	WaterSpeed *= 0.8;
	AmbientSound = MiscSound; // No more raspy breathin'...cuz he has no throat or mouth :S
	
	// Destroy HeadBallisticCollision
	if ( HeadBallisticCollision != None )  {
		HeadBallisticCollision.DisableCollision();
		HeadBallisticCollision.Destroy();
		HeadBallisticCollision = None;
	}

	if ( MonsterController(Controller) != None )
		MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's headless now, after all) :-D
	
	PlaySound(DecapitationSound, SLOT_Misc,1.30,True,525);
	
	Return True; // Haed was removed
}

// Process the damaging and Return the amount of taken damage
function int ProcessTakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType )
{
	local	bool						bIsHeadshot;
	local	Controller					Killer;
	local	KFPlayerReplicationInfo		KFPRI;
	
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
	
	//[block] Damage modifiers
	// Scale damage if the Zed has been zapped
	if ( bZapped )
		Damage = Round( float(Damage) * ZappedDamageMod );
		
	// Owner takes damage while holding this weapon - used by shield gun
	if ( Weapon != None )
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	
	// Modify Damage if Pawn is driving a vehicle
	if ( DrivenVehicle != None )
		DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
	
	if ( InstigatedBy != None )  {
		if ( InstigatedBy.HasUDamage() )
			Damage *= 2;
		KFPRI = KFPlayerReplicationInfo(instigatedBy.PlayerReplicationInfo);
	}
	
	if ( !bDecapitated && class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.bCheckForHeadShots && class<DamTypeBurned>(DamageType) == None && class<DamTypeFlamethrower>(DamageType) == None )  {
		// Do larger headshot checks if it is a melee attach
		if ( class<DamTypeMelee>(DamageType) != None )
			bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.25);
		else
			bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);
		
		if ( bIsHeadShot )  {
			if ( class<DamTypeMelee>(DamageType) == None && KFPRI != None &&
				 KFPRI.ClientVeteranSkill != None )
				Damage = Round( float(Damage) * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult * KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(instigatedBy), DamageType) );
			else
				Damage = Round( float(Damage) * class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult );
		}
		
		bLaserSightedEBRM14Headshotted = bIsHeadshot && instigatedBy != None && M14EBRBattleRifle(instigatedBy.Weapon) != None && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
	}
	else
		bLaserSightedEBRM14Headshotted = bLaserSightedEBRM14Headshotted && bDecapitated;
	
	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None )
		Damage = KFPRI.ClientVeteranSkill.Static.AddDamage(KFPRI, self, KFPawn(instigatedBy), Damage, DamageType);
	
	// ReduceDamage
	if ( Level.Game != None )
		Damage = Level.Game.ReduceDamage( Damage, self, instigatedBy, HitLocation, Momentum, DamageType );
	
	//ToDo: issue #204
	// if ( Armor != None )
		//ArmorAbsorbDamage( Damage, instigatedBy, Momentum, DamageType );
	if ( DamageType.default.bArmorStops )
		Damage = ShieldAbsorb( Damage );
	//[end]
	
	// Just Return if this wouldn't even damage us.
	if ( Damage < 1 )
		Return 0;
	
	// KillAssistant
	if ( DamageType != None && LastDamagedBy != None && LastDamagedBy.IsPlayerPawn() && LastDamagedBy.Controller != None && KFMonsterController(Controller) != None )
		KFMonsterController(Controller).AddKillAssistant( LastDamagedBy.Controller, FMin(Health, Damage) );
	
	// Last Damage
	LastDamagedBy = InstigatedBy;
	LastDamagedByType = damageType;
	HitMomentum = VSize(Momentum);
	LastHitLocation = Hitlocation;
	LastMomentum = Momentum;
	LastDamageAmount = Damage;

	if ( !bDecapitated && bIsHeadShot && ProcessTakeHeadShotDamage(Damage) )  {
		// Head explodes, causing additional hurty.
		Damage += Damage + HealthMax * 0.25;
		if ( BurnDown > 0 )
			KFSteamStatsAndAchievements(KFPawn(LastDamagedBy).PlayerReplicationInfo.SteamStatsAndAchievements).AddBurningDecapKill(class'KFGameType'.static.GetCurrentMapName(Level));
		// Bonuses
		if ( UM_HumanPawn(instigatedBy) != None )  {
			// SlowMoCharge
			UM_HumanPawn(instigatedBy).AddSlowMoCharge( HeadShotSlowMoChargeBonus );
			// ImpressiveKill
			if ( UM_BaseGameInfo(Level.Game) != None && Damage > Health )
				UM_BaseGameInfo(Level.Game).CheckForImpressiveKill( UM_PlayerController(instigatedBy.Controller), Self );
		}
		// Award headshot here, not when zombie died.
		if ( Class<KFWeaponDamageType>(DamageType) != None && 
			 instigatedBy != None && KFPlayerController(instigatedBy.Controller) != None )  {
			bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(instigatedBy.Weapon) != None && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
			Class<KFWeaponDamageType>(DamageType).Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), self.Class, bLaserSightedEBRM14Headshotted);
		}
	}
	
	// Client check for Gore FX
	//BodyPartRemoval(Damage,instigatedBy,Hitlocation,Momentum,DamageType);
	/*
	if ( Damage < Health && DamageType != class'DamTypeFrag' && DamageType != class'DamTypePipeBomb' && DamageType != class'DamTypeM79Grenade' && DamageType != class'DamTypeM32Grenade' && DamageType != class'DamTypeM203Grenade' && DamageType != class'DamTypeDwarfAxe' && DamageType != class'DamTypeSPGrenade' && DamageType != class'DamTypeSealSquealExplosion' && DamageType != class'DamTypeSeekerSixRocket' && Class<Whisky_DamTypeHammer>(DamageType) == None && Class<UM_BaseDamType_Explosive>(DamageType) == None )
		Momentum *= float(Damage) / float(Health) * 0.75;
	*/
	

	if ( HitLocation == vect(0.0, 0.0, 0.0) )
		HitLocation = Location;
	
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
		if ( KFPRI != None && KFPRI.ClientVeteranSkill != None && KFPRI.ClientVeteranSkill.static.KilledShouldExplode(KFPRI, KFPawn(instigatedBy)) )
			HurtRadius( 500.0, 1000.0, class'DamTypeFrag', 100000.0, Location );
		
		Died( Killer, DamageType, HitLocation );
	}
	// Paw has lost some Health
	else  {
		// Decapitated BleedOutTime
		if ( bDecapitated )
			BleedOutTime = Level.TimeSeconds +  BleedOutDuration;
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

event TakeDamage( int Damage, Pawn instigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	// GodMode
	if ( Role < ROLE_Authority || Damage < 1 || (Controller != None && Controller.bGodMode) )
		Return;

	// Fire damage
	if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) != None || class<UM_BaseDamType_Flame>(DamageType) != None || (class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.bDealBurningDamage) )  {
		if ( BurnDown < 1 || Damage > LastBurnDamage )  {
			// LastBurnDamage variable is storing last burn damage (unperked) received,
			// which will be used to make additional damage per every burn tick (second).
			LastBurnDamage = Damage;
			// FireDamageClass variable stores damage type, which started zed's burning
			// and will be passed to this function again every next burn tick (as DamageType argument)
			if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) != None ||
				 class<UM_BaseDamType_Flame>(DamageType) != None || class<DamTypeTrenchgun>(DamageType) != None || class<DamTypeFlareRevolver>(DamageType) != None || class<DamTypeMAC10MPInc>(DamageType) != None )
				FireDamageClass = DamageType;
			else
				FireDamageClass = class'DamTypeFlamethrower';
		}

		if ( class<UM_BaseDamType_IncendiaryBullet>(DamageType) == None && class<DamTypeMAC10MPInc>(DamageType) == None )
			Damage *= 1.5; // Increase burn damage 1.5 times, except MAC10 and all Incendiary Bullets by instatnt fire.
		
		if ( Damage >= 15 )
			HeatAmount = 4;
		else
			++HeatAmount;
		
		// if enough Heat
		if ( HeatAmount > 3 )  {
			HeatAmount = 3;
			BurnDown = 10; // Inits burn tick count to 10
			if ( !bBurnified )  {
				bBurnified = True;
				SetGroundSpeed(GroundSpeed * 0.8); // Lowers movement speed by 20%
				BurnInstigator = instigatedBy;
				SetTimer(1.0, False); // Sets timer to execute after the second
			}
		}
	}

	// Same rules apply to zombies as players.
	if ( class<DamTypeVomit>(DamageType) != None )  {
		BileCount = 7;
		BileInstigator = instigatedBy;
		if ( NextBileTime < Level.TimeSeconds )
			NextBileTime = Level.TimeSeconds+BileFrequency;
	}

	ProcessTakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
}

function RemoveHead() { }

function TakeFireDamage( int Damage, Pawn FireDamageInstigator );

function TakeBileDamage()
{
	ProcessTakeDamage( (Rand(3) + 2), BileInstigator, Location, Vect(0.0, 0.0, 0.0), LastBileDamagedByType );
}

simulated event Timer()
{
	// bSTUNNED variable actually indicates flinching, not stunning! So don't get confused.
	bSTUNNED = False;
	
	if ( Role < Role_Authority )
		Return;	// Server code next
	
	if ( BurnDown > 0 )  {
		--BurnDown;
		LastBurnDamage = Round( Lerp(FRand(), float(LastBurnDamage) * 0.9, float(LastBurnDamage)) );
		ProcessTakeDamage( LastBurnDamage, BurnInstigator, Vect(0.0, 0.0, 0.0), Vect(0.0, 0.0, 0.0), FireDamageClass );
		// Melt em' :)
		if ( BurnDown < CrispUpThreshhold )
			ZombieCrispUp();
		// if still burning
		if ( BurnDown > 0 )  {
			HeatAmount = Min( BurnDown, 4 );
			SetTimer(1.0, False); // Sets timer to execute after the second again
			Return;
		}
	}
	
	bBurnified = False;
	LastBurnDamage = 0;
	HeatAmount = 0;
	if ( !bZapped )
		SetGroundSpeed(default.GroundSpeed);
	StopBurnFX();
	SetTimer(0.0, False);  // Disable timer
}

function PushAwayZombie(Vector NewVelocity)
{
	AddVelocity(NewVelocity);
	bNoJumpAdjust = True;
	if ( Controller != None )
		Controller.SetFall();
}

/*
function PushAwayZombie(vector PushAwayDirection, float PushAwayPower)
{
	if ( PushAwayPower > Mass )  {
		AnimEnd(1);
		bShotAnim = True;
		bNoJumpAdjust = True;
		Acceleration = vect(0, 0, 0);
		Velocity = (PushAwayPower - Mass) * Normal(PushAwayDirection);
		Velocity.Z += 100.000000;
		UM_MonsterController(Controller).bUseFreezeHack = True;
		if ( Controller != None && UM_MonsterController(Controller) != None
			&& !Controller.IsInState('ZombiePushedAway') )
			Controller.GotoState('ZombiePushedAway');
		SetPhysics(PHYS_Falling);
		if ( Controller != None )
			Controller.SetFall();
	}
} */

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
	 HeadHitPointName="HitPoint_Head"
	 
	 bPhysicsAnimUpdate=True
	 
	 Intelligence=BRAINS_Mammal
	 
	 ImpressiveKillChance=0.03
	 ImpressiveKillDuration=4.0
	 
	 HealthMax=150.0
	 Health=150
	 HeadHealth=25.0
	 
	 HeadShotSlowMoChargeBonus=0.2
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
	 // Monster Speed
	 SpeedScaleRange=(Min=0.9,Max=1.1)
	 // Monster Health
	 HealthScaleRange=(Min=0.9,Max=1.1)
	 // Monster HeadHealth
	 HeadHealthScaleRange=(Min=0.92,Max=1.08)
	 // JumpZ
	 JumpZScaleRange=(Min=1.0,Max=1.2)
	 // MeleeRange
	 MeleeRangeScale=(Min=0.95,Max=1.05)
	 // DamageScale
	 DamageScaleRange=(Min=0.9,Max=1.1)
	 // Extra Sizes
	 ExtraSizeChance=0.150000
	 ExtraSizeScaleRange=(Min=0.6,Max=1.3)
	 // Extra Speed
	 ExtraSpeedChance=0.200000
	 ExtraSpeedScaleRange=(Min=1.2,Max=2.0)
	 // Extra Health
	 ExtraHealthChance=0.200000
	 ExtraHealthScaleRange=(Min=1.15,Max=2.0)
	 ExtraHeadHealthScaleRange=(Min=1.1,Max=1.9)
	 //Anims
	 DoubleJumpAnims(0)="Jump"
	 DoubleJumpAnims(1)="Jump"
	 DoubleJumpAnims(2)="Jump"
	 DoubleJumpAnims(3)="Jump"
	 ZombieDamType(0)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ZombieDamType(1)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ZombieDamType(2)=Class'UnlimaginMod.UM_ZombieDamType_Melee'
	 ControllerClass=Class'UnlimaginMod.UM_MonsterController'
	 // Collision flags
	 SurfaceType=EST_Flesh
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