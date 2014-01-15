//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KFMonsterController
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
class UM_KFMonsterController extends KFMonsterController;

//var		float	MyDazzleTime;

// Get rid of this Zed if he's stuck somewhere and noone has seen him
function bool CanKillMeYet()
{
	if ( KFGameType(Level.Game) != None )  {
		if ( KFMonster(Pawn) != None && KFGameType(Level.Game).WaveNum >= KFGameType(Level.Game).FinalWave )
			Return True;
		if ( KFMonster(Pawn) != None && (Level.TimeSeconds - KFMonster(Pawn).LastSeenOrRelevantTime) > 8 )
			Return True;
	}

	Return False;
}

// If we're not dead, and we can see our target, and we still have a head. lets go eat it.
function bool FindFreshBody()
{
	local KFGameType K;
	local int i;
	local PlayerDeathMark Best;
	local float Dist,BDist;

	K = KFGameType(Level.Game);
	
	if( K == None || KFM.bDecapitated || !KFM.bCannibal || (!Level.Game.bGameEnded && Pawn.Health>=(Pawn.Default.Health*1.5)) )
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