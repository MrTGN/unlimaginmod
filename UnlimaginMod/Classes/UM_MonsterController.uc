//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MonsterController
//	Parent class:	 KFMonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ï½© 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ï½© 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 09.10.2012 19:31
//================================================================================
class UM_MonsterController extends KFMonsterController;

//var		float	MyDazzleTime;
var		transient	float				KnockDownEndTime;

var					float				FriendlyFireAggroChance;

function InitPlayerReplicationInfo()
{
	PlayerReplicationInfo = Spawn(PlayerReplicationInfoClass, Self,,vect(0,0,0),rot(0,0,0));
	if ( PlayerReplicationInfo == None )
		Return;
	
	if ( PlayerReplicationInfo.PlayerName == "" )
		PlayerReplicationInfo.SetPlayerName(class'GameInfo'.Default.DefaultPlayerName);

	PlayerReplicationInfo.bNoTeam = !Level.Game.bTeamGame;
}

function SetCombatTimer()
{
	SetTimer((1.2 - 0.09 * FMin(10.0, (Skill + ReactionTime))), True);
}

event PostBeginPlay()
{
	if ( !bDeleteMe && bIsPlayer && Level.NetMode != NM_Client )
		InitPlayerReplicationInfo();
	
	SetCombatTimer();
	if ( UnrealMPGameInfo(Level.Game).bSoaking )
		bSoaking = True;

	MoanTime = Level.TimeSeconds + 2.0 + 36.0 * FRand();
	EvaluateTime = Level.TimeSeconds;
	TimeToSet = Level.TimeSeconds;
	ItsSet = False;

	/* Kind of a hack, but it's the safest way to toggle Threat assessment behaviour right now .. */
	if ( KFGameType(Level.Game) != None && KFGameType(Level.Game).bUseZEDThreatAssessment )
		bUseThreatAssessment = True;
}

function bool TryToDuck(vector duckDir, bool bReversed)
{
	local	vector	HitLocation, HitNormal, Extent;
	local	Actor	HitActor;
	local	bool	bSuccess, bDuckLeft;

	if ( Pawn.PhysicsVolume.bWaterVolume || Pawn.PhysicsVolume.Gravity.Z > Pawn.PhysicsVolume.Default.Gravity.Z )
		Return False;

	duckDir.Z = 0;
	bDuckLeft = !bReversed;
	Extent = Pawn.GetCollisionExtent();
	HitActor = Trace(HitLocation, HitNormal, Pawn.Location + 240 * duckDir, Pawn.Location, false, Extent);
	bSuccess = ( HitActor == None || (VSizeSquared(HitLocation - Pawn.Location) > 22500.0) );
	if ( !bSuccess )  {
		bDuckLeft = !bDuckLeft;
		duckDir *= -1;
		HitActor = Trace(HitLocation, HitNormal, Pawn.Location + 240.0 * duckDir, Pawn.Location, false, Extent);
		bSuccess = ( HitActor == None || (VSizeSquared(HitLocation - Pawn.Location) > 22500.0) );
	}
	
	if ( !bSuccess )
		Return False;

	if ( HitActor == None )
		HitLocation = Pawn.Location + 240 * duckDir;

	HitActor = Trace(HitLocation, HitNormal, HitLocation - MAXSTEPHEIGHT * vect(0,0,1), HitLocation, false, Extent);
	if ( HitActor == None )
		Return False;

	if ( bDuckLeft )
		UnrealPawn(Pawn).CurrentDir = DCLICK_Left;
	else
		UnrealPawn(Pawn).CurrentDir = DCLICK_Right;
	UnrealPawn(Pawn).Dodge(UnrealPawn(Pawn).CurrentDir);
	
	Return True;
}

function ReceiveWarning(Pawn Shooter, float ProjSpeed, vector FireDir)
{
	local	float	EnemyDist, DodgeSkill;
	local	vector	X,Y,Z, EnemyDir;

	// AI controlled creatures may duck if not falling
	DodgeSkill = Skill + Monster(Pawn).DodgeSkillAdjust;
	if ( Pawn.Health < 1 || !Monster(Pawn).bCanDodge || DodgeSkill < 4 || Enemy == None ||
		|| Pawn.Physics == PHYS_Falling || Pawn.Physics == PHYS_Swimming || FRand() > (0.2 * DodgeSkill - 0.4) )
		Return;

	// and projectile time is long enough
	EnemyDist = VSize(Shooter.Location - Pawn.Location);
	if ( (EnemyDist / ProjSpeed) < (0.11 + 0.15 * FRand()) )
		Return;
	
	// only if tight FOV
	GetAxes(Pawn.Rotation,X,Y,Z);
	EnemyDir = (Shooter.Location - Pawn.Location) / EnemyDist;
	if ( (EnemyDir Dot X) < 0.8 )
		Return;
	
	if ( (FireDir Dot Y) > 0.0 )  {
		TryToDuck(-Y, True);
	}
	else
		TryToDuck(Y, False);
}

function InstantWarnTarget(Actor Target, FireProperties FiredAmmunition, vector FireDir)
{
	if ( FiredAmmunition.bInstantHit && Pawn(Target) != None && Pawn(Target).Controller != None )  {
		if ( VSizeSquared(Target.Location - Pawn.Location) < Square(Target.CollisionRadius) )
			Return;
		
		if ( FRand() < FiredAmmunition.WarnTargetPct )
			Pawn(Target).Controller.ReceiveWarning(Pawn, -1, FireDir);
	}
}

