//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_FleshPound
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:12
//================================================================================
class UM_BaseMonster_FleshPound extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//========================================================================
//[block] Variables

var()	float					BlockDamageReduction;
var		bool					bChargingPlayer, bClientCharge;
var		int						TwoSecondDamageTotal;
var		float					LastDamagedTime, RageEndTime;

var()	vector					RotMag;						// how far to rot view
var()	vector					RotRate;				// how fast to rot view
var()	float					RotTime;				// how much time to rot the instigator's view
var()	vector					OffsetMag;			// max view offset vertically
var()	vector					OffsetRate;				// how fast to offset view vertically
var()	float					OffsetTime;				// how much time to offset view

var		name					ChargingAnim;		// How he runs when charging the player.

//var ONSHeadlightCorona DeviceGlow; //KFTODO: Don't think this is needed, its not reffed anywhere

var()	int						RageDamageThreshold;  // configurable.
var(Display) array<Material> 	RageSkins;

var 	FleshPoundAvoidArea		AvoidArea;  // Make the other AI fear this AI

var		bool					bFrustrated;        // The fleshpound is tired of being kited and is pissed and ready to attack

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bChargingPlayer, bFrustrated;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	// Randomizing RageDamageThreshold
	if ( Level.Game != None && !bDiffAdjusted )
		RageDamageThreshold *= Lerp( FRand(), 0.95, 1.05 );
		
	Super.PostBeginPlay();
}

simulated event PostNetBeginPlay()
{
	if ( AvoidArea == None )
		AvoidArea = Spawn(class'FleshPoundAvoidArea',self);
	
	if ( AvoidArea != None )
		AvoidArea.InitFor(Self);

	EnableChannelNotify(1, 1);
	AnimBlendParams(1, 1.0, 0.0,, SpineBone1);
	
	Super.PostNetBeginPlay();
}

// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
    if ( bNewMindControlled )  {
        NumZCDHits++;
        // if we hit him a couple of times, make him rage!
        if ( NumZCDHits > 1 )  {
            if ( !IsInState('ChargeToMarker') )
                GotoState('ChargeToMarker');
            else  {
                NumZCDHits = 1;
                if ( IsInState('ChargeToMarker') )
                    GotoState('');
            }
        }
        else if( IsInState('ChargeToMarker') )
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
    if ( bChargingPlayer && NumZCDHits > 1  )
        GotoState('ChargeToMarker');
    else
        GotoState('');
}

// Important Block of code controlling how the Zombies (excluding the Bloat and Fleshpound who cannot be stunned, respond to damage from the
// various weapons in the game. The basic rule is that any damage amount equal to or greater than 40 points will cause a stun.
// There are exceptions with the fists however, which are substantially under the damage quota but can still cause stuns 50% of the time.
// Why? Cus if they didn't at least have that functionality, they would be fundamentally useless. And anyone willing to take on a hoarde of zombies
// with only the gloves on his hands, deserves more respect than that!
function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
	if ( Level.TimeSeconds - LastPainAnim < MinTimeBetweenPainAnims )
		Return;

    // Don't interrupt the controller if its waiting for an animation to end
    if ( !Controller.IsInState('WaitForAnim') && Damage >= 10 )
        PlayDirectionalHit(HitLocation);

	LastPainAnim = Level.TimeSeconds;

	if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
		Return;

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

