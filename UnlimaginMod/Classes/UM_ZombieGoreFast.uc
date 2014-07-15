//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieGoreFast
//	Parent class:	 UM_ZombieGoreFastBase
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 06.10.2012 16:13
//================================================================================
class UM_ZombieGoreFast extends UM_ZombieGoreFastBase;

#exec OBJ LOAD FILE=KFPlayerSound.uax

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

simulated event PostBeginPlay()
{
	// Randomizing RunAttackTimeout
	if ( Level.Game != None && !bDiffAdjusted )  {
		RunAttackTimeout *= GetRandMult(0.9, 1.1);
		RunGroundSpeedScale *= GetRandMult(0.85, 1.15);
	}
	
	Super.PostBeginPlay();
}

simulated event PostNetReceive()
{
    if( !bZapped )
    {
    	if (bRunning)
    		MovementAnims[0]='ZombieRun';
    	else MovementAnims[0]=default.MovementAnims[0];
    }
}

// This zed has been taken control of. Boost its health and speed
function SetMindControlled(bool bNewMindControlled)
{
    if( bNewMindControlled )
    {
        NumZCDHits++;

        // if we hit him a couple of times, make him rage!
        if( NumZCDHits > 1 )
        {
            if( !IsInState('RunningToMarker') )
            {
                GotoState('RunningToMarker');
            }
            else
            {
                NumZCDHits = 1;
                if( IsInState('RunningToMarker') )
                {
                    GotoState('');
                }
            }
        }
        else
        {
            if( IsInState('RunningToMarker') )
            {
                GotoState('');
            }
        }

        if( bNewMindControlled != bZedUnderControl )
        {
            SetGroundSpeed(OriginalGroundSpeed * 1.25);
    		Health *= 1.25;
    		HealthMax *= 1.25;
		}
    }
    else
    {
        NumZCDHits=0;
    }

    bZedUnderControl = bNewMindControlled;
}

// Handle the zed being commanded to move to a new location
function GivenNewMarker()
{
    if( bRunning && NumZCDHits > 1 )
    {
        GotoState('RunningToMarker');
    }
    else
    {
        GotoState('');
    }
}

function RangedAttack(Actor A)
{
	Super.RangedAttack(A);
	if( !bShotAnim && !bDecapitated && VSize(A.Location-Location) <= 700 )
		GoToState('RunningState');
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
        return false;
    }

	function BeginState()
	{
		if( bZapped )
        {
            GoToState('');
        }
        else
        {
    		SetGroundSpeed(OriginalGroundSpeed * RunGroundSpeedScale);
    		bRunning = true;
    		if( Level.NetMode!=NM_DedicatedServer )
    			PostNetReceive();

    		NetUpdateTime = Level.TimeSeconds - 1;
		}
	}

	function EndState()
	{
		if( !bZapped )
		{
            SetGroundSpeed(GetOriginalGroundSpeed());
        }
		bRunning = False;
		if( Level.NetMode!=NM_DedicatedServer )
			PostNetReceive();

		RunAttackTimeout=0;

		NetUpdateTime = Level.TimeSeconds - 1;
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
        if( Level.Game.GameDifficulty < 2.0 )
        {
            ChargeChance = 0.1;
        }
        else if( Level.Game.GameDifficulty < 4.0 )
        {
            ChargeChance = 0.2;
        }
        else if( Level.Game.GameDifficulty < 5.0 )
        {
            ChargeChance = 0.3;
        }
        else // Hardest difficulty
        {
            ChargeChance = 0.4;
        }

    	if ( bShotAnim || Physics == PHYS_Swimming)
    		return;
    	else if ( CanAttack(A) )
    	{
    		bShotAnim = true;

    		// Randomly do a moving attack so the player can't kite the zed
            if( FRand() < ChargeChance )
    		{
        		SetAnimAction('ClawAndMove');
        		RunAttackTimeout = GetAnimDuration('GoreAttack1', 1.0);
    		}
    		else
    		{
        		SetAnimAction(MeleeAnims[Rand(3)]);
        		Controller.bPreparingMove = true;
        		Acceleration = vect(0,0,0);
                // Once we attack stop running
        		GoToState('');
    		}
    		return;
    	}
    }

    simulated function Tick(float DeltaTime)
    {
		// Keep moving toward the target until the timer runs out (anim finishes)
        if( RunAttackTimeout > 0 )
		{
            RunAttackTimeout -= DeltaTime;

            if( RunAttackTimeout <= 0 && !bZedUnderControl )
            {
                RunAttackTimeout = 0;
                GoToState('');
            }
		}

        // Keep the gorefast moving toward its target when attacking
    	if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
    	{
    		if( LookTarget!=None )
    		{
    		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    		}
        }

        global.Tick(DeltaTime);
    }


