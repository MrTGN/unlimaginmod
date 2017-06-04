//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Crawler
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:10
//================================================================================
class UM_BaseMonster_Crawler extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//========================================================================
//[block] Variables

var()			float						PounceSpeed;
var				bool						bPouncing;

var(Anims)		name						MeleeAirAnims[3]; // Attack anims for when flying through the air

var				bool						bPoisonous;
var				float						PoisonousChance;
var(Display)	Material					PoisonousMaterial;
var				class<DamTypeZombieAttack>	PoisonDamageType;
var				range						PoisonDamageRandRange;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetInitial )
		bPoisonous;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	// Randomizing PounceSpeed
	if ( Level.Game != None && !bDiffAdjusted )
		PounceSpeed *= Lerp( FRand(), 0.9, 1.1 );
	
	Super.PostBeginPlay();
	
	// Server only next
	if ( Role < ROLE_Authority )
		Return;
	
	if ( FRand() <= PoisonousChance )  {
		bPoisonous = True;
		CurrentDamtype = PoisonDamageType;
		PoisonDamageRandRange.Min *= DifficultyDamageModifer();
		PoisonDamageRandRange.Max *= DifficultyDamageModifer();
		SetOverlayMaterial(PoisonousMaterial, 1800.0, False); // 30 minutes
	}
	else
		CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
}

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( bPoisonous )
		MenuName = "Poisonous" @ MenuName;
}

function bool DoPounce()
{
	if ( bZapped || bIsCrouched || bWantsToCrouch || Physics != PHYS_Walking || 
		 VSize(Location - Controller.Target.Location) > (MeleeRange * 5.0) )
		Return False;

	bPouncing = True;
	Velocity = Normal(Controller.Target.Location - Location) * PounceSpeed;
	Velocity.Z = JumpZ;
	SetPhysics(PHYS_Falling);
	ZombieSpringAnim();
	
	Return True;
}

simulated function ZombieSpringAnim()
{
	SetAnimAction('ZombieSpring');
}

event Landed(vector HitNormal)
{
	Super.Landed(HitNormal);
	bPouncing = False;
}

event Bump(actor Other)
{
	if ( bPouncing && KFHumanPawn(Other) != None )  {
		if ( bPoisonous )
			KFHumanPawn(Other).TakeDamage( Lerp(FRand(), PoisonDamageRandRange.Min, PoisonDamageRandRange.Max), self, Location, Velocity, PoisonDamageType );
		else if ( CurrentDamtype != None )
			KFHumanPawn(Other).TakeDamage( (MeleeDamage * Lerp(FRand(), 0.95, 1.05)), self, Location, Velocity, CurrentDamtype );
		else
			KFHumanPawn(Other).TakeDamage( (MeleeDamage * Lerp(FRand(), 0.95, 1.05)), self, Location, Velocity, ZombieDamType[Rand(ArrayCount(ZombieDamType))] );
		//TODO - move this to humanpawn.takedamage? Also see KFMonster.MeleeDamageTarget
		if ( KFHumanPawn(Other).Health <= 0 )
			KFHumanPawn(Other).SpawnGibs(Rotation, 1);
		//After impact, there'll be no momentum for further bumps
		bPouncing = True;
	}
}

// Blend his attacks so he can hit you in mid air.
simulated function int DoAnimAction( name AnimName )
{
    if ( AnimName == 'InAir_Attack1' || AnimName == 'InAir_Attack2' )  {
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.0, 1);
		Return 1;
	}
	
    if ( AnimName == 'HitF' )  {
		AnimBlendParams(1, 1.0, 0.0,, NeckBone);
		PlayAnim(AnimName,, 0.0, 1);
		Return 1;
	}

	if ( AnimName == 'ZombieSpring' )  {
        PlayAnim(AnimName,,0.02);
        Return 0;
	}

	Return Super.DoAnimAction(AnimName);
}

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == '' )
		Return;

	if ( NewAction == 'DoorBash' )  {
		if ( bPoisonous )
			CurrentDamtype = PoisonDamageType;
		else
			CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
	}
	else if ( NewAction == 'Claw' )  {
		if ( bPoisonous )
			CurrentDamtype = PoisonDamageType;
		else
			CurrentDamtype = ZombieDamType[Rand(ArrayCount(ZombieDamType))];
		if ( Physics == PHYS_Falling )
			NewAction = MeleeAirAnims[Rand(ArrayCount(MeleeAirAnims))];
		else
			NewAction = MeleeAnims[Rand(ArrayCount(MeleeAnims))];
	}
	
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

// The animation is full body and should set the bWaitForAnim flag
simulated function bool AnimNeedsWait(name TestAnim)
{
    if ( TestAnim == 'ZombieSpring' || TestAnim == 'DoorBash' )
        Return True;

    Return True;
}

//[end] Functions
//====================================================================

