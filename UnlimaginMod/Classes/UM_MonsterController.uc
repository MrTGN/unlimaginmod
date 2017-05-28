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
var		transient	float				StunEndTime;

var					float				FriendlyFireAggroChance;

var					UM_BaseMonster		MyMonster;

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		MyMonster;
}

function InitPlayerReplicationInfo()
{
	PlayerReplicationInfo = Spawn(PlayerReplicationInfoClass, Self,,vect(0,0,0),rot(0,0,0));
	if ( PlayerReplicationInfo == None )
		Return;
	
	if ( PlayerReplicationInfo.PlayerName == "" )
		PlayerReplicationInfo.SetPlayerName(class'GameInfo'.Default.DefaultPlayerName);

	PlayerReplicationInfo.bNoTeam = !Level.Game.bTeamGame;
}

function Reset()
{
    TargetDoor = None;
	TargetCorpse = None;
	KickTarget = None;
	StartleActor = None;
	AvoidMonster = None;
	KillAssistants.Length = 0;
	MoanTime = Level.TimeSeconds + Lerp(FRand(), 4.0, 30.0);
	Super(Controller).Reset();
}

function FearThisSpot(AvoidMarker aSpot)
{
	if ( Pawn == None || Skill < Lerp(FRand(), 1.0, 3.0) || !LineOfSightTo(aSpot) )
		Return;

	// Check FearSpots[0]
	if ( FearSpots[0] == None || VSizeSquared(Pawn.Location - FearSpots[0].Location) > VSizeSquared(Pawn.Location - aSpot.Location) )  {
		FearSpots[0] = aSpot;
		Return;
	}
	
	// Check FearSpots[1]
	if ( FearSpots[1] == None || VSizeSquared(Pawn.Location - FearSpots[1].Location) > VSizeSquared(Pawn.Location - aSpot.Location) )  {
		FearSpots[1] = aSpot;
		Return;
	}
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

	MoanTime = Level.TimeSeconds + Lerp(FRand(), 4.0, 30.0);
	EvaluateTime = Level.TimeSeconds;
	TimeToSet = Level.TimeSeconds;
	ItsSet = False;

	// Kind of a hack, but it's the safest way to toggle Threat assessment behaviour right now ..
	bUseThreatAssessment = KFGameType(Level.Game) != None && KFGameType(Level.Game).bUseZEDThreatAssessment;
}

function SetPeripheralVision()
{
	if ( Pawn == None )
		Return;
	
	if ( Skill < 2.0 )
		Pawn.PeripheralVision = 0.7;
	else if ( Skill < 5.0 )
		Pawn.PeripheralVision = 1.0 - 0.2 * Skill;
	else
		Pawn.PeripheralVision = 0.0;

	Pawn.SightRadius = Pawn.Default.SightRadius;
}

function SetMaxDesiredSpeed()
{
	if ( Pawn == None )
		Return;
	
	if ( Skill > 3.0 )
		Pawn.MaxDesiredSpeed = 1;
	else
		Pawn.MaxDesiredSpeed = 0.6 + 0.1 * Skill;
}

function ResetSkill()
{
	bLeadTarget = Skill >= 4.0;
	SetCombatTimer();
	SetPeripheralVision();
	if ( (Skill + ReactionTime) > 7.0 )
		RotationRate.Yaw = 90000;
	else if ( (Skill + ReactionTime) >= 4.0 )
		RotationRate.Yaw = 20000 + 7000 * (Skill + ReactionTime);
	else
		RotationRate.Yaw = 30000 + 4000 * (Skill + ReactionTime);
	AcquisitionYawRate = Round(0.75 + 0.05 * ReactionTime) * RotationRate.Yaw;
	SetMaxDesiredSpeed();
}

function InitializeSkill(float InSkill)
{
	Skill = FClamp(InSkill, 0.0, 7.0);
	ReSetSkill();
}

function Restart()
{
	if ( Pawn == None || MyMonster.bStartUpDisabled )
		Return;
	
	Enemy = None;
	InitializeSkill(DeathMatch(Level.Game).AdjustedDifficulty);
	Pawn.MaxFallSpeed = 1.1 * Pawn.default.MaxFallSpeed; // so bots will accept a little falling damage for shorter routes
	Pawn.SetMovementPhysics();
	if ( Pawn.Physics == PHYS_Walking )
		Pawn.SetPhysics(PHYS_Falling);
	
	Enable('NotifyBump');
	WhatToDoNext(1);
}

function Possess(Pawn aPawn)
{
	if ( aPawn == None )
		Return;
	
	// Do not allow to controll another pawns
	if ( UM_BaseMonster(aPawn) == None )  {
		aPawn.Destroy();
		Destroy();
		Return;
	}
	
	aPawn.PossessedBy(self);
	Pawn = aPawn;
	MyMonster = UM_BaseMonster(aPawn);
	if ( PlayerReplicationInfo != None )  {
		if ( Vehicle(Pawn) != None && Vehicle(Pawn).Driver != None )
			PlayerReplicationInfo.bIsFemale = Vehicle(Pawn).Driver.bIsFemale;
		else
			PlayerReplicationInfo.bIsFemale = Pawn.bIsFemale;
	}
	// preserve Pawn's rotation initially for placed Pawns
	FocalPoint = Pawn.Location + 512.0 * vector(Pawn.Rotation);
	Restart();
}

// unpossessed a pawn (not because pawn was killed)
function UnPossess()
{
	if ( Pawn != None )
		Pawn.UnPossessed();
	Pawn = None;
	MyMonster = None;
}

function AddKillAssistant(Controller PC, float Damage)
{
	local	bool	bIsalreadyAssistant;
	local	int		i;
	
	if ( PC == None || Damage <= 0.0 )
		Return;

	for ( i = 0; i < KillAssistants.Length; ++i )  {
		// Check for none
		if ( KillAssistants[i].PC == None )  {
			KillAssistants.Remove(i, 1);
			--i;
			continue;
		}
		// Try to find PC in KillAssistants
		if ( KillAssistants[i].PC == PC )  {
			bIsalreadyAssistant = True;
			KillAssistants[i].Damage += Damage;
			Break;
		}
	}

	if ( !bIsalreadyAssistant )  {
		// Add last PC to the top
		KillAssistants.Insert(0, 1);
		KillAssistants[0].PC = PC;
		KillAssistants[0].Damage = Damage;
	}
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

event ReceiveWarning(Pawn Shooter, float ProjSpeed, vector FireDir)
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
			MoveTimer = -1.0;
		}
	}
	
	Return False;
}

// Randomly plays a different moan sound for the Zombie each time it is called. Gruesome!
function ZombieMoan()
{
	MoanTime = Level.TimeSeconds + Lerp(FRand(), 12.0, 20.0);
	
	// Headless zombies can't moan.
	if ( MyMonster == None || MyMonster.Health < 1 || MyMonster.bDecapitated )
		Return;
	
	MyMonster.ZombieMoan();
}

event Tick(float DeltaTime)
{
	if ( Level.TimeSeconds >= MoanTime )
		ZombieMoan();
	
	/*
	if ( bAboutToGetDoor )  {
		bAboutToGetDoor = False;
		if ( TargetDoor != None )
			BreakUpDoor(TargetDoor, True);
	}	*/
}

/*
event AnimEnd(int Channel)
{
	if ( Pawn != None )
		Pawn.AnimEnd(Channel);
}	*/

function NotifyMonsterDecapitated()
{
	Accuracy = -5.0; // More chance of missing. (he's headless now, after all) :-D
	// We can't see and can't hear now
	Disable('SeeMonster');
	Disable('SeePlayer');
	Disable('HearNoise');
}

