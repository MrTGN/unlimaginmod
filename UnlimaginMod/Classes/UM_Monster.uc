//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_Monster
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
class UM_Monster extends KFMonster
	hidecategories(AnimTweaks,DeRes,Force,Gib,Karma,Udamage,UnrealPawn)
	Abstract;

#exec OBJ LOAD FILE=KF_EnemyGlobalSndTwo.uax
//#exec OBJ LOAD FILE=KFZED_Temp_UT.utx
#exec OBJ LOAD FILE=KFZED_FX_T.utx

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var				bool	bRandomSizeAdjusted, bThisIsMiniBoss;

//	Monster Size
var				float	ExtraSizeChance;
var				range	SizeScaleRange, ExtraSizeScaleRange;
// Monster Speed
var				float	ExtraSpeedChance;
var				range	SpeedScaleRange, ExtraSpeedScaleRange;
// Monster Health
var				float	ExtraHealthChance;
var				range	HealthScaleRange, ExtraHealthScaleRange;
var				range	HeadHealthScaleRange, ExtraHeadHealthScaleRange;
// Monster Jump ZAxis height scale
var				range	JumpZScaleRange;
// Monster MeleeRange
var				range	MeleeRangeScale;
// Monster Damage
var				range	DamageScaleRange;

var				float	MeshTestCollisionHeight;	// Height of test collision cyllinder in the Editor
var				float	MeshTestCollisionRadius;	// Radius of test collision cyllinder in the Editor

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
	var	float							AreaDamageScale;	// Amount to scale taken damage by this area
	var	bool							bArmoredArea;	// This area can be covered with armor
};

var	array<BallisticCollisionData>		BallisticCollision;
var		UM_PawnHeadCollision			HeadBallisticCollision;	// Reference for code in IsHeadShot() function

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

function RandomizeMonsterSizes()
{
	local	float	RandomSizeMult;
	
	RandomSizeMult = BaseActor.static.GetExtraRandRangeFloat( SizeScaleRange, ExtraSizeChance, ExtraSizeScaleRange );
	// DrawScale
	SetDrawScale(default.DrawScale * RandomSizeMult);
	
	MeleeRange = default.MeleeRange * RandomSizeMult * BaseActor.static.GetRandRangeFloat( MeleeRangeScale );
	SeveredArmAttachScale = default.SeveredArmAttachScale * RandomSizeMult;
	SeveredLegAttachScale = default.SeveredLegAttachScale * RandomSizeMult;
	SeveredHeadAttachScale = default.SeveredHeadAttachScale * RandomSizeMult;
	
	// Sizes
	Mass = default.Mass * RandomSizeMult;
	// CollisionSize scaled by DrawScale
	SetCollisionSize( (MeshTestCollisionRadius * DrawScale), (MeshTestCollisionHeight * DrawScale) );
	// EyeHeight scaled by DrawScale
	BaseEyeHeight = default.BaseEyeHeight * DrawScale;
	EyeHeight = default.EyeHeight * DrawScale;
	//PrePivot.Z = CollisionHeight - default.CollisionHeight;
	PrePivot.Z = ((MeshTestCollisionRadius * DrawScale) - MeshTestCollisionRadius) * DrawScale;
	
	OnlineHeadshotScale = default.OnlineHeadshotScale * RandomSizeMult;
	OnlineHeadshotOffset = default.OnlineHeadshotOffset * RandomSizeMult;
	
	HeadHeight = default.HeadHeight * RandomSizeMult;
	
	CrouchHeight = default.CrouchHeight * RandomSizeMult;
	CrouchRadius = default.CrouchRadius * RandomSizeMult;
	
	bRandomSizeAdjusted = True;
}

