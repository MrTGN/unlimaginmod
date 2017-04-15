//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Scrake
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:23
//================================================================================
class UM_BaseMonster_Scrake extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//========================================================================
//[block] Variables

var(Sounds) sound   SawAttackLoopSound; // THe sound for the saw revved up, looping
var(Sounds) sound   ChainSawOffSound;   //The sound of this zombie dieing without a head

var         bool    bCharging;          // Scrake charges when his health gets low
var()       float   AttackChargeRate;   // Ratio to increase scrake movement speed when charging and attacking

// Exhaust effects
var()	class<VehicleExhaustEffect>	ExhaustEffectClass; // Effect class for the exhaust emitter
var()	VehicleExhaustEffect 		ExhaustEffect;
var 		bool	bNoExhaustRespawn;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	Reliable if ( Role == ROLE_Authority && bNetDirty )
		bCharging;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostNetBeginPlay()
{
	EnableChannelNotify(1, 1);
	AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
	
	Super.PostNetBeginPlay();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	SpawnExhaustEmitter();
}

// Make the scrakes's ambient scale higher, since there are just a few, and thier chainsaw need to be heard from a distance
simulated function CalcAmbientRelevancyScale()
{
	   // Make the zed only relevant by thier ambient sound out to a range of 30 meters
	CustomAmbientRelevancyScale = 1500 / (100 * SoundRadius);
}

simulated event PostNetReceive()
{
	if ( bCharging )
		MovementAnims[0]='ChargeF';
	else if( !(bCrispified && bBurnified) )
		MovementAnims[0] = default.MovementAnims[0];
}

// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
	if ( bNewMindControlled )  {
		NumZCDHits++;
		// if we hit him a couple of times, make him rage!
		if ( NumZCDHits > 1 )  {
			if ( !IsInState('RunningToMarker') )
				GotoState('RunningToMarker');
			else  {
				NumZCDHits = 1;
				if( IsInState('RunningToMarker') )
					GotoState('');
			}
		}
		else if( IsInState('RunningToMarker') )
			GotoState('');

		if ( bNewMindControlled != bZedUnderControl )  {
			SetGroundSpeed(OriginalGroundSpeed * 1.25);
			Health *= 1.25;
			HealthMax *= 1.25;
		}
	}
	else
		NumZCDHits = 0;

	bZedUnderControl = bNewMindControlled;
}

// Handle the zed being commanded to move to a new location
function GivenNewMarker()
{
	if( bCharging && NumZCDHits > 1  )
		GotoState('RunningToMarker');
	else
		GotoState('');
}

simulated function SetBurningBehavior()
{
	// If we're burning stop charging
	if ( Role == Role_Authority && IsInState('RunningState') )  {
		Super.SetBurningBehavior();
		GotoState('');
	}
	else
		Super.SetBurningBehavior();
}

simulated function SpawnExhaustEmitter()
{
	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExhaustEffectClass != None )  {
			ExhaustEffect = Spawn(ExhaustEffectClass, self);
			if ( ExhaustEffect != None )  {
				AttachToBone(ExhaustEffect, 'Chainsaw_lod1');
				ExhaustEffect.SetRelativeLocation(vect(0, -20, 0));
			}
		}
	}
}

simulated function UpdateExhaustEmitter()
{
	local byte Throttle;

	if ( Level.NetMode != NM_DedicatedServer )  {
		if ( ExhaustEffect != None )  {
			if ( bShotAnim )
				Throttle = 3;
			else
				Throttle = 0;
		}
		else if ( !bNoExhaustRespawn )
			SpawnExhaustEmitter();
	}
}

simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	UpdateExhaustEmitter();
}

function RangedAttack(Actor A)
{
	local	int		RandIndex;
	
	if ( bShotAnim || Physics == PHYS_Swimming )
		Return;
	else if ( CanAttack(A) )  {
		bShotAnim = True;
		RandIndex = Rand(3);
		CurrentDamType = ZombieDamType[RandIndex];
		SetAnimAction(MeleeAnims[RandIndex]);
		//PlaySound(sound'Claw2s', SLOT_None); KFTODO: Replace this
		GoToState('SawingLoop');
	}

	if ( !bShotAnim && !bDecapitated )  {
		if ( Level.Game.GameDifficulty < 5.0 )  {
			if ( (float(Health) / HealthMax) < 0.5 )
				GoToState('RunningState');
		}
		else  if ( (float(Health) / HealthMax) < 0.75 ) // Changed Rage Point from 0.5 to 0.75 in Balance Round 1(applied to only Suicidal and HoE in Round 7)
				GoToState('RunningState');
	}
}