event bool NotifyLanded(vector HitNormal)
{
	local	vector	Vel2D;

	if ( MoveTarget != None )  {
		Vel2D = Pawn.Velocity;
		Vel2D.Z = 0;
		if ( (Vel2D Dot (MoveTarget.Location - Pawn.Location)) < 0 )  {
			Pawn.Acceleration = vect(0,0,0);
			if ( NavigationPoint(MoveTarget) != None )
				Pawn.Anchor = NavigationPoint(MoveTarget);
			MoveTimer = -1;
		}
	}
	
	Return False;
}

event Tick(float DeltaTime)
{
	if ( Level.TimeSeconds >= MoanTime )  {
		ZombieMoan();
		MoanTime = Level.TimeSeconds + 12.0 + FRand() * 8.0;
	}
	
	if ( bAboutToGetDoor )  {
		bAboutToGetDoor = False;
		if ( TargetDoor != None )
			BreakUpDoor(TargetDoor, True);
	}
}

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	if ( KFGameType(Level.Game) == None || KFMonster(Pawn) == None )
		Return False;

	Return KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave || (Level.TimeSeconds - KFMonster(Pawn).LastSeenOrRelevantTime) > 8.0;
}

function bool DoWaitForLanding()
{
	GotoState('WaitingForLanding');
	
	Return True;
}

state WaitingForLanding
{
	event BeginState()
	{
		bJustLanded = False;
		if ( MoveTarget != None && (Enemy == None || Focus != Enemy) )
			FaceActor(1.5);
		
		if ( Enemy == None || Focus != Enemy )
			StopFiring();
	}
	
	function bool DoWaitForLanding()
	{
		if ( bJustLanded )
			Return False;
			
		BeginState();
		
		Return True;
	}

	event bool NotifyLanded(vector HitNormal)
	{
		bJustLanded = True;
		WhatToDoNext(50);
		
		Return False;
	}

	event Timer()
	{
		if ( Focus == Enemy )
			TimedFireWeaponAtEnemy();
		else
			SetCombatTimer();
	}
}

// If we're not dead, and we can see our target, and we still have a head. lets go eat it.
function bool FindFreshBody()
{
	local	KFGameType		K;
	local	int				i;
	local	PlayerDeathMark	Best;
	local	float			Dist, BDist;

	K = KFGameType(Level.Game);
	
	if ( K == None || KFM.bDecapitated || !KFM.bCannibal || (!Level.Game.bGameEnded && Pawn.Health >= (Pawn.Default.Health * 1.5)) )
		Return False;

	for ( i = 0; i < K.DeathMarkers.Length; ++i )  {
		if ( K.DeathMarkers[i] == None )
			Continue; // skip
		
		Dist = VSize(K.DeathMarkers[i].Location - Pawn.Location);
		if ( Dist < 800 && ActorReachable(K.DeathMarkers[i]) && (Best == None || Dist < BDist) )  {
			Best = K.DeathMarkers[i];
			BDist = Dist;
		}
	}
		
	if ( Best == None )
		Return False;

	TargetCorpse = Best;
	GoToState('CorpseFeeding');
	
	Return True;
}

function bool FindBestPathToward(Actor A, bool bCheckedReach, bool bAllowDetour)
{
	local	vector	HitLoc, HitNorm;

	if ( A == None )
		Return False; // Shouldn't get to this, but just in case.
	
	RouteCache[1] = None;
	if ( !bCheckedReach && ActorReachable(A) )
		MoveTarget = A;
	else  {
		// Sometimes they may attempt to find another way around if this way leads to i.e. a welded door.
		if ( ExtraCostWay != None )
			ExtraCostWay.ExtraCost += 200;
		
		if ( BlockedWay != None )  {
			BlockedWay.ExtraCost += 10000;
			MoveTarget = FindPathToward(A);
			BlockedWay.ExtraCost -= 10000;
		}
		else 
			MoveTarget = FindPathToward(A);
		
		if ( ExtraCostWay != None )
			ExtraCostWay.ExtraCost -= 200;
		
		if ( MoveTarget != None )  {
			if ( LastResult == MoveTarget )  {
				if ( NavigationPoint(MoveTarget) != None && NumAttmpts > 3 && FRand() < 0.6 )  {
					BlockedWay = NavigationPoint(MoveTarget);
					LastResult = None;
					NumAttmpts = 0;
					
					Return FindBestPathToward(A, True, bAllowDetour);
				}
				else
					++NumAttmpts;
			}
			else 
				NumAttmpts = 0;
			
			LastResult = MoveTarget;
			if ( NavigationPoint(MoveTarget) != None && KFMonster(Trace(HitLoc, HitNorm,MoveTarget.Location, Pawn.Location, True)) != None )  {
				ExtraCostWay = NavigationPoint(MoveTarget);
				ExtraCostWay.ExtraCost += 200;
				MoveTarget = FindPathToward(A); // Might consider taking another path if zombie is blocking this one.
				ExtraCostWay.ExtraCost -= 200;
			}
		}
	}
	
	if ( MoveTarget != None )  {
		if ( RouteCache[1] != None && ActorReachable(RouteCache[1]) )
			MoveTarget = RouteCache[1];
		
		if ( KFM.bCanDistanceAttackDoors )  {
			A = Trace(HitLoc, HitNorm, MoveTarget.Location, Pawn.Location, False);
			if ( KFDoorMover(A) != None && KFDoorMover(A).bSealed )  {
				TargetDoor = KFDoorMover(A);
				bAboutToGetDoor = True;
			}
		}
		
		Return True;
	}
	
	if ( A == Enemy && A != None )  {
		FailedHuntTime = Level.TimeSeconds;
		FailedHuntEnemy = Enemy;
	}
	
	if ( bSoaking && Physics != PHYS_Falling )
		SoakStop("COULDN'T FIND BEST PATH TO "$A);
	
	Return False;
}