function BuildBallisticCollision()
{
	local	int		i;
	
	for ( i = 0; i < BallisticCollision.Length; ++i )  {
		if ( BallisticCollision[i].AreaClass != None )  {
			BallisticCollision[i].Area = Spawn( BallisticCollision[i].AreaClass, Self );
			// if exist
			if ( BallisticCollision[i].Area != None )  {
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
						BallisticCollision[i].Area.SetRelativeRotation( BallisticCollision[i].AreaRotation * DrawScale );
				}
				// Area.ImpactStrength
				if ( BallisticCollision[i].AreaImpactStrength > 0.0 )
					BallisticCollision[i].Area.ImpactStrength = BallisticCollision[i].AreaImpactStrength * DrawScale * BaseActor.static.GetRandFloat(0.9, 1.1);
			}
		}
	}
}

function DestroyBallisticCollision()
{
	local	int		i;
	
	HeadBallisticCollision = None;
	while ( BallisticCollision.Length > 0 )  {
		i = BallisticCollision.Length - 1;
		if ( BallisticCollision[i].Area != None )
			BallisticCollision[i].Area.Destroy();
		BallisticCollision.Remove(i, 1);
	}
}

event PreBeginPlay()
{
	if ( !bRandomSizeAdjusted )
		RandomizeMonsterSizes();
	
	Super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	local	float	RandMult;
	local	float	MovementSpeedDifficultyScale;
	
	if ( ROLE == ROLE_Authority )  {
		BuildBallisticCollision();
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

	// Difficulty Scaling
	if ( Level.Game != None && !bDiffAdjusted )  {
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
			CurrentDamType = ZombieDamType[Rand(3)];
		
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
			RandMult = BaseActor.static.GetRandRangeFloat( ExtraHeadHealthScaleRange );
		}
		else
			RandMult = BaseActor.static.GetRandRangeFloat( HeadHealthScaleRange );

		HeadHealth = FMin( (default.HeadHealth * DifficultyHeadHealthModifer() * RandMult * NumPlayersHeadHealthModifer()), (HealthMax - 10.0) );
		//[end]
			
		//floats
		RandMult = BaseActor.static.GetRandRangeFloat( DamageScaleRange );
		SpinDamConst = FMax( (DifficultyDamageModifer() * default.SpinDamConst * RandMult), 1.0 );
		SpinDamRand = FMax( (DifficultyDamageModifer() * default.SpinDamRand * RandMult), 1.0 );
		JumpZ = default.JumpZ * BaseActor.static.GetRandRangeFloat( JumpZScaleRange );
		//int
		ScreamDamage = Max( Round(DifficultyDamageModifer() * default.ScreamDamage * BaseActor.static.GetRandRangeFloat(DamageScaleRange)), 1 );
		MeleeDamage = Max( Round(DifficultyDamageModifer() * default.MeleeDamage * BaseActor.static.GetRandRangeFloat(DamageScaleRange)), 1 );

		
		//log(self$" HealthMax "$HealthMax$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
		//log(self$" Health "$Health$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
		//log(self$" HeadHealth "$HeadHealth$" GameDifficulty "$Level.Game.GameDifficulty$" NumPlayersHealthModifer "$NumPlayersHealthModifer());
		
		// ToDo: need to somehow distinguish a miniboss among other monsters
		/*
		if ( bThisIsMiniBoss )  {
			
		} */

		bDiffAdjusted = True;
	}

	if ( Level.NetMode != NM_DedicatedServer )  {
		AdditionalWalkAnims[AdditionalWalkAnims.length] = default.MovementAnims[0];
		MovementAnims[0] = AdditionalWalkAnims[Rand(AdditionalWalkAnims.length)];
	}
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

simulated event Destroyed()
{
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
			
			if ( UM_KFMonsterController(Controller) != None )
				UM_KFMonsterController(Controller).KickTarget = KActor(Other);
			else if ( KFMonsterController(Controller) != None )
				KFMonsterController(Controller).KickTarget = KActor(Other);
			
			SetAnimAction(PuntAnim);
		}
	}
}

