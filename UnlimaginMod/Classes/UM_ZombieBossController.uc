//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieBossController
//	Parent class:	 UM_MonsterController
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 10.10.2012 20:15
//================================================================================
class UM_ZombieBossController extends UM_MonsterController;

var NavigationPoint HidingSpots;

var     float       WaitAnimTimeout;    // How long until the Anim we are waiting for is completed; Hack so the server doesn't get stuck in idle when its doing the Rage anim
var     int         AnimWaitChannel;    // The channel we are waiting to end in WaitForAnim
var     name        AnimWaitingFor;     // The animation we are waiting to end in WaitForAnim, mostly used for debugging
var     bool        bAlreadyFoundEnemy; // The Boss has already found an enemy at least once

function bool CanKillMeYet()
{
	Return False;
}

function TimedFireWeaponAtEnemy()
{
	if ( Enemy == None || FireWeaponAt(Enemy) )
		SetCombatTimer();
	else
		SetTimer(0.01, True);
}

// Overridden to support a quick initial attack to get the boss to the players quickly
function FightEnemy(bool bCanCharge)
{
	if ( KFM.bShotAnim )  {
		GoToState('WaitForAnim');
		Return;
	}
	if ( KFM.MeleeRange != KFM.default.MeleeRange )
		KFM.MeleeRange = KFM.default.MeleeRange;

	if ( Enemy == None || Enemy.Health < 1 )
		FindNewEnemy();

	if ( Enemy == FailedHuntEnemy && Level.TimeSeconds == FailedHuntTime )  {
	//	if ( Enemy.Controller.bIsPlayer )
		//	FindNewEnemy();
		if ( Enemy == FailedHuntEnemy )  {
						GoalString = "FAILED HUNT - HANG OUT";
			if ( EnemyVisible() )
				bCanCharge = False;
		}
	}
	
	if ( !EnemyVisible() )  {
		// Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
		if ( bAlreadyFoundEnemy || UM_BaseMonster_Boss(Pawn).SneakCount > 2 )  {
			bAlreadyFoundEnemy = True;
			GoalString = "Hunt";
			GotoState('ZombieHunt');
		}
		else  {
			// Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
			UM_BaseMonster_Boss(Pawn).SneakCount++;
			GoalString = "InitialHunt";
			GotoState('InitialHunting');
		}
		Return;
	}

	// see enemy - decide whether to charge it or strafe around/stand and fire
	Target = Enemy;
	GoalString = "Charge";
	PathFindState = 2;
	DoCharge();
}


// Get the boss to the players quickly after initial spawn
state InitialHunting extends Hunting
{
	event SeePlayer(Pawn SeenPlayer)
	{
		super.SeePlayer(SeenPlayer);
		bAlreadyFoundEnemy = True;
		GoalString = "Hunt";
		GotoState('ZombieHunt');
	}

	event BeginState()
	{
		// Added sneakcount hack to try and fix the endless loop crash. Try and track down what was causing this later - Ramm
		UM_BaseMonster_Boss(Pawn).SneakCount++;

		Super.BeginState();
	}
}

state ZombieCharge
{
	function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
	{
		Return False;
	}

	// I suspect this function causes bloats to get confused
	function bool TryStrafe(vector sideDir)
	{
		Return False;
	}

	event Timer()
	{
		Disable('NotifyBump');
		Target = Enemy;
		TimedFireWeaponAtEnemy();
	}

WaitForAnim:

	if ( Monster(Pawn).bShotAnim )
		Goto('Moving');
	if ( !FindBestPathToward(Enemy, False,True) )
		GotoState('ZombieRestFormation');
Moving:
	MoveToward(Enemy);
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

state RunSomewhere
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle;

	event BeginState()
	{
		HidingSpots = None;
		Enemy = None;
		SetTimer(0.1,True);
	}
	event SeePlayer(Pawn SeenPlayer)
	{
		SetEnemy(SeenPlayer);
	}
	event Timer()
	{
		if ( Enemy == None )
			Return;
		Target = Enemy;
		KFM.RangedAttack(Target);
	}
Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	While( KFM.bShotAnim )
		Sleep(0.25);
	
	if ( HidingSpots == None )
		HidingSpots = FindRandomDest();
	
	if ( HidingSpots == None )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	
	if ( ActorReachable(HidingSpots) )  {
		MoveTarget = HidingSpots;
		HidingSpots = None;
	}
	else 
		FindBestPathToward(HidingSpots,True,False);
	
	if ( MoveTarget == None )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	
	if ( Enemy != None && VSize(Enemy.Location - Pawn.Location) < 100.0 )
		MoveToward(MoveTarget,Enemy,,False);
	else 
		MoveToward(MoveTarget,MoveTarget,,False);
	
	if ( HidingSpots == None || !PlayerSeesMe() )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	GoTo'Begin';
}
State SyrRetreat
{
Ignores HearNoise,DamageAttitudeTo,Tick,EnemyChanged,Startle;

	event BeginState()
	{
		HidingSpots = None;
		Enemy = None;
		SetTimer(0.1,True);
	}
	event SeePlayer(Pawn SeenPlayer)
	{
		SetEnemy(SeenPlayer);
	}
	event Timer()
	{
		if( Enemy==None )
			Return;
		Target = Enemy;
		KFM.RangedAttack(Target);
	}
	function FindHideSpot()
	{
		local NavigationPoint N,BN;
		local float Dist,BDist,MDist;
		local vector EnemyDir;

		if ( Enemy == None )  {
			HidingSpots = FindRandomDest();
			Return;
		}
		EnemyDir = Normal(Enemy.Location - Pawn.Location);
		for( N = Level.NavigationPointList; N != None; N = N.NextNavigationPoint )  {
			MDist = VSize(N.Location-Pawn.Location);
			if ( MDist < 2500.0 && !FastTrace(N.Location,Enemy.Location) && FindPathToward(N)!=None )  {
				Dist = VSize(N.Location-Enemy.Location)/FMax(MDist/800.f,1.5);
				if ( (EnemyDir Dot Normal(Enemy.Location-N.Location)) < 0.2 )
					Dist /= 10.0;
				if ( BN==None || BDist<Dist )  {
					BN = N;
					BDist = Dist;
				}
			}
		}
		if ( BN == None )
			HidingSpots = FindRandomDest();
		else 
			HidingSpots = BN;
	}

Begin:
	if ( Pawn.Physics == PHYS_Falling )
		WaitForLanding();
	
	While( KFM.bShotAnim )
		Sleep(0.25);
	
	if ( HidingSpots == None )
		FindHideSpot();
	
	if ( HidingSpots == None )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	
	if ( ActorReachable(HidingSpots) )  {
		MoveTarget = HidingSpots;
		HidingSpots = None;
	}
	else 
		FindBestPathToward(HidingSpots,True,False);
	
	if ( MoveTarget == None )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	
	if ( Enemy != None && VSize(Enemy.Location - Pawn.Location) < 100.0 )
		MoveToward(MoveTarget,Enemy,,False);
	else 
		MoveToward(MoveTarget,MoveTarget,,False);
	
	if ( HidingSpots == None )
		UM_BaseMonster_Boss(Pawn).BeginHealing();
	GoTo'Begin';
}

