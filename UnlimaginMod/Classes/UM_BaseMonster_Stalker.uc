//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Stalker
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:29
//================================================================================
class UM_BaseMonster_Stalker extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax

//========================================================================
//[block] Variables

var		transient	float			NextCheckTime, LastUncloakTime;
var					KFHumanPawn		LocalKFHumanPawn;
var(Display) 	array<Material> 	UnCloakedSkins;

var					UM_HumanPawn	DisabledPawn;           // The pawn that has been disabled by this zombie's grapple
var					bool			bGrappling;             // This zombie is grappling someone
var					float			GrappleEndTime;         // When the current grapple should be over
var()				float			GrappleDuration;        // How long a grapple by this zombie should last
var		transient	float			GrappleSquaredRange;

var		transient	float			NextGrappleRangeCheckTime;
var					float			GrappleRangeCheckDelay;

var					range			GrabChance;
var		transient	float			CurrentGrabChance;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	if ( Role == ROLE_Authority )
		CurrentGrabChance = Lerp( FRand(), GrabChance.Min, GrabChance.Max );
	CloakStalker();
	Super.PostBeginPlay();
}

simulated event PostNetBeginPlay()
{
	local PlayerController PC;

	Super.PostNetBeginPlay();

	if ( Level.NetMode != NM_DedicatedServer )  {
		PC = Level.GetLocalPlayerController();
		if ( PC != None && PC.Pawn != None )
			LocalKFHumanPawn = KFHumanPawn(PC.Pawn);
	}
}

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
		if ( bDecapitated || NewDisabledPawn == None || !NewDisabledPawn.CanBeGrabbedBy(self) || FRand() > CurrentGrabChance )
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

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == 'Claw' || NewAction == MeleeAnims[0] || NewAction == MeleeAnims[1] || NewAction == MeleeAnims[2] )
		UncloakStalker();
	
	Super.SetAnimAction(NewAction);
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

	if ( Level.NetMode != NM_DedicatedServer )  {
	    if ( bZapped )
			NextCheckTime = Level.TimeSeconds; // Make sure we check if we need to be cloaked as soon as the zap wears off
		else if ( Level.TimeSeconds > NextCheckTime && Health > 0 )  {
			NextCheckTime = Level.TimeSeconds + 0.5;
	        if ( LocalKFHumanPawn != None && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
	            VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
				bSpotted = True;
			else
				bSpotted = False;

			if ( !bSpotted && !bCloaked && Skins[0] != UnCloakedSkins[0] )
				UncloakStalker();
			else if ( Level.TimeSeconds - LastUncloakTime > 1.2 )  {
				// if we're uberbrite, turn down the light
				if ( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )  {
					bUnlit = False;
					CloakStalker();
				}
				else if ( Skins[0] != default.Skins[0] )
					CloakStalker();
			}
		}
	}
}

// Cloak Functions ( called from animation notifies to save Gibby trouble ;) )
simulated function CloakStalker()
{
	// No cloaking if zapped
	if ( bZapped )
		Return;

	if ( bSpotted )  {
		if ( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = True;
		Return;
	}

	// No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	if ( !bDecapitated && !bCrispified )  {
		Visibility = 1;
		bCloaked = True;

		if ( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = default.Skins[0];
		Skins[1] = default.Skins[1];

		// Invisible - no shadow
		if ( PlayerShadow != None )
			PlayerShadow.bShadowActive = False;
		if ( RealTimeShadow != None )
			RealTimeShadow.Destroy();

		// Remove/disallow projectors on invisible people
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = False;
		SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, True);
	}
}

simulated function UnCloakStalker()
{
	if ( bZapped )
		Return;

	if ( !bCrispified )  {
		LastUncloakTime = Level.TimeSeconds;

		Visibility = default.Visibility;
		bCloaked = False;
		bUnlit = False;

		// 25% chance of our Enemy saying something about us being invisible
		if ( KFGameType(Level.Game) != None && Level.NetMode != NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand() < 0.25 && Controller.Enemy != None && PlayerController(Controller.Enemy.Controller) != None )  {
			PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
			KFGameType(Level.Game).bDidStalkerInvisibleMessage = True;
		}
		
		if ( Level.NetMode == NM_DedicatedServer )
			Return;

		if ( Skins[0] != UnCloakedSkins[0] )  {
			Skins = UnCloakedSkins;

			if ( PlayerShadow != None )
				PlayerShadow.bShadowActive = True;

			bAcceptsProjectors = True;
			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, True);
		}
	}
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
	Super.SetZappedBehavior();

	bUnlit = False;

	// Handle setting the zed to uncloaked so the zapped overlay works properly
	if ( Level.Netmode != NM_DedicatedServer )  {
		Skins = UnCloakedSkins;

		if ( PlayerShadow != None )
			PlayerShadow.bShadowActive = True;

		bAcceptsProjectors = True;
		SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, True);
	}
}

