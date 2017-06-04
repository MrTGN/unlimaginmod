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

var					UM_HumanPawn	DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var					bool			bGrappling;             // This zombie is grappling someone
var					float			GrappleEndTime;         // When the current grapple should be over
var()				float			GrappleDuration;        // How long a grapple by this zombie should last
var		transient	float			GrappleSquaredRange;

var		transient	float			NextGrappleRangeCheckTime;
var					float			GrappleRangeCheckDelay;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

// EnemyChanged() called by controller when current enemy changes
function EnemyChanged()
{
	Super.EnemyChanged();
	if ( LookTarget != None )
		GrappleSquaredRange = Square(MeleeRange + CollisionRadius + LookTarget.CollisionRadius);
}

function ClawDamageTarget()
{
	local	vector			PushDir;
	local	UM_HumanPawn	NewDisabledPawn;
	local	float			UsedMeleeDamage;
	
	if ( Controller == None || Controller.Target == None )
		Return;
	
	if ( MeleeDamage < 20 )
		UsedMeleeDamage = MeleeDamage;
	// Melee damage +/- 5%
	else
		UsedMeleeDamage = Round( float(MeleeDamage) * Lerp(FRand(), 0.95, 1.05) );

	// If zombie has latched onto us...
	if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )  {
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);
		NewDisabledPawn = UM_HumanPawn(Controller.Target);
		if ( bDecapitated || NewDisabledPawn == None || !NewDisabledPawn.CanBeGrabbedBy(self) )
			Return;
		
		if ( DisabledPawn != None && NewDisabledPawn != DisabledPawn )
			DisabledPawn.EnableMovement();
		
		bGrappling = True;
		GrappleEndTime = Level.TimeSeconds + GrappleDuration;
		DisabledPawn = NewDisabledPawn;
		NewDisabledPawn.DisableMovement(GrappleDuration);
		NewDisabledPawn.NotifyGrabbedBy(Self);
	}
}

function bool IsOutOfGrappleRange()
{
	if ( LookTarget == None )
		Return True;
	
	if ( Level.TimeSeconds < NextGrappleRangeCheckTime )
		Return False;
	
	NextGrappleRangeCheckTime = Level.TimeSeconds + GrappleRangeCheckDelay;
	
	Return VSizeSquared(LookTarget.Location - Location) > GrappleSquaredRange;
}

simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if ( Role == ROLE_Authority )  {
		if ( bShotAnim && !bWaitForAnim && LookTarget != None )
			Acceleration = AccelRate * Normal(LookTarget.Location - Location);
		// if we move out of melee range, stop doing the grapple animation
		if ( bGrappling && (Level.TimeSeconds > GrappleEndTime || IsOutOfGrappleRange()) )  {
			bGrappling = False;
			AnimEnd(1);
		}
	}
}

function BreakGrapple()
{
	if ( DisabledPawn == None )
		Return;
	
	DisabledPawn.EnableMovement();
	DisabledPawn = None;
}

function RemoveHead()
{
	Super.RemoveHead();
	MeleeAnims[0] = 'Claw';
	MeleeAnims[1] = 'Claw';
	MeleeAnims[2] = 'Claw2';

	MeleeDamage *= 2;
	MeleeRange *= 2;

	BreakGrapple();
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	BreakGrapple();
	Super.Died(Killer, DamageType, HitLocation);
}

simulated event Destroyed()
{
	BreakGrapple();
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 KnockDownHealthPct=0.65
	 ExplosiveKnockDownHealthPct=0.55
	 
	 // Explosion parametrs
	 KilledExplodeChance=0.2
	 ExplosionDamage=160
	 ExplosionRadius=260.0
	 ExplosionMomentum=7000.0
	 //ExplosionShrapnelClass=
	 //ExplosionShrapnelAmount=(Min=4,Max=6)
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Weak'
	 
	 GrappleRangeCheckDelay=0.1
	 GrappleDuration=1.500000
	 MeleeAnims(0)="ClotGrapple"
	 MeleeAnims(1)="ClotGrappleTwo"
	 MeleeAnims(2)="ClotGrappleThree"
	 bCannibal=True
	 MeleeDamage=6
	 damageForce=5000
	 KFRagdollName="Clot_Trip"
	 CrispUpThreshhold=9
	 PuntAnim="ClotPunt"
	 Intelligence=BRAINS_Mammal
	 SeveredArmAttachScale=0.800000
	 SeveredLegAttachScale=0.800000
	 SeveredHeadAttachScale=0.800000
	 MotionDetectorThreat=0.340000
	 ScoringValue=7
	 MeleeRange=20.000000
	 GroundSpeed=105.000000
	 WaterSpeed=105.000000
	 
	 JumpZ=340.0
	 JumpSpeed=160.0
	 RotationRate=(Yaw=45000,Roll=0)
	 MenuName="Clot"
	 DecapitationAnim="HeadLoss"
	 bKnockDownByDecapitation=True
	 // MovementAnims
	 MovementAnims(0)="ClotWalk"
     MovementAnims(1)="ClotWalk"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 TurnLeftAnim="TurnLeft"
     TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="ClotWalk"
	 WalkAnims(1)="ClotWalk"
	 WalkAnims(2)="RunL"
	 WalkAnims(3)="RunR"
	 AdditionalWalkAnims(0)="ClotWalk2"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Headless"
     HeadlessWalkAnims(1)="WalkB_Headless"
     HeadlessWalkAnims(2)="WalkL_Headless"
     HeadlessWalkAnims(3)="WalkR_Headless"
     // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_FireTwo"
     BurningWalkFAnims(2)="WalkF_FireThree"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
	 
	 HealthMax=130.0
	 Health=130
	 HeadHealth=25.0
	 DecapitatedRandDamage=(Min=16.0,Max=33.0)
	 //PlayerCountHealthScale=0.0
     PlayerCountHealthScale=0.0
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.0
	 Mass=200.000000
}
