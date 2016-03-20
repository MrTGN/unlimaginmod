//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieGoreFastController
//	Parent class:	 UM_MonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2012 21:58
//================================================================================
class UM_ZombieGoreFastController extends UM_MonsterController;

var	bool	bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != None )
		{
			// 25% chance of first player to see this Gorefast saying something
			if ( UM_InvasionGame(Level.Game) != None )
			{
				if ( !UM_InvasionGame(Level.Game).bDidSpottedGorefastMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 13, "");
					UM_InvasionGame(Level.Game).bDidSpottedGorefastMessage = True;
				}
			}
			else if ( KFGameType(Level.Game) != None )
			{
				if ( !KFGameType(Level.Game).bDidSpottedGorefastMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 13, "");
					KFGameType(Level.Game).bDidSpottedGorefastMessage = True;
				}
			}
			
			bDoneSpottedCheck = True;
		}

		global.SeePlayer(SeenPlayer);
	}
}

defaultproperties
{
     StrafingAbility=0.500000
}
