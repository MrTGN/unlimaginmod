//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_ZombieStalker_XMas
//	Parent class:	 UM_BaseMonster_Stalker
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 14.12.2012 0:02
//================================================================================
class UM_ZombieStalker_XMas extends UM_BaseMonster_Stalker;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax

simulated event Tick( float DeltaTime )
{
	Super(UM_BaseMonster).Tick( DeltaTime );

	if( Level.NetMode==NM_DedicatedServer )
		Return; // Servers aren't intrested in this info.

    if( bZapped )
    {
        // Make sure we check if we need to be cloaked as soon as the zap wears off
        NextCheckTime = Level.TimeSeconds;
    }
	else if( Level.TimeSeconds > NextCheckTime && Health > 0 )
	{
		NextCheckTime = Level.TimeSeconds + 0.5;

		if( LocalKFHumanPawn != None && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() &&
			VSizeSquared(Location - LocalKFHumanPawn.Location) < LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0 ) // 640000 = 800 Units
		{
			bSpotted = True;
		}
		else
		{
			bSpotted = False;
		}

		if ( !bSpotted && !bCloaked && Skins[0] != Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb' )
		{
			UncloakStalker();
		}
		else if ( Level.TimeSeconds - LastUncloakTime > 1.2 )
		{
			// if we're uberbrite, turn down the light
			if( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )
			{
				bUnlit = False;
				CloakStalker();
			}
			else if ( Skins[0] != Shader'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_invisible' )
			{
				CloakStalker();
			}
		}
	}
}


simulated function CloakStalker()
{
    // No cloaking if zapped
    if( bZapped )
    {
        Return;
    }

	if ( bSpotted )
	{
		if( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = True;
		Return;
	}

	if ( !bDecapitated && !bCrispified ) // No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	{
		Visibility = 1;
		bCloaked = True;

		if( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Shader'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_invisible';
		Skins[1] = Shader'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_invisible';

		// Invisible - no shadow
		if(PlayerShadow != None)
			PlayerShadow.bShadowActive = False;
		if(RealTimeShadow != None)
			RealTimeShadow.Destroy();

		// Remove/disallow projectors on invisible people
		Projectors.Remove(0, Projectors.Length);
		bAcceptsProjectors = False;
		SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, True);
	}
}

simulated function UnCloakStalker()
{
    if( bZapped )
    {
        Return;
    }

	if( !bCrispified )
	{
		LastUncloakTime = Level.TimeSeconds;

		Visibility = default.Visibility;
		bCloaked = False;

		if ( UM_InvasionGame(Level.Game) != None )
		{
			// 25% chance of our Enemy saying something about us being invisible
			if( Level.NetMode!=NM_Client && !UM_InvasionGame(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=None &&
			 PlayerController(Controller.Enemy.Controller)!=None )
			{
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
				UM_InvasionGame(Level.Game).bDidStalkerInvisibleMessage = True;
			}
		}
		else if ( KFGameType(Level.Game) != None )
		{
			// 25% chance of our Enemy saying something about us being invisible
			if( Level.NetMode!=NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage && FRand()<0.25 && Controller.Enemy!=None &&
			 PlayerController(Controller.Enemy.Controller)!=None )
			{
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
				KFGameType(Level.Game).bDidStalkerInvisibleMessage = True;
			}
		}

		if ( Level.NetMode == NM_DedicatedServer )
		{
			Return;
		}

		if ( Skins[0] != Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb' )
		{
			Skins[1] = FinalBlend'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_fb';
			Skins[0] = Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb';

			if ( PlayerShadow != None )
			{
				PlayerShadow.bShadowActive = True;
			}

			bAcceptsProjectors = True;

			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, True);
		}
	}
}

// Set the zed to the zapped behavior
simulated function SetZappedBehavior()
{
    super(KFMonster).SetZappedBehavior();

	bUnlit = False;
	// Handle setting the zed to uncloaked so the zapped overlay works properly
    if( Level.Netmode != NM_DedicatedServer )
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb';

		if (PlayerShadow != None)
			PlayerShadow.bShadowActive = True;

		bAcceptsProjectors = True;
		SetOverlayMaterial(Material'KFZED_FX_T.Energy.ZED_overlay_Hit_Shdr', 999, True);
	}
}

function RemoveHead()
{
	Super.RemoveHead();

	if ( !bCrispified )
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb';
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super.PlayDying(DamageType,HitLoc);

	if ( bUnlit )
	{
		bUnlit=!bUnlit;
	}

	LocalKFHumanPawn = None;

	if ( !bCrispified )
	{
		Skins[1] = FinalBlend'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_fb';
		Skins[0] = Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb';
	}
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.stalkerclause_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.stalker_claus');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.stalkcerclause_ref_cmb');

	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_XMAS_T.stalker_invisible');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.StalkerCloakOpacity_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.StalkerClause_cloakrefract_cmb');
	myLevel.AddPrecacheMaterial(Material'KFCharacters.StalkerSkin');

	//myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.StalkerCloakEnv_rot');
	//myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.stalker_opacity_osc');
	//myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_fb');
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmStalker_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegStalker_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadStalker_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Stalker.Stalker_Challenge'
     MenuName="Christmas Stalker"
     AmbientSound=Sound'KF_BaseStalker.Stalker_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.StalkerClause'
     Skins(0)=Shader'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_invisible'
     Skins(1)=Shader'KF_Specimens_Trip_XMAS_T.StalkerClause.StalkerClause_invisible'
}