state RunningState
{
	// Set the zed to the zapped behavior
	simulated function SetZappedBehavior()
	{
		Global.SetZappedBehavior();
		GoToState('');
	}

	// Don't override speed in this state
	function bool CanSpeedAdjust()
	{
		Return False;
	}

	event BeginState()
	{
		if ( bZapped )
			GoToState('');
		else  {
			SetGroundSpeed(OriginalGroundSpeed * 3.5);
			bCharging = True;
			if ( Level.NetMode != NM_DedicatedServer )
				PostNetReceive();

			NetUpdateTime = Level.TimeSeconds - 1;
		}
	}

	event EndState()
	{
		if ( !bZapped )
			SetGroundSpeed(GetOriginalGroundSpeed());

		bCharging = False;
		if ( Level.NetMode != NM_DedicatedServer )
			PostNetReceive();
	}

	function RemoveHead()
	{
		Global.RemoveHead();
		GoToState('');
	}

	function RangedAttack(Actor A)
	{
		local	int		RandIndex;
		
		if ( bShotAnim || Physics == PHYS_Swimming )
			Return;
		else if ( CanAttack(A) )  {
			bShotAnim = True;
			RandIndex = Rand(3);
			CurrentDamType = ZombieDamType[RandIndex];
			SetAnimAction(MeleeAnims[RandIndex]);
			GoToState('SawingLoop');
		}
	}
}

// State where the zed is charging to a marked location.
// Not sure if we need this since its just like RageCharging,
// but keeping it here for now in case we need to implement some
// custom behavior for this state
state RunningToMarker extends RunningState
{
}


State SawingLoop
{
	// Don't override speed in this state
	function bool CanSpeedAdjust()
	{
		Return False;
	}

	function bool CanGetOutOfWay()
	{
		Return False;
	}

	event BeginState()
	{
		local float ChargeChance, RagingChargeChance;

		// Decide what chance the scrake has of charging during an attack
		if ( Level.Game.GameDifficulty < 2.0 )  {
			ChargeChance = 0.25;
			RagingChargeChance = 0.5;
		}
		else if ( Level.Game.GameDifficulty < 4.0 )  {
			ChargeChance = 0.5;
			RagingChargeChance = 0.70;
		}
		else if ( Level.Game.GameDifficulty < 5.0 )  {
			ChargeChance = 0.65;
			RagingChargeChance = 0.85;
		}
		// Hardest difficulty
		else  {
			ChargeChance = 0.95;
			RagingChargeChance = 1.0;
		}

		// Randomly have the scrake charge during an attack so it will be less predictable
		if ( ((Health / HealthMax) < 0.5 && FRand() <= RagingChargeChance) || FRand() <= ChargeChance )  {
			SetGroundSpeed(OriginalGroundSpeed * AttackChargeRate);
			bCharging = True;
			if ( Level.NetMode != NM_DedicatedServer )
				PostNetReceive();
			NetUpdateTime = Level.TimeSeconds - 1.0;
		}
	}

	function RangedAttack(Actor A)
	{
		if ( bShotAnim )
			Return;
		else if ( CanAttack(A) )  {
			Acceleration = vect(0,0,0);
			bShotAnim = True;
			MeleeDamage = default.MeleeDamage * 0.6;
			SetAnimAction('SawImpaleLoop');
			CurrentDamType = ZombieDamType[0];
			if ( AmbientSound != SawAttackLoopSound )
				AmbientSound = SawAttackLoopSound;
		}
		else 
			GoToState('');
	}
	
	event AnimEnd( int Channel )
	{
		Super.AnimEnd(Channel);
		if ( Controller != None && Controller.Enemy != None )
			RangedAttack(Controller.Enemy); // Keep on attacking if possible.
	}

	event Tick( float DeltaTime )
	{
		// Keep the scrake moving toward its target when attacking
		if ( Role == ROLE_Authority && bShotAnim && !bWaitForAnim && LookTarget != None )
			Acceleration = AccelRate * Normal(LookTarget.Location - Location);

		Global.Tick( DeltaTime );
	}

	event EndState()
	{
		AmbientSound = default.AmbientSound;
		MeleeDamage = default.MeleeDamage;

		SetGroundSpeed(GetOriginalGroundSpeed());
		bCharging = False;
		if ( Level.NetMode != NM_DedicatedServer )
			PostNetReceive();
	}
}