state CorpseFeeding
{
	ignores EnemyNotVisible, SeePlayer, HearNoise, NotifyBump;

	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin)  { }

	event Timer()
	{
		Target = TargetCorpse;
		if ( Target == None )
			WhatToDoNext(38);
	}
	
	function AttackCorpse()
	{
		Target = TargetCorpse;
		KFM.CorpseAttack(Target);
	}

Begin:
	WaitForLanding();
	While ( TargetCorpse != None && !ActorReachable(TargetCorpse) )  {
		if ( !FindBestPathToward(TargetCorpse, True, False) )
			WhatToDoNext(33);
		
		MoveToward(MoveTarget, MoveTarget);
	}
	
	if ( TargetCorpse == None )
		WhatToDoNext(32);
	
	MoveTo((TargetCorpse.Location + Normal(Pawn.Location-TargetCorpse.Location) * (20.0 + FRand() * 20.0)), TargetCorpse);
	
	if ( TargetCorpse == None )
		WhatToDoNext(31);
	
	Focus = TargetCorpse;
	While ( TargetCorpse != None && (Pawn.Health < (Pawn.Default.Health * 1.5) || Level.Game.bGameEnded) )  {
		AttackCorpse();
		
		While( KFM.bShotAnim )
			Sleep(0.1);
		
		if ( Enemy != None && VSize(Enemy.Location - Pawn.Location) < 500 && CanSee(Enemy) )
			WhatToDoNext(37); // Can't look, eating.
	}
	
	WhatToDoNext(30);
}

function bool EnemyVisible()
{
	if ( Level.TimeSeconds == EnemyVisibilityTime && VisibleEnemy == Enemy )
		Return bEnemyIsVisible;
	
	VisibleEnemy = Enemy;
	EnemyVisibilityTime = Level.TimeSeconds;
	//EnemyVisibilityTime = Level.TimeSeconds + 0.001;
	bEnemyIsVisible = LineOfSightTo( VisibleEnemy );
	
	Return bEnemyIsVisible;
}

function SetEnemyInfo(bool bNewEnemyVisible)
{
	AcquireTime = Level.TimeSeconds;
	if ( bNewEnemyVisible )  {
		LastSeenTime = Level.TimeSeconds;
		LastSeenPos = Enemy.Location;
		LastSeeingPos = Pawn.Location;
		bEnemyInfoValid = True;
	}
	else  {
		LastSeenTime = -1000;
		bEnemyInfoValid = False;
	}
}

// EnemyChanged() called when current enemy changes
function EnemyChanged(bool bNewEnemyVisible)
{
	bEnemyAcquired = false;
	SetEnemyInfo(bNewEnemyVisible);
	if ( UM_BaseMonster(Pawn) != None )  {
		UM_BaseMonster(Pawn).EnemyChanged();
		UM_BaseMonster(Pawn).PlayChallengeSound();
	}
}

function ChangeEnemy(Pawn NewEnemy, bool bCanSeeNewEnemy)
{
	OldEnemy = Enemy;
	Enemy = NewEnemy;
	EnemyChanged(bCanSeeNewEnemy);
}

function bool SetEnemy( Pawn NewEnemy, optional bool bHateMonster, optional float MonsterHateChanceOverride )
{
	local	float	EnemyDistSquared;
	local	bool	bNewMonsterEnemy;
	
	if ( NewEnemy == None || NewEnemy.Health < 1 || NewEnemy.Controller == None || NewEnemy == Enemy )
		Return False;
	
	// This enemy is of absolutely no threat currently, ignore it
	if ( (bUseThreatAssessment && KFHumanpawn(NewEnemy) != None && KFHumanPawn(NewEnemy).AssessThreatTo(self) < 1) || (!bHateMonster && KFHumanPawnEnemy(NewEnemy) != None && KFHumanPawnEnemy(NewEnemy).AttitudeToSpecimen <= ATTITUDE_Ignore) )
		Return False; // In other words, dont attack human pawns as long as they dont damage me or hates me.

	if ( KFM.Intelligence >= BRAINS_Mammal && Enemy != None && NewEnemy.Controller.bIsPlayer )  {
		// If current Enemy is closer
		if ( LineOfSightTo(Enemy) && VSizeSquared(Enemy.Location - Pawn.Location) < VSizeSquared(NewEnemy.Location - Pawn.Location) )
			Return False;
		
		Enemy = None;
	}

	if ( MonsterHateChanceOverride <= 0.0 )
		MonsterHateChanceOverride = 0.15;

	// Get pissed at this fucker..
	if ( bHateMonster && KFMonster(NewEnemy) != None && 
		 (NewEnemy.Controller.Target == Self || FRand() < MonsterHateChanceOverride)
		 && LineOfSightTo(NewEnemy) && VSizeSquared(NewEnemy.Location - Pawn.Location) < 2250000.0 )  {
		ChangeEnemy(NewEnemy, CanSee(NewEnemy));
		Return True;
	}
	
	// Code From MonsterController.uc next
	bNewMonsterEnemy = bHateMonster && Level.Game.NumPlayers < 4 && !Monster(Pawn).SameSpeciesAs(NewEnemy) && !NewEnemy.Controller.bIsPlayer;
	if ( !NewEnemy.Controller.bIsPlayer	&& !bNewMonsterEnemy )
		Return False;
	
	if ( Enemy == None || !EnemyVisible() || (bNewMonsterEnemy && LineOfSightTo(NewEnemy)) )  {
		ChangeEnemy(NewEnemy, CanSee(NewEnemy));
		TriggerFirstSeePlayerEvent();
		Return True;
	}
	
	if ( !CanSee(NewEnemy) || (!bHateMonster && Monster(Enemy) != None && NewEnemy.Controller.bIsPlayer) )
		Return False;
	
	EnemyDistSquared = VSizeSquared(Enemy.Location - Pawn.Location);
	if ( EnemyDistSquared < Square(Pawn.MeleeRange) )
		Return False;
	
	if ( EnemyDistSquared > 1.7 * VSizeSquared(NewEnemy.Location - Pawn.Location) )  {
		ChangeEnemy(NewEnemy,CanSee(NewEnemy));
		TriggerFirstSeePlayerEvent();
		Return True;
	}
	
	Return False;
}