// Turn off the zapped behavior
simulated function UnSetZappedBehavior()
{
	Super.UnSetZappedBehavior();

	// Handle getting the zed back cloaked if need be
	if ( Level.Netmode != NM_DedicatedServer )  {
		NextCheckTime = Level.TimeSeconds;
		SetOverlayMaterial(None, 0.0f, True);
	}
}

// Overridden because we need to handle the overlays differently for zombies that can cloak
function SetZapped(float ZapAmount, Pawn Instigator)
{
	LastZapTime = Level.TimeSeconds;

	if ( bZapped )  {
		TotalZap = ZapThreshold;
		RemainingZap = ZapDuration;
	}
	else  {
		TotalZap += ZapAmount;

		if ( TotalZap >= ZapThreshold )  {
			RemainingZap = ZapDuration;
			  bZapped = True;
		}
	}
	ZappedBy = Instigator;
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

	BreakGrapple();
	
	if ( !bCrispified )
		Skins = UnCloakedSkins;
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	BreakGrapple();
	Super.Died(Killer, damageType, HitLocation);
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType,HitLoc);

	if ( bUnlit )
		bUnlit = !bUnlit;

	LocalKFHumanPawn = None;

	if ( !bCrispified )
		Skins = UnCloakedSkins;
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
	 KilledExplodeChance=0.2
	 ExplosionDamage=160
	 ExplosionRadius=280.0
	 ExplosionMomentum=8000.0
	 ExplosionVisualEffect=class'KFMod.FlameImpact_Medium'
	 
	 KnockDownHealthPct=0.65
	 ExplosiveKnockDownHealthPct=0.5
	 
	 Intelligence=BRAINS_Human
	 GrappleRangeCheckDelay=0.1
	 GrabChance=(Min=0.0,Max=0.75)
	 GrappleDuration=1.500000
	 
	 MeleeDamage=9
	 damageForce=5000
	 KFRagdollName="Stalker_Trip"
	 ZombieDamType(0)=Class'KFMod.DamTypeSlashingAttack'
	 ZombieDamType(1)=Class'KFMod.DamTypeSlashingAttack'
	 ZombieDamType(2)=Class'KFMod.DamTypeSlashingAttack'
	 
	 CrispUpThreshhold=10
	 PuntAnim="ClotPunt"
	 
	 ScoringValue=15
	 SoundGroupClass=Class'KFMod.KFFemaleZombieSounds'
	 IdleHeavyAnim="StalkerIdle"
	 IdleRifleAnim="StalkerIdle"
	 MeleeRange=30.000000
	 GroundSpeed=200.000000
	 WaterSpeed=180.000000
	 
	 // JumpZ
	 JumpZ=350.0
	 JumpSpeed=220.0
	 AirControl=0.25
	 
	 HeadHeight=2.500000
	 MenuName="Stalker"
	 // MeleeAnims
	 MeleeAnims(0)="StalkerSpinAttack"
	 MeleeAnims(1)="StalkerAttack1"
	 MeleeAnims(2)="JumpAttack"
	 // MovementAnims
	 MovementAnims(0)="ZombieRun"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="RunL"
     MovementAnims(3)="RunR"
	 TurnLeftAnim="TurnLeft"
     TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="ZombieRun"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="RunL"
     WalkAnims(3)="RunR"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Fire"
     HeadlessWalkAnims(1)="WalkB_Fire"
     HeadlessWalkAnims(2)="WalkL_Fire"
     HeadlessWalkAnims(3)="WalkR_Fire"
     // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_Fire"
     BurningWalkFAnims(2)="WalkF_Fire"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
	 // IdleAnim
	 IdleCrouchAnim="StalkerIdle"
	 IdleWeaponAnim="StalkerIdle"
	 IdleRestAnim="StalkerIdle"	 
	 
	 SeveredArmAttachScale=0.800000
	 SeveredLegAttachScale=0.700000
	 MotionDetectorThreat=0.250000
	 
	 bKnockDownByDecapitation=True
	 
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=100.0
     Health=100
	 HeadHealth=25.0
	 PlayerCountHealthScale=0.0
	 PlayerNumHeadHealthScale=0.0
	 Mass=140.000000 // lb (ôóíò)
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=7.0,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=2.0,Y=-1.2,Z=0.0),AreaImpactStrength=5.2)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=14.0,AreaHeight=36.0,AreaImpactStrength=7.0)
}
