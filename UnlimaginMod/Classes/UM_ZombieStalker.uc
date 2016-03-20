//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieStalker
//	Parent class:	 UM_BaseMonster_Stalker
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 16:26
//================================================================================
class UM_ZombieStalker extends UM_BaseMonster_Stalker;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KFX.utx
#exec OBJ LOAD FILE=KF_BaseStalker.uax

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

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

	if( MeleeDamage > 1 )
	{
	   UsedMeleeDamage = (MeleeDamage - (MeleeDamage * 0.05)) + (MeleeDamage * (FRand() * 0.1));
	}
	else
	{
	   UsedMeleeDamage = MeleeDamage;
	}

	if(Controller!=none && Controller.Target!=none)
		PushDir = (damageForce * Normal(Controller.Target.Location - Location));
	else 
		PushDir = damageForce * vector(Rotation);
	
	// Melee damage is +/- 10% of default
	if ( MeleeDamageTarget(UsedMeleeDamage, PushDir) )
	{
		KFP = KFPawn(Controller.Target);

		PlaySound(MeleeAttackHitSound, SLOT_Interact, 2.0);

		if( !bDecapitated && KFP != None && FRand() <= GrabChance )
        {
			if ( KFPlayerReplicationInfo(KFP.PlayerReplicationInfo) == none ||
				 KFP.GetVeteran().static.CanBeGrabbed(KFPlayerReplicationInfo(KFP.PlayerReplicationInfo), self))
			{
				if ( DisabledPawn != none )
					DisabledPawn.bMovementDisabled = false;

				KFP.DisableMovement(GrappleDuration);
				DisabledPawn = KFP;
			}
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
	if ( AnimName == MeleeAnims[0] || AnimName == MeleeAnims[1] || AnimName == MeleeAnims[2] )
	{
		AnimBlendParams(1, 1.0, 0.1,, FireRootBone);
		PlayAnim(AnimName,, 0.1, 1);

		// Randomly send out a message about Clot grabbing you(10% chance)
		if ( FRand() < 0.10 && LookTarget != none && KFPlayerController(LookTarget.Controller) != none &&
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

	Return super.DoAnimAction( AnimName );
}

simulated event Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// From CloatBase
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

	if( Level.NetMode != NM_DedicatedServer )
	{
	    if( bZapped )
	    {
	        // Make sure we check if we need to be cloaked as soon as the zap wears off
	        NextCheckTime = Level.TimeSeconds;
	    }
		else if( Level.TimeSeconds > NextCheckTime && Health > 0 )
		{
			NextCheckTime = Level.TimeSeconds + 0.5;

	        if( LocalKFHumanPawn != none && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
	            VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
	        {
				bSpotted = True;
			}
			else
			{
				bSpotted = false;
			}

			if ( !bSpotted && !bCloaked && Skins[0] != Combiner'KF_Specimens_Trip_T.stalker_cmb' )
			{
				UncloakStalker();
			}
			else if ( Level.TimeSeconds - LastUncloakTime > 1.2 )
			{
				// if we're uberbrite, turn down the light
				if( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )
				{
					bUnlit = false;
					CloakStalker();
				}
				else if ( Skins[0] != Shader'KF_Specimens_Trip_T.stalker_invisible' )
				{
					CloakStalker();
				}
			}
		}
	}
}

// Cloak Functions ( called from animation notifies to save Gibby trouble ;) )

simulated function CloakStalker()
{
    // No cloaking if zapped
    if( bZapped )
    {
        return;
    }

	if ( bSpotted )
	{
		if( Level.NetMode == NM_DedicatedServer )
			return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = true;
		return;
	}

	if ( !bDecapitated && !bCrispified ) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	{
		Visibility = 1;
		bCloaked = true;

		if( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Shader'KF_Specimens_Trip_T.stalker_invisible';
		Skins[1] = Shader'KF_Specimens_Trip_T.stalker_invisible';

		// Invisible - no shadow
		if(PlayerShadow != none)
			PlayerShadow.bShadowActive = false;
		if(RealTimeShadow != none)
			RealTimeShadow.Destroy();

		// Remove/disallow projectors on invisible people
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = false;
		SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
	}
}

simulated function UnCloakStalker()
{
    if( bZapped )
    {
        return;
    }

	if( !bCrispified )
	{
		LastUncloakTime = Level.TimeSeconds;

		Visibility = default.Visibility;
		bCloaked = false;
		bUnlit = false;

		if ( UM_InvasionGame(Level.Game) != None )
		{
			// 25% chance of our Enemy saying something about us being invisible
			if( Level.NetMode!=NM_Client && !UM_InvasionGame(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
			 PlayerController(Controller.Enemy.Controller)!=none )
			{
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
				UM_InvasionGame(Level.Game).bDidStalkerInvisibleMessage = true;
			}
		}
		else if ( KFGameType(Level.Game) != None )
		{
			// 25% chance of our Enemy saying something about us being invisible
			if( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=none &&
			 PlayerController(Controller.Enemy.Controller)!=none )
			{
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
				KFGameType(Level.Game).bDidStalkerInvisibleMessage = true;
			}
		}
		
		if( Level.NetMode == NM_DedicatedServer )
			Return;

		if ( Skins[0] != Combiner'KF_Specimens_Trip_T.stalker_cmb' )
		{
			Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
			Skins[0] = Combiner'KF_Specimens_Trip_T.stalker_cmb';

			if (PlayerShadow != none)
				PlayerShadow.bShadowActive = true;

			bAcceptsProjectors = true;

			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, true);
		}
	}
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super.SetZappedBehavior();

    bUnlit = false;

	// Handle setting the zed to uncloaked so the zapped overlay works properly
    if( Level.Netmode != NM_DedicatedServer )
	{
        Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_T.stalker_cmb';

		if (PlayerShadow != none)
			PlayerShadow.bShadowActive = true;

		bAcceptsProjectors = true;
		SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, true);
	}
}

// Turn off the zapped behavior
simulated function UnSetZappedBehavior()
{
    super.UnSetZappedBehavior();

	// Handle getting the zed back cloaked if need be
    if( Level.Netmode != NM_DedicatedServer )
	{
        NextCheckTime = Level.TimeSeconds;
        SetOverlayMaterial(None, 0.0f, true);
	}
}

// Overridden because we need to handle the overlays differently for zombies that can cloak
function SetZapped(float ZapAmount, Pawn Instigator)
{
    LastZapTime = Level.TimeSeconds;

    if( bZapped )
    {
        TotalZap = ZapThreshold;
        RemainingZap = ZapDuration;
    }
    else
    {
        TotalZap += ZapAmount;

        if( TotalZap >= ZapThreshold )
        {
            RemainingZap = ZapDuration;
              bZapped = true;
        }
    }
    ZappedBy = Instigator;
}

function RemoveHead()
{
	Super.RemoveHead();

	if ( DisabledPawn != none )
	{
		DisabledPawn.bMovementDisabled = false;
		DisabledPawn = none;
	}
	
	if (!bCrispified)
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_T.stalker_cmb';
	}
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

    LocalKFHumanPawn = none;

	if (!bCrispified)
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_T.stalker_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_T.stalker_cmb';
	}
}

simulated function Destroyed()
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
	if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
	{
		if ( Role == ROLE_Authority )
		{
			if ( (Level.Game != None) && (Level.Game.GameDifficulty > 2) )
				MakeNoise(0.1 * Level.Game.GameDifficulty);
			if ( bCountJumps && (Inventory != None) )
				Inventory.OwnerEvent('Jumped');
		}
		if ( Physics == PHYS_Spider )
			Velocity = JumpZ * Floor;
		else if ( Physics == PHYS_Ladder )
			Velocity.Z = 0;
		else if ( bIsWalking )
		{
			Velocity.Z = Default.JumpZ;
			Velocity.X = (Default.JumpZ * 0.6);
		}
		else
		{
			Velocity.Z = JumpZ;
			Velocity.X = (JumpZ * 0.6);
		}
		if ( (Base != None) && !Base.bWorldGeometry )
		{
			Velocity.Z += Base.Velocity.Z;
			Velocity.X += Base.Velocity.X;
		}
		SetPhysics(PHYS_Falling);
		return true;
	}
	return false;
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.stalker_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.stalker_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.stalker_diff');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.stalker_spec');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.stalker_invisible');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.StalkerCloakOpacity_cmb');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.StalkerCloakEnv_rot');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.stalker_opacity_osc');
	myLevel.AddPrecacheMaterial(Material'KFCharacters.StalkerSkin');
}

defaultproperties
{
     EventClasses(0)="UnlimaginMod.UM_ZombieStalker"
     EventClasses(1)="UnlimaginMod.UM_ZombieStalker"
     //EventClasses(2)="UnlimaginMod.UM_ZombieStalker_HALLOWEEN"
	 EventClasses(2)="UnlimaginMod.UM_ZombieStalker"
     //EventClasses(3)="UnlimaginMod.UM_ZombieStalker_XMas"
	 EventClasses(3)="UnlimaginMod.UM_ZombieStalker"
     DetachedArmClass=Class'KFChar.SeveredArmStalker'
     DetachedLegClass=Class'KFChar.SeveredLegStalker'
     DetachedHeadClass=Class'KFChar.SeveredHeadStalker'
}