function bool FindNewEnemy()
{
	local	byte			i;
	local	Pawn			BestEnemy;
	local	bool			bSeeBest;
	local	float			BestDist, NewDist;
	local	UM_BaseGameInfo	GameInfo;
	local	UM_HumanPawn	Human;
	local	float			HighestThreatLevel,	ThreatLevel;

	if ( KFM.bNoAutoHuntEnemies )
		Return False;

	GameInfo = UM_BaseGameInfo(Level.Game);
	if ( GameInfo == None || GameInfo.PlayerList.Length < 1 )
		Return False;

	for ( i = 0; i < GameInfo.PlayerList.Length; ++i )  {
		Human = UM_HumanPawn(GameInfo.PlayerList[i].Pawn);
		if ( Human == None || Human.Health < 1 || Human.bPendingDelete )
			continue;	// skip
		
		if ( bUseThreatAssessment )  {
			ThreatLevel = Human.AssessThreatTo(self, true);
			if ( ThreatLevel <= 0 )
				continue;
			
			if ( ThreatLevel > HighestThreatLevel )  {
				HighestThreatLevel = ThreatLevel;
				BestEnemy = Human;
				bSeeBest = CanSee(Human);
			}
		}
		// Dont use threat assessment.  Fall back on the old Distance based stuff.
		else  {
			NewDist = VSizeSquared(Human.Location - Pawn.Location);
			if ( BestEnemy == None || NewDist < BestDist )  {
				BestEnemy = Human;
				BestDist = NewDist;
			}
		}
	}

	if ( BestEnemy != None )  {
		ChangeEnemy(BestEnemy, bSeeBest);
		Return True;
	}

	Return False;
}

// Handles tactical attacking state selection - choose which type of attack to do from here
function ChooseAttackMode()
{
	GoalString = " ChooseAttackMode last seen "$(Level.TimeSeconds - LastSeenTime);
	// should I run away?
	if ( Enemy == None || Pawn == None )
		log("HERE 1 Enemy "$Enemy$" pawn "$Pawn);
	
	GoalString = "ChooseAttackMode FightEnemy";
	FightEnemy(True);
}

function bool FindRoamDest()
{
	local	actor	BestPath;

	if ( Pawn.FindAnchorFailedTime == Level.TimeSeconds )  {
		// couldn't find an anchor.
		GoalString = "No anchor "$Level.TimeSeconds;
		if ( Pawn.LastValidAnchorTime > 5 )  {
			if ( bSoaking )
				SoakStop("NO PATH AVAILABLE!!!");
			else  {
				if ( NumRandomJumps > 5 )  {
					Pawn.Health = 0;
					Pawn.Died( self, class'Suicided', Pawn.Location );
					
					Return True;
				}
				else  {
					// jump
					NumRandomJumps++;
					if ( Physics != PHYS_Falling )  {
						Pawn.SetPhysics(PHYS_Falling);
						// Pawn.Velocity = 0.5 * Pawn.GroundSpeed * VRand();
						Pawn.Velocity.Z = Pawn.JumpZ;
					}
				}
			}
		}
		//log(self$" Find Anchor failed!");
		
		Return False;
	}
	
	NumRandomJumps = 0;
	GoalString = "Find roam dest "$Level.TimeSeconds;
	// find random NavigationPoint to roam to
	if ( RouteGoal == None || Pawn.Anchor == RouteGoal || Pawn.ReachedDestination(RouteGoal) )  {
		RouteGoal = FindRandomDest();
		BestPath = RouteCache[0];
		if ( RouteGoal == None )  {
			if ( bSoaking && Physics != PHYS_Falling )
				SoakStop("COULDN'T FIND ROAM DESTINATION");
			
			Return False;
		}
	}
	
	if ( BestPath == None )
		BestPath = FindPathToward(RouteGoal,false);
	
	if ( BestPath != None )  {
		MoveTarget = BestPath;
		GotoState('ZombieRoam');
		
		Return True;
	}
	
	if ( bSoaking && Physics != PHYS_Falling )
		SoakStop("COULDN'T FIND ROAM PATH TO "$RouteGoal);
	
	RouteGoal = None;
	
	Return False;
}

function WanderOrCamp(bool bMayCrouch)
{
	if ( KFM.bNoAutoHuntEnemies )
		GoToState('WaitToStart');
	else
		FindRoamDest();
}