Begin:
    GoTo('CheckCharge');
CheckCharge:
    if( Controller!=None && Controller.Target!=None && VSize(Controller.Target.Location-Location)<700 )
    {
        Sleep(0.5+ FRand() * 0.5);
        //log("Still charging");
        GoTo('CheckCharge');
    }
    else
    {
        //log("Done charging");
        GoToState('');
    }
}

// State where the zed is charging to a marked location.
state RunningToMarker extends RunningState
{
    simulated function Tick(float DeltaTime)
    {
		// Keep moving toward the target until the timer runs out (anim finishes)
        if( RunAttackTimeout > 0 )
		{
            RunAttackTimeout -= DeltaTime;

            if( RunAttackTimeout <= 0 && !bZedUnderControl )
            {
                RunAttackTimeout = 0;
                GoToState('');
            }
		}

        // Keep the gorefast moving toward its target when attacking
    	if( Role == ROLE_Authority && bShotAnim && !bWaitForAnim )
    	{
    		if( LookTarget!=None )
    		{
    		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    		}
        }

        global.Tick(DeltaTime);
    }


Begin:
    GoTo('CheckCharge');
CheckCharge:
    if( bZedUnderControl || (Controller!=None && Controller.Target!=None && VSize(Controller.Target.Location-Location)<700) )
    {
        Sleep(0.5+ FRand() * 0.5);
        GoTo('CheckCharge');
    }
    else
    {
        GoToState('');
    }
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
	else
	{
		for ( meleeAnimIndex = 0; meleeAnimIndex < 2; meleeAnimIndex++ )
		{
			if ( NewAction == MeleeAnims[meleeAnimIndex] )
			{
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
		bWaitForAnim = false;

	if ( Level.NetMode != NM_Client )
	{
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
	}
}

// Handle playing the anim action on the upper body only if we're attacking and moving
simulated function int AttackAndMoveDoAnimAction( name AnimName )
{
	local int meleeAnimIndex;

    if( AnimName == 'ClawAndMove' )
	{
		meleeAnimIndex = Rand(3);
		AnimName = meleeAnims[meleeAnimIndex];
		CurrentDamtype = ZombieDamType[meleeAnimIndex];
	}

    if( AnimName=='GoreAttack1' || AnimName=='GoreAttack2' )
	{
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);

		return 1;
	}

	return super.DoAnimAction( AnimName );
}

simulated function HideBone(name boneName)
{
	//  Gorefast does not have a left arm and does not need it to be hidden
	if (boneName != LeftFArmBone)
	{
		super.HideBone(boneName);
	}
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gorefast_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gorefast_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.gorefast_diff');
}

defaultproperties
{
     EventClasses(0)="UnlimaginMod.UM_ZombieGoreFast"
     EventClasses(1)="UnlimaginMod.UM_ZombieGoreFast"
     EventClasses(2)="UnlimaginMod.UM_ZombieGoreFast_HALLOWEEN"
     EventClasses(3)="UnlimaginMod.UM_ZombieGoreFast_XMas"
     DetachedArmClass=Class'KFChar.SeveredArmGorefast'
     DetachedLegClass=Class'KFChar.SeveredLegGorefast'
     DetachedHeadClass=Class'KFChar.SeveredHeadGorefast'
     bLeftArmGibbed=True
     ControllerClass=Class'UnlimaginMod.UM_ZombieGoreFastController'
}