function int AdjustTakenDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, bool bIsHeadShot )
{
	if ( Level.TimeSeconds > LastDamagedTime )
		TwoSecondDamageTotal = 0;
	
	LastDamagedTime = Level.TimeSeconds + 2.0;
	/* A little extra damage from the grenade launchers, they are HE not shrapnel,
		and its shrapnel that REALLY hurts the FP ;) 
		Frags and LAW rockets will bring him down way faster than bullets and shells. */
	if ( Class<UM_BaseDamType_Explosive>(DamageType) != None || DamageType == class'DamTypeLaw' || DamageType == class'DamTypeM79Grenade' || DamageType == class'DamTypeM32Grenade' || DamageType == class'DamTypeM203Grenade' || DamageType == class 'DamTypeSPGrenade' || DamageType == class 'DamTypeSealSquealExplosion' || DamageType == class 'DamTypeSeekerSixRocket' )
		Damage = Round( float(Damage) * 1.25 );
	// double damage from handheld explosives or poison
	else if ( DamageType == class'DamTypeFrag' || DamageType == class'DamTypePipeBomb' || DamageType == class'DamTypeMedicNade' )
        Damage = Round( float(Damage) * 2.0 );
	// He takes less damage to small arms fire (non explosives)
	else if ( bIsHeadShot && class<KFWeaponDamageType>(DamageType) != None && class<KFWeaponDamageType>(DamageType).default.HeadShotDamageMult >= 1.5 )
		Damage = Round( float(Damage) * 0.75 ); // Don't reduce the damage so much if its a high headshot damage weapon
	else if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(DamageType) != None || class<DamTypeCrossbowHeadShot>(DamageType) != None) )
		Damage = Round( float(Damage) * 0.4 );
	// Reduced damage from the blower thrower bile, but lets not zero it out entirely
	else if( DamageType == class 'DamTypeBlowerThrower' )
		Damage = Round( float(Damage) * 0.25 );
	else if ( DamageType == class'DamTypeVomit' )
		Return 0; // nulled
	else
		Damage = Round( float(Damage) * 0.55 );
	
	if ( AnimAction == 'PoundBlock' )
		Damage = Round( float(Damage) * BlockDamageReduction );
	
	if ( Damage < 1 )
		Return 0;
	
	// Shut off his "Device" when dead
	if ( Damage >= Health )
		PostNetReceive();
	
	TwoSecondDamageTotal += Damage;
	if ( !bDecapitated && TwoSecondDamageTotal > RageDamageThreshold && !bChargingPlayer && !bZapped && (!(bCrispified && bBurnified) || bFrustrated) )
		StartCharging();
	
	Return Damage;
}

// changes colors on Device (notified in anim)
simulated function DeviceGoRed()
{
	Skins = RageSkins;
}

simulated function DeviceGoNormal()
{
    Skins = default.Skins;
}

// Sets the FP in a berserk charge state until he either strikes his target, or hits timeout
function StartCharging()
{
    local float RageAnimDur;

	if ( Health <= 0 )
        Return;
	
	SetAnimAction('PoundRage');
	Acceleration = vect(0,0,0);
	bShotAnim = True;
	Velocity.X = 0;
	Velocity.Y = 0;
	Controller.GoToState('WaitForAnim');
	UM_MonsterController(Controller).bUseFreezeHack = True;
	RageAnimDur = GetAnimDuration('PoundRage');
    UM_ZombieFleshPoundController(Controller).SetPoundRageTimout(RageAnimDur);
	GoToState('BeginRaging');
}

state BeginRaging
{
    Ignores StartCharging;

    // Set the zed to the zapped behavior
    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
        GoToState('');
    }

    function bool CanGetOutOfWay()
	{
		Return False;
	}

    simulated function bool HitCanInterruptAction()
	{
		Return False;
	}

	event Tick( float DeltaTime )
	{
        Acceleration = vect(0,0,0);
        Global.Tick( DeltaTime );
	}

Begin:
    Sleep(GetAnimDuration('PoundRage'));
    GotoState('RageCharging');
}


simulated function SetBurningBehavior()
{
    if ( bFrustrated || bChargingPlayer )
        Return;

    Super.SetBurningBehavior();
}