function TriggerFirstSeePlayerEvent()
{
	if ( bTriggeredFirstEvent )
		Return;
	
	bTriggeredFirstEvent = True;
	if ( KFM.FirstSeePlayerEvent != '' )
		TriggerEvent(KFM.FirstSeePlayerEvent, Pawn, Pawn);
}

State WaitToStart
{
	ignores Tick, Timer, FindNewEnemy, NotifyLanded, DoWaitForLanding;

	event BeginState()
	{
		Pawn.AmbientSound = None;
		Enemy = None;
		Focus = None;
		FocalPoint = Pawn.Location + vector(Pawn.Rotation) * 5000.0;
		Pawn.Acceleration = vect(0,0,0);
	}
	
	event Trigger( Actor Other, Pawn EventInstigator )
	{
		SetEnemy(EventInstigator, True);
		WhatToDoNext(56);
	}
	
	function bool SetEnemy( Pawn NewEnemy, optional bool bHateMonster, optional float MonsterHateChanceOverride )
	{
		if ( Level.TimeSeconds < 1.0 )
			Return False;
		
		Return Global.SetEnemy(NewEnemy, bHateMonster, MonsterHateChanceOverride);
	}
	
	event EndState()
	{
		if ( Pawn.Health > 0 )  {
			TriggerFirstSeePlayerEvent();			
			Pawn.AmbientSound = Pawn.Default.AmbientSound;
		}
	}
}

function ExecuteWhatToDoNext()
{
	bHasFired = False;
	GoalString = "WhatToDoNext at "$Level.TimeSeconds;
	
	if ( Pawn == None )  {
		warn(GetHumanReadableName()$" WhatToDoNext with no pawn");
		Return;
	}
	
	if ( KFM.bStartUpDisabled )  {
		KFM.bStartUpDisabled = False;
		GoToState('WaitToStart');
		Return;
	}
	
	if ( KFM.bShotAnim )  {
		GoToState('WaitForAnim');
		Return;
	}
	
	if ( Level.Game.bGameEnded && FindFreshBody() )
		Return;
	
	if ( Pawn.Physics == PHYS_None )
		Pawn.SetMovementPhysics();
	
	if ( Pawn.Physics == PHYS_Falling && DoWaitForLanding() )
		Return;
		
	if ( Enemy != None && (Enemy.Health <= 0 || Enemy.Controller == None) )
		Enemy = None;

	if ( Enemy == None || !EnemyVisible() )
		FindNewEnemy();

	if ( Enemy != None )
		ChooseAttackMode();
	else  {
		GoalString = "WhatToDoNext Wander or Camp at "$Level.TimeSeconds;
		WanderOrCamp(True);
	}
}

// Check if just above ground - if so land
function TryToWalk()
{
	local	vector	HitLocation, HitNormal, Extent;
	local	actor	HitActor;

	if ( Pawn.PhysicsVolume.bWaterVolume )
		Return;

	Extent = Pawn.GetCollisionExtent();
	HitActor = Trace(HitLocation, HitNormal, Pawn.Location - vect(0,0,100), Pawn.Location, false, Extent);
	
	if ( HitActor != None && HitActor.bWorldGeometry && HitNormal.Z > MINFLOORZ )
		Pawn.SetPhysics(PHYS_Falling);
}

function string GetOldEnemyName()
{
	if ( OldEnemy == None )
		Return "NONE";
	else
		Return OldEnemy.GetHumanReadableName();
}

function string GetEnemyName()
{
	if ( Enemy == None )
		Return "NONE";
	else
		Return Enemy.GetHumanReadableName();
}

function WhatToDoNext(byte CallingByte)
{
	if ( ChoosingAttackLevel > 0 )
		log("CHOOSEATTACKAGAIN in state "$GetStateName()$" enemy "$GetEnemyName()$" old enemy "$GetOldEnemyName()$" CALLING BYTE "$CallingByte);

	if ( ChooseAttackTime == Level.TimeSeconds )  {
		ChooseAttackCounter++;
		if ( ChooseAttackCounter > 3 )
			log("CHOOSEATTACKSERIAL in state "$GetStateName()$" enemy "$GetEnemyName()$" old enemy "$GetOldEnemyName()$" CALLING BYTE "$CallingByte);
	}
	else  {
		ChooseAttackTime = Level.TimeSeconds;
		ChooseAttackCounter = 0;
	}
	
	if ( Monster(Pawn).bTryToWalk && Pawn.Physics == PHYS_Flying && ChoosingAttackLevel == 0 && ChooseAttackCounter == 0 )
		TryToWalk();
	
	ChoosingAttackLevel++;
	ExecuteWhatToDoNext();
	ChoosingAttackLevel--;
}

function DamageAttitudeTo(Pawn Other, float Damage)
{
	if ( !ActorReachable(Other) )
		Return;
	
	if ( UM_BaseMonster(Other) != None )  {
		if ( SetEnemy(Other, True, FriendlyFireAggroChance) )
			WhatToDoNext(5);
	}
	else if ( SetEnemy(Other, True) )
		WhatToDoNext(5);
}

function NotifyTakeHit(Pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	if ( InstigatedBy == None || Pawn == None || InstigatedBy == Pawn || Pawn.Health < 1 || InstigatedBy.Health < 1 || Damage < 1 )
		Return;
	
	DamageAttitudeTo(InstigatedBy, Damage);
}


