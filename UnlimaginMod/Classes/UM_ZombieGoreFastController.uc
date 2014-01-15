//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieGoreFastController
//	Parent class:	 UM_KFMonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2012 21:58
//================================================================================
class UM_ZombieGoreFastController extends UM_KFMonsterController;

var	bool	bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
		{
			// 25% chance of first player to see this Gorefast saying something
			if ( UnlimaginGameType(Level.Game) != None )
			{
				if ( !UnlimaginGameType(Level.Game).bDidSpottedGorefastMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 13, "");
					UnlimaginGameType(Level.Game).bDidSpottedGorefastMessage = true;
				}
			}
			else if ( KFGameType(Level.Game) != None )
			{
				if ( !KFGameType(Level.Game).bDidSpottedGorefastMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 13, "");
					KFGameType(Level.Game).bDidSpottedGorefastMessage = true;
				}
			}
			
			bDoneSpottedCheck = true;
		}

		global.SeePlayer(SeenPlayer);
	}
}

defaultproperties
{
     StrafingAbility=0.500000
}
