//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieSirenController
//	Parent class:	 UM_KFMonsterController
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2012 22:21
//================================================================================
class UM_ZombieSirenController extends UM_KFMonsterController;

var		bool		bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
		{
			// 25% chance of first player to see this Siren saying something
			if ( UM_InvasionGame(Level.Game) != None )
			{
				if ( !UM_InvasionGame(Level.Game).bDidSpottedSirenMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 15, "");
					UM_InvasionGame(Level.Game).bDidSpottedSirenMessage = true;
				}
			}
			else if ( KFGameType(Level.Game) != None )
			{
				if ( !KFGameType(Level.Game).bDidSpottedSirenMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 15, "");
					KFGameType(Level.Game).bDidSpottedSirenMessage = true;
				}
			}

			bDoneSpottedCheck = true;
		}

		super.SeePlayer(SeenPlayer);
	}
}

defaultproperties
{
}
