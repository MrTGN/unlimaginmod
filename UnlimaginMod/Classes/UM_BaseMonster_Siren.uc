//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Siren
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:26
//================================================================================
class UM_BaseMonster_Siren extends UM_BaseMonster
	Abstract;

//========================================================================
//[block] Variables

var () int ScreamRadius; // AOE for scream attack.

var () class <DamageType> ScreamDamageType;
var () int ScreamForce;

var(Shake)  rotator RotMag;            // how far to rot view
var(Shake)  float   RotRate;           // how fast to rot view
var(Shake)  vector  OffsetMag;         // max view offset vertically
var(Shake)  float   OffsetRate;        // how fast to offset view vertically
var(Shake)  float   ShakeTime;         // how long to shake for per scream
var(Shake)  float   ShakeFadeTime;     // how long after starting to shake to start fading out
var(Shake)  float	ShakeEffectScalar; // Overall scale for shake/blur effect
var(Shake)  float	MinShakeEffectScale;// The minimum that the shake effect drops off over distance
var(Shake)  float	ScreamBlurScale;   // How much motion blur to give from screams

var bool bAboutToDie;
var float DeathTimer;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	// Randomizing ScreamRadius
	if ( Level.Game != None && !bDiffAdjusted )
		ScreamRadius *= Lerp( FRand(), 0.9, 1.1 );
	
	Super.PostBeginPlay();
}

simulated function bool AnimNeedsWait( name TestAnim )
{
	Return False;
}

function DoorAttack( Actor A )
{
	if ( bShotAnim || Physics == PHYS_Swimming || bDecapitated || A == None )
		Return;
	
	bShotAnim = True;
	SetAnimAction('Siren_Scream');
}

function RangedAttack(Actor A)
{
	local int LastFireTime;
	local float Dist;

	if ( bShotAnim )
		Return;

	Dist = VSize(A.Location - Location);

	if ( Physics == PHYS_Swimming )  {
		SetAnimAction(MeleeAnims[Rand(3)]);
		bShotAnim = True;
		LastFireTime = Level.TimeSeconds;
	}
	else if ( Dist < (MeleeRange + CollisionRadius + A.CollisionRadius) )  {
		bShotAnim = True;
		LastFireTime = Level.TimeSeconds;
		SetAnimAction(MeleeAnims[Rand(3)]);
		//PlaySound(sound'Claw2s', SLOT_Interact); KFTODO: Replace this
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
	}
	else if ( Dist <= ScreamRadius && !bDecapitated && !bZapped )  {
		bShotAnim = True;
		SetAnimAction('Siren_Scream');
		// Only stop moving if we are close
		if ( Dist < (ScreamRadius * 0.25) )  {
			Controller.bPreparingMove = True;
			Acceleration = vect(0.0,0.0,0.0);
		}
		else
			Acceleration = AccelRate * Normal(A.Location - Location);
	}
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == 'Siren_Scream' || AnimName == 'Siren_Bite' 
		 || AnimName=='Siren_Bite2' )  {
		AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
		PlayAnim(AnimName,, 0.1, 1);
		Return 1;
	}

	PlayAnim(AnimName,,0.1);
	Return 0;
}

// Scream Time
simulated function SpawnTwoShots()
{
	if ( bZapped )
		Return;

	DoShakeEffect();

	if ( Level.NetMode != NM_Client )  {
		// Deal Actual Damage.
		if ( Controller != None && KFDoorMover(Controller.Target) != None )
			Controller.Target.TakeDamage((ScreamDamage * 0.6), Self, Location, vect(0,0,0), ScreamDamageType);
		else
			HurtRadius(ScreamDamage, ScreamRadius, ScreamDamageType, ScreamForce, Location);
	}
}

