//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieFleshPound
//	Parent class:	 UM_ZombieFleshPoundBase
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:11
//================================================================================
class UM_ZombieFleshPound extends UM_ZombieFleshPoundBase;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	// Randomizing RageDamageThreshold
	if ( Level.Game != None && !bDiffAdjusted )
		RageDamageThreshold *= Lerp( FRand(), 0.9, 1.1 );
		
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
    if( bNewMindControlled )  {
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
		return;

    // Don't interrupt the controller if its waiting for an animation to end
    if ( !Controller.IsInState('WaitForAnim') && Damage >= 10 )
        PlayDirectionalHit(HitLocation);

	LastPainAnim = Level.TimeSeconds;

	if( Level.TimeSeconds - LastPainSound < MinTimeBetweenPainSounds )
		return;

	LastPainSound = Level.TimeSeconds;
	PlaySound(HitSound[0], SLOT_Pain,1.25,,400);
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	local int BlockSlip, OldHealth;
	local float BlockChance;//, RageChance;
	local Vector X,Y,Z, Dir;
	local bool bIsHeadShot;
	local float HeadShotCheckScale;

	GetAxes(Rotation, X,Y,Z);

	if ( LastDamagedTime<Level.TimeSeconds )
		TwoSecondDamageTotal = 0;
	LastDamagedTime = Level.TimeSeconds+2;
	OldHealth = Health; // Corrected issue where only the Base Health is counted toward the FP's Rage in Balance Round 6(second attempt)

    HeadShotCheckScale = 1.0;

    // Do larger headshot checks if it is a melee attach
    if ( class<DamTypeMelee>(damageType) != None )
        HeadShotCheckScale *= 1.25;

    bIsHeadShot = IsHeadShot(Hitlocation, normal(Momentum), 1.0);

	// He takes less damage to small arms fire (non explosives)
	// Frags and LAW rockets will bring him down way faster than bullets and shells.
	if ( Class<UM_BaseDamType_Explosive>(DamageType) == None
		 && DamageType != class'DamTypeFrag' && DamageType != class'DamTypeLaw' 
		 && DamageType != class'DamTypePipeBomb' && DamageType != class'DamTypeM79Grenade' 
		 && DamageType != class'DamTypeM32Grenade' && DamageType != class'DamTypeM203Grenade' 
		 && DamageType != class'DamTypeMedicNade' && DamageType != class 'DamTypeSPGrenade' 
		 && DamageType != class 'DamTypeSealSquealExplosion' 
		 && DamageType != class 'DamTypeSeekerSixRocket' )  {
		// Don't reduce the damage so much if its a high headshot damage weapon
		if ( bIsHeadShot && class<KFWeaponDamageType>(damageType) != None &&
		    class<KFWeaponDamageType>(damageType).default.HeadShotDamageMult >= 1.5 )
			Damage *= 0.75;
		else if ( Level.Game.GameDifficulty >= 5.0 && bIsHeadshot && (class<DamTypeCrossbow>(damageType) != None || class<DamTypeCrossbowHeadShot>(damageType) != None) )
			Damage *= 0.35; // was 0.3 in Balance Round 1, then 0.4 in Round 2, then 0.3 in Round 3/4, and 0.35 in Round 5
		else
			Damage *= 0.5;
	}
	// double damage from handheld explosives or poison
    else if ( DamageType == class'DamTypeFrag' || DamageType == class'DamTypePipeBomb' || DamageType == class'DamTypeMedicNade' )
        Damage *= 2.0;
    // A little extra damage from the grenade launchers, they are HE not shrapnel,
    // and its shrapnel that REALLY hurts the FP ;)
    else if ( Class<UM_BaseDamType_Explosive>(DamageType) != None
			 || DamageType == class'DamTypeM79Grenade' 
			 || DamageType == class'DamTypeM32Grenade'
			 || DamageType == class'DamTypeM203Grenade' 
			 || DamageType == class 'DamTypeSPGrenade'
			 || DamageType == class 'DamTypeSealSquealExplosion'
			 || DamageType == class 'DamTypeSeekerSixRocket' )
        Damage *= 1.25;

	// Shut off his "Device" when dead
	if ( Damage >= Health )
		PostNetReceive();

	// Damage Berserk responses...
	// Start a charge.
	// The Lower his health, the less damage needed to trigger this response.
	//RageChance = (( HealthMax / Health * 300) - TwoSecondDamageTotal );

	// Calculate whether the shot was coming from in front.
	Dir = -Normal(Location - Hitlocation);
	BlockSlip = Rand(5);

	if ( AnimAction == 'PoundBlock' )
		Damage *= BlockDamageReduction;

	if ( (Dir Dot X) > 0.7 || Dir == vect(0,0,0) )
		BlockChance = (Health / HealthMax * 100 ) - Damage * 0.25;


	// We are healthy enough to block the attack, and we succeeded the blockslip.
	// only 40% damage is done in this circumstance.
	//TODO - bring this back?

	// Log (Damage);

	if ( damageType == class'DamTypeVomit' )
		Damage = 0; // nulled
	// Reduced damage from the blower thrower bile, but lets not zero it out entirely
	else if( damageType == class 'DamTypeBlowerThrower' )
       Damage *= 0.25;
		
	Super.TakeDamage(Damage, instigatedBy, hitLocation, momentum, damageType,HitIndex) ;

	TwoSecondDamageTotal += OldHealth - Health; // Corrected issue where only the Base Health is counted toward the FP's Rage in Balance Round 6(second attempt)

	if ( !bDecapitated && TwoSecondDamageTotal > RageDamageThreshold && !bChargingPlayer 
		 && !bZapped && (!(bCrispified && bBurnified) || bFrustrated) )
		StartCharging();
}

// changes colors on Device (notified in anim)
simulated function DeviceGoRed()
{
    Skins[1] = Shader'KFCharacters.FPRedBloomShader';
}

simulated function DeviceGoNormal()
{
    Skins[1] = Shader'KFCharacters.FPAmberBloomShader';
}

// Sets the FP in a berserk charge state until he either strikes his target, or hits timeout
function StartCharging()
{
    local float RageAnimDur;

	if ( Health <= 0 )
        Return;
	SetAnimAction('PoundRage');
	Acceleration = vect(0,0,0);
	bShotAnim = true;
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

	function Tick( float Delta )
	{
        Acceleration = vect(0,0,0);
        Global.Tick(Delta);
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
        if( !bShotAnim )
            Super.PlayDirectionalHit(HitLoc);
    }

    function bool CanGetOutOfWay()
    {
        return false;
    }

    // Don't override speed in this state
    function bool CanSpeedAdjust()
    {
        return false;
    }

	function BeginState()
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

	function EndState()
	{
        bChargingPlayer = False;
        bFrustrated = false;

        UM_ZombieFleshPoundController(Controller).RageFrustrationTimer = 0;

		if( Health > 0 && !bZapped )
			SetGroundSpeed(GetOriginalGroundSpeed());

		if ( Level.NetMode != NM_DedicatedServer )
			ClientChargingAnims();

		NetUpdateTime = Level.TimeSeconds - 1;
	}

	function Tick( float Delta )
	{
		if ( !bShotAnim )  {
			SetGroundSpeed(OriginalGroundSpeed * 2.3);	//2.0;
			if ( !bFrustrated && !bZedUnderControl && Level.TimeSeconds > RageEndTime )
            	GoToState('');
		}

        // Keep the flesh pound moving toward its target when attacking
    	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
   		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);

        Global.Tick(Delta);
	}

	function Bump( Actor Other )
	{
        local float RageBumpDamage;
        local KFMonster KFMonst;

        KFMonst = KFMonster(Other);

        // Hurt/Kill enemies that we run into while raging
        if( !bShotAnim && KFMonst != None && UM_ZombieFleshPound(Other) == None && Pawn(Other).Health > 0 )  {
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

	function Tick( float Delta )
	{
		if ( !bShotAnim )  {
			SetGroundSpeed(OriginalGroundSpeed * 2.3);
			if( !bFrustrated && !bZedUnderControl && Level.TimeSeconds > RageEndTime )
            	GoToState('');
		}

        // Keep the flesh pound moving toward its target when attacking
    	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
			Acceleration = AccelRate * Normal(LookTarget.Location - Location);

        Global.Tick(Delta);
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
	if( Level.NetMode != NM_DedicatedServer )
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
	if( AnimName=='PoundAttack1' || AnimName=='PoundAttack2' || AnimName=='PoundAttack3'
        || AnimName=='FPRageAttack' || AnimName=='ZombieFireGun' )  {
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

simulated function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    // Keep the flesh pound moving toward its target when attacking
	if ( Role == ROLE_Authority && bShotAnim && LookTarget != None )
		Acceleration = AccelRate * Normal(LookTarget.Location - Location);
}

function bool FlipOver()
{
	Return False;
}

function bool SameSpeciesAs(Pawn P)
{
	Return ( UM_ZombieFleshPound(P) != None );
}

simulated function Destroyed()
{
	if ( AvoidArea != None )
		AvoidArea.Destroy();

	Super.Destroyed();
}


static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.fleshpound_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.fleshpound_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.fleshpound_diff');
}

defaultproperties
{
     EventClasses(0)="UnlimaginMod.UM_ZombieFleshPound"
     EventClasses(1)="UnlimaginMod.UM_ZombieFleshPound"
     //EventClasses(2)="UnlimaginMod.UM_ZombieFleshPound_HALLOWEEN"
	 EventClasses(2)="UnlimaginMod.UM_ZombieFleshPound"
     //EventClasses(3)="UnlimaginMod.UM_ZombieFleshPound_XMas"
	 EventClasses(3)="UnlimaginMod.UM_ZombieFleshPound"
     DetachedArmClass=Class'KFChar.SeveredArmPound'
     DetachedLegClass=Class'KFChar.SeveredLegPound'
     DetachedHeadClass=Class'KFChar.SeveredHeadPound'
     ControllerClass=Class'UnlimaginMod.UM_ZombieFleshPoundController'
}
