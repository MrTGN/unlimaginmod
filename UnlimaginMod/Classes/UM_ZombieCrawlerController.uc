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

var	float	LastPounceTime;
var	bool	bDoneSpottedCheck;

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

function bool IsInPounceDist(actor PTarget)
{
	local vector DistVec;
	local float time;
	local float HeightMoved;
	local float EndHeight;

	//work out time needed to reach target

	DistVec = Pawn.location - PTarget.location;
	DistVec.Z = 0;

	time = vsize(DistVec) / UM_BaseMonster_Crawler(Pawn).PounceSpeed;
	// vertical change in that time
	//assumes downward grav only
	HeightMoved = Pawn.JumpZ * time + 0.5 * Pawn.PhysicsVolume.Gravity.z * Square(time);
	EndHeight = Pawn.Location.z + HeightMoved;

	//log(Vsize(Pawn.Location - PTarget.Location));
	if ( (abs(EndHeight - PTarget.Location.Z) < (Pawn.CollisionHeight + PTarget.CollisionHeight)) && VSizeSquared(Pawn.Location - PTarget.Location) < Square(KFMonster(Pawn).MeleeRange * 5.0) )
		Return True;
	else
		Return False;
}

function bool FireWeaponAt(Actor A)
{
	local	float	RelativeDir;

	if ( A == None )
		A = Enemy;
	
	if ( A == None || Focus != A )
		Return False;

	if ( CanAttack(A) )  {
		Target = A;
		Monster(Pawn).RangedAttack(Target);
	}
	else if ( (LastPounceTime + (4.5 - FRand() * 3.0)) < Level.TimeSeconds )  {
		// Get the vector from A to B
		RelativeDir = Normal(Vector(Pawn.Rotation)) dot (A.Location - Pawn.Location);
		//Facing enemy
		if ( RelativeDir > 0.85 && IsInPounceDist(A) && UM_BaseMonster_Crawler(Pawn).DoPounce() )
			LastPounceTime = Level.TimeSeconds;
	}

	Return False;
}

function bool NotifyLanded(vector HitNormal)
{
	if ( UM_BaseMonster_Crawler(Pawn).bPouncing )  {
		// restart pathfinding from landing location
		//GotoState('Hunting');
		GotoState('ZombieHunt');
		Return False;
	}
	else
		Return Super.NotifyLanded(HitNormal);
}

defaultproperties
{
}