function float AdjustAimError(float AimError, float TargetDist, bool bDefendMelee, bool bInstantProj, bool bLeadTargetNow )
{
	if ( Pawn(Target) != None && Pawn(Target).Visibility < 2 )
		AimError *= 2.5;

	// figure out the relative motion of the target across the bots view, and adjust aim error
	// based on magnitude of relative motion
	AimError *= FMin(5.0, (12.0 - 11.0 *
		(Normal(Target.Location - Pawn.Location) Dot Normal((Target.Location + 1.2 * Target.Velocity) - (Pawn.Location + Pawn.Velocity)))) );

	// if enemy is charging straight at bot with a melee weapon, improve aim
	if ( bDefendMelee )
		AimError *= 0.5;

	if ( Target.Velocity == vect(0,0,0) )
		AimError *= 0.6;

	// aiming improves over time if stopped
	if ( Stopped() && Level.TimeSeconds > StopStartTime )  {
		if ( (Skill + Accuracy) > 4.0 )
			AimError *= 0.9;
		AimError *= FClamp((2.0 - 0.08 * FMin(Skill, 7) - FRand()) / (Level.TimeSeconds - StopStartTime + 0.4), 0.7, 1.0);
	}

	// adjust aim error based on Skill
	if ( !bDefendMelee )
		AimError *= 3.3 - 0.37 * (FClamp((Skill + Accuracy), 0.0, 8.5) + 0.5 * FRand());

	// Bots don't aim as well if recently hit, or if they or their target is flying through the air
	if ( (Skill < 7.0 || FRand() < 0.5) && (Level.TimeSeconds - Pawn.LastPainTime) < 0.2 )
		AimError *= 1.3;
	
	if ( Pawn.Physics == PHYS_Falling || Target.Physics == PHYS_Falling )
		AimError *= 1.6;

	// Bots don't aim as well at recently acquired targets (because they haven't had a chance to lock in to the target)
	if ( AcquireTime > (Level.TimeSeconds - 0.5 - 0.6 * (7.0 - Skill)) )  {
		AimError *= 1.5;
		if ( bInstantProj )
			AimError *= 1.5;
	}

	Return Lerp(FRand(), -AimError, AimError);
}

state Scripting
{
	function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
	{
		Super(AIController).DisplayDebug(Canvas,YL,YPos);
		Canvas.DrawText("AIScript "$SequenceScript$" ActionNum "$ActionNum, false);
		YPos += YL;
		Canvas.SetPos(4,YPos);
		CurrentAction.DisplayDebug(Canvas,YL,YPos);
	}

	/* UnPossess()
	scripted sequence is over - return control to PendingController
	*/
	function UnPossess()
	{
		Pawn.UnPossessed();
		if ( Pawn != None && PendingController != None )  {
			PendingController.bStasis = false;
			PendingController.Possess(Pawn);
		}
		Pawn = None;
		MyMonster = None;
		if ( !bChangingPawns )
			Destroy();
	}

	function LeaveScripting()
	{
		UnPossess();
	}

	function InitForNextAction()
	{
		SequenceScript.SetActions(self);
		if ( CurrentAction == None )  {
			LeaveScripting();
			Return;
		}
		MyScript = SequenceScript;
		if ( CurrentAnimation == None )
			ClearAnimation();
	}

	event Trigger( actor Other, pawn EventInstigator )
	{
		if ( CurrentAction.CompleteWhenTriggered() )
			CompleteAction();
	}

	event Timer()
	{
		if ( CurrentAction.WaitForPlayer() && CheckIfNearPlayer(CurrentAction.GetDistance()) )
			CompleteAction();
		else if ( CurrentAction.CompleteWhenTimer() )
			CompleteAction();
	}

	event AnimEnd(int Channel)
	{
		if ( CurrentAction != none && CurrentAction.CompleteOnAnim(Channel) )  {
			CompleteAction();
			Return;
		}
		
		if ( Channel != 0 )
			Pawn.AnimEnd(Channel);
		else if ( CurrentAnimation == None || !CurrentAnimation.PawnPlayBaseAnim(self,false) )
			ClearAnimation();
	}

	// ifdef WITH_LIPSINC
	function LIPSincAnimEnd()
	{
		if ( CurrentAction.CompleteOnLIPSincAnim() )  {
			CompleteAction();
		else
			Pawn.LIPSincAnimEnd();
	}
	// endif

	function CompleteAction()
	{
		CurrentAction.ActionCompleted();
		ActionNum++;
		GotoState('Scripting','Begin');
	}

	function SetMoveTarget()
	{
		local	Actor	NextMoveTarget;

		Focus = ScriptedFocus;
		NextMoveTarget = CurrentAction.GetMoveTargetFor(self);
		if ( NextMoveTarget == None )  {
			GotoState('Broken');
			Return;
		}
		if ( Focus == None )
			Focus = NextMoveTarget;
		MoveTarget = NextMoveTarget;
		if ( !ActorReachable(MoveTarget) )  {
			MoveTarget = FindPathToward(MoveTarget,false);
			if ( Movetarget == None )  {
				AbortScript();
				Return;
			}
			if ( Focus == NextMoveTarget )
				Focus = MoveTarget;
		}
	}

	function AbortScript()
	{
		LeaveScripting();
	}
	
	/* WeaponFireAgain()
	Notification from weapon when it is ready to fire (either just finished firing,
	or just finished coming up/reloading).
	Returns true if weapon should fire.
	If it returns false, can optionally set up a weapon change
	*/
	function bool WeaponFireAgain(float RefireRate, bool bFinishedFire)
	{
		if ( bFineWeaponControl )
			Return True;
		
		if ( Pawn.bIgnorePlayFiring )  {
			Pawn.bIgnorePlayFiring = False;
			Return False;
		}
		
		if ( NumShots < 0 )  {
			bShootTarget = False;
			bShootSpray = False;
			StopFiring();
			Return False;
		}
		
		if ( bShootTarget && ScriptedFocus != None && !ScriptedFocus.bDeleteMe )  {
			Target = ScriptedFocus;
			if ( (!bShootSpray && Pawn.Weapon.RefireRate() < 0.99 && !Pawn.Weapon.CanAttack(Target))
				|| !Pawn.Weapon.BotFire(bFinishedFire,FiringMode) )  {
				Enable('Tick'); //FIXME - use multiple timer for this instead
				bPendingShoot = True;
				Return False;
			}
			
			if ( NumShots > 0 )  {
				NumShots--;
				if ( NumShots == 0 )
					NumShots = -1;
			}
			
			Return True;
		}
		
		StopFiring();
		Return False;
	}
	
	function MayShootAtEnemy();

	function MayShootTarget()
	{
		WeaponFireAgain(0, False);
	}

	event Tick(float DeltaTime)
	{
		if ( bPendingShoot )  {
			bPendingShoot = False;
			MayShootTarget();
		}
		
		if ( !bPendingShoot && (CurrentAction == None || !CurrentAction.StillTicking(self,DeltaTime)) )
			Disable('Tick');
	}

	event EndState()
	{
		bUseScriptFacing = true;
		bFakeShot = false;
	}

Begin:
	InitforNextAction();
	if ( bBroken )
		GotoState('Broken');
	
	if ( CurrentAction.TickedAction() )
		Enable('Tick');
	
	if ( !bFineWeaponControl )  {
		if ( !bShootTarget )  {
			bFire = 0;
			bAltFire = 0;
		}
		else  {
			Pawn.Weapon.RateSelf();
			if ( bShootSpray )
				MayShootTarget();
		}
	}
	
	if ( CurrentAction.MoveToGoal() )  {
		Pawn.SetMovementPhysics();
		if ( Pawn.Physics == PHYS_Falling )
			WaitForLanding();

KeepMoving:
		SetMoveTarget();
		MayShootTarget();
		if ( MoveTarget != None && MoveTarget != Pawn )  {
			MoveToward(MoveTarget, Focus,,,Pawn.bIsWalking);
			if ( MoveTarget != CurrentAction.GetMoveTargetFor(self) || !Pawn.ReachedDestination(CurrentAction.GetMoveTargetFor(self)) )
				Goto('KeepMoving');
		}
		CompleteAction();
	}
	else if ( CurrentAction.TurnToGoal() )  {
		Pawn.SetMovementPhysics();
		Focus = CurrentAction.GetMoveTargetFor(self);
		if ( Focus == None )
			FocalPoint = Pawn.Location + 1000.0 * vector(SequenceScript.Rotation);
		FinishRotation();
		CompleteAction();
	}
	else  {
		//Pawn.SetPhysics(PHYS_RootMotion);
		Pawn.Acceleration = vect(0,0,0);
		Focus = ScriptedFocus;
		if ( !bUseScriptFacing )
			FocalPoint = Pawn.Location + 1000.0 * vector(Pawn.Rotation);
		else if ( Focus == None )  {
			MayShootAtEnemy();
			FocalPoint = Pawn.Location + 1000.0 * vector(SequenceScript.Rotation);
		}
		FinishRotation();
		MayShootTarget();
	}
}

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	if ( UM_BaseGameInfo(Level.Game) == None || UM_BaseMonster(Pawn) == None || !UM_BaseMonster(Pawn).bAllowRespawnIfLost )
		Return False;

	Return (Level.TimeSeconds - UM_BaseMonster(Pawn).LastPlayersSeenTime) > 40.0;
}

