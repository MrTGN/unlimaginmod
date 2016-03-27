//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieHuskController
//	Parent class:	 UM_MonsterController
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 10.10.2012 22:07
//================================================================================
class UM_ZombieHuskController extends UM_MonsterController;

// Overridden to create a delay between when the husk fires his projectiles
function bool FireWeaponAt(Actor A)
{
	if ( A == None )
		A = Enemy;
	
	if ( A == None || Focus != A )
		Return False;
	
	Target = A;

	if ( (VSize(A.Location - Pawn.Location) >= UM_BaseMonster_Husk(Pawn).MeleeRange + Pawn.CollisionRadius + Target.CollisionRadius) && (UM_BaseMonster_Husk(Pawn).NextFireProjectileTime - Level.TimeSeconds) > 0.0 )
		Return False;

	Monster(Pawn).RangedAttack(Target);
	
	Return False;
}

/*
AdjustAim()
Returns a rotation which is the direction the bot should aim - after introducing the appropriate aiming error
Overridden to cause the zed to fire at the feet more often - Ramm
*/
function rotator AdjustAim(FireProperties FiredAmmunition, vector projStart, int AimError)
{
	local rotator FireRotation, TargetLook;
	local float FireDist, TargetDist, ProjSpeed;
	local actor HitActor;
	local vector FireSpot, FireDir, TargetVel, HitLocation, HitNormal;
	local int realYaw;
	local bool bDefendMelee, bClean, bLeadTargetNow;
	local bool bWantsToAimAtFeet;

	if ( FiredAmmunition.ProjectileClass != None )
		projspeed = FiredAmmunition.ProjectileClass.default.speed;

	// make sure bot has a valid target
	if ( Target == None )  {
		Target = Enemy;
		if ( Target == None )
			Return Rotation;
	}
	FireSpot = Target.Location;
	TargetDist = VSize(Target.Location - Pawn.Location);

	// perfect aim at stationary objects
	if ( Pawn(Target) == None )  {
		if ( !FiredAmmunition.bTossed )
			Return rotator(Target.Location - projstart);
		else
		{
			FireDir = AdjustToss(projspeed,ProjStart,Target.Location,True);
			SetRotation(Rotator(FireDir));
			Return Rotation;
		}
	}

	bLeadTargetNow = FiredAmmunition.bLeadTarget && bLeadTarget;
	bDefendMelee = ( (Target == Enemy) && DefendMelee(TargetDist) );
	AimError = AdjustAimError(AimError,TargetDist,bDefendMelee,FiredAmmunition.bInstantHit, bLeadTargetNow);

	// lead target with non instant hit projectiles
	if ( bLeadTargetNow )  {
		TargetVel = Target.Velocity;
		// hack guess at projecting falling velocity of target
		if ( Target.Physics == PHYS_Falling )  {
			if ( Target.PhysicsVolume.Gravity.Z <= Target.PhysicsVolume.Default.Gravity.Z )
				TargetVel.Z = FMin(TargetVel.Z + FMax(-400, Target.PhysicsVolume.Gravity.Z * FMin(1,TargetDist/projSpeed)),0);
			else
				TargetVel.Z = FMin(0, TargetVel.Z);
		}
		// more or less lead target (with some random variation)
		FireSpot += FMin( 1, (0.7 + 0.6 * FRand()) ) * TargetVel * TargetDist / projSpeed;
		FireSpot.Z = FMin( Target.Location.Z, FireSpot.Z );

		if ( Target.Physics != PHYS_Falling && FRand() < 0.55 && VSize(FireSpot - ProjStart) > 1000 )  {
			// don't always lead far away targets, especially if they are moving sideways with respect to the bot
			TargetLook = Target.Rotation;
			if ( Target.Physics == PHYS_Walking )
				TargetLook.Pitch = 0;
			bClean = ( ((Vector(TargetLook) Dot Normal(Target.Velocity)) >= 0.71) && FastTrace(FireSpot, ProjStart) );
		}
		else // make sure that bot isn't leading into a wall
			bClean = FastTrace(FireSpot, ProjStart);
		if ( !bClean)  {
			// reduce amount of leading
			if ( FRand() < 0.3 )
				FireSpot = Target.Location;
			else
				FireSpot = 0.5 * (FireSpot + Target.Location);
		}
	}

	bClean = False; //so will fail first check unless shooting at feet

    // Randomly determine if we should try and splash damage with the fire projectile
    if( FiredAmmunition.bTrySplash )  {
        if ( Skill < 2.0 )
            if ( FRand() > 0.85 )
                bWantsToAimAtFeet = True;
        else if ( Skill < 3.0 )
            if ( FRand() > 0.5 )
                bWantsToAimAtFeet = True;
        else if ( Skill >= 3.0 )
            if ( FRand() > 0.25 )
                bWantsToAimAtFeet = True;
    }

	if ( FiredAmmunition.bTrySplash && Pawn(Target) != None && ((Target.Physics == PHYS_Falling && (Pawn.Location.Z + 80.0) >= Target.Location.Z) || ((Pawn.Location.Z + 19.0) >= Target.Location.Z && (bDefendMelee || bWantsToAimAtFeet))) )  {
        HitActor = Trace(HitLocation, HitNormal, FireSpot - vect(0,0,1) * (Target.CollisionHeight + 10), FireSpot, False);
 		bClean = (HitActor == None);
		if ( !bClean )  {
			FireSpot = HitLocation + vect(0,0,3);
			bClean = FastTrace(FireSpot, ProjStart);
		}
		else
			bClean = ( (Target.Physics == PHYS_Falling) && FastTrace(FireSpot, ProjStart) );
	}

	if ( !bClean )  {
		//try middle
		FireSpot.Z = Target.Location.Z;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	
	if ( FiredAmmunition.bTossed && !bClean && bEnemyInfoValid )  {
		FireSpot = LastSeenPos;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
		if ( HitActor != None )  {
			bCanFire = False;
			FireSpot += 2 * Target.CollisionHeight * HitNormal;
		}
		bClean = True;
	}

	if( !bClean )  {
		// try head
 		FireSpot.Z = Target.Location.Z + 0.9 * Target.CollisionHeight;
 		bClean = FastTrace(FireSpot, ProjStart);
	}
	
	if ( !bClean && Target == Enemy && bEnemyInfoValid )  {
		FireSpot = LastSeenPos;
		if ( Pawn.Location.Z >= LastSeenPos.Z )
			FireSpot.Z -= 0.4 * Enemy.CollisionHeight;
	 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
		if ( HitActor != None )  {
			FireSpot = LastSeenPos + 2 * Enemy.CollisionHeight * HitNormal;
			if ( Monster(Pawn).SplashDamage() && (Skill >= 4) )  {
			 	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
				if ( HitActor != None )
					FireSpot += 2 * Enemy.CollisionHeight * HitNormal;
			}
			bCanFire = False;
		}
	}

	// adjust for toss distance
	if ( FiredAmmunition.bTossed )
		FireDir = AdjustToss(projspeed,ProjStart,FireSpot,True);
	else
		FireDir = FireSpot - ProjStart;

	FireRotation = Rotator(FireDir);
	realYaw = FireRotation.Yaw;
	InstantWarnTarget(Target,FiredAmmunition,vector(FireRotation));

	FireRotation.Yaw = SetFireYaw(FireRotation.Yaw + AimError);
	FireDir = vector(FireRotation);
	// avoid shooting into wall
	FireDist = FMin(VSize(FireSpot-ProjStart), 400);
	FireSpot = ProjStart + FireDist * FireDir;
	HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
	if ( HitActor != None )  {
		if ( HitNormal.Z < 0.7 )  {
			FireRotation.Yaw = SetFireYaw(realYaw - AimError);
			FireDir = vector(FireRotation);
			FireSpot = ProjStart + FireDist * FireDir;
			HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
		}
		
		if ( HitActor != None )  {
			FireSpot += HitNormal * 2 * Target.CollisionHeight;
			if ( Skill >= 4 )  {
				HitActor = Trace(HitLocation, HitNormal, FireSpot, ProjStart, False);
				if ( HitActor != None )
					FireSpot += Target.CollisionHeight * HitNormal;
			}
			FireDir = Normal(FireSpot - ProjStart);
			FireRotation = rotator(FireDir);
		}
	}

	SetRotation(FireRotation);
	
	Return FireRotation;
}

defaultproperties
{
}