state WaitForAnim
{
	ignores SeePlayer, HearNoise, Timer, EnemyNotVisible, NotifyBump, Startle;

	event BeginState()
	{
		bUseFreezeHack = False;
	}
	
	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

	event AnimEnd(int Channel)
	{
		Pawn.AnimEnd(Channel);
		if ( !Monster(Pawn).bShotAnim )
			WhatToDoNext(99);
	}

	event Tick( float Delta )
	{
		Global.Tick(Delta);
		if ( bUseFreezeHack )  {
			MoveTarget = None;
			MoveTimer = -1;
			Pawn.Acceleration = vect(0.0,0.0,0.0);
			Pawn.GroundSpeed = 1;
			Pawn.AccelRate = 0;
		}
	}
	
	event EndState()
	{
		if ( Pawn != None )  {
			Pawn.AccelRate = Pawn.Default.AccelRate;
			Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
		}
		bUseFreezeHack = False;
	}

Begin:
	While( KFM.bShotAnim )
		Sleep(0.15);

	WhatToDoNext(99);
}

state Hunting
{
ignores EnemyNotVisible;

	function bool IsHunting()
	{
		Return True;
	}

	/* 	MayFall() called by] engine physics if walking and bCanJump, and
		is about to go off a ledge.  Pawn has opportunity (by setting
		bCanJump to false) to avoid fall	*/
	function MayFall()
	{
		Pawn.bCanJump = ( MoveTarget == None || MoveTarget.Physics != PHYS_Falling || !MoveTarget.IsA('Pickup') );
	}

	event SeePlayer(Pawn SeenPlayer)
	{
		if ( SeenPlayer == Enemy )  {
			if ( (Level.timeseconds - ChallengeTime) > 7.0 )  {
				ChallengeTime = Level.TimeSeconds;
				Monster(Pawn).PlayChallengeSound();
			}
			VisibleEnemy = Enemy;
			EnemyVisibilityTime = Level.TimeSeconds;
			bEnemyIsVisible = True;
			Focus = Enemy;
			WhatToDoNext(22);
		}
		else
			Global.SeePlayer(SeenPlayer);
	}

	event Timer()
	{
		SetCombatTimer();
		StopFiring();
	}

	function PickDestination()
	{
		local vector nextSpot, ViewSpot,Dir;
		local float posZ;
		local bool bCanSeeLastSeen;

		// If no enemy, or I should see him but don't, then give up
		if ( Enemy == None || Enemy.Health < 1 )  {
			Enemy = None;
			WhatToDoNext(23);
			Return;
		}

		if ( Pawn.JumpZ > 0 )
			Pawn.bCanJump = True;

		if ( ActorReachable(Enemy) )  {
			Destination = Enemy.Location;
			MoveTarget = None;
			Return;
		}

		ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
		bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

		if ( FindBestPathToward(Enemy, True, True) )
			Return;

		if ( bSoaking && Physics != PHYS_Falling )
			SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

		MoveTarget = None;
		if ( !bEnemyInfoValid )  {
			Enemy = None;
			WhatToDoNext(26);
			Return;
		}

		Destination = LastSeeingPos;
		bEnemyInfoValid = False;
		if ( FastTrace(Enemy.Location, ViewSpot) && VSizeSquared(Pawn.Location - Destination) > Square(Pawn.CollisionRadius) )  {
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
			if ( VSizeSquared(Dir) < Square(Pawn.CollisionRadius) )  {
				GoalString = "Stakeout 3 from hunt";
				GotoState('StakeOut');
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
				else  {
					GoalString = "Stakeout 2 from hunt";
					GotoState('StakeOut');
					Return;
				}
			}
		}
	}

	function bool FindViewSpot()
	{
		local	vector	X, Y, Z;

		GetAxes(Rotation, X, Y, Z);

		// try left and right
		if ( FastTrace(Enemy.Location, (Pawn.Location + 2.0 * Y * Pawn.CollisionRadius)) )  {
			Destination = Pawn.Location + 2.5 * Y * Pawn.CollisionRadius;
			Return True;
		}
		
		Destination = Pawn.Location - 2.5 * Y * Pawn.CollisionRadius;
		Return True;
	}

	event EndState()
	{
		if ( Pawn != None && Pawn.JumpZ > 0 )
			Pawn.bCanJump = True;
	}

AdjustFromWall:
	MoveTo(Destination, MoveTarget);

Begin:
	WaitForLanding();
	if ( CanSee(Enemy) )
		SeePlayer(Enemy);

WaitForAnim:
	FinishAnim(0);
	PickDestination();
	if ( (Level.timeseconds - ChallengeTime) > 10.0 )  {
		ChallengeTime = Level.TimeSeconds;
		Monster(Pawn).PlayChallengeSound();
	}

SpecialNavig:
	if ( MoveTarget == None )
		MoveTo(Destination);
	else
		MoveToward( MoveTarget, FaceActor(10),, (FRand() < 0.75 && ShouldStrafeTo(MoveTarget)) );

	WhatToDoNext(27);
	if ( bSoaking )
		SoakStop("STUCK IN HUNTING!");
}