// Added in Balance Round 1 to reduce the headshot damage taken from Crossbows
function int ProcessTakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType )
{
	local bool bIsHeadShot;

	bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);
	if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != None || class<DamTypeCrossbowHeadShot>(damageType) != None) )  {
		Damage *= 0.5; // Was 0.5 in Balance Round 1, then 0.6 in Round 2, back to 0.5 in Round 3
	}

	Damage = Super.ProcessTakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );

	// Added in Balance Round 3 to make the Scrake "Rage" more reliably when his health gets low(limited to Suicidal and HoE in Round 7)
	if ( InstigatedBy != None && Level.Game.GameDifficulty >= 5.0 && !IsInState('SawingLoop') && !IsInState('RunningState') && (float(Health) / HealthMax) < 0.75 )
		RangedAttack(InstigatedBy);

	//No needed this block in UnlimaginMod
	/*
	if ( damageType == class'DamTypeDBShotgun' )  {
		PC = PlayerController( InstigatedBy.Controller );
		if ( PC != None )  {
		    Stats = KFSteamStatsAndAchievements( PC.SteamStatsAndAchievements );
		    if( Stats != None )
		        Stats.CheckAndSetAchievementComplete( Stats.KFACHIEVEMENT_PushScrakeSPJ );
		}
	} */
	Return Damage;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	local int StunChance;

	StunChance = rand(5);

	if ( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
		Return;

	if( (Level.Game.GameDifficulty < 5.0 || StunsRemaining != 0) 
		 && (Damage >= 150 || (DamageType.name == 'DamTypeStunNade' && StunChance > 3) 
			 || (DamageType.name == 'DamTypeCrossbowHeadshot' && Damage >= 200)) )
		PlayDirectionalHit(HitLocation);

	LastPainAnim = Level.TimeSeconds;

	if ( (Level.TimeSeconds - LastPainSound) < MinTimeBetweenPainSounds )
		Return;

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == 'SawZombieAttack1' || AnimName == 'SawZombieAttack2' )  {
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);
		Return 1;
	}
	else
		Return Super.DoAnimAction(AnimName);
}

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
	if ( TestAnim == 'SawImpaleLoop' || TestAnim == 'DoorBash' || TestAnim == 'KnockDown' )
		Return True;
	else
		Return False;
}

function PlayDyingSound()
{
	if ( Level.NetMode != NM_Client )  {
		if ( bGibbed )  {
			// Do nothing for now
			PlaySound(GibGroupClass.static.GibSound(), SLOT_Pain,2.0,True,525);
			Return;
		}

		if ( bDecapitated )
			PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,True,525);
		else
			PlaySound(DeathSound[0], SLOT_Pain,1.30,True,525);

		PlaySound(ChainSawOffSound, SLOT_Misc, 2.0,,525.0);
	}
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	AmbientSound = None;

	if ( ExhaustEffect != None )  {
		ExhaustEffect.Destroy();
		ExhaustEffect = None;
		bNoExhaustRespawn = True;
	}

	Super.Died( Killer, DamageType, HitLocation );
}

simulated function ProcessHitFX()
{
	local Coords boneCoords;
	local class<xEmitter> HitEffects[4];
	local int i,j;
	local float GibPerterbation;

	if( Level.NetMode == NM_DedicatedServer || bSkeletized || Mesh == SkeletonMesh )  {
		SimHitFxTicker = HitFxTicker;
		Return;
	}

	for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )  {
		j++;
		if ( j > 30 )  {
			SimHitFxTicker = HitFxTicker;
			Return;
		}

		if ( HitFX[SimHitFxTicker].damtype == None 
			|| (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime) > 3 && !IsHumanControlled()) )
			Continue;

		//log("Processing effects for damtype "$HitFX[SimHitFxTicker].damtype);

		if ( HitFX[SimHitFxTicker].bone == 'obliterate' && !class'GameInfo'.static.UseLowGore() )  {
			SpawnGibs( HitFX[SimHitFxTicker].rotDir, 1);
			bGibbed = True;
			// Wait a tick on a listen server so the obliteration can replicate before the pawn is destroyed
			if ( Level.NetMode == NM_ListenServer )  {
				bDestroyNextTick = True;
				TimeSetDestroyNextTickTime = Level.TimeSeconds;
			}
			else
				Destroy();
			Return;
		}

		boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );

		if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() && !bSkeletized && !class'GameInfo'.static.UseLowGore() )  {
			//AttachEmitterEffect( BleedingEmitterClass, HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
			HitFX[SimHitFxTicker].damtype.static.GetHitEffects( HitEffects, Health );
			// don't attach effects under water
			if ( !PhysicsVolume.bWaterVolume )  {
				for( i = 0; i < ArrayCount(HitEffects); i++ )  {
					if ( HitEffects[i] == None )
						Continue;
					AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
				}
			}
		}
		
		if ( class'GameInfo'.static.UseLowGore() )
			HitFX[SimHitFxTicker].bSever = False;

		if( HitFX[SimHitFxTicker].bSever )  {
			GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;

			switch( HitFX[SimHitFxTicker].bone )  {
				case 'obliterate':
					Break;

				case LeftThighBone:
					if( !bLeftLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftLegGibbed=True;
					}
					Break;

				case RightThighBone:
					if( !bRightLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightLegGibbed=True;
					}
					Break;

				case LeftFArmBone:
					if( !bLeftArmGibbed )  {
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftArmGibbed=True;
					}
					Break;

				case RightFArmBone:
					if( !bRightArmGibbed )  {
	                    SpawnSeveredGiblet( DetachedSpecialArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightArmGibbed=True;
					}
					Break;

				case 'head':
					if( !bHeadGibbed )  {
						if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False, True);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, True);

						bHeadGibbed = True;
					}
					Break;
			}


			if ( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone && HitFX[SimHitFXTicker].bone != 'head' && Health < 1 )
				HideBone(HitFX[SimHitFxTicker].bone);
		}
	}
}

