//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieCrawlerController
//	Parent class:	 UM_MonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2012 20:06
//================================================================================
class UM_ZombieCrawlerController extends UM_MonsterController;

var		bool		bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != None )  {
			// 25% chance of first player to see this Crawler saying something
			if ( KFGameType(Level.Game) != None && !KFGameType(Level.Game).bDidSpottedCrawlerMessage && FRand() < 0.25 )  {
				PlayerController(SeenPlayer.Controller).Speech('AUTO', 18, "");
				KFGameType(Level.Game).bDidSpottedCrawlerMessage = True;
			}

			bDoneSpottedCheck = True;
		}

		Super.SeePlayer(SeenPlayer);
	}
}

/*
event bool NotifyLanded(vector HitNormal)
{
	if ( UM_BaseMonster_Crawler(Pawn).bPouncing )  {
		// restart pathfinding from landing location
		//GotoState('Hunting');
		GotoState('ZombieHunt');
		Return False;
	}
	else
		Return Super.NotifyLanded(HitNormal);
}	*/

defaultproperties
{
}