// Actually execute the kick (this is notified in the ZombieKick animation)
function KickActor()
{
	KickTarget.Velocity.Z += (Mass * 5 + (KGetMass() * 10));
	KickTarget.KAddImpulse(ImpactVector, KickLocation);
	Acceleration = vect(0,0,0);
	Velocity = vect(0,0,0);
	if ( UM_KFMonsterController(Controller) != None )
		UM_KFMonsterController(controller).GotoState('Kicking');
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
	
	if ( UM_KFMonsterController(Controller) != None )
		UM_KFMonsterController(Controller).bUseFreezeHack = True;
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
		CurrentDamtype = ZombieDamType[Rand(3)];
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
	
	// TraceThisActor returns true if did not hit this actor.
	Return !HeadBallisticCollision.TraceThisActor( TraceHitLoc, TraceHitNorm, (Loc + Ray), (Loc - Ray), TraceExtetnt );
}	*/

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
	if ( class<UM_BaseDamType_IncendiaryBullet>(damageType) != None || 
		 class<UM_BaseDamType_Flame>(damageType) != None ||
		 (class<KFWeaponDamageType>(damageType) != None && class<KFWeaponDamageType>(damageType).default.bDealBurningDamage) )
    {
        if ( BurnDown<=0 || Damage > LastBurnDamage )  {
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

		if ( class<DamTypeMAC10MPInc>(damageType) == none &&
			 class<UM_BaseDamType_IncendiaryBullet>(damageType) == none )
            Damage *= 1.5; // Increase burn damage 1.5 times, except MAC10 and all Incendiary Bullets by instatnt fire.

        // BurnDown variable indicates how many ticks are remaining for zed to burn.
        // It is 0, when zed isn't burning (or stopped burning).
        // So all the code below will be executed only, if zed isn't already burning
        if ( BurnDown <= 0 )  {
            if ( HeatAmount > 4 || Damage >= 15 )  {
                bBurnified = true;
                BurnDown = 10; // Inits burn tick count to 10
                SetGroundSpeed(GroundSpeed *= 0.80); // Lowers movement speed by 20%
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
		if ( UM_KFMonsterController(Controller) != none )
			UM_KFMonsterController(Controller).AddKillAssistant(LastDamagedBy.Controller, FMin(Health, Damage));
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
				if ( HeadHealth <= 0 || Damage > Health )
				   RemoveHead();
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

	if ( bIsHeadShot && Health <= 0 )  {
		if ( UnlimaginGameType(Level.Game) != None )
			UnlimaginGameType(Level.Game).DramaticEvent(0.03);
		else if ( KFGameType(Level.Game) != None )
			KFGameType(Level.Game).DramaticEvent(0.03);
	}

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
		UM_KFMonsterController(Controller).bUseFreezeHack = True;
		if ( Controller != None && UM_KFMonsterController(Controller) != None
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
	if ( Controller != None && UM_KFMonsterController(Controller) != None
			&& !Controller.IsInState('IamDazzled') )
		Controller.GoToState('IamDazzled');
	UM_KFMonsterController(Controller).bUseFreezeHack = True;
}

//[end] Functions
//====================================================================

defaultproperties
{
     // Monster Size
	 SizeScaleRange=(Min=0.8,Max=1.2)
	 // Monster Speed
	 SpeedScaleRange=(Min=0.85,Max=1.1)
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
	 ExtraSizeScaleRange=(Min=0.52,Max=1.25)
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
	 ControllerClass=Class'UnlimaginMod.UM_KFMonsterController'
	 // Collision flags
	 bCollideActors=True
	 bCollideWorld=True
	 bBlockActors=True
	 bBlockPlayers=True
	 bUseCylinderCollision=True
	 // This collision flags was moved to the BallisticCollision
	 bBlockProjectiles=False
	 bProjTarget=False
	 bBlockZeroExtentTraces=True
	 bBlockNonZeroExtentTraces=True
	 
	 DrawScale=1.000000
	 MeshTestCollisionHeight=50.0
	 MeshTestCollisionRadius=25.0
	 CollisionHeight=50.0
	 CollisionRadius=25.0
	 
	 PrePivot=(X=0.0,Y=0.0,Z=0.0)
}