state RageCharging
{
Ignores StartCharging;

    // Set the zed to the zapped behavior
    simulated function SetZappedBehavior()
    {
        Global.SetZappedBehavior();
       	GoToState('');
    }

    function PlayDirectionalHit(Vector HitLoc)
    {
        if ( !bShotAnim )
            Super.PlayDirectionalHit(HitLoc);
    }

    function bool CanGetOutOfWay()
    {
        Return False;
    }

    // Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        Return False;
    }

	event BeginState()
	{
        local float DifficultyModifier;

		if ( bZapped )
            GoToState('');
        else  {
            bChargingPlayer = True;
    		if ( Level.NetMode != NM_DedicatedServer )
    			ClientChargingAnims();

            // Scale rage length by difficulty
            if( Level.Game.GameDifficulty < 2.0 )
                DifficultyModifier = 0.85;
            else if( Level.Game.GameDifficulty < 4.0 )
                DifficultyModifier = 1.0;
            else if( Level.Game.GameDifficulty < 5.0 )
                DifficultyModifier = 1.25;
            // Hardest difficulty
			else
                DifficultyModifier = 3.0; // Doubled Fleshpound Rage time for Suicidal and HoE in Balance Round 1

    		RageEndTime = (Level.TimeSeconds + 5 * DifficultyModifier) + (FRand() * 6 * DifficultyModifier);
    		NetUpdateTime = Level.TimeSeconds - 1;
		}
	}

	event EndState()
	{
        bChargingPlayer = False;
        bFrustrated = False;

        UM_ZombieFleshPoundController(Controller).RageFrustrationTimer = 0;

		if ( Health > 0 && !bZapped )
			SetGroundSpeed(GetOriginalGroundSpeed());

		if ( Level.NetMode != NM_DedicatedServer )
			ClientChargingAnims();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	event Tick( float DeltaTime )
	{
		if ( !bShotAnim )  {
			SetGroundSpeed(OriginalGroundSpeed * 2.3);	//2.0;
			if ( !bFrustrated && !bZedUnderControl && Level.TimeSeconds > RageEndTime )
            	GoToState('');
		}

        // Keep the flesh pound moving toward its target when attacking
    	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
   		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);

        Global.Tick( DeltaTime );
	}

	event Bump( Actor Other )
	{
        local float RageBumpDamage;
        local KFMonster KFMonst;

        KFMonst = KFMonster(Other);

        // Hurt/Kill enemies that we run into while raging
        if( !bShotAnim && KFMonst != None && UM_BaseMonster_FleshPound(Other) == None && Pawn(Other).Health > 0 )  {
			// Random chance of doing obliteration damage
            if ( FRand() < 0.4 )
				RageBumpDamage = 501;
			else
				RageBumpDamage = 450;

			RageBumpDamage *= KFMonst.PoundRageBumpDamScale;
			Other.TakeDamage(RageBumpDamage, self, Other.Location, Velocity * Other.Mass, class'DamTypePoundCrushed');
		}
		else 
			Global.Bump(Other);
	}
	
	// If fleshie hits his target on a charge, then he should settle down for abit.
	function bool MeleeDamageTarget(int hitdamage, vector pushdir)
	{
		local bool RetVal,bWasEnemy;

		bWasEnemy = (Controller.Target==Controller.Enemy);
		RetVal = Super.MeleeDamageTarget(hitdamage*1.75, pushdir*3);
		if ( RetVal && bWasEnemy )
			GoToState('');
		
		Return RetVal;
	}
}

// State where the zed is charging to a marked location.
// Not sure if we need this since its just like RageCharging,
// but keeping it here for now in case we need to implement some
// custom behavior for this state
state ChargeToMarker extends RageCharging
{
Ignores StartCharging;

	event Tick( float DeltaTime )
	{
		if ( !bShotAnim )  {
			SetGroundSpeed(OriginalGroundSpeed * 2.3);
			if( !bFrustrated && !bZedUnderControl && Level.TimeSeconds > RageEndTime )
            	GoToState('');
		}

        // Keep the flesh pound moving toward its target when attacking
    	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
			Acceleration = AccelRate * Normal(LookTarget.Location - Location);

        Global.Tick( DeltaTime );
	}
}

