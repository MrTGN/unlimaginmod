//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster
//	Parent class:	 KFMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 18:35
//================================================================================
class UM_Monster extends KFMonster
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
	var		name							AreaBone;	// Name Of the bone area will be attached to
	var		vector							AreaOffset;	// Area offset from the bone
	var		rotator							AreaRotation;	// Area relative rotation from the bone
	var		float							AreaImpactStrength;	// J / mm2
	var		float							AreaHealth;	// Health amount of this body part
	var		float							AreaDamageScale;	// Amount to scale taken damage by this area
	var		bool							bArmoredArea;	// This area can be covered with armor
};

var		array<BallisticCollisionData>	BallisticCollision;
var		UM_PawnHeadCollision			HeadBallisticCollision;	// Reference to the Head Ballistic Collision

var		float							HeadShotSlowMoChargeBonus;

var		transient	bool				bAddedToMonsterList;

var					float				ImpressiveKillChance;
var					float				ImpressiveKillDuration;

var		transient	float				LastSeenCheckTime;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty && bNetInitial )
		bThisIsMiniBoss;
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
			if ( BallisticCollision[i].AreaSizeScale <= 0.0 )
				CurrentSizeScale = DrawScale;
			else
				CurrentSizeScale = BallisticCollision[i].AreaSizeScale * DrawScale;
			
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
			
			// if attached
			if ( BallisticCollision[i].Area.Base != None )  {
				// AreaOffset
				if ( BallisticCollision[i].AreaOffset != vect(0.0, 0.0, 0.0) )
					BallisticCollision[i].Area.SetRelativeLocation( BallisticCollision[i].AreaOffset * CurrentSizeScale );
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

// Sets the current Health
protected function SetHealth( int NewHealth )
{
	Health = Max(NewHealth, 0);
}

event PreBeginPlay()
{
	LastSeenCheckTime = Level.TimeSeconds;
	
	if ( !bRandomSizeAdjusted )
		RandomizeMonsterSizes();
	
	Super.PreBeginPlay();
}

function bool NotRelevantMoreThan( float NotSeenTime )
{
	Return (Level.TimeSeconds - LastSeenCheckTime) > NotSeenTime && (Level.TimeSeconds - LastSeenOrRelevantTime) > NotSeenTime;
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
		/*
		if ( HeadBallisticCollision != None )
			OnlineHeadshotOffset = HeadBallisticCollision.Location - (Location - CollisionHeight * Vect(0.0, 0.0, 1.0));	*/
	}

	AssignInitialPose();
	// Let's randomly alter the position of our zombies' spines, to give their animations
	// the appearance of being somewhat unique.
	SetTimer(1.0, false);

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

	bSTUNNED = false;
	DECAP = false;

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
				MovementSpeedDifficultyScale = 0.95;
			else if( Level.Game.GameDifficulty < 4.0 )
				MovementSpeedDifficultyScale = 1.0;
			else if( Level.Game.GameDifficulty < 5.0 )
				MovementSpeedDifficultyScale = 1.15;
			else if( Level.Game.GameDifficulty < 7.0 )
				MovementSpeedDifficultyScale = 1.22;
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
			JumpZ = default.JumpZ * DrawScale * Lerp( FRand(), JumpZScaleRange.Min, JumpZScaleRange.Max );
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

	if ( Level.NetMode != NM_DedicatedServer )  {
		AdditionalWalkAnims[AdditionalWalkAnims.length] = default.MovementAnims[0];
		MovementAnims[0] = AdditionalWalkAnims[Rand(AdditionalWalkAnims.length)];
	}
}

simulated event PostNetBeginPlay()
{
	EnableChannelNotify(1, 1);
	AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
	AnimBlendParams(1, 1.0, 0.0,, HeadBone);
	
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
	
	SetHealth(0);
	
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

// Return true if we can do the Zombie speed adjust that gets the Zeds
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
	
	if ( bResetAnimAct && ResetAnimActTime < Level.TimeSeconds )  {
		AnimAction = '';
		bResetAnimAct = False;
	}
	
	if ( Controller != None )
		LookTarget = Controller.Enemy;
	
	// If the Zed has been bleeding long enough, make it die
	if ( Role == ROLE_Authority && bDecapitated && BleedOutTime > 0 && (Level.TimeSeconds - BleedOutTime) >= 0.0 )  {
		Died( LastDamagedBy.Controller, class'DamTypeBleedOut', Location );
		BleedOutTime = 0.0;
	}
	
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
	bShotAnim = true;
}