state DoorBashing
{
	ignores EnemyNotVisible, SeeMonster;

	event Timer()
	{
		Disable('NotifyBump');
	}

	function AttackDoor()
	{
		// Don't move while we are bashing a door!
		MoveTarget = None;
		MoveTimer = -1;
		Target = TargetDoor;
		KFM.DoorAttack(Target);
	}
	
	event SeePlayer( Pawn Seen )
	{
		// Only the smarties will react to seen Pawn
		if ( Seen != None && KFM.Intelligence == BRAINS_Human && ActorReachable(Seen) && SetEnemy(Seen) )
			WhatToDoNext(23);
	}
	
	function DamageAttitudeTo( Pawn Other, float Damage )
	{
		if ( KFM.Intelligence >= BRAINS_Mammal && ActorReachable(Other) && SetEnemy(Other) )
			WhatToDoNext(32);
	}
	
	event HearNoise( float Loudness, Actor NoiseMaker )
	{
		local	Pawn	NoiseMakerPawn;
		
		// Only the smarties will react on any Noise
		if ( KFM.Intelligence < BRAINS_Human && Loudness < 1.0 )
			Return;
		
		if ( Pawn(NoiseMaker) != None )
			NoiseMakerPawn = Pawn(NoiseMaker);
		else
			NoiseMakerPawn = NoiseMaker.Instigator;
		
		if ( NoiseMakerPawn != None && KFM.Intelligence >= BRAINS_Mammal && ActorReachable(NoiseMakerPawn) && SetEnemy(NoiseMakerPawn) )
			WhatToDoNext(32);
	}

	event EndState()
	{
		if ( UM_BaseMonster(Pawn) != None )
			UM_BaseMonster(Pawn).EndDoorBashing();
	}

Begin:
	WaitForLanding(); // Native latent function

KeepMoving:
	// Finish prev anim
	if ( KFM.bShotAnim )
		FinishAnim(0);
	
	While ( TargetDoor != None && !TargetDoor.bHidden && TargetDoor.bSealed && !TargetDoor.bZombiesIgnore )  {
		AttackDoor();
		if ( KFM.bShotAnim )
			FinishAnim(0);
		// Try to attack the real enemy.
		if ( Enemy != None && KFM.Intelligence >= BRAINS_Mammal && ActorReachable(Enemy) )
			WhatToDoNext(14);
	}
	
	WhatToDoNext(152);

Moving:
	MoveToward(TargetDoor);
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

// Something has startled this actor and they want to stay away from it
function Startle(Actor Feared)
{
	if ( Monster(Pawn) != None && !Monster(Pawn).bShotAnim && Skill > (1 + 2.0 * FRand()) )  {
		GoalString = "STARTLED!";
		StartleActor = Feared;
		GotoState('Startled');
	}
}

state Startled
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;

	event BeginState()
	{
		// FIXME - need FindPathAwayFrom()
		Pawn.Acceleration = Pawn.Location - StartleActor.Location;
		Pawn.Acceleration.Z = 0;
		Pawn.bIsWalking = False;
		Pawn.bWantsToCrouch = False;
		if ( Pawn.Acceleration == vect(0,0,0) )
			Pawn.Acceleration = VRand();
		Pawn.Acceleration = Pawn.AccelRate * Normal(Pawn.Acceleration);
	}
	
	function Startle(Actor Feared)
	{
		GoalString = "STARTLED!";
		StartleActor = Feared;
		BeginState();
	}

Begin:
	Sleep(0.5);
	WhatToDoNext(11);
	Goto('Begin');
}