// Maybe spawn some chunks when the player gets obliterated
simulated function SpawnGibs(Rotator HitRotation, float ChunkPerterbation)
{
	if ( ExhaustEffect != None )  {
		ExhaustEffect.Destroy();
		ExhaustEffect = None;
		bNoExhaustRespawn = True;
	}

	Super.SpawnGibs(HitRotation,ChunkPerterbation);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 KnockedDownHealthPct=0.7
	 KilledWaveCountDownExtensionTime=10.0
	 ImpressiveKillChance=0.5
	 
	 HeadShotSlowMoChargeBonus=0.35
	 
	 AttackChargeRate=2.500000
	 ExhaustEffectClass=Class'KFMod.ChainsawExhaust'
	 
	 StunsRemaining=1
	 BleedOutDuration=6.000000
	 ZapThreshold=1.250000
	 ZappedDamageMod=1.250000
	 bHarpoonToBodyStuns=False
	 DamageToMonsterScale=8.000000
	 ZombieFlag=3
	 MeleeDamage=20
	 damageForce=-75000
	 bFatAss=True
	 KFRagdollName="Scrake_Trip"
	 
	 bMeleeStunImmune=True
	 Intelligence=BRAINS_Mammal
	 SeveredArmAttachScale=1.100000
	 SeveredLegAttachScale=1.100000
	 PoundRageBumpDamScale=0.010000
	 MotionDetectorThreat=3.000000
	 ScoringValue=75
	 IdleHeavyAnim="SawZombieIdle"
	 IdleRifleAnim="SawZombieIdle"
	 MeleeRange=40.000000
	 GroundSpeed=85.000000
	 WaterSpeed=75.000000
	 HeadHeight=2.200000
	 MenuName="Scrake"
	 
	 // MeleeAnims
	 MeleeAnims(0)="SawZombieAttack1"
	 MeleeAnims(1)="SawZombieAttack2"
	 MeleeAnims(2)="SawZombieAttack1"
	 // MovementAnims
	 MovementAnims(0)="SawZombieWalk"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 // WalkAnims
	 WalkAnims(0)="SawZombieWalk"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Headless"
     HeadlessWalkAnims(1)="WalkB_Headless"
     HeadlessWalkAnims(2)="WalkF_Headless"
     HeadlessWalkAnims(3)="WalkF_Headless"
	 // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_Fire"
     BurningWalkFAnims(2)="WalkF_Fire"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
	 // IdleAnim
	 IdleCrouchAnim="SawZombieIdle"
	 IdleWeaponAnim="SawZombieIdle"
	 IdleRestAnim="SawZombieIdle"
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=1050.0
     Health=1050
	 HeadHealth=650.0
	 //PlayerCountHealthScale=0.500000
	 //PlayerNumHeadHealthScale=0.300000
	 PlayerCountHealthScale=0.4
	 PlayerNumHeadHealthScale=0.3
	 Mass=420.000000
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=7.0,AreaHeight=7.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-2.4,Z=0.0),AreaImpactStrength=10.0)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=20.0,AreaHeight=44.4,AreaImpactStrength=14.4)
}