// Shake nearby players screens
simulated function DoShakeEffect()
{
	local PlayerController PC;
	local float Dist, scale, BlurScale;

	//viewshake
	if ( Level.NetMode != NM_DedicatedServer )  {
		PC = Level.GetLocalPlayerController();
		if ( PC != None && PC.ViewTarget != None )  {
			Dist = VSize(Location - PC.ViewTarget.Location);
			if ( Dist < ScreamRadius )  {
				scale = (ScreamRadius - Dist) / (ScreamRadius);
				scale *= ShakeEffectScalar;
				BlurScale = scale;

				// Reduce blur if there is something between us and the siren
				if ( !FastTrace(PC.ViewTarget.Location,Location) )  {
					scale *= 0.25;
					BlurScale = scale;
				}
				else
					scale = Lerp(scale,MinShakeEffectScale,1.0);

				PC.SetAmbientShake(Level.TimeSeconds + ShakeFadeTime, ShakeTime, OffsetMag * Scale, OffsetRate, RotMag * Scale, RotRate);

				if ( KFHumanPawn(PC.ViewTarget) != None )
					KFHumanPawn(PC.ViewTarget).AddBlur(ShakeTime, BlurScale * ScreamBlurScale);

				// 10% chance of player saying something about our scream
				if ( Level != None && Level.Game != None && KFGameType(Level.Game) != None 
					 && !KFGameType(Level.Game).bDidSirenScreamMessage && FRand() < 0.10 )  {
						PC.Speech('AUTO', 16, "");
						KFGameType(Level.Game).bDidSirenScreamMessage = True;
				}
			}
		}
	}
}

// When siren loses her head she's got nothin' Kill her.

function RemoveHead()
{
	Super.RemoveHead();
	
	if ( FRand() < 0.5 )
		KilledBy(LastDamagedBy);
	else  {
		bAboutToDie = True;
		MeleeRange = -500;
		DeathTimer = Level.TimeSeconds + 10.0 * FRand();
	}
}

simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	
	if ( bAboutToDie && Level.TimeSeconds > DeathTimer )  {
		if( Health > 0 && Level.NetMode != NM_Client )
			KilledBy(LastDamagedBy);
		bAboutToDie = False;
	}

	if ( Role == ROLE_Authority )  {
		if ( bShotAnim )  {
			SetGroundSpeed(GetOriginalGroundSpeed() * 0.65);
			if ( LookTarget != None )
			    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
		}
		else
			SetGroundSpeed(GetOriginalGroundSpeed());
	}
}

function PlayDyingSound()
{
	if ( !bAboutToDie )
		Super.PlayDyingSound();
}