simulated event PostNetReceive()
{
	if ( bClientCharge != bChargingPlayer && !bZapped )  {
		bClientCharge = bChargingPlayer;
		if ( bChargingPlayer )  {
			MovementAnims[0] = ChargingAnim;
			MeleeAnims[0] = 'FPRageAttack';
			MeleeAnims[1] = 'FPRageAttack';
			MeleeAnims[2] = 'FPRageAttack';
			DeviceGoRed();
		}
		else  {
			MovementAnims[0] = default.MovementAnims[0];
			MeleeAnims[0] = default.MeleeAnims[0];
			MeleeAnims[1] = default.MeleeAnims[1];
			MeleeAnims[2] = default.MeleeAnims[2];
			DeviceGoNormal();
		}
	}
}

simulated function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDyingAnimation(DamageType,HitLoc);
	if ( Level.NetMode != NM_DedicatedServer )
		DeviceGoNormal();
}

simulated function ClientChargingAnims()
{
	PostNetReceive();
}

function ClawDamageTarget()
{
	local vector PushDir;
	local KFHumanPawn HumanTarget;
	local KFPlayerController HumanTargetController;
	local float UsedMeleeDamage;
	local name  Sequence;
	local float Frame, Rate;

	GetAnimParams( ExpectingChannel, Sequence, Frame, Rate );

	if ( MeleeDamage > 1 )
	   UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	else
	   UsedMeleeDamage = MeleeDamage;

    // Reduce the melee damage for anims with repeated attacks, since it does repeated damage over time
    if ( Sequence == 'PoundAttack1' )
        UsedMeleeDamage *= 0.5;
    else if( Sequence == 'PoundAttack2' )
        UsedMeleeDamage *= 0.25;

	//calculate based on relative positions
	if ( Controller != None && Controller.Target != None )
		PushDir = (damageForce * Normal(Controller.Target.Location - Location));
	//calculate based on way Monster is facing
	else
		PushDir = damageForce * vector(Rotation);

	if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )  {
		HumanTarget = KFHumanPawn(Controller.Target);
		if ( HumanTarget != None )
			HumanTargetController = KFPlayerController(HumanTarget.Controller);
		if( HumanTargetController != None )
			HumanTargetController.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 1.25);
	}
}

function SpinDamage(actor Target)
{
	local vector HitLocation;
	local Name TearBone;
	local Float dummy;
	local float DamageAmount;
	local vector PushDir;
	local KFHumanPawn HumanTarget;

	if ( Target == None )
		Return;

	PushDir = damageForce * Normal(Target.Location - Location);
	DamageAmount = SpinDamConst + Rand(SpinDamRand);

	// FLING DEM DEAD BODIEZ!
	if ( Target.IsA('KFHumanPawn') && Pawn(Target).Health <= DamageAmount )  {
		KFHumanPawn(Target).RagDeathVel *= 3;
		KFHumanPawn(Target).RagDeathUpKick *= 1.5;
	}

	if ( Target != None && Target.IsA('KFDoorMover') )  {
		if ( CurrentDamtype != None )
			Target.TakeDamage(DamageAmount , self,HitLocation, PushDir, CurrentDamtype);
		else
			Target.TakeDamage(DamageAmount , self,HitLocation, PushDir, ZombieDamType[Rand(3)]);
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 1.25);
	}

	if ( KFHumanPawn(Target) != None )  {
		HumanTarget = KFHumanPawn(Target);
		if ( HumanTarget.Controller != None )
			HumanTarget.Controller.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

		//TODO - line below was KFPawn. Does this whole block need to be KFPawn, or is it OK as KFHumanPawn?
		if ( CurrentDamtype != None )
			KFHumanPawn(Target).TakeDamage(DamageAmount, self, HitLocation, PushDir, CurrentDamtype);
		else
			KFHumanPawn(Target).TakeDamage(DamageAmount, self, HitLocation, PushDir, ZombieDamType[Rand(3)]);

		if ( KFHumanPawn(Target).Health <=0 )  {
			KFHumanPawn(Target).SpawnGibs(Rotator(PushDir), 1);
			TearBone = KFPawn(Target).GetClosestBone(HitLocation,Velocity,dummy);
			KFHumanPawn(Controller.Target).HideBone(TearBone);
		}
	}
}

