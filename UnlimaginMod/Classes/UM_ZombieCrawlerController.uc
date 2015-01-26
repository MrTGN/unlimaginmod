//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieCrawlerController
//	Parent class:	 UM_KFMonsterController
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 10.10.2012 20:06
//================================================================================
class UM_ZombieCrawlerController extends UM_KFMonsterController;

var	float	LastPounceTime;
var	bool	bDoneSpottedCheck;

state ZombieHunt
{
	event SeePlayer(Pawn SeenPlayer)
	{
		if ( !bDoneSpottedCheck && PlayerController(SeenPlayer.Controller) != none )
		{
			// 25% chance of first player to see this Crawler saying something
			if ( UM_InvasionGame(Level.Game) != None )
			{
				if ( !UM_InvasionGame(Level.Game).bDidSpottedCrawlerMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 18, "");
					UM_InvasionGame(Level.Game).bDidSpottedCrawlerMessage = true;
				}
			}
			else if ( KFGameType(Level.Game) != None )
			{
				if ( !KFGameType(Level.Game).bDidSpottedCrawlerMessage && FRand() < 0.25 )
				{
					PlayerController(SeenPlayer.Controller).Speech('AUTO', 18, "");
					KFGameType(Level.Game).bDidSpottedCrawlerMessage = true;
				}
			}

			bDoneSpottedCheck = true;
		}

		super.SeePlayer(SeenPlayer);
	}
}

function bool IsInPounceDist(actor PTarget)
{
	local vector DistVec;
	local float time;

	local float HeightMoved;
	local float EndHeight;

	//work out time needed to reach target

	DistVec = pawn.location - PTarget.location;
	DistVec.Z=0;

	time = vsize(DistVec)/UM_ZombieCrawler(pawn).PounceSpeed;

	// vertical change in that time

	//assumes downward grav only
	HeightMoved = Pawn.JumpZ*time + 0.5*pawn.PhysicsVolume.Gravity.z*time*time;

	EndHeight = pawn.Location.z +HeightMoved;

	//log(Vsize(Pawn.Location - PTarget.Location));


	if((abs(EndHeight - PTarget.Location.Z) < Pawn.CollisionHeight + PTarget.CollisionHeight) 
		 && VSize(pawn.Location - PTarget.Location) < KFMonster(pawn).MeleeRange * 5)
		return true;
	else
		return false;
}

function bool FireWeaponAt(Actor A)
{
	local vector aFacing,aToB;
	local float RelativeDir;

	if ( A == None )
		A = Enemy;
	if ( (A == None) || (Focus != A) )
		return false;

	if(CanAttack(A))
	{
		Target = A;
		Monster(Pawn).RangedAttack(Target);
	}
	else
	{
		//TODO - base off land time rather than launch time?
		if((LastPounceTime + (4.5 - (FRand() * 3.0))) < Level.TimeSeconds )
		{
			aFacing=Normal(Vector(Pawn.Rotation));
			// Get the vector from A to B
			aToB=A.Location-Pawn.Location;

			RelativeDir = aFacing dot aToB;
			
			//Facing enemy
			if ( RelativeDir > 0.85 && IsInPounceDist(A) && UM_ZombieCrawler(Pawn).DoPounce()==true )
				LastPounceTime = Level.TimeSeconds;
		}
	}

	return false;
}

function bool NotifyLanded(vector HitNormal)
{
	if( UM_ZombieCrawler(pawn).bPouncing )
	{
		// restart pathfinding from landing location
		GotoState('hunting');
		return false;
	}
	else
		return super.NotifyLanded(HitNormal);
}

defaultproperties
{
}
