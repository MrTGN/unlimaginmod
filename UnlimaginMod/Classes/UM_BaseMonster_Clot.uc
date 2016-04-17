//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Clot
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:06
//================================================================================
class UM_BaseMonster_Clot extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_Freaks_Trip.ukx
#exec OBJ LOAD FILE=KF_Specimens_Trip_T.utx

//========================================================================
//[block] Variables

var     KFPawn  DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var     bool    bGrappling;             // This zombie is grappling someone
var     float   GrappleEndTime;         // When the current grapple should be over
var()   float   GrappleDuration;        // How long a grapple by this zombie should last

var	float	ClotGrabMessageDelay;	// Amount of time between a player saying "I've been grabbed" message

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bGrappling;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

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


	if ( MeleeDamage > 1 )
		UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	else
		UsedMeleeDamage = MeleeDamage;

	// If zombie has latched onto us...
	if ( MeleeDamageTarget( UsedMeleeDamage, PushDir) )  {
		KFP = KFPawn(Controller.Target);
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);
		if ( !bDecapitated && KFP != None )  {
			if ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo) == None ||
				 KFP.GetVeteran().static.CanBeGrabbed(KFPlayerReplicationInfo(KFP.PlayerReplicationInfo), self))  {
				if ( DisabledPawn != None )
					DisabledPawn.bMovementDisabled = False;

				KFP.DisableMovement(GrappleDuration);
				DisabledPawn = KFP;
			}
		}
	}
}

simulated function bool AnimNeedsWait(name TestAnim)
{
	if ( TestAnim == 'KnockDown' || TestAnim == 'DoorBash' )
		Return True;

	Return False;
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == MeleeAnims[0] || AnimName == MeleeAnims[1] || AnimName == MeleeAnims[2] )  {
		AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);
		// Randomly send out a message about Clot grabbing you(10% chance)
		if ( FRand() < 0.10 && LookTarget != None && KFPlayerController(LookTarget.Controller) != None && VSizeSquared(Location - LookTarget.Location) < 2500 &&
			 Level.TimeSeconds - KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime > ClotGrabMessageDelay && KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'KFVetBerserker' && KFPlayerController(LookTarget.Controller).SelectedVeterancy != class'UM_SRVetBerserker' )  {
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

	if ( Role == ROLE_Authority )  {
		if ( bShotAnim && LookTarget != None )
			Acceleration = AccelRate * Normal(LookTarget.Location - Location);
		if ( bGrappling && Level.TimeSeconds > GrappleEndTime )
			bGrappling = False;
	}

	// if we move out of melee range, stop doing the grapple animation
	if ( bGrappling && LookTarget != None && VSize(LookTarget.Location - Location) > (MeleeRange + CollisionRadius + LookTarget.CollisionRadius) )  {
		bGrappling = False;
		AnimEnd(1);
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

	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
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

simulated event Destroyed()
{
	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 GrappleDuration=1.500000
	 ClotGrabMessageDelay=12.000000
	 MeleeAnims(0)="ClotGrapple"
	 MeleeAnims(1)="ClotGrappleTwo"
	 MeleeAnims(2)="ClotGrappleThree"
	 bCannibal=True
	 MeleeDamage=6
	 damageForce=5000
	 KFRagdollName="Clot_Trip"
	 CrispUpThreshhold=9
	 PuntAnim="ClotPunt"
	 AdditionalWalkAnims(0)="ClotWalk2"
	 Intelligence=BRAINS_Mammal
	 SeveredArmAttachScale=0.800000
	 SeveredLegAttachScale=0.800000
	 SeveredHeadAttachScale=0.800000
	 MotionDetectorThreat=0.340000
	 ScoringValue=7
	 MeleeRange=20.000000
	 GroundSpeed=105.000000
	 WaterSpeed=105.000000
	 JumpZ=340.000000
	 MenuName="Clot"
	 MovementAnims(0)="ClotWalk"
	 WalkAnims(0)="ClotWalk"
	 WalkAnims(1)="ClotWalk"
	 WalkAnims(2)="ClotWalk"
	 WalkAnims(3)="ClotWalk"
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=130.0
	 Health=130
	 HeadHealth=25.0
	 //PlayerCountHealthScale=0.0
     PlayerCountHealthScale=0.0
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.0
	 Mass=200.000000
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=5.6,AreaHeight=6.6,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=1.6,Y=-1.6,Z=0.0),AreaImpactStrength=5.4)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=17.0,AreaHeight=36.8,AreaImpactStrength=7.4)
}
