//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MonsterController
//	Parent class:	 KFMonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 09.10.2012 19:31
//================================================================================
class UM_MonsterController extends KFMonsterController;

//var		float	MyDazzleTime;

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	if ( KFGameType(Level.Game) != None && KFMonster(Pawn) != None &&
		( KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave || (Level.TimeSeconds - KFMonster(Pawn).LastSeenOrRelevantTime) > 20.0 ) )
			Return True;

	Return False;
}

function bool EnemyVisible()
{
	if ( VisibleEnemy == Enemy && Level.TimeSeconds <= EnemyVisibilityTime )
		Return bEnemyIsVisible;
	
	VisibleEnemy = Enemy;
	//EnemyVisibilityTime = Level.TimeSeconds;
	EnemyVisibilityTime = Level.TimeSeconds + 0.001;
	bEnemyIsVisible = LineOfSightTo(Enemy);
	
	Return bEnemyIsVisible;
}

state ZombieHunt
{
	event BeginState()  { }
	
	event EndState()  { }
	
	function Timer()
	{
		if (Pawn.Velocity == vect(0,0,0) )
			GotoState('ZombieRestFormation','Moving');
		SetCombatTimer();
		StopFiring();
	}
	
	function PickDestination()
	{
		local	vector	nextSpot, ViewSpot,Dir;
		local	float	posZ;
		local	bool	bCanSeeLastSeen;

		if ( FindFreshBody() )
			Return;
		
		if ( Enemy != None && !KFM.bCannibal && Enemy.Health <= 0 )  {
			Enemy = None;
			WhatToDoNext(23);
			Return;
		}
		
		if ( PathFindState == 0 )  {
			InitialPathGoal = FindRandomDest();
			PathFindState = 1;
		}
		
		if ( PathFindState == 1 )  {
			if ( InitialPathGoal == None )
				PathFindState = 2;
			else if ( ActorReachable(InitialPathGoal) )  {
				MoveTarget = InitialPathGoal;
				PathFindState = 2;
				Return;
			}
			else if ( FindBestPathToward(InitialPathGoal, true,true) )
				Return;
			else 
				PathFindState = 2;
		}

		if ( Pawn.JumpZ > 0 )
			Pawn.bCanJump = True;

		if ( KFM.Intelligence==BRAINS_Retarded && FRand() < 0.25 )  {
			Destination = Pawn.Location + VRand() * 200.0;
			Return;
		}
		
		if ( ActorReachable(Enemy) )  {
			Destination = Enemy.Location;
			if ( KFM.Intelligence == BRAINS_Retarded && FRand() < 0.5 )  {
				Destination += VRand() * 50.0;
				Return;
			}
			MoveTarget = None;
			
			Return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if ( FindBestPathToward(Enemy, true,true) )
			Return;

		if ( bSoaking && (Physics != PHYS_Falling) )
			SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

		MoveTarget = None;
		if ( !bEnemyInfoValid )  {
			Enemy = None;
			GotoState('StakeOut');
			Return;
		}

		Destination = LastSeeingPos;
		bEnemyInfoValid = false;
		if ( FastTrace(Enemy.Location, ViewSpot) && VSize(Pawn.Location - Destination) > Pawn.CollisionRadius )  {
				SeePlayer(Enemy);
				Return;
		}

		posZ = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
		nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
		nextSpot.Z = posZ;
		if ( FastTrace(nextSpot, ViewSpot) )
			Destination = nextSpot;
		else if ( bCanSeeLastSeen )  {
			Dir = Pawn.Location - LastSeenPos;
			Dir.Z = 0;
			if ( VSize(Dir) < Pawn.CollisionRadius )  {
				Destination = Pawn.Location + VRand() * 500.0;
				Return;
			}
			Destination = LastSeenPos;
		}
		else  {
			Destination = LastSeenPos;
			if ( !FastTrace(LastSeenPos, ViewSpot) )  {
				// check if could adjust and see it
				if ( PickWallAdjust(Normal(LastSeenPos - ViewSpot)) || FindViewSpot() )  {
					if ( Pawn.Physics == PHYS_Falling )
						SetFall();
					else
						GotoState('Hunting', 'AdjustFromWall');
				}
				else
					Destination = Pawn.Location + VRand() * 500.0;
			}
		}
	}
}

function FightEnemy(bool bCanCharge)
{
	if ( KFM.bShotAnim )  {
		GoToState('WaitForAnim');
		Return;
	}
	
	if ( KFM.MeleeRange != KFM.default.MeleeRange )
		KFM.MeleeRange = KFM.default.MeleeRange;

	if ( Enemy == none || Enemy.Health <= 0 || EnemyThreatChanged() )
		FindNewEnemy();

	if ( Enemy == FailedHuntEnemy && Level.TimeSeconds == FailedHuntTime )  {
		//if ( Enemy.Controller.bIsPlayer )
		//FindNewEnemy();

		if ( Enemy == FailedHuntEnemy )  {
			GoalString = "FAILED HUNT - HANG OUT";
			if ( EnemyVisible() )
				bCanCharge = false;
		}
	}
	
	if ( !EnemyVisible() )  {
		GoalString = "Hunt";
		GotoState('ZombieHunt');
		Return;
	}

	// see enemy - decide whether to charge it or strafe around/stand and fire
	Target = Enemy;
	GoalString = "Charge";
	PathFindState = 2;
	DoCharge();
}

// If we're not dead, and we can see our target, and we still have a head. lets go eat it.
function bool FindFreshBody()
{
	local KFGameType K;
	local int i;
	local PlayerDeathMark Best;
	local float Dist,BDist;

	K = KFGameType(Level.Game);
	
	if( K == None || KFM.bDecapitated || !KFM.bCannibal || (!Level.Game.bGameEnded && Pawn.Health >= (Pawn.Default.Health * 1.5)) )
		Return False;

	if ( K != None )  {
		for( i=0; i<K.DeathMarkers.Length; i++ )  {
			if ( K.DeathMarkers[i] == None )
				Continue;
			Dist = VSize(K.DeathMarkers[i].Location-Pawn.Location);
			if ( Dist < 800 && ActorReachable(K.DeathMarkers[i]) && (Best==None || Dist<BDist) )  {
				Best = K.DeathMarkers[i];
				BDist = Dist;
			}
		}
	}
		
	if ( Best == None )
		Return False;

	TargetCorpse = Best;
	GoToState('CorpseFeeding');
	
	Return True;
}

// State for being scared of something, the bot attempts to move away from it
state ZombiePushedAway
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;
	
Begin:
	WaitForLanding();
	Sleep(0.4);
	WhatToDoNext(11);
}

state IamDazzled
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;
	
Begin:
	//Sleep(MyDazzleTime);
	Sleep(10);
	WhatToDoNext(11);
}

defaultproperties
{
	//MyDazzleTime=10.000000
}