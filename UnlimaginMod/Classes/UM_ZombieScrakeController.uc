//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieScrakeController
//	Parent class:	 UM_MonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2012 22:12
//================================================================================
class UM_ZombieScrakeController extends UM_MonsterController;
// Custom Zombie Thinkerating
// By : Alex

var	bool	bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != None )
		{
			// 25% chance of first player to see this Scrake saying something
			if ( UM_InvasionGame(Level.Game) != None )
			{
				if ( !UM_InvasionGame(Level.Game).bDidSpottedScrakeMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 14, "");
					UM_InvasionGame(Level.Game).bDidSpottedScrakeMessage = True;
				}
			}
			else if ( KFGameType(Level.Game) != None )
			{
				if ( !KFGameType(Level.Game).bDidSpottedScrakeMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 14, "");
					KFGameType(Level.Game).bDidSpottedScrakeMessage = True;
				}
			}

			bDoneSpottedCheck = True;
		}

		super.SeePlayer(SeenPlayer);
	}
}

function TimedFireWeaponAtEnemy()
{
	if ( (Enemy == None) || FireWeaponAt(Enemy) )
		SetCombatTimer();
	else SetTimer(0.01, True);
}

state ZombieCharge
{
    // Don't do this in this state
    function GetOutOfTheWayOfShot(vector ShotDirection, vector ShotOrigin){}

	function bool StrafeFromDamage(float Damage, class<DamageType> DamageType, bool bFindDest)
	{
		Return False;
	}
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

	While( Monster(Pawn).bShotAnim )
		Sleep(0.25);
	if ( !FindBestPathToward(Enemy, False,True) )
		GotoState('ZombieRestFormation');
Moving:
	MoveToward(Enemy);
	WhatToDoNext(17);
	if ( bSoaking )
		SoakStop("STUCK IN CHARGING!");
}

defaultproperties
{
}