function bool DoWaitForLanding()
{
	GotoState('WaitingForLanding');
	Return True;
}

function bool CanAttack(Actor A)
{
	// return true if in range of current weapon
	Return MyMonster.CanAttack(A);
}

function bool FireWeaponAt(Actor A)
{
	if ( A == None )
		A = Enemy;
	
	if ( A == None || MyMonster == None || Focus != A || !MyMonster.CanAttack(A) )
		Return False;
	
	Target = A;
	MyMonster.RangedAttack(Target);
	
	//ToDo: ïî ëîãèêå äëÿ çàäåðæêè âûñòðåëà äîëæíî âîçâðàùàòüñÿ True. #Ïðîâåðèòü!!!
	//Return False;
	Return True;
}

function TimedFireWeaponAtEnemy()
{
	if ( Enemy == None || FireWeaponAt(Enemy) )
		SetCombatTimer();
	else
		SetTimer(0.1, True);
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
		// Check for blocking doors
		if ( !IsInState('DoorBashing') && MyMonster.bCanDistanceAttackDoors )  {
			A = Trace(HitLoc, HitNorm, MoveTarget.Location, Pawn.Location, False);
			if ( KFDoorMover(A) != None && MyMonster.CanAttackDoor(KFDoorMover(A)) )  {
				//TargetDoor = KFDoorMover(A);
				//bAboutToGetDoor = True;
				BreakUpDoor(KFDoorMover(A), True);
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

// If we're not dead, and we can see our target, and we still have a head. lets go eat it.
function bool FindFreshBody()
{
	local	KFGameType		K;
	local	int				i;
	local	PlayerDeathMark	Best;
	local	float			Dist, BDist;

	K = KFGameType(Level.Game);
	if ( K == None || MyMonster.bDecapitated || !MyMonster.bCannibal || (!K.bGameEnded && float(Pawn.Health) >= (Pawn.Default.Health * 1.5)) )
		Return False;

	for ( i = 0; i < K.DeathMarkers.Length; ++i )  {
		if ( K.DeathMarkers[i] == None )
			Continue; // skip
		
		Dist = VSizeSquared(K.DeathMarkers[i].Location - Pawn.Location);
		if ( Dist < 640000.0 && ActorReachable(K.DeathMarkers[i]) && (Best == None || Dist < BDist) )  {
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

state CorpseFeeding
{
	ignores EnemyNotVisible, SeePlayer, HearNoise, NotifyBump;

	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin)  { }
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}

	event Timer()
	{
		Target = TargetCorpse;
		if ( Target == None )
			WhatToDoNext(38);
	}
	
	function AttackCorpse()	{ }
	
	event EndState()
	{
		MyMonster.EnableMovement();
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	While ( TargetCorpse != None && !ActorReachable(TargetCorpse) )  {
		if ( !FindBestPathToward(TargetCorpse, True, False) )  {
			WhatToDoNext(33);
			Break;
		}
		if ( MoveTarget != None )
			MoveToward(MoveTarget, MoveTarget);
	}
	
	if ( TargetCorpse == None )
		WhatToDoNext(32);
	
	MoveTo( (TargetCorpse.Location + Normal(Pawn.Location - TargetCorpse.Location) * (20.0 + FRand() * 20.0)), TargetCorpse );
	
	if ( TargetCorpse == None )
		WhatToDoNext(31);
	
	Focus = TargetCorpse;
	while ( MyMonster.CanCorpseAttack(TargetCorpse) )  {
		// AttackCorpse
		Target = TargetCorpse;
		MyMonster.CorpseAttack(Target);
		if ( MyMonster.bShotAnim )
			FinishAnim(MyMonster.ExpectingChannel);
		
		// Can't look, eating.
		if ( Enemy != None && VSizeSquared(Enemy.Location - Pawn.Location) < 250000.0 && CanSee(Enemy) )
			WhatToDoNext(37);
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
	bEnemyAcquired = False;
	SetEnemyInfo(bNewEnemyVisible);
	if ( MyMonster == None )
		Return;
	
	MyMonster.EnemyChanged();
	MyMonster.PlayChallengeSound();
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

	if ( MyMonster.Intelligence >= BRAINS_Mammal && Enemy != None && NewEnemy.Controller.bIsPlayer )  {
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

	if ( MyMonster.bNoAutoHuntEnemies )
		Return False;

	GameInfo = UM_BaseGameInfo(Level.Game);
	if ( GameInfo == None || GameInfo.PlayerList.Length < 1 )
		Return False;

	for ( i = 0; i < GameInfo.PlayerList.Length; ++i )  {
		if ( !PlayerList[i].bIsActivePlayer )
			continue;
		
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

function DoTacticalMove()
{
	GotoState('TacticalMove');
}

function DoCharge()
{
	if ( Pawn == None )
		Return;
	
	if ( !Enemy.PhysicsVolume.bWaterVolume )
		GotoState('ZombieCharge');
	else if ( !Pawn.bCanSwim )
		DoTacticalMove();
}

function FightEnemy(bool bCanCharge)
{
	if ( Enemy == None || Enemy.Health < 1 || EnemyThreatChanged() )
		FindNewEnemy();

	if ( Enemy == FailedHuntEnemy && Level.TimeSeconds == FailedHuntTime )  {
		FindNewEnemy();
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
	if ( MyMonster.bNoAutoHuntEnemies )
		GoToState('WaitToStart');
	else
		FindRoamDest();
}

function TriggerFirstSeePlayerEvent()
{
	if ( bTriggeredFirstEvent )
		Return;
	
	bTriggeredFirstEvent = True;
	if ( MyMonster.FirstSeePlayerEvent != '' )
		TriggerEvent(MyMonster.FirstSeePlayerEvent, Pawn, Pawn);
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
	
	if ( MyMonster.bStartUpDisabled )  {
		MyMonster.bStartUpDisabled = False;
		GoToState('WaitToStart');
		Return;
	}
	
	if ( MyMonster.bShotAnim )  {
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

/* WaitForMover()
Wait for Mover M to tell me it has completed its move */
function WaitForMover(Mover M)
{
    if ( M == None )
		Return;
	
	if ( Enemy != None && (Level.TimeSeconds - LastSeenTime) < M.MoveTime )
        Focus = Enemy;
    PendingMover = M;
    bPreparingMove = True;
    Pawn.Acceleration = vect(0,0,0);
    StopStartTime = Level.TimeSeconds;
}

/* MoverFinished()
Called by Mover when it finishes a move, and this pawn has the mover
set as its PendingMover	*/
function MoverFinished()
{
	if ( PendingMover.MyMarker.ProceedWithMove(Pawn) )  {
		PendingMover = None;
		bPreparingMove = False;
	}
}



state WaitForAnim
{
	ignores SeePlayer, HearNoise, Timer, EnemyNotVisible, NotifyBump, Startle;

	event BeginState() { }
	
	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin) { }

	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}

	event Tick( float Delta )
	{
		Global.Tick(Delta);
	}
	
	event EndState()
	{
		MyMonster.EnableMovement();
	}

Begin:
	if ( MyMonster.bShotAnim )  {
		MoveTarget = None;
		MoveTimer = -1.0;
		MyMonster.DisableMovement();
		FinishAnim(MyMonster.ExpectingChannel);
	}
	WhatToDoNext(99);
}

// This state currently only used in KFO-FrightYard to force Zeds into the toxic pit.
// State is activated by KFVolume_ZedPit, when touched by a Zed.
state ScriptedMoveTo
{
	ignores TakeDamage, SeePlayer, HearNoise, SeeMonster, Bump, HitWall, Touch;

	event BeginState()
	{
		//log( self$" MoveToNodeGoal BeginState" );
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	if ( ActorReachable( ScriptedMoveTarget ) )  {
		MoveToward( ScriptedMoveTarget );
		Goto( 'Begin' );
	}
	else if ( FindBestPathToward( ScriptedMoveTarget, False, False ) )  {
		MoveToward( MoveTarget );
		Goto( 'Begin' );
	}
	else  {
		Sleep( 0.1f );
		Goto( 'Begin' );
	}
}

// Make the AI try and stay away from this Monster
function AvoidThisMonster(KFMonster Feared)
{
	GoalString = "VEHICLE AVOID!";
	AvoidMonster = Feared;
	GotoState('MonsterAvoid');
}

// State for being scared of something, the bot attempts to move away from it
state MonsterAvoid
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;

	event BeginState()
	{
		SetTimer(0.4,true);
	}
	
	function AvoidThisMonster(KFMonster Feared)
	{
		GoalString = "AVOID MONSTER!";
		// Switch to the new guy if he is closer
		if ( VSizeSquared(Pawn.Location - Feared.Location) < VSizeSquared(Pawn.Location - AvoidMonster.Location) )  {
			AvoidMonster = Feared;
			BeginState();
		}
	}
	
	function HitTheDirt()
	{
		local	vector	side;

		GoalString = "AVOID Monster!   Jumping!!!";
		side = (Pawn.Location - AvoidMonster.Location) cross vect(0,0,1);
		Pawn.Velocity = Pawn.AccelRate * Normal(side);
		
		// jump the other way if its shorter
		if ( (side dot AvoidMonster.Velocity) > 0.0 )
			Pawn.Velocity = -Pawn.Velocity;
		
		Pawn.Velocity.Z = Pawn.JumpZ;
		bPlannedJump = True;
		Pawn.SetPhysics(PHYS_Falling);
	}

	event Timer()
	{
		local	vector	dir, side;

		if ( AvoidMonster == None || (AvoidMonster.Velocity dot (Pawn.Location - AvoidMonster.Location) < 0.0) )  {
			WhatToDoNext(11);
			Return;
		}
		
		Pawn.bIsWalking = False;
		Pawn.bWantsToCrouch = False;
		dir = Pawn.Location - AvoidMonster.Location;
		if ( VSizeSquared(dir) < Square(AvoidMonster.CollisionRadius * NearMult) )
			HitTheDirt();
		else  {
			side = dir cross vect(0,0,1);
			// pick the shortest direction to move to
			if ( (side dot AvoidMonster.Velocity) > 0.0 )
				Destination = Pawn.Location + (-Normal(side) * (AvoidMonster.CollisionRadius * FarMult));
			else
				Destination = Pawn.Location + (Normal(side) * AvoidMonster.CollisionRadius * FarMult);

			GoalString = "AVOID VEHICLE!   Moving my arse..";
		}
	}

	event EndState()
	{
		bTimerLoop = False;
		AvoidMonster = None;
		Focus = None;
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	MoveTo(Destination, AvoidMonster, False);
	
	if ( AvoidMonster == None || VSizeSquared(Pawn.Location - AvoidMonster.Location) > Square(AvoidMonster.CollisionRadius * FarMult) || (AvoidMonster.Velocity dot (Pawn.Location - AvoidMonster.Location)) < 0.0 )  {
		WhatToDoNext(11);
		warn("!! " @ Pawn.GetHumanReadableName() @ " STUCK IN AVOID MONSTER !!");
		GoalString = "!! STUCK IN AVOID MONSTER !!";
	}
	
	Sleep(0.2);
	GoTo('Begin');
}

// Something is shooting along a line, get out of the way of that line
function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin)
{
	GetOutOfTheWayDirection = ShotDirection;
	GetOutOfTheWayOrigin = ShotOrigin;
	if ( KFMonster(Pawn) != None && KFMonster(Pawn).CanGetOutOfWay() )
		GotoState('GettingOutOfTheWayOfShot');
}

// State for being scared of something, the bot attempts to move away from it
state GettingOutOfTheWayOfShot
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;

	function HitTheDirt()
	{
		local	vector	side;

		GoalString = "AVOID Shot!   Jumping!!!";

		side = GetOutOfTheWayDirection cross vect(0,0,1);
		Pawn.Velocity = Pawn.JumpZ * 0.5 * Normal(side);

		// jump the other way if its shorter
		if ( (side dot (Pawn.Location - GetOutOfTheWayOrigin)) < 0.0 )
			Pawn.Velocity = -Pawn.Velocity;
		
		Pawn.Velocity.Z = Pawn.JumpZ * 0.5;
		bPlannedJump = True;
		Pawn.SetPhysics(PHYS_Falling);
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	HitTheDirt();
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	Sleep(0.1);
	WhatToDoNext(11);
}

function Actor FaceMoveTarget()
{
	if ( MoveTarget != Enemy )
		StopFiring();
	
	Return MoveTarget;
}

function Actor FaceActor(float StrafingModifier)
{
	local	float	RelativeDir;

	bRecommendFastMove = False;
	if ( Enemy == None || (Level.TimeSeconds - LastSeenTime) > (6.0 - StrafingModifier) )
		Return FaceMoveTarget();
	
	if ( MoveTarget == Enemy )
		Return Enemy;
	
	if ( (Level.TimeSeconds - LastSeenTime) > (4.0 - StrafingModifier) )
		Return FaceMoveTarget();
	
	if ( GameObject(MoveTarget) != None && Skill > 2.5 )
		Return Enemy;
	
	RelativeDir = Normal(Enemy.Location - Pawn.Location - vect(0,0,1) * (Enemy.Location.Z - Pawn.Location.Z)) Dot Normal(MoveTarget.Location - Pawn.Location - vect(0,0,1) * (MoveTarget.Location.Z - Pawn.Location.Z));

	if ( RelativeDir > 0.85 )
		Return Enemy;
	
	if ( RelativeDir > 0.3 && Bot(Enemy.Controller) != None && MoveTarget == Enemy.Controller.MoveTarget )
		Return Enemy;
	
	if ( (Skill + StrafingAbility) < (2.0 + FRand()) )
		Return FaceMoveTarget();

	if ( RelativeDir < 0.3 || (Skill + StrafingAbility) < ((5 + StrafingModifier) * FRand()) || (0.4 * RelativeDir + 0.8) < FRand() )
		Return FaceMoveTarget();

	Return Enemy;
}

function bool ShouldStrafeTo(Actor WayPoint)
{
	local	NavigationPoint		N;

	if ( Monster(Pawn).bAlwaysStrafe )
		Return True;

	if ( (Skill + StrafingAbility) < 3.0 )
		Return False;

	if ( WayPoint == Enemy )  {
		if ( Monster(Pawn).PreferMelee() )
			Return False;
		
		Return (Skill + StrafingAbility) < Lerp(FRand(), -1.0, 4.0);
	}
	else if ( Pickup(WayPoint) == None )  {
		N = NavigationPoint(WayPoint);
		if ( N == None || N.bNeverUseStrafing )
			Return False;

		if ( N.FearCost > 200 )
			Return True;
		
		if ( N.bAlwaysUseStrafing && FRand() < 0.8 )
			Return True;
	}
	
	if ( Pawn(WayPoint) != None )
		Return (Skill + StrafingAbility) < Lerp(FRand(), -1.0, 4.0);

	if ( (Skill + StrafingAbility) < Lerp(FRand(), -1.0, 6.0) )
		Return False;

	if ( Enemy == None )
		Return FRand() < 0.4;

	if ( EnemyVisible() )
		Return FRand() < 0.85;
	
	Return FRand() < 0.6;
}

state Hunting
{
ignores EnemyNotVisible;

	function bool IsHunting()
	{
		Return True;
	}
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}

	/* 	MayFall() called by] engine physics if walking and bCanJump, and
		is about to go off a ledge.  Pawn has opportunity (by setting
		bCanJump to false) to avoid fall	*/
	event MayFall()
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

	function PickDestination()
	{
		local	vector	nextSpot, ViewSpot, Dir;
		local	bool	bCanSeeLastSeen;

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

		nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
		nextSpot.Z = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
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

	event EndState()
	{
		if ( Pawn != None && Pawn.JumpZ > 0 )
			Pawn.bCanJump = True;
	}

AdjustFromWall:
	MoveTo(Destination, MoveTarget);

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	if ( CanSee(Enemy) )
		SeePlayer(Enemy);

WaitForAnim:
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	PickDestination();
	if ( (Level.timeseconds - ChallengeTime) > 10.0 )  {
		ChallengeTime = Level.TimeSeconds;
		Monster(Pawn).PlayChallengeSound();
	}

SpecialNavig:
	if ( MoveTarget == None )
		MoveTo(Destination);
	else
		MoveToward( MoveTarget, FaceActor(10.0),, (FRand() < 0.75 && ShouldStrafeTo(MoveTarget)) );

	WhatToDoNext(27);
	if ( bSoaking )
		SoakStop("STUCK IN HUNTING!");
}

function bool Stopped()
{
	Return MyMonster.bMovementDisabled;
}

state RangedAttack
{
	ignores SeePlayer, HearNoise, Bump;

	function bool Stopped()
	{
		Return True;
	}

	function CancelCampFor(Controller C)
	{
		DoTacticalMove();
	}

	function StopFiring()
	{
		Global.StopFiring();
		if ( bHasFired )  {
			bHasFired = False;
			WhatToDoNext(32);
		}
	}

	function EnemyNotVisible()
	{
		//let attack animation complete
		WhatToDoNext(33);
	}

	function Timer()
	{
		if ( Monster(Pawn).PreferMelee() )  {
			SetCombatTimer();
			StopFiring();
			WhatToDoNext(34);
		}
		else
			TimedFireWeaponAtEnemy();
	}

	function DoRangedAttackOn(Actor A)
	{
		Target = A;
		GotoState('RangedAttack');
	}

	function BeginState()
	{
		StopStartTime = Level.TimeSeconds;
		bHasFired = false;
		Pawn.Acceleration = vect(0,0,0); //stop
		if ( Target == None )
			Target = Enemy;
		if ( Target == None )
			log(GetHumanReadableName()$" no target in ranged attack");
	}

Begin:
	bHasFired = false;
	GoalString = "Ranged attack";
	Focus = Target;
	Sleep(0.0);
	if ( Enemy != None )
		CheckIfShouldCrouch(Pawn.Location,Enemy.Location, 1);
	if ( NeedToTurn(Target.Location) )
	{
		Focus = Target;
		FinishRotation();
	}
	bHasFired = true;
	if ( Target == Enemy )
		TimedFireWeaponAtEnemy();
	else
		FireWeaponAt(Target);
	Sleep(0.1);
	if ( Monster(Pawn).PreferMelee() || (Target == None) || (Target != Enemy) || Monster(Pawn).bBoss )
		WhatToDoNext(35);
	if ( Enemy != None )
		CheckIfShouldCrouch(Pawn.Location,Enemy.Location, 1);
	Focus = Target;
	Sleep(FMax(Monster(Pawn).RangedAttackTime(),0.2 + (0.5 + 0.5 * FRand()) * 0.4 * (7 - Skill)));
	WhatToDoNext(36);
	if ( bSoaking )
		SoakStop("STUCK IN RANGEDATTACK!");
}

// I have came up to a door, break it!
function BreakUpDoor( KFDoorMover Other, bool bTryDistanceAttack )
{
	if ( Other == None || Pawn == None )
		Return;
	
	TargetDoor = Other;
	MyMonster.SetDistanceDoorAttack(bTryDistanceAttack);
	
	GoalString = "DOORBASHING";
	GotoState('DoorBashing');
}

state DoorBashing
{
	ignores EnemyNotVisible, SeeMonster;

	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	event Timer()
	{
		Disable('NotifyBump');
	}
	
	event Tick( float Delta )
	{
		Global.Tick(Delta);
	}

	function AttackDoor()
	{
		// Don't move while we are bashing a door!
		MoveTarget = None;
		MoveTimer = -1.0;
		Target = TargetDoor;
		MyMonster.AttackDoor();
	}
	
	event SeePlayer( Pawn Seen )
	{
		// Only the smarties will react to seen Pawn
		if ( Seen != None && MyMonster.Intelligence == BRAINS_Human && ActorReachable(Seen) && SetEnemy(Seen) )
			WhatToDoNext(23);
	}
	
	function DamageAttitudeTo( Pawn Other, float Damage )
	{
		if ( MyMonster.Intelligence >= BRAINS_Mammal && ActorReachable(Other) && SetEnemy(Other) )
			WhatToDoNext(32);
	}
	
	event HearNoise( float Loudness, Actor NoiseMaker )
	{
		local	Pawn	NoiseMakerPawn;
		
		// Only the smarties will react on any Noise
		if ( MyMonster.Intelligence < BRAINS_Human && Loudness < 1.0 )
			Return;
		
		if ( Pawn(NoiseMaker) != None )
			NoiseMakerPawn = Pawn(NoiseMaker);
		else
			NoiseMakerPawn = NoiseMaker.Instigator;
		
		if ( NoiseMakerPawn != None && MyMonster.Intelligence >= BRAINS_Mammal && ActorReachable(NoiseMakerPawn) && SetEnemy(NoiseMakerPawn) )
			WhatToDoNext(32);
	}
	
	function NotifyMonsterDecapitated()
	{
		Global.NotifyMonsterDecapitated();
		if ( MyMonster.bShotAnim )
			AnimEnd(MyMonster.ExpectingChannel);
		WhatToDoNext(152);
	}

	event EndState()
	{
		MyMonster.EnableMovement();
		MyMonster.GotoState('');
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding(); // Native latent function

KeepMoving:
	// Finish prev anim
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	while ( MyMonster.CanAttackDoor(TargetDoor) )  {
		AttackDoor();
		if ( MyMonster.bShotAnim )
			FinishAnim(MyMonster.ExpectingChannel);
		// Try to attack the real enemy.
		if ( Enemy != None && MyMonster.Intelligence >= BRAINS_Mammal && ActorReachable(Enemy) )
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
	if ( MyMonster != None && !MyMonster.bShotAnim && Skill > Lerp(FRand(), 1.0, 3.0) )  {
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

state NoGoal
{
}

function bool Formation()
{
	Return False;
}

// extends NoGoal
state RestFormation
{
	ignores EnemyNotVisible;

	event BeginState()
	{
		Enemy = None;
		Pawn.bCanJump = False;
		Pawn.bAvoidLedges = True;
		Pawn.bStopAtLedges = True;
		Pawn.SetWalking(true);
		MinHitWall += 0.15;
	}
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	function CancelCampFor(Controller C)
	{
		DirectedWander(Normal(Pawn.Location - C.Pawn.Location));
	}

	function bool Formation()
	{
		Return True;
	}

	event Timer()
	{
		SetCombatTimer();
		Enable('NotifyBump');
	}

	function PickDestination()
	{
		if ( TestDirection(VRand(), Destination) )
			Return;
		TestDirection(VRand(), Destination);
	}

	event EndState()
	{
		MonitoredPawn = None;
		MinHitWall -= 0.15;
		if ( Pawn != None )  {
			Pawn.bStopAtLedges = False;
			Pawn.bAvoidLedges = False;
			Pawn.SetWalking(False);
			if ( Pawn.JumpZ > 0.0 )
				Pawn.bCanJump = True;
		}
	}

	event MonitoredPawnAlert()
	{
		WhatToDoNext(6);
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();

Camping:
	Pawn.Acceleration = vect(0,0,0);
	Focus = None;
	FocalPoint = VRand();
	NearWall(MINVIEWDIST);
	FinishRotation();
	Sleep(3.0 + FRand());

Moving:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	PickDestination();

WaitForAnim:
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	MoveTo(Destination,, True);
	if ( Pawn.bCanFly && Pawn.Physics == PHYS_Walking )
		Pawn.SetPhysics(PHYS_Flying);
	
	WhatToDoNext(8);
	
	Goto('Begin');
}

function DirectedWander(vector WanderDir)
{
	GoalString = "DIRECTED WANDER "$GoalString;
	if ( TestDirection(WanderDir,Destination) )
		GotoState('ZombieRestFormation', 'Moving');
	else 
		GotoState('ZombieRestFormation', 'Begin');
}

function WanderOrCamp(bool bMayCrouch)
{
	if ( MyMonster.bNoAutoHuntEnemies )
		GoToState('WaitToStart');
	else
		FindRoamDest();
}

// extends RestFormation
state ZombieRestFormation
{
	ignores EnemyNotVisible;

	event BeginState()
	{
	   // Enemy = None;
		//Pawn.bAvoidLedges = true;
		//Pawn.bStopAtLedges = true;
		//Pawn.SetWalking(true);
		MinHitWall += 0.15;
	}
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	function CancelCampFor(Controller C)
	{
		DirectedWander(Normal(Pawn.Location - C.Pawn.Location));
	}

	function bool Formation()
	{
		Return True;
	}
	
	event Timer()
	{
		if ( Pawn.Velocity == vect(0,0,0) )
			Gotostate('ZombieRestFormation','Moving');
		
		SetCombatTimer();
		Disable('NotifyBump');
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
	
	function PickDestination()
	{
		local	vector	nextSpot, ViewSpot, Dir;
		local	bool	bCanSeeLastSeen;

		if ( TestDirection(VRand(),Destination) )  {
			// If we're not a cannibal.  don't munch
			if ( Enemy != None && !MyMonster.bCannibal && Enemy.Health < 1 )  {
				Enemy = None;
				WhatToDoNext(23);
				Return;
			}

			if ( Pawn.JumpZ > 0 )
				Pawn.bCanJump = True;

			if ( Enemy != None && ActorReachable(Enemy) )  {
				Destination = Enemy.Location;
				MoveTarget = None;
				Return;
			}

			ViewSpot = Pawn.Location + Pawn.BaseEyeHeight * vect(0,0,1);
			bCanSeeLastSeen = bEnemyInfoValid && FastTrace(LastSeenPos, ViewSpot);

			if ( Enemy != None && FindBestPathToward(Enemy, True, True) )
				Return;

			if ( bSoaking && Physics != PHYS_Falling )
				SoakStop("COULDN'T FIND PATH TO ENEMY "$Enemy);

			MoveTarget = None;
			if ( Enemy == None || !bEnemyInfoValid )  {
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

			nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
			nextSpot.Z = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
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
				if ( FastTrace(LastSeenPos, ViewSpot) )
					Return;
				
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
				}
			}
		}
		else 
			TestDirection(VRand(),Destination);
	}

	event MonitoredPawnAlert()
	{
		WhatToDoNext(6);
	}
	
	event EndState()
	{
		//MonitoredPawn = None;
		MinHitWall -= 0.15;
		if ( Pawn != None && Pawn.JumpZ > 0.0 )
			Pawn.bCanJump = True;
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();

Camping:
	//Pawn.Acceleration = vect(0,0,0);
	Focus = None;
	FocalPoint = VRand();
	NearWall(MINVIEWDIST);
	FinishRotation();
	Sleep(3.0 + FRand());

Moving:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	PickDestination();

WaitForAnim:
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	MoveTo(Destination,, True);
	if ( Pawn.bCanFly && Pawn.Physics == PHYS_Walking )
		Pawn.SetPhysics(PHYS_Flying);
	
	WhatToDoNext(8);
	
	Goto('Begin');
}

state MoveToGoal
{
	event Timer()
	{
		SetCombatTimer();
		enable('NotifyBump');
	}
}

// extends MoveToGoal
state MoveToGoalWithEnemy
{
	event Timer()
	{
		TimedFireWeaponAtEnemy();
	}
}

// extends MoveToGoal
state MoveToGoalNoEnemy
{
}

// extends MoveToGoalNoEnemy
state Roaming
{
	ignores EnemyNotVisible;

	event MayFall()
	{
		Pawn.bCanJump = MoveTarget != None && (MoveTarget.Physics != PHYS_Falling || !MoveTarget.IsA('Pickup'));
	}

Begin:
	SwitchToBestWeapon();
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	MoveToward(MoveTarget, FaceActor(1),, ShouldStrafeTo(MoveTarget));

DoneRoaming:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	WhatToDoNext(12);
	if ( bSoaking )
		SoakStop("STUCK IN ROAMING!");
}

// extends Roaming
state ZombieRoam
{
	event Timer()
	{
		if ( Pawn.Velocity == vect(0,0,0) )
			GotoState('ZombieRestFormation','Moving');
	}
}

state ZombieHunt
{
	event BeginState() { }
	
	event EndState() { }
	
	event Timer()
	{
		if ( Pawn.Velocity == vect(0, 0, 0) )
			GotoState('ZombieRestFormation','Moving');
		
		SetCombatTimer();
		StopFiring();
	}
	
	function PickDestination()
	{
		local	vector	nextSpot, ViewSpot,Dir;
		local	bool	bCanSeeLastSeen;

		if ( Enemy != None && Enemy.Health < 1 && !MyMonster.bCannibal )  {
			Enemy = None;
			WhatToDoNext(23);
			Return;
		}
		
		if ( FindFreshBody() )
			Return;
		
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

		if ( MyMonster.Intelligence == BRAINS_Retarded && FRand() < 0.25 )  {
			Destination = Pawn.Location + VRand() * 200.0;
			Return;
		}
		
		if ( ActorReachable(Enemy) )  {
			Destination = Enemy.Location;
			if ( MyMonster.Intelligence == BRAINS_Retarded && FRand() < 0.5 )  {
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

		nextSpot = LastSeenPos - Normal(Enemy.Velocity) * Pawn.CollisionRadius;
		nextSpot.Z = LastSeenPos.Z + Pawn.CollisionHeight - Enemy.CollisionHeight;
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

state StakeOut
{
	ignores EnemyNotVisible;

	event BeginState()
	{
		StopStartTime = Level.TimeSeconds;
		Pawn.Acceleration = vect(0,0,0);
		Pawn.bCanJump = False;
		SetFocus();
		if ( Enemy != None && (!bEnemyInfoValid || !ClearShot(FocalPoint, False) || ((Level.TimeSeconds - LastSeenTime) > 6.0 && FRand() < 0.5)) )
			FindNewStakeOutDir();
	}
	
	/* DoStakeOut()
	called by ChooseAttackMode - if called in this state, means stake out twice in a row
	*/
	function DoStakeOut()
	{
		SetFocus();
		if ( Enemy!=None && ((FRand() < 0.3) || !FastTrace(FocalPoint + vect(0,0,0.9) * Enemy.CollisionHeight, Pawn.Location + vect(0,0,0.8) * Pawn.CollisionHeight)) )
			FindNewStakeOutDir();
		GotoState('StakeOut','Begin');
	}

	function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int AimError)
	{
		local vector FireSpot;
		local actor HitActor;
		local vector HitLocation, HitNormal;

		if ( Enemy == None )
			Return Pawn.Rotation;

		FireSpot = FocalPoint;
		HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, false);
		if ( HitActor != None )  {
			FireSpot += 2 * Enemy.CollisionHeight * HitNormal;
			if ( !FastTrace(FireSpot, ProjStart) )  {
				FireSpot = FocalPoint;
				StopFiring();
			}
		}
		SetRotation(Rotator(FireSpot - ProjStart));
		
		Return Rotation;
	}
	
	function SetFocus()
	{
		if ( bEnemyInfoValid )
			FocalPoint = LastSeenPos;
		else if( Enemy != None )
			FocalPoint = Enemy.Location;
	}

Begin:
	Pawn.Acceleration = vect(0,0,0);
	Focus = None;
	CheckIfShouldCrouch(Pawn.Location, FocalPoint, 1);
	FinishRotation();
	if ( Enemy != None && MyMonster.HasRangedAttack() && FRand() < 0.5 && VSizeSquared(Enemy.Location - FocalPoint) < 22500.0
		 && (Level.TimeSeconds - LastSeenTime) < 4.0 && ClearShot(FocalPoint, True) )
		FireWeaponAt(Enemy);
	else
		StopFiring();
	Sleep( Lerp(FRand(), 0.4, 0.8) );
	// check if uncrouching would help
	if ( Pawn.bIsCrouched && !FastTrace(FocalPoint, (Pawn.Location + Pawn.EyeHeight * vect(0,0,1))) 
		 && FastTrace(FocalPoint, (Pawn.Location + (Pawn.Default.EyeHeight + Pawn.Default.CollisionHeight - Pawn.CollisionHeight) * vect(0,0,1))) )  {
		Pawn.bWantsToCrouch = False;
		Sleep( Lerp(FRand(), 0.4, 0.8) );
	}
	MoveTo(Pawn.Location + VRand() * 80.0); // Try moving somewhere
	WhatToDoNext(31);
	if ( bSoaking )
		SoakStop("STUCK IN STAKEOUT!");
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
		if ( !PlayerList[i].bIsActivePlayer )
			continue;
		
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

state TacticalMove
{
	ignores SeePlayer, HearNoise;

	event BeginState()
	{
		bForcedDirection = False;
		if ( Skill < 4.0 )
			Pawn.MaxDesiredSpeed = 0.4 + 0.08 * Skill;
		MinHitWall += 0.15;
		Pawn.bAvoidLedges = True;
		Pawn.bStopAtLedges = True;
		Pawn.bCanJump = False;
		bAdjustFromWalls = False;
	}
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	function bool IsStrafing()
	{
		Return True;
	}

	event ReceiveWarning(Pawn Shooter, float ProjSpeed, vector FireDir)
	{
		if ( bCanFire && FRand() < 0.4 )
			Return;

		Super(ScriptedController).ReceiveWarning(Shooter, ProjSpeed, FireDir);
	}

	function SetFall()
	{
		Pawn.Acceleration = vect(0,0,0);
		Destination = Pawn.Location;
		Global.SetFall();
	}

	event bool NotifyHitWall(vector HitNormal, actor Wall)
	{
		if ( Pawn.Physics == PHYS_Falling )
			Return False;
		
		if ( Enemy == None )  {
			WhatToDoNext(18);
			Return False;
		}
		
		if ( bChangeDir || FRand() < 0.5 || ((Enemy.Location - Pawn.Location) Dot HitNormal) < 0.0 )  {
			Focus = Enemy;
			WhatToDoNext(19);
		}
		else  {
			bChangeDir = True;
			Destination = Pawn.Location - HitNormal * FRand() * 500.0;
		}
		
		Return True;
	}

	event Timer()
	{
		enable('NotifyBump');
		Target = Enemy;
		if ( Enemy != None )
			TimedFireWeaponAtEnemy();
		else
			SetCombatTimer();
	}

	event EnemyNotVisible()
	{
		StopFiring();
		if ( FastTrace(Enemy.Location, LastSeeingPos) )
			GotoState('TacticalMove','RecoverEnemy');
		else
			WhatToDoNext(20);
		
		Disable('EnemyNotVisible');
	}

	function PawnIsInPain(PhysicsVolume PainVolume)
	{
		Destination = Pawn.Location - MINSTRAFEDIST * Normal(Pawn.Velocity);
	}
	
	function bool EngageDirection(vector StrafeDir, bool bForced)
	{
		local	actor	HitActor;
		local	vector	HitLocation, collspec, MinDest, HitNormal;

		// successfully engage direction if can trace out and down
		MinDest = Pawn.Location + MINSTRAFEDIST * StrafeDir;
		if ( !bForced )  {
			collSpec = Pawn.GetCollisionExtent();
			collSpec.Z = FMax(6, Pawn.CollisionHeight - Pawn.CollisionRadius);

			HitActor = Trace(HitLocation, HitNormal, MinDest, Pawn.Location, false, collSpec);
			if ( HitActor != None )
				Return False;

			if ( Pawn.Physics == PHYS_Walking )  {
				collSpec.X = FMin(14, 0.5 * Pawn.CollisionRadius);
				collSpec.Y = collSpec.X;
				HitActor = Trace(HitLocation, HitNormal, minDest - (Pawn.CollisionRadius + MAXSTEPHEIGHT) * vect(0,0,1), minDest, false, collSpec);
				if ( HitActor == None )  {
					HitNormal = -1 * StrafeDir;
					Return False;
				}
			}
		}
		Destination = MinDest + StrafeDir * (0.5 * MINSTRAFEDIST + FMin( VSize(Enemy.Location - Pawn.Location), (MINSTRAFEDIST * Lerp(FRand(), 0.0, 2.0)) ));
		
		Return True;
	}

	/* PickDestination()
	Choose a destination for the tactical move, based on aggressiveness and the tactical
	situation. Make sure destination is reachable
	*/
	function PickDestination()
	{
		local	vector	pickdir, enemydir, enemyPart, Y;
		local	float	strafeSize;

		if ( Pawn == None )  {
			warn(self$" Tactical move pick destination with no pawn");
			Return;
		}
		
		bChangeDir = False;
		if ( Pawn.PhysicsVolume.bWaterVolume && !Pawn.bCanSwim && Pawn.bCanFly )  {
			Destination = Pawn.Location + 75.0 * (VRand() + vect(0,0,1));
			Destination.Z += 100.0;
			Return;
		}

		enemydir = Normal(Enemy.Location - Pawn.Location);
		Y = (enemydir Cross vect(0,0,1));
		if ( Pawn.Physics == PHYS_Walking )  {
			Y.Z = 0;
			enemydir.Z = 0;
		}
		else
			enemydir.Z = FMax(0,enemydir.Z);

		strafeSize = FMax( Lerp(FRand(), -0.2, 0.2), Lerp(FRand(), -0.7 , 0.7) );
		enemyPart = enemydir * strafeSize;
		if ( Pawn.bCanFly )  {
			if ( Pawn.Location.Z - Enemy.Location.Z < 1000.0 )
				enemyPart = enemyPart + FRand() * vect(0,0,1);
			else
				enemyPart = enemyPart - FRand() * vect(0,0,0.7);
		}
		strafeSize = FMax( 0.0, (1 - Abs(strafeSize)) );
		pickdir = strafeSize * Y;
		if ( bStrafeDir )
			pickdir *= -1;
		bStrafeDir = !bStrafeDir;

		if ( EngageDirection( (enemyPart + pickdir), False ) )
			Return;

		if ( EngageDirection( (enemyPart - pickdir), False ) )
			Return;

		bForcedDirection = True;
		StartTacticalTime = Level.TimeSeconds;
		EngageDirection( (EnemyPart + PickDir), True );
	}

	event EndState()
	{
		bAdjustFromWalls = True;
		if ( Pawn == None )
			Return;
		SetMaxDesiredSpeed();
		Pawn.bAvoidLedges = False;
		Pawn.bStopAtLedges = False;
		MinHitWall -= 0.15;
		
		if ( Pawn.JumpZ > 0.0 )
			Pawn.bCanJump = True;
	}

TacticalTick:
	Sleep(0.02);
Begin:
	if (Pawn.Physics == PHYS_Falling)  {
		Focus = Enemy;
		Destination = Enemy.Location;
		WaitForLanding();
	}
	PickDestination();

DoMove:
	if ( !Pawn.bCanStrafe )  {
		StopFiring();
WaitForAnim:
		if ( MyMonster.bShotAnim )
			FinishAnim(MyMonster.ExpectingChannel);
		
		MoveTo(Destination);
	}
	else  {
DoStrafeMove:
		MoveTo(Destination, Enemy);
	}
	
	if ( bForcedDirection && (Level.TimeSeconds - StartTacticalTime) < 0.2 )  {
		if ( Skill >  Lerp(FRand(), 2.0, 5.0) )  {
			bMustCharge = True;
			WhatToDoNext(51);
		}
		GoalString = "RangedAttack from failed tactical";
		DoRangedAttackOn(Enemy);
	}
	
	if ( Enemy == None || EnemyVisible() || !FastTrace(Enemy.Location, LastSeeingPos) || Monster(Pawn).PreferMelee() || !Pawn.bCanStrafe )
		Goto('FinishedStrafe');
	//CheckIfShouldCrouch(LastSeeingPos,Enemy.Location, 0.5);

RecoverEnemy:
	GoalString = "Recover Enemy";
	HidingSpot = Pawn.Location;
	StopFiring();
	Sleep(Lerp(FRand(), 0.1, 0.3));
	Destination = LastSeeingPos + 4.0 * Pawn.CollisionRadius * Normal(LastSeeingPos - Pawn.Location);
	MoveTo(Destination, Enemy);
	if ( FireWeaponAt(Enemy) )  {
		Pawn.Acceleration = vect(0,0,0);
		if ( Monster(Pawn).SplashDamage() )  {
			StopFiring();
			Sleep(0.05);
		}
		else
			Sleep( Lerp(FRand(), 0.1, 0.4) + 0.06 * (7 - FMin(7, Skill)) );
		if ( FRand() > 0.5 )  {
			Enable('EnemyNotVisible');
			Destination = HidingSpot + 4.0 * Pawn.CollisionRadius * Normal(HidingSpot - Pawn.Location);
			Goto('DoMove');
		}
	}

FinishedStrafe:
	WhatToDoNext(21);
	if ( bSoaking )
		SoakStop("STUCK IN TACTICAL MOVE!");
}

// extends MoveToGoalWithEnemy
state Charging
{
	ignores SeePlayer, HearNoise;

	/* MayFall() called by engine physics if walking and bCanJump, and
		is about to go off a ledge.  Pawn has opportunity (by setting
		bCanJump to false) to avoid fall
	*/
	event MayFall()
	{
		if ( MoveTarget != Enemy )
			Return;

		Pawn.bCanJump = ActorReachable( Enemy );
		if ( !Pawn.bCanJump )
			MoveTimer = -1.0;
	}
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}

	function bool TryToDuck(vector duckDir, bool bReversed)
	{
		if ( FRand() < 0.6 )
			Return Global.TryToDuck(duckDir, bReversed);
		
		if ( MoveTarget == Enemy )
			Return TryStrafe(duckDir);
	}

	function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
	{
		local	vector	sideDir;

		if ( FRand() * Damage < 0.15 * CombatStyle * Pawn.Health )
			Return False;

		if ( !bFindDest )
			Return True;

		sideDir = Normal( Normal(Enemy.Location - Pawn.Location) Cross vect(0,0,1) );
		if ( (Pawn.Velocity Dot sidedir) > 0 )
			sidedir *= -1;

		Return TryStrafe(sideDir);
	}

	function bool TryStrafe(vector sideDir)
	{
		local	vector	Extent, HitLocation, HitNormal;
		local	Actor	HitActor;

		Extent = Pawn.GetCollisionExtent();
		HitActor = Trace(HitLocation, HitNormal, (Pawn.Location + MINSTRAFEDIST * sideDir), Pawn.Location, false, Extent);
		if ( HitActor != None )  {
			sideDir *= -1.0;
			HitActor = Trace(HitLocation, HitNormal, (Pawn.Location + MINSTRAFEDIST * sideDir), Pawn.Location, false, Extent);
		}
		
		if ( HitActor != None )
			Return False;

		if ( Pawn.Physics == PHYS_Walking )  {
			HitActor = Trace(HitLocation, HitNormal, (Pawn.Location + MINSTRAFEDIST * sideDir - MAXSTEPHEIGHT * vect(0,0,1)), (Pawn.Location + MINSTRAFEDIST * sideDir), false, Extent);
			
			if ( HitActor == None )
				Return False;
		}
		
		Destination = Pawn.Location + 2.0 * MINSTRAFEDIST * sideDir;
		GotoState('TacticalMove', 'DoStrafeMove');
		
		Return True;
	}

	function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
	{
		local	float	pick;
		local	vector	sideDir;
		local	bool	bWasOnGround;

		Super(ScriptedController).NotifyTakeHit(InstigatedBy,HitLocation, Damage,DamageType,Momentum);

		bWasOnGround = Pawn.Physics == PHYS_Walking;
		if ( Pawn.health < 1 || StrafeFromDamage(Damage, damageType, True) )
			Return;
		
		//weave
		if ( bWasOnGround && MoveTarget == Enemy && Pawn.Physics == PHYS_Falling )  {
			pick = 1.0;
			if ( bStrafeDir )
				pick = -1.0;
			sideDir = Normal( Normal(Enemy.Location - Pawn.Location) Cross vect(0,0,1) );
			sideDir.Z = 0;
			Pawn.Velocity += pick * Pawn.GroundSpeed * 0.7 * sideDir;
			if ( FRand() < 0.2 )
				bStrafeDir = !bStrafeDir;
		}
	}

	event bool NotifyBump(actor Other)
	{
		if ( Other == Enemy )  {
			DoRangedAttackOn(Enemy);
			Return False;
		}
		
		Return Global.NotifyBump(Other);
	}

	event Timer()
	{
		Enable('NotifyBump');
		Target = Enemy;
		TimedFireWeaponAtEnemy();
	}

	event EnemyNotVisible()
	{
		WhatToDoNext(15);
	}

	event EndState()
	{
		if ( Pawn != None && Pawn.JumpZ > 0.0 )
			Pawn.bCanJump = True;
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
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	if ( !FindBestPathToward(Enemy, False, True) )
		GotoState('TacticalMove');

Moving:
	MoveToward(MoveTarget, FaceActor(1),, ShouldStrafeTo(MoveTarget));
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

// extends Charging
state ZombieCharge
{
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	event SeePlayer( Pawn Seen )
	{
		if ( Seen != None && MyMonster.Intelligence == BRAINS_Human && ActorReachable(Seen) &&SetEnemy(Seen) )
			WhatToDoNext(23);
	}
	
	function DamageAttitudeTo( Pawn Other, float Damage )
	{
		if ( MyMonster.Intelligence < BRAINS_Stupid || !ActorReachable(Other) )
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
		if ( MyMonster.Intelligence < BRAINS_Human || Loudness < 1.0 )
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
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	if ( !FindBestPathToward(Enemy, False, True) )
		GotoState('TacticalMove');

Moving:
	if ( MyMonster.Intelligence == BRAINS_Retarded )  {
		if ( FRand() < 0.3 )
			MoveTo((Pawn.Location + VRand() * 200.0), None);
		else if ( MoveTarget == Enemy && FRand() < 0.5 )
			MoveTo((MoveTarget.Location + VRand() * 50.0), None);
		else 
			MoveToward(MoveTarget, FaceActor(1.0),, ShouldStrafeTo(MoveTarget));
	}
	else 
		MoveToward(MoveTarget, FaceActor(1.0),, ShouldStrafeTo(MoveTarget));
	
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

state Kicking
{
	ignores EnemyNotVisible;
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}

Begin:

WaitForAnim:
	if ( MyMonster.bShotAnim && KickTarget != None )
		FinishAnim(MyMonster.ExpectingChannel);

	WhatToDoNext(152);
	if ( bSoaking )
		SoakStop("STUCK IN KICKING!!!");
}

// old state for the Boss KnockDown
state KnockDown
{
	ignores EnemyNotVisible,Startle;

	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	Pawn.ShouldCrouch(True);

WaitForAnim:
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);

	WhatToDoNext(152);
	if ( bSoaking )
		SoakStop("STUCK IN STAGGERED!!!");

End:
	Pawn.ShouldCrouch(False);
}

function SetStunTime(float StunDuration)
{
	if ( StunDuration <= 0.0 )
		Return;
	
	if ( Level.TimeSeconds >= StunEndTime || StunDuration > (StunEndTime - Level.TimeSeconds) )
		StunEndTime = Level.TimeSeconds + StunDuration;
}

state KnockedDown
{
	ignores SeePlayer, HearNoise, Timer, EnemyNotVisible, NotifyBump, Startle;

	// Don't do this in this state
	function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin) { }
	
	event AnimEnd(int Channel)
	{
		if ( Pawn != None )
			Pawn.AnimEnd(Channel);
	}
	
	event EndState()
	{
		if ( MyMonster.bShotAnim )
			Return; // In case we need to replay KnockDown anim
		
		MyMonster.EndKnockDown();
	}

Begin:
	MoveTarget = None;
	MoveTimer = -1.0;

WaitForAnim:
	if ( MyMonster.bShotAnim )
		FinishAnim(MyMonster.ExpectingChannel);
	
	WhatToDoNext(99);
	if ( bSoaking )
		SoakStop("STUCK IN KnockDown!!!");
}

state DecapitatedMoving
{

}

// State for being scared of something, the bot attempts to move away from it
state ZombiePushedAway
{
	ignores EnemyNotVisible, SeePlayer, HearNoise;
	
Begin:
	if ( Pawn.Physics == PHYS_Falling )
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