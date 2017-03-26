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

var		float			NextCheckTime, LastUncloakTime;
var		KFHumanPawn		LocalKFHumanPawn;

// From CloatBase
var		KFPawn			DisabledPawn;	// The pawn that has been disabled by this zombie's grapple
var		bool			bGrappling;		// This zombie is grappling someone
var		float			GrappleEndTime;		// When the current grapple should be over
var()	float			GrappleDuration;	// How long a grapple by this zombie should last
var		float			GrabMessageDelay;	// Amount of time between a player saying "I've been grabbed" message
var		float			GrabChance, MinGrabChance, MaxGrabChance;

var(Display) array<Material> 	UnCloakedSkins;

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

simulated event PostBeginPlay()
{
	//Randomizing GrabChance
	GrabChance = default.GrabChance * Lerp( FRand(), MinGrabChance, MaxGrabChance );
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

function ClawDamageTarget()
{
	local vector PushDir;
	local KFPawn KFP;
	local float UsedMeleeDamage;

	if ( MeleeDamage > 1 )
	   UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	else
	   UsedMeleeDamage = MeleeDamage;

	if ( Controller != None && Controller.Target != None )
		PushDir = (damageForce * Normal(Controller.Target.Location - Location));
	else 
		PushDir = damageForce * vector(Rotation);
	
	// Melee damage is +/- 10% of default
	if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )  {
		KFP = KFPawn(Controller.Target);
		PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);
		if ( !bDecapitated && KFP != None && FRand() <= GrabChance && ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo) == None ||
			 KFP.GetVeteran().static.CanBeGrabbed(KFPlayerReplicationInfo(KFP.PlayerReplicationInfo), self)) )  {
			if ( DisabledPawn != None )
				DisabledPawn.bMovementDisabled = False;

			KFP.DisableMovement(GrappleDuration);
			DisabledPawn = KFP;
		}
	}
}

simulated event SetAnimAction(name NewAction)
{
	if ( NewAction == 'Claw' || NewAction == MeleeAnims[0] ||
		 NewAction == MeleeAnims[1] || NewAction == MeleeAnims[2] )
		UncloakStalker();
	
	Super.SetAnimAction(NewAction);
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == MeleeAnims[0] || AnimName == MeleeAnims[1] || AnimName == MeleeAnims[2] )  {
		AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);

		// Randomly send out a message about Clot grabbing you(10% chance)
		if ( FRand() < 0.10 && LookTarget != None && KFPlayerController(LookTarget.Controller) != None &&
			 VSizeSquared(Location - LookTarget.Location) < 2500 /* (MeleeRange + 20)^2 */ &&
			 Level.TimeSeconds - KFPlayerController(LookTarget.Controller).LastClotGrabMessageTime > GrabMessageDelay &&
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

	// From CloatBase
	if ( Role == ROLE_Authority && bGrappling && Level.TimeSeconds > GrappleEndTime )
		bGrappling = False;

	// if we move out of melee range, stop doing the grapple animation
	if ( bGrappling && LookTarget != None && VSize(LookTarget.Location - Location) > (MeleeRange + CollisionRadius + LookTarget.CollisionRadius) )  {
		bGrappling = False;
		AnimEnd(1);
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

function RemoveHead()
{
	Super.RemoveHead();

	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
	
	if ( !bCrispified )
		Skins = UnCloakedSkins;
}

function Died( Controller Killer, class<DamageType> DamageType, vector HitLocation )
{
	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
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
	if ( DisabledPawn != None )  {
		DisabledPawn.bMovementDisabled = False;
		DisabledPawn = None;
	}
	Super.Destroyed();
}

// Give her the ability to spring.
function bool DoJump( bool bUpdating )
{
	if ( !bIsCrouched && !bWantsToCrouch && (Physics == PHYS_Walking || Physics == PHYS_Ladder || Physics == PHYS_Spider) )  {
		if ( Role == ROLE_Authority )  {
			if ( Level.Game != None && Level.Game.GameDifficulty > 2.0 )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && Inventory != None )
				Inventory.OwnerEvent('Jumped');
		}
		
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )  {
			Velocity.Z = Default.JumpZ;
			Velocity.X = (Default.JumpZ * 0.6);
		}
		else  {
			Velocity.Z = JumpZ;
			Velocity.X = (JumpZ * 0.6);
		}
		
		if ( Base != None && !Base.bWorldGeometry )  {
			Velocity.Z += Base.Velocity.Z;
			Velocity.X += Base.Velocity.X;
		}
		SetPhysics(PHYS_Falling);
		
		Return True;
	}
	
	Return False;
}

//[end] Functions
//====================================================================

defaultproperties
{
	 Intelligence=BRAINS_Human
	 
	 MinGrabChance=0.200000
	 MaxGrabChance=0.800000
	 GrappleDuration=1.500000
	 GrabMessageDelay=12.000000
	 MeleeAnims(0)="StalkerSpinAttack"
	 MeleeAnims(1)="StalkerAttack1"
	 MeleeAnims(2)="JumpAttack"
	 
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
	 JumpZ=350.000000
	 HeadHeight=2.500000
	 MenuName="Stalker"
	 MovementAnims(0)="ZombieRun"
	 MovementAnims(1)="ZombieRun"
	 MovementAnims(2)="ZombieRun"
	 MovementAnims(3)="ZombieRun"
	 WalkAnims(0)="ZombieRun"
	 WalkAnims(1)="ZombieRun"
	 WalkAnims(2)="ZombieRun"
	 WalkAnims(3)="ZombieRun"
	 IdleCrouchAnim="StalkerIdle"
	 IdleWeaponAnim="StalkerIdle"
	 IdleRestAnim="StalkerIdle"	 
	 
	 SeveredArmAttachScale=0.800000
	 SeveredLegAttachScale=0.700000
	 MotionDetectorThreat=0.250000
	 
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
