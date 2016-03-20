//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieClot
//	Parent class:	 UM_BaseMonster_Clot
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:05
//================================================================================
class UM_ZombieClot extends UM_BaseMonster_Clot;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_Freaks_Trip.ukx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

function BreakGrapple()
{
	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
}

function ClawDamageTarget()
{
	local vector PushDir;
	local KFPawn KFP;
	local float UsedMeleeDamage;


	if( MeleeDamage > 1 )
    {
	   UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	}
	else
	{
	   UsedMeleeDamage = MeleeDamage;
	}

	// If zombie has latched onto us...
	if ( MeleeDamageTarget( UsedMeleeDamage, PushDir))
	{
		KFP = KFPawn(Controller.Target);

        PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);

        if( !bDecapitated && KFP != none )
        {
			if ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo) == none ||
				 KFP.GetVeteran().static.CanBeGrabbed(KFPlayerReplicationInfo(KFP.PlayerReplicationInfo), self))
			{
				if( DisabledPawn != none )
				{
				     DisabledPawn.bMovementDisabled = false;
				}

				KFP.DisableMovement(GrappleDuration);
				DisabledPawn = KFP;
			}
		}
	}
}

simulated function bool AnimNeedsWait(name TestAnim)
{
    if( TestAnim == 'KnockDown' || TestAnim == 'DoorBash' )
    {
        return true;
    }

    return false;
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == MeleeAnims[0] || AnimName == MeleeAnims[1] || AnimName == MeleeAnims[2] )
	{
		AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);

		// Randomly send out a message about Clot grabbing you(10% chance)
		if ( FRand() < 0.10 && LookTarget != none && KFPlayerController(LookTarget.Controller) != none &&
			 VSizeSquared(Location - LookTarget.Location) < 2500 /* (MeleeRange + 20)^2 */ &&
			 Level.TimeSeconds - KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime > ClotGrabMessageDelay &&
			 KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'KFVetBerserker' &&
			 KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'UM_SRVetBerserker' )
		{
			PlayerController(LookTarget.Controller).Speech('AUTO', 11, "");
			KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime = Level.TimeSeconds;
		}

        bGrappling = True;
        GrappleEndTime = Level.TimeSeconds + GrappleDuration;

		Return 1;
	}

	Return Super.DoAnimAction( AnimName );
}

simulated event Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

	if( bShotAnim && Role == ROLE_Authority )
	{
		if( LookTarget!=None )
		{
		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
		}
    }

	if( Role == ROLE_Authority && bGrappling )
	{
		if( Level.TimeSeconds > GrappleEndTime )
		{
		    bGrappling = false;
		}
    }

    // if we move out of melee range, stop doing the grapple animation
    if( bGrappling && LookTarget != none )
    {
        if( VSize(LookTarget.Location - Location) > MeleeRange + CollisionRadius + LookTarget.CollisionRadius )
        {
            bGrappling = false;
            AnimEnd(1);
        }
    }
}

function RemoveHead()
{
	Super.RemoveHead();
	MeleeAnims[0] = 'Claw';
	MeleeAnims[1] = 'Claw';
	MeleeAnims[2] = 'Claw2';

    MeleeDamage *= 2;
    MeleeRange *= 2;

	if( DisabledPawn != none )
	{
	     DisabledPawn.bMovementDisabled = false;
	     DisabledPawn = none;
	}
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
	Super.Died(Killer, DamageType, HitLocation);
}

simulated function Destroyed()
{
    if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
	Super.Destroyed();
}

static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{//should be derived and used.
    Super.PreCacheStaticMeshes(myLevel);
/*
    myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_1');
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_2');
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_3');
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_4');
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_5');
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.clot.clothead_piece_6');
*/
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.clot_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.clot_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.clot_diffuse');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.clot_spec');
}

defaultproperties
{
     EventClasses(0)="UnlimaginMod.UM_ZombieClot"
     EventClasses(1)="UnlimaginMod.UM_ZombieClot"
     //EventClasses(2)="UnlimaginMod.UM_ZombieClot_HALLOWEEN"
	 EventClasses(2)="UnlimaginMod.UM_ZombieClot"
     //EventClasses(3)="UnlimaginMod.UM_ZombieClot_XMas"
	 EventClasses(3)="UnlimaginMod.UM_ZombieClot"
     DetachedArmClass=Class'KFChar.SeveredArmClot'
     DetachedLegClass=Class'KFChar.SeveredLegClot'
     DetachedHeadClass=Class'KFChar.SeveredHeadClot'
}