simulated function ProcessHitFX()
{
	local Coords boneCoords;
	local class<xEmitter> HitEffects[4];
	local int i,j;
	local float GibPerterbation;

	if ( (Level.NetMode == NM_DedicatedServer) || bSkeletized || (Mesh == SkeletonMesh) )  {
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
			 || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime > 3) && !IsHumanControlled()) )
			Continue;

		//log("Processing effects for damtype "$HitFX[SimHitFxTicker].damtype);

		if ( HitFX[SimHitFxTicker].bone == 'obliterate' 
			 && !class'GameInfo'.static.UseLowGore() )  {
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

		if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() 
			 && !bSkeletized && !class'GameInfo'.static.UseLowGore() )  {
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

			switch( HitFX[SimHitFxTicker].bone )
			{
				case 'obliterate':
					Break;

				case LeftThighBone:
					if ( !bLeftLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftLegGibbed=True;
					}
					Break;

				case RightThighBone:
					if ( !bRightLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightLegGibbed=True;
					}
					Break;

				case LeftFArmBone:
					Break;

				case RightFArmBone:
					Break;

				case 'head':
					if ( !bHeadGibbed )  {
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


			if( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone &&
				HitFX[SimHitFXTicker].bone != LeftFArmBone && HitFX[SimHitFXTicker].bone != RightFArmBone &&
				HitFX[SimHitFXTicker].bone != 'head' && Health <=0 )
				HideBone(HitFX[SimHitFxTicker].bone);
		}
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 KilledExplodeChance=0.1
	 ExplosionDamage=140
	 ExplosionDamageType=Class'DamTypeFrag'
	 ExplosionRadius=300.0
	 ExplosionMomentum=8000.0
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Weak'
	 
	 KnockDownHealthPct=0.75
	 ExplosiveKnockDownHealthPct=0.65
	 KilledWaveCountDownExtensionTime=6.0
	 ImpressiveKillChance=0.05
	 
	 Intelligence=BRAINS_Human
	 
	 AlphaSpeedScaleRange=(Min=1.2,Max=2.5)
	 ScreamRadius=700
	 ScreamDamageType=Class'UnlimaginMod.UM_ZombieDamType_SirenScream'
	 ScreamForce=-150000
	 RotMag=(Pitch=150,Yaw=150,Roll=150)
	 RotRate=500.000000
	 OffsetMag=(Y=5.000000,Z=1.000000)
	 OffsetRate=500.000000
	 ShakeTime=2.000000
	 ShakeFadeTime=0.250000
	 ShakeEffectScalar=1.000000
	 MinShakeEffectScale=0.600000
	 ScreamBlurScale=0.850000
	 
	 ZapThreshold=0.500000
	 ZappedDamageMod=1.500000
	 ZombieFlag=1
	 MeleeDamage=13
	 damageForce=5000
	 KFRagdollName="Siren_Trip"
	 ZombieDamType(0)=Class'UnlimaginMod.UM_ZombieDamType_Slashing'
	 ZombieDamType(1)=Class'UnlimaginMod.UM_ZombieDamType_Slashing'
	 ZombieDamType(2)=Class'UnlimaginMod.UM_ZombieDamType_Slashing'
	 
	 ScreamDamage=8
	 CrispUpThreshhold=7
	 bCanDistanceAttackDoors=True
	 SeveredLegAttachScale=0.700000
	 MotionDetectorThreat=2.000000
	 ScoringValue=25
	 SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
	 IdleHeavyAnim="Siren_Idle"
	 IdleRifleAnim="Siren_Idle"
	 MeleeRange=45.000000
	 GroundSpeed=100.000000
	 WaterSpeed=80.000000
	 
	 // JumpZ
	 JumpZ=320.0
	 JumpSpeed=130.0
	 
	 HeadHeight=1.000000
	 HeadScale=1.000000
	 MenuName="Siren"
	 // MeleeAnims
	 MeleeAnims(0)="Siren_Bite"
	 MeleeAnims(1)="Siren_Bite2"
	 MeleeAnims(2)="Siren_Bite"
	 // HitAnims
	 HitAnims(0)="HitF"
     HitAnims(1)="HitF2"
     HitAnims(2)="HitF3"
	 KFHitFront="HitReactionF"
     KFHitBack="HitReactionB"
     KFHitLeft="HitReactionL"
     KFHitRight="HitReactionR"
	 // MovementAnims
	 MovementAnims(0)="Siren_Walk"
     MovementAnims(1)="Siren_Walk"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 TurnLeftAnim="TurnLeft"
     TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="Siren_Walk"
     WalkAnims(1)="Siren_Walk"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Fire"
     HeadlessWalkAnims(1)="WalkB_Fire"
     HeadlessWalkAnims(2)="WalkL_Fire"
     HeadlessWalkAnims(3)="WalkR_Fire"
     // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_Fire"
     BurningWalkFAnims(2)="WalkF_Fire"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
	 // IdleAnim
	 IdleCrouchAnim="Siren_Idle"
	 IdleWeaponAnim="Siren_Idle"
	 IdleRestAnim="Siren_Idle"
 
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=300.0
     Health=300
	 HeadHealth=200.0
	 //PlayerCountHealthScale=0.100000
	 //PlayerNumHeadHealthScale=0.050000
	 PlayerCountHealthScale=0.1
	 PlayerNumHeadHealthScale=0.05
	 Mass=100.000000 // lb (ôóíò)
	 
	 GibbedDeathSound=SoundGroup'KF_EnemyGlobalSnd.Gibs_Small'
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.5,AreaHeight=7.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=0.6,Y=-2.0,Z=0.0),AreaImpactStrength=5.6)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=14.0,AreaHeight=34.8,AreaImpactStrength=6.9)
}