simulated function int DoAnimAction( name AnimName )
{
	if( AnimName == 'PoundAttack1' || AnimName == 'PoundAttack2' || AnimName == 'PoundAttack3' || AnimName == 'FPRageAttack' || AnimName == 'ZombieFireGun' )  {
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
    if ( TestAnim == 'PoundRage' || TestAnim == 'DoorBash' )
        Return True;
	else
		Return False;
}

simulated event Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

    // Keep the flesh pound moving toward its target when attacking
	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
		Acceleration = AccelRate * Normal(LookTarget.Location - Location);
}

function bool SameSpeciesAs(Pawn P)
{
	Return ( UM_BaseMonster_FleshPound(P) != None );
}

simulated event Destroyed()
{
	if ( AvoidArea != None )
		AvoidArea.Destroy();

	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // Explosion parametrs
	 KilledExplodeChance=0.1
	 ExplosionDamage=180
	 ExplosionRadius=280.0
	 ExplosionMomentum=8000.0
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Medium'
	 
	 KnockDownHealthPct=0.75
	 ExplosiveKnockDownHealthPct=0.65
	 KilledWaveCountDownExtensionTime=12.0
	 
	 ImpressiveKillChance=1.0
	 
	 HeadShotSlowMoChargeBonus=0.5
	 
	 BlockDamageReduction=0.400000
     RotMag=(X=500.000000,Y=500.000000,Z=600.000000)
     RotRate=(X=12500.000000,Y=12500.000000,Z=12500.000000)
     RotTime=6.000000
     OffsetMag=(X=5.000000,Y=10.000000,Z=5.000000)
     OffsetRate=(X=300.000000,Y=300.000000,Z=300.000000)
     OffsetTime=3.500000
     ChargingAnim="PoundRun"
     RageDamageThreshold=360
     
     StunsRemaining=1
     BleedOutDuration=7.000000
     ZapThreshold=1.750000
     ZappedDamageMod=1.250000
     bHarpoonToBodyStuns=False
     DamageToMonsterScale=5.000000
     ZombieFlag=3
     MeleeDamage=35
     damageForce=15000
     bFatAss=True
     KFRagdollName="FleshPound_Trip"
     SpinDamConst=20.000000
     SpinDamRand=20.000000
     bMeleeStunImmune=True
     Intelligence=BRAINS_Mammal
     SeveredArmAttachScale=1.300000
     SeveredLegAttachScale=1.200000
     SeveredHeadAttachScale=1.500000
     MotionDetectorThreat=5.000000
     bBoss=True
     ScoringValue=200
     IdleHeavyAnim="PoundIdle"
     IdleRifleAnim="PoundIdle"
     RagDeathUpKick=100.000000
     MeleeRange=55.000000
     WaterSpeed=120.000000
	 GroundSpeed=130.000000
	 
	 // JumpZ
	 JumpZ=320.0
	 JumpSpeed=160.0
	 
     HeadHeight=2.500000
     HeadScale=1.300000
     MenuName="Flesh Pound"
	 // MeleeAnims
	 MeleeAnims(0)="PoundAttack1"
     MeleeAnims(1)="PoundAttack2"
     MeleeAnims(2)="PoundAttack3"
	 // MovementAnims
	 MovementAnims(0)="PoundWalk"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 // WalkAnims
     WalkAnims(0)="PoundWalk"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
     IdleCrouchAnim="PoundIdle"
     IdleWeaponAnim="PoundIdle"
     IdleRestAnim="PoundIdle"
     RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=1500.0
	 Health=1500
	 HeadHealth=700.0
	 //PlayerCountHealthScale=0.25
     PlayerCountHealthScale=0.25
	 //PlayerNumHeadHealthScale=0.3
	 PlayerNumHeadHealthScale=0.25
	 Mass=600.000000
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=8.5,AreaHeight=9.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.5,Y=-2.5,Z=0.0),AreaImpactStrength=12.6)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=26.0,AreaHeight=50.8,AreaImpactStrength=18.8)
}