function bool PlayerSeesMe()
{
	local Controller C;

	for( C = Level.ControllerList; C != None; C = C.NextController )  {
		if ( C.bIsPlayer && C.Pawn != None && C.Pawn != Pawn && LineOfSightTo(C.Pawn) )
			Return True;
	}
	Return False;
}

// Used to set a timeout for the WaitForAnim state. This is a bit of a hack fix
// for the Patriach getting stuck in its idle anim on a dedicated server when it
// is supposed to doing something. For some reason, on a dedicated server only, it
// never gets an animend call for some of the anims, instead the anim gets
// interrupted by the idle anim. If we figure that bug out, we can
// probably take this out in the future. But for now the fix works - Ramm
function SetWaitForAnimTimout(float NewWaitAnimTimeout, name AnimToWaitFor)
{
	WaitAnimTimeout = NewWaitAnimTimeout;
	AnimWaitingFor = AnimToWaitFor;
}

state WaitForAnim
{
Ignores SeePlayer,HearNoise,Timer,EnemyNotVisible,NotifyBump,Startle;


	// The anim has ended, clear the flags and let the AI do its thing
	function WaitTimeout()
	{
		if ( bUseFreezeHack )  {
			if ( Pawn != None )  {
				Pawn.AccelRate = Pawn.Default.AccelRate;
				Pawn.GroundSpeed = Pawn.Default.GroundSpeed;
			}
			bUseFreezeHack = False;
		}

		AnimEnd(AnimWaitChannel);
	}

	event AnimEnd(int Channel)
	{
		/*local name  Sequence;
		local float Frame, Rate;


		Pawn.GetAnimParams( KFMonster(Pawn).ExpectingChannel, Sequence, Frame, Rate );

		log(GetStateName()$" AnimEnd for Exp Chan "$KFMonster(Pawn).ExpectingChannel$" = "$Sequence$" Channel = "$Channel);

		Pawn.GetAnimParams( 0, Sequence, Frame, Rate );
		log(GetStateName()$" AnimEnd for Chan 0 = "$Sequence);

		Pawn.GetAnimParams( 1, Sequence, Frame, Rate );
		log(GetStateName()$" AnimEnd for Chan 1 = "$Sequence);

		log(GetStateName()$" AnimEnd bShotAnim = "$Monster(Pawn).bShotAnim); */

		Pawn.AnimEnd(Channel);
		if ( !Monster(Pawn).bShotAnim )
			WhatToDoNext(99);
	}

	event Tick( float Delta )
	{
		Global.Tick(Delta);

		if ( WaitAnimTimeout > 0 )  {
			WaitAnimTimeout -= Delta;
			if ( WaitAnimTimeout < 1 )  {
				WaitAnimTimeout = 0;
				WaitTimeout();
			}
		}

		if ( bUseFreezeHack )  {
			MoveTarget = None;
			MoveTimer = -1;
			Pawn.Acceleration = vect(0,0,0);
			Pawn.GroundSpeed = 1;
			Pawn.AccelRate = 0;
		}
	}
	event EndState()
	{
		Super.EndState();
		AnimWaitingFor = '';
	}
}

defaultproperties
{
}