state ZombieHunt
{
	event BeginState() { }
	
	event EndState() { }
	
	event Timer()
	{
		if ( Pawn.Velocity == vect(0.0,0.0,0.0) )
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
		
		if ( Enemy != None && !KFM.bCannibal && Enemy.Health < 1 )  {
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
			else if ( FindBestPathToward(InitialPathGoal, True, True) )
				Return;
			else 
				PathFindState = 2;
		}

		if ( Pawn.JumpZ > 0 )
			Pawn.bCanJump = True;

		if ( KFM.Intelligence == BRAINS_Retarded && FRand() < 0.25 )  {
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

		if ( FindBestPathToward(Enemy, True, True) )
			Return;

		if ( bSoaking && Physics != PHYS_Falling )
			SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

		MoveTarget = None;
		if ( !bEnemyInfoValid )  {
			Enemy = None;
			GotoState('StakeOut');
			Return;
		}

		Destination = LastSeeingPos;
		bEnemyInfoValid = False;
		if ( FastTrace(Enemy.Location, ViewSpot) && VSizeSquared(Pawn.Location - Destination) > Square(Pawn.CollisionRadius) )  {
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

function bool EnemyThreatChanged()
{
	local	UM_BaseGameInfo		GameInfo;
	local	UM_HumanPawn		Human;
	local	float				NewThreat, CurrentThreat;
	local	byte				i;

	if ( !bUseThreatAssessment )
		Return False;

	if ( KFHumanPawn(Enemy) != None )
		CurrentThreat = KFHumanPawn(Enemy).AssessThreatTo(self);
	else
		Return True;

	/* Current Enemy is of no threat suddenly */
	if ( CurrentThreat < 1 )
		Return True;
	
	GameInfo = UM_BaseGameInfo(Level.Game);
	if ( GameInfo == None || GameInfo.PlayerList.Length < 1 )
		Return False;
	
	for ( i = 0; i < GameInfo.PlayerList.Length; ++i )  {
		Human = UM_HumanPawn(GameInfo.PlayerList[i].Pawn);
		if ( Human == None || Human.Health < 1 || Human.bPendingDelete || Human == Enemy )
			continue;	// skip
		
		NewThreat = Human.AssessThreatTo(self);
		// There's another guy nearby with a greater threat than me
		if ( NewThreat > CurrentThreat )
			Return True;
	}

	Return False;
}

// extends Charging
state ZombieCharge
{
	event SeePlayer( Pawn Seen )
	{
		if ( Seen != None && KFM.Intelligence == BRAINS_Human && ActorReachable(Seen) &&SetEnemy(Seen) )
			WhatToDoNext(23);
	}
	
	function DamageAttitudeTo( Pawn Other, float Damage )
	{
		if ( KFM.Intelligence < BRAINS_Stupid || !ActorReachable(Other) )
			Return;
		
		if ( UM_BaseMonster(Other) != None )  {
			if ( SetEnemy(Other, True, FriendlyFireAggroChance) )
				WhatToDoNext(5);
		}
		else if ( Enemy != None && VSizeSquared(Enemy.Location - Pawn.Location) <= VSizeSquared(Other.Location - Pawn.Location) && SetEnemy(Other, True) )
			WhatToDoNext(5);
	}
	
	event HearNoise( float Loudness, Actor NoiseMaker )
	{
		local	Pawn	NoiseMakerPawn;
		
		// Only the smarties will react on any Noise
		if ( KFM.Intelligence < BRAINS_Human || Loudness < 1.0 )
			Return;
		
		if ( Pawn(NoiseMaker) != None )
			NoiseMakerPawn = Pawn(NoiseMaker);
		else
			NoiseMakerPawn = NoiseMaker.Instigator;
		
		if ( NoiseMakerPawn != None && FastTrace(NoiseMakerPawn.Location, Pawn.Location) )
			SetEnemy(NoiseMakerPawn);
	}
	
	function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
	{
		Return False;
	}

	// I suspect this function causes bloats to get confused
	function bool TryStrafe(vector sideDir)
	{
		Return False;
	}

	function NotifyTakeHit(Pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> DamageType, vector Momentum)
	{
		Global.NotifyTakeHit(InstigatedBy, HitLocation, Damage, DamageType, Momentum);
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )  {
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	if ( Enemy == None )
		WhatToDoNext(16);
	
WaitForAnim:
	While( KFM.bShotAnim )
		FinishAnim(0);
	if ( !FindBestPathToward(Enemy, False, True) )
		GotoState('TacticalMove');

Moving:
	if ( KFM.Intelligence == BRAINS_Retarded )  {
		if ( FRand() < 0.3 )
			MoveTo((Pawn.Location + VRand() * 200.0), None);
		else if ( MoveTarget == Enemy && FRand() < 0.5 )
			MoveTo((MoveTarget.Location + VRand() * 50.0), None);
		else 
			MoveToward(MoveTarget,FaceActor(1),, ShouldStrafeTo(MoveTarget));
	}
	else 
		MoveToward(MoveTarget, FaceActor(1),, ShouldStrafeTo(MoveTarget));
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

function DoTacticalMove() {}

function DoCharge()
{
	if ( Pawn == None )
		Return;
	
	if ( Enemy.PhysicsVolume.bWaterVolume )  {
		if ( !Pawn.bCanSwim )  {
			DoTacticalMove();
			Return;
		}
	}
	else  {
		if ( KFM.MeleeRange != KFM.default.MeleeRange )
			KFM.MeleeRange = KFM.default.MeleeRange;
		GotoState('ZombieCharge');
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

	if ( Enemy == None || Enemy.Health < 1 || EnemyThreatChanged() )
		FindNewEnemy();

	if ( Enemy == FailedHuntEnemy && Level.TimeSeconds == FailedHuntTime )  {
		if ( Enemy == FailedHuntEnemy )  {
			GoalString = "FAILED HUNT - HANG OUT";
			if ( EnemyVisible() )
				bCanCharge = False;
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

state Kicking
{
	ignores EnemyNotVisible;

Begin:

WaitForAnim:
	if ( KFM.bShotAnim && KickTarget != None )  {
		//MoveToward(KickTarget,FaceActor(1),,false ); //,GetDesiredOffset(),ShouldStrafeTo(MoveTarget));
		Sleep(0.1);
		Goto('WaitForAnim');
	}


	WhatToDoNext(152);
	if ( bSoaking )
		SoakStop("STUCK IN KICKING!!!");
}

function SetKnockDownTime(float KnockDownDuration)
{
	if ( KnockDownDuration <= 0.0 )
		Return;
	
	if ( Level.TimeSeconds >= KnockDownEndTime || KnockDownDuration > (KnockDownEndTime - Level.TimeSeconds) )
		KnockDownEndTime = Level.TimeSeconds + KnockDownDuration;
}

state KnockedDown
{
	ignores SeePlayer, HearNoise, Timer, EnemyNotVisible, NotifyBump, Startle;

	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin) { }
	
	event AnimEnd(int Channel)
	{
		Pawn.AnimEnd(Channel);
	}

Begin:
	MoveTarget = None;
	MoveTimer = -1;

WaitForAnimEnd:
	FinishAnim(0);
	if ( Level.TimeSeconds < KnockDownEndTime )  {
		if ( UM_HumanPawn(Pawn) != None )
			UM_HumanPawn(Pawn).PlayKnockDown();
		GoTo('WaitForAnimEnd');
	}
	
	if ( UM_HumanPawn(Pawn) != None )
		UM_HumanPawn(Pawn).EndKnockDown();
	
	WhatToDoNext(99);
	if ( bSoaking )
		SoakStop("STUCK IN KnockDown!!!");
}

// State for being scared of something, the bot attempts to move away from it
state ZombiePushedAway
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;
	
Begin:
	WaitForLanding();
	Sleep(0.4);
	WhatToDoNext(99);
}

state IamDazzled
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;
	
Begin:
	//Sleep(MyDazzleTime);
	Sleep(10);
	WhatToDoNext(99);
}

defaultproperties
{
	//MyDazzleTime=10.000000
	FriendlyFireAggroChance=0.5
}