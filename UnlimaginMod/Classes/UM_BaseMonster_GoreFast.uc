//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_GoreFast
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:15
//================================================================================
class UM_BaseMonster_GoreFast extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//========================================================================
//[block] Variables

var		bool		bRunning;
var		float		RunAttackTimeout, RunGroundSpeedScale;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bRunning;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	// Randomizing RunAttackTimeout
	if ( Level.Game != None && !bDiffAdjusted )  {
		RunAttackTimeout *= Lerp( FRand(), 0.9, 1.1 );
		RunGroundSpeedScale *= Lerp( FRand(), 0.85, 1.15 );
	}
	
	Super.PostBeginPlay();
}

simulated event PostNetReceive()
{
	if ( !bZapped )  {
		if ( bRunning )
			MovementAnims[0] = 'ZombieRun';
		else 
			MovementAnims[0] = default.MovementAnims[0];
	}
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
				if ( IsInState('RunningToMarker') )
					GotoState('');
			}
		}
		else if ( IsInState('RunningToMarker') )
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
	if ( bRunning && NumZCDHits > 1 )
		GotoState('RunningToMarker');
	else
		GotoState('');
}

function RangedAttack(Actor A)
{
	Super.RangedAttack(A);
	if ( !bShotAnim && !bDecapitated && VSize(A.Location - Location) <= 700.0 )
		GoToState('RunningState');
}

state RunningState
{	
	event BeginState()
	{
		if ( bZapped )
			GoToState('');
		else  {
			SetGroundSpeed(OriginalGroundSpeed * RunGroundSpeedScale);
			bRunning = True;
			if ( Level.NetMode!=NM_DedicatedServer )
				PostNetReceive();

			NetUpdateTime = Level.TimeSeconds - 1.0;
		}
	}
	
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

	function RemoveHead()
	{
		GoToState('');
		Global.RemoveHead();
	}

	function RangedAttack(Actor A)
	{
		local float ChargeChance;

		// Decide what chance the gorefast has of charging during an attack
		if ( Level.Game.GameDifficulty < 2.0 )
			ChargeChance = 0.1;
		else if( Level.Game.GameDifficulty < 4.0 )
			ChargeChance = 0.2;
		else if( Level.Game.GameDifficulty < 5.0 )
			ChargeChance = 0.3;
		else // Hardest difficulty
			ChargeChance = 0.4;

		if ( bShotAnim || Physics == PHYS_Swimming )
			Return;
		else if ( CanAttack(A) )  {
			bShotAnim = True;
			// Randomly do a moving attack so the player can't kite the zed
			if ( FRand() < ChargeChance )  {
				SetAnimAction('ClawAndMove');
				RunAttackTimeout = GetAnimDuration('GoreAttack1', 1.0);
			}
			else  {
				SetAnimAction(MeleeAnims[Rand(3)]);
				Controller.bPreparingMove = True;
				Acceleration = vect(0,0,0);
				// Once we attack stop running
				GoToState('');
			}
			
			Return;
		}
	}

	simulated event Tick( float DeltaTime )
	{
		// Keep moving toward the target until the timer runs out (anim finishes)
		if ( RunAttackTimeout > 0 )  {
			RunAttackTimeout -= DeltaTime;
			if ( RunAttackTimeout <= 0 && !bZedUnderControl )  {
				RunAttackTimeout = 0;
				GoToState('');
			}
		}

		// Keep the gorefast moving toward its target when attacking
		if ( Role == ROLE_Authority && bShotAnim && !bWaitForAnim && LookTarget != None )
		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);

		Global.Tick( DeltaTime );
	}
	
	event EndState()
	{
		if ( !bZapped )
			SetGroundSpeed(GetOriginalGroundSpeed());
		bRunning = False;
		if ( Level.NetMode != NM_DedicatedServer )
			PostNetReceive();

		RunAttackTimeout = 0;

		NetUpdateTime = Level.TimeSeconds - 1.0;
	}


Begin:
	GoTo('CheckCharge');

CheckCharge:
	if( Controller != None && Controller.Target != None && VSize(Controller.Target.Location - Location) < 700.0 )  {
		Sleep(0.5+ FRand() * 0.5);
		//log("Still charging");
		GoTo('CheckCharge');
	}
	else
		GoToState('');
}

// State where the zed is charging to a marked location.
state RunningToMarker extends RunningState
{
	simulated event Tick( float DeltaTime )  {
		// Keep moving toward the target until the timer runs out (anim finishes)
		if ( RunAttackTimeout > 0 )  {
			RunAttackTimeout -= DeltaTime;
			if ( RunAttackTimeout <= 0 && !bZedUnderControl )  {
				RunAttackTimeout = 0;
				GoToState('');
			}
		}

		// Keep the gorefast moving toward its target when attacking
		if ( Role == ROLE_Authority && bShotAnim && !bWaitForAnim && LookTarget != None )
		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);

		Global.Tick( DeltaTime );
	}


Begin:
	GoTo('CheckCharge');

CheckCharge:
	if ( bZedUnderControl || (Controller != None && Controller.Target != None && VSize(Controller.Target.Location - Location) < 700.0) )  {
		Sleep(0.5+ FRand() * 0.5);
		GoTo('CheckCharge');
	}
	else
		GoToState('');
}

// Overridden to handle playing upper body only attacks when moving
simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;
	local bool bWantsToAttackAndMove;

	if ( NewAction == '' )
		Return;

	if ( NewAction == 'ClawAndMove' )
		bWantsToAttackAndMove = True;
	else
		bWantsToAttackAndMove = False;

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

	if ( bWantsToAttackAndMove )
		ExpectingChannel = AttackAndMoveDoAnimAction(NewAction);
	else
		ExpectingChannel = DoAnimAction(NewAction);

	if ( !bWantsToAttackAndMove && AnimNeedsWait(NewAction) )
		bWaitForAnim = True;
	else
		bWaitForAnim = False;

	if ( Level.NetMode != NM_Client )  {
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
	}
}

// Handle playing the anim action on the upper body only if we're attacking and moving
simulated function int AttackAndMoveDoAnimAction( name AnimName )
{
	local int meleeAnimIndex;

	if ( AnimName == 'ClawAndMove' )  {
		meleeAnimIndex = Rand(3);
		AnimName = meleeAnims[meleeAnimIndex];
		CurrentDamtype = ZombieDamType[meleeAnimIndex];
	}

	if ( AnimName=='GoreAttack1' || AnimName=='GoreAttack2' )  {
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);

		Return 1;
	}

	Return Super.DoAnimAction( AnimName );
}

simulated function HideBone(name boneName)
{
	//  Gorefast does not have a left arm and does not need it to be hidden
	if ( boneName != LeftFArmBone )
		Super.HideBone(boneName);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 KnockedDownHealthPct=0.7
	 KilledWaveCountDownExtensionTime=5.0
	 ImpressiveKillChance=0.05
	 
	 RunGroundSpeedScale=1.850000
	 bCannibal=True
	 MeleeDamage=15
	 damageForce=5000
	 KFRagdollName="GoreFast_Trip"
	 CrispUpThreshhold=8
	 SeveredArmAttachScale=0.900000
	 SeveredLegAttachScale=0.900000
	 MotionDetectorThreat=0.500000
	 ScoringValue=12
	 IdleHeavyAnim="GoreIdle"
	 IdleRifleAnim="GoreIdle"
	 MeleeRange=30.000000
	 GroundSpeed=120.000000
	 WaterSpeed=140.000000
	 HeadHeight=2.500000
	 HeadScale=1.500000
	 MenuName="Gorefast"
	 // MeleeAnims
	 MeleeAnims(0)="GoreAttack1"
	 MeleeAnims(1)="GoreAttack2"
	 MeleeAnims(2)="GoreAttack1"
	 // MovementAnims
	 MovementAnims(0)="GoreWalk"
     MovementAnims(1)="GoreWalk"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 TurnLeftAnim="TurnLeft"
     TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="GoreWalk"
     WalkAnims(1)="GoreWalk"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
	 
	 IdleCrouchAnim="GoreIdle"
	 IdleWeaponAnim="GoreIdle"
	 IdleRestAnim="GoreIdle"
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=250.0
	 Health=250
	 //HeadHealth=25.0
	 HeadHealth=25.0
	 //PlayerCountHealthScale=0.150000
	 PlayerCountHealthScale=0.1
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.05
	 Mass=300.000000
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.8,AreaHeight=6.0,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-1.8,Z=0.0),AreaImpactStrength=5.8)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=17.4,AreaHeight=38.0,AreaImpactStrength=8.2)
}