defaultproperties
{
	 KnockDownHealthPct=0.0
	 ExplosiveKnockDownHealthPct=0.6
	 
	 KilledExplodeChance=0.25
	 ExplosionDamage=180
	 ExplosionDamageType=Class'DamTypeFrag'
	 ExplosionRadius=280.0
	 ExplosionMomentum=8000.0
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Weak'
	 
	 ImpressiveKillChance=0.05
	 
	 HeadShotSlowMoChargeBonus=0.25
	 
	 PoisonousChance=0.25
	 //PoisonousMaterial=ConstantColor'KillingFloorLabTextures.Statics.elevater_glow'
	 //PoisonousMaterial=FinalBlend'kf_fx_trip_t.siren.siren_scream_fb'
	 PoisonousMaterial=Combiner'kf_fx_trip_t.siren.siren_scream_cmb'
	 PoisonDamageType=Class'UnlimaginMod.UM_ZombieDamType_CrawlerPoison'
	 PoisonDamageRandRange=(Min=6.0,Max=8.0)
	 AlphaSpeedChance=0.25
	 AlphaSpeedScaleRange=(Min=1.2,Max=2.4)
	 // Extra Sizes
	 ExtraSizeScaleRange=(Min=0.52,Max=1.3)
	 ZombieDamType(0)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
     ZombieDamType(1)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
     ZombieDamType(2)=Class'UnlimaginMod.UM_ZombieDamType_CrawlerMelee'
	 PounceSpeed=330.000000
     bStunImmune=True
     bCannibal=True
     ZombieFlag=2
     MeleeDamage=6
     damageForce=5000
     KFRagdollName="Crawler_Trip"
     CrispUpThreshhold=10
     Intelligence=BRAINS_Mammal
	 AlphaIntelligence=BRAINS_Human
     SeveredArmAttachScale=0.800000
     SeveredLegAttachScale=0.850000
     SeveredHeadAttachScale=1.100000
     MotionDetectorThreat=0.340000
     ScoringValue=10
     IdleHeavyAnim="ZombieLeapIdle"
     IdleRifleAnim="ZombieLeapIdle"
     bCrawler=True
     GroundSpeed=140.000000
     WaterSpeed=130.000000

	 // JumpZ
	 JumpZ=350.0
	 JumpSpeed=200.0
	 AirControl=0.25
     HeadHeight=2.500000
     HeadScale=1.050000
     MenuName="Crawler"
     bDoTorsoTwist=False
	 // MeleeAirAnims
	 MeleeAirAnims(0)="InAir_Attack1"
     MeleeAirAnims(1)="InAir_Attack2"
	 MeleeAirAnims(2)="InAir_Attack1"
     // MeleeAnims
	 MeleeAnims(0)="ZombieLeapAttack"
     MeleeAnims(1)="ZombieLeapAttack2"
	 MeleeAnims(2)="ZombieLeapAttack"
     // HitAnims
	 HitAnims(0)="HitF"
     HitAnims(1)="HitF"
	 HitAnims(2)="HitF"
     KFHitFront="HitF"
     KFHitBack="HitF"
     KFHitLeft="HitF"
     KFHitRight="HitF"
	 // MovementAnims
	 MovementAnims(0)="ZombieScuttle"
     MovementAnims(1)="ZombieScuttleB"
     MovementAnims(2)="ZombieScuttleL"
     MovementAnims(3)="ZombieScuttleR"
     // WalkAnims
	 WalkAnims(0)="ZombieScuttle"
     WalkAnims(1)="ZombieScuttleB"
     WalkAnims(2)="ZombieScuttleL"
     WalkAnims(3)="ZombieScuttleR"
	 // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_Fire"
     BurningWalkFAnims(2)="WalkF_Fire"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkF_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
     // AirAnims
	 AirAnims(0)="ZombieSpring"
     AirAnims(1)="ZombieSpring"
     AirAnims(2)="ZombieSpring"
     AirAnims(3)="ZombieSpring"
	 // TakeoffAnims
     TakeoffAnims(0)="ZombieSpring"
     TakeoffAnims(1)="ZombieSpring"
     TakeoffAnims(2)="ZombieSpring"
     TakeoffAnims(3)="ZombieSpring"
	 // DoubleJumpAnims
	 DoubleJumpAnims(0)="ZombieSpring"
     DoubleJumpAnims(1)="ZombieSpring"
     DoubleJumpAnims(2)="ZombieSpring"
     DoubleJumpAnims(3)="ZombieSpring"
     AirStillAnim="ZombieSpring"
     TakeoffStillAnim="ZombieLeapIdle"
     IdleCrouchAnim="ZombieLeapIdle"
     IdleWeaponAnim="ZombieLeapIdle"
     IdleRestAnim="ZombieLeapIdle"
     bOrientOnSlope=True
	 
	 GibbedDeathSound=SoundGroup'KF_EnemyGlobalSnd.Gibs_Small'
	 
	 HealthMax=70.0
	 Health=70
	 HeadHealth=25.0
	 DecapitatedRandDamage=(Min=8.0,Max=16.0)
	 //PlayerCountHealthScale=0.0
     PlayerCountHealthScale=0.0
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.0
	 Mass=100.000000
}