// High damage was taken, make em fall over.
function bool FlipOver()
{
	if ( Physics==PHYS_Falling )
		SetPhysics(PHYS_Walking);

	bShotAnim = true;
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
		else if( class<DamTypeNailGun>(DamageType) != none )
			HitFX[HitFxTicker].damtype = class'DamTypeProjectileDecap';
		else
			HitFX[HitFxTicker].damtype = class'DamTypeDecapitation';

		if ( DamageType.default.bNeverSevers || class'GameInfo'.static.UseLowGore()
			|| (Level.Game != none && Level.Game.PreventSever(self, boneName, Damage, DamageType)) )
			HitFX[HitFxTicker].bSever = false;
		else
			HitFX[HitFxTicker].bSever = true;

		HitFX[HitFxTicker].bone = HeadBone;
		HitFX[HitFxTicker].rotDir = r;
		HitFxTicker = HitFxTicker + 1;
		
		if( HitFxTicker > ArrayCount(HitFX)-1 )
			HitFxTicker = 0;

		bPlayBrainSplash = true;

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
					break;

				case LeftFootBone:
				case 'lleg':
					boneName = LeftThighBone;
					break;

				case RightFootBone:
				case 'rleg':
					boneName = RightThighBone;
					break;

				case RightHandBone:
				case RightShoulderBone:
				case 'rarm':
					boneName = RightFArmBone;
					break;

				case LeftHandBone:
				case LeftShoulderBone:
				case 'larm':
					boneName = LeftFArmBone;
					break;

				case 'None':
				case 'spine':
					boneName = FireRootBone;
					break;
			}

			if ( DamageType.default.bAlwaysSevers || Damage == 1000 )  {
				HitFX[HitFxTicker].bSever = true;
				bDidSever = true;
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
			HitFX[HitFxTicker].bSever = false;
			bDidSever = false;
		}

		if ( HitFX[HitFxTicker].bSever )  {
	        if ( !DamageType.default.bLocationalHit && 
				 (boneName == 'None' || boneName == FireRootBone || boneName == 'Spine' ))  {
	        	RandBone = Rand(4);

				switch( RandBone )
	            {
	                case 0:
						boneName = LeftThighBone;
						break;
	                case 1:
						boneName = RightThighBone;
						break;
	                case 2:
						boneName = LeftFArmBone;
	                    break;
	                case 3:
						boneName = RightFArmBone;
	                    break;
	                case 4:
						boneName = HeadBone;
	                    break;
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
		SetAnimAction(MeleeAnims[Rand(3)]);
		//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
		Return;
	}
}

simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;

	if ( NewAction == '' )
		Return;
	
	if ( NewAction == 'DoorBash' )
		CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
	else  {
		for ( meleeAnimIndex = 0; meleeAnimIndex < 2; meleeAnimIndex++ )  {
			if ( NewAction == MeleeAnims[meleeAnimIndex] )  {
				CurrentDamtype = ZombieDamType[meleeAnimIndex];
				Break;
			}
		}
	}
	
	/* if ( NewAction == MeleeAnims[0] || 
		 NewAction == MeleeAnims[1] ||
		 NewAction == MeleeAnims[2] )
	{
		meleeAnimIndex = Rand(3);
		NewAction = MeleeAnims[meleeAnimIndex];
		CurrentDamtype = ZombieDamType[meleeAnimIndex];
	}
	else if ( NewAction == 'DoorBash' )
	   CurrentDamtype = ZombieDamType[Rand(3)]; */

	ExpectingChannel = DoAnimAction(NewAction);

	if ( AnimNeedsWait(NewAction) )
		bWaitForAnim = True;
	else
		bWaitForAnim = False;

	if ( Level.NetMode != NM_Client )  {
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
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

	if ( HeadBone == '' )
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
		else if ( Physics == PHYS_Swimming )
			PlayAnim(SwimAnims[0], 1.0, 0.0);

		if( !bWasAnimating )
			SetAnimFrame(0.5);
	}

	if( bUseAltHeadShotLocation )  {
		HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
		AdditionalScale *= OnlineHeadshotScale;
	}
	else  {
		C = GetBoneCoords(HeadBone);
		HeadLoc = C.Origin + (HeadHeight * HeadScale * AdditionalScale * C.XAxis);
	}
	//ServerHeadLocation = HeadLoc;

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

/* ToDo: òðåáóåò äîðàáîòêè! Ïîêà çàêîìåíòèë.
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
	
	// TraceThisActor returns true if did not hit this actor.
	Return !HeadBallisticCollision.TraceThisActor( TraceHitLoc, TraceHitNorm, (Loc + Ray), (Loc - Ray), TraceExtetnt );
}	*/

//Issue: #264
function RemoveHead()
{
	local	int		i;
	
	if ( HeadBallisticCollision != None )  {
		HeadBallisticCollision.DisableCollision();
		HeadBallisticCollision.Destroy();
		HeadBallisticCollision = None;
	}
	
	Intelligence = BRAINS_Retarded; // Headless dumbasses!
	bDecapitated  = True;
	DECAP = True;
	DecapTime = Level.TimeSeconds;

	Velocity = vect(0.0, 0.0, 0.0);
	SetAnimAction('HitF');
	SetGroundSpeed(GroundSpeed *= 0.80);
	AirSpeed *= 0.8;
	WaterSpeed *= 0.8;

	// No more raspy breathin'...cuz he has no throat or mouth :S
	AmbientSound = MiscSound;

	if ( Controller != None )
		MonsterController(Controller).Accuracy = -5;  // More chance of missing. (he's headless now, after all) :-D

	// Head explodes, causing additional hurty.
	if ( KFPawn(LastDamagedBy) != None )  {
		//ToDo: #264.1
		TakeDamage( (LastDamageAmount + 0.25 * HealthMax) , LastDamagedBy, LastHitLocation, LastMomentum, LastDamagedByType);

		if ( BurnDown > 0 )
			KFSteamStatsAndAchievements(KFPawn(LastDamagedBy).PlayerReplicationInfo.SteamStatsAndAchievements).AddBurningDecapKill(class'KFGameType'.static.GetCurrentMapName(Level));
	}

	if ( Health > 0 )
		BleedOutTime = Level.TimeSeconds +  BleedOutDuration;

	// He's got no head so biting is out.
	if ( MeleeAnims[2] == 'Claw3' )
		MeleeAnims[2] = 'Claw2';
	if ( MeleeAnims[1] == 'Claw3' )
		MeleeAnims[1] = 'Claw1';

	// Plug in headless anims if we have them
	for ( i = 0; i < 4; ++i )  {
		if ( HeadlessWalkAnims[i] != '' && HasAnim(HeadlessWalkAnims[i]) )  {
			MovementAnims[i] = HeadlessWalkAnims[i];
			WalkAnims[i]     = HeadlessWalkAnims[i];
		}
	}

	PlaySound(DecapitationSound, SLOT_Misc,1.30,true,525);
}

function CheckForImpressiveKill( UM_PlayerController PC )
{
	if ( PC == None || PC.Pawn == None || UM_BaseGameInfo(Level.Game) == None || !UM_BaseGameInfo(Level.Game).AllowImpressiveKillEvent(ImpressiveKillChance) )
		Return;
	
	UM_BaseGameInfo(Level.Game).DoZedTime( ImpressiveKillDuration );
	if ( UM_BaseGameInfo(Level.Game).bShowImpressiveKillEvents )
		PC.ShowActor( Self, ImpressiveKillDuration );
}

event TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType, optional int HitIndex )
{
	local bool bIsHeadshot;
	local KFPlayerReplicationInfo KFPRI;
	local float HeadShotCheckScale;

	LastDamagedBy = instigatedBy;
	LastDamagedByType = damageType;
	HitMomentum = VSize(momentum);
	LastHitLocation = hitlocation;
	LastMomentum = momentum;

	if ( KFPawn(instigatedBy) != None && instigatedBy.PlayerReplicationInfo != None )
		KFPRI = KFPlayerReplicationInfo(instigatedBy.PlayerReplicationInfo);

	// Scale damage if the Zed has been zapped
	if ( bZapped )
		Damage *= ZappedDamageMod;

	// Zeds and fire dont mix.
	if ( class<UM_BaseDamType_IncendiaryBullet>(damageType) != None || class<UM_BaseDamType_Flame>(damageType) != None
		 || (class<KFWeaponDamageType>(damageType) != None && class<KFWeaponDamageType>(damageType).default.bDealBurningDamage) )  {
		if ( BurnDown < 1 || Damage > LastBurnDamage )  {
			// LastBurnDamage variable is storing last burn damage (unperked) received,
			// which will be used to make additional damage per every burn tick (second).
			LastBurnDamage = Damage;

			// FireDamageClass variable stores damage type, which started zed's burning
			// and will be passed to this function again every next burn tick (as damageType argument)
			if ( class<DamTypeTrenchgun>(damageType) != none ||
				 class<DamTypeFlareRevolver>(damageType) != none ||
				 class<DamTypeMAC10MPInc>(damageType) != none ||
				 class<UM_BaseDamType_IncendiaryBullet>(damageType) != none ||
				 class<UM_BaseDamType_Flame>(damageType) != none )
				FireDamageClass = damageType;
			else
				FireDamageClass = class'DamTypeFlamethrower';
		}

		if ( class<DamTypeMAC10MPInc>(damageType) == None &&
			 class<UM_BaseDamType_IncendiaryBullet>(damageType) == None )
			Damage *= 1.5; // Increase burn damage 1.5 times, except MAC10 and all Incendiary Bullets by instatnt fire.

		// BurnDown variable indicates how many ticks are remaining for zed to burn.
		// It is 0, when zed isn't burning (or stopped burning).
		// So all the code below will be executed only, if zed isn't already burning
		if ( BurnDown < 1 )  {
			if ( HeatAmount > 4 || Damage >= 15 )  {
				bBurnified = True;
				BurnDown = 10; // Inits burn tick count to 10
				SetGroundSpeed(GroundSpeed * 0.8); // Lowers movement speed by 20%
				BurnInstigator = instigatedBy;
				SetTimer(1.0,false); // Sets timer function to be executed each second
			}
			else
				HeatAmount++;
		}
	}

	if ( !bDecapitated && class<KFWeaponDamageType>(damageType) != None &&
		 class<KFWeaponDamageType>(damageType).default.bCheckForHeadShots )  {
		HeadShotCheckScale = 1.0;

		// Do larger headshot checks if it is a melee attach
		if ( class<DamTypeMelee>(damageType) != None )
			HeadShotCheckScale *= 1.25;

		bIsHeadShot = IsHeadShot(hitlocation, normal(momentum), HeadShotCheckScale);
		bLaserSightedEBRM14Headshotted = bIsHeadshot && M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
	}
	else
		bLaserSightedEBRM14Headshotted = bLaserSightedEBRM14Headshotted && bDecapitated;

	if ( KFPRI != None && KFPRI.ClientVeteranSkill != None )
		Damage = KFPRI.ClientVeteranSkill.Static.AddDamage(KFPRI, self, KFPawn(instigatedBy), Damage, damageType);

	if ( damageType != None && LastDamagedBy != None && 
		 LastDamagedBy.IsPlayerPawn() && LastDamagedBy.Controller != None )  {
		if ( UM_MonsterController(Controller) != none )
			UM_MonsterController(Controller).AddKillAssistant(LastDamagedBy.Controller, FMin(Health, Damage));
		else if ( KFMonsterController(Controller) != none )
			KFMonsterController(Controller).AddKillAssistant(LastDamagedBy.Controller, FMin(Health, Damage));
	}

	if ( (bDecapitated || bIsHeadShot) && class<DamTypeBurned>(damageType) == None 
		 && class<DamTypeFlamethrower>(damageType) == None )  {
		// Do not change Damage if bCheckForHeadShots=False in damageType class 
		if ( class<KFWeaponDamageType>(damageType) != None &&
			 class<KFWeaponDamageType>(damageType).default.bCheckForHeadShots )
			Damage = Damage * class<KFWeaponDamageType>(damageType).default.HeadShotDamageMult;

		if ( class<DamTypeMelee>(damageType) == None && KFPRI != None &&
			 KFPRI.ClientVeteranSkill != None )
			Damage = float(Damage) * KFPRI.ClientVeteranSkill.Static.GetHeadShotDamMulti(KFPRI, KFPawn(instigatedBy), damageType);

		LastDamageAmount = Damage;

		if ( !bDecapitated )  {
			if ( bIsHeadShot )  {
			    // Play a sound when someone gets a headshot TODO: Put in the real sound here
				PlaySound(sound'KF_EnemyGlobalSndTwo.Impact_Skull', SLOT_None,2.0,true,500);
				HeadHealth -= LastDamageAmount;
				if ( HeadHealth <= 0 || Damage > Health )  {
					RemoveHead();
					if ( UM_HumanPawn(instigatedBy) != None )
						UM_HumanPawn(instigatedBy).AddSlowMoCharge( HeadShotSlowMoChargeBonus );
				}
				
				if ( Health < 1 )
					CheckForImpressiveKill( UM_PlayerController(instigatedBy.Controller) );
			}

			// Award headshot here, not when zombie died.
			if ( bDecapitated && Class<KFWeaponDamageType>(damageType) != None && 
				 instigatedBy != None && KFPlayerController(instigatedBy.Controller) != None )  {
				bLaserSightedEBRM14Headshotted = M14EBRBattleRifle(instigatedBy.Weapon) != none && M14EBRBattleRifle(instigatedBy.Weapon).bLaserActive;
				Class<KFWeaponDamageType>(damageType).Static.ScoredHeadshot(KFSteamStatsAndAchievements(PlayerController(instigatedBy.Controller).SteamStatsAndAchievements), self.Class, bLaserSightedEBRM14Headshotted);
			}
		}
	}

	// Client check for Gore FX
	//BodyPartRemoval(Damage,instigatedBy,hitlocation,momentum,damageType);

	if ( (Health - Damage) > 0 && damageType != class'DamTypeFrag' 
		 && damageType != class'DamTypePipeBomb' && damageType != class'DamTypeM79Grenade' 
		 && damageType != class'DamTypeM32Grenade' && damageType != class'DamTypeM203Grenade' 
		 && damageType != class'DamTypeDwarfAxe' && damageType != class'DamTypeSPGrenade'
		 && damageType != class'DamTypeSealSquealExplosion'
		 && damageType != class'DamTypeSeekerSixRocket'
		 && Class<Whisky_DamTypeHammer>(damageType) == None
		 && Class<UM_BaseDamType_Explosive>(damageType) == none )
		Momentum = vect(0,0,0);

	// Same rules apply to zombies as players.
	if ( class<DamTypeVomit>(damageType) != None )  {
		BileCount = 7;
		BileInstigator = instigatedBy;
		if ( NextBileTime < Level.TimeSeconds )
			NextBileTime = Level.TimeSeconds+BileFrequency;
	}

	if ( KFPRI != None && (Health - Damage) <= 0 && KFPRI.ClientVeteranSkill != None && 
		 KFPRI.ClientVeteranSkill.static.KilledShouldExplode(KFPRI, KFPawn(instigatedBy)) )  {
		Super(Skaarj).TakeDamage(Damage + 600, instigatedBy, hitLocation, momentum, damageType);
		HurtRadius(500, 1000, class'DamTypeFrag', 100000, Location);
	}
	else
		Super(Skaarj).TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType);

	bBackstabbed = False;
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
	 LifeSpan=150.0
	 ImpressiveKillChance=0.03
	 ImpressiveKillDuration=3.0
	 
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
	 SizeScaleRange=(Min=0.8,Max=1.2)
	 // Monster Speed
	 SpeedScaleRange=(Min=0.8,Max=1.1)
	 // Monster Health
	 HealthScaleRange=(Min=0.9,Max=1.1)
	 // Monster HeadHealth
	 HeadHealthScaleRange=(Min=0.92,Max=1.08)
	 // JumpZ
	 JumpZScaleRange=(Min=0.88,Max=1.12)
	 // MeleeRange
	 MeleeRangeScale=(Min=0.95,Max=1.05)
	 // DamageScale
	 DamageScaleRange=(Min=0.9,Max=1.1)
	 // Extra Sizes
	 ExtraSizeChance=0.150000
	 ExtraSizeScaleRange=(Min=0.55,Max=1.25)
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
	 CrouchHeight=34.0
	 CrouchRadius=25.0
	 
	 PrePivot=(X=0.0,Y=0.0,Z=0.0)
}