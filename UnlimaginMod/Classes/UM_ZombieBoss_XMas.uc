//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieBoss_XMas
//	Parent class:	 UM_BaseMonster_Boss
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 13.12.2012 22:27
//================================================================================
class UM_ZombieBoss_XMas extends UM_BaseMonster_Boss;

#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_Xmas.uax
#exec OBJ LOAD FILE=KF_Specimens_Trip_XMAS_T.utx

simulated function CloakBoss()
{
	local Controller C;
	local int Index;

    // No cloaking if zapped
    if( bZapped )
    {
        Return;
    }

	if ( bSpotted )
	{
		Visibility = 120;

		if ( Level.NetMode==NM_DedicatedServer )
		{
			Return;
		}

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		bUnlit = True;

		Return;
	}

	Visibility = 1;
	bCloaked = True;

	if ( Level.NetMode!=NM_Client )
	{
		for ( C=Level.ControllerList; C!=None; C=C.NextController )
		{
			if ( C.bIsPlayer && C.Enemy==Self )
			{
				C.Enemy = None; // Make bots lose sight with me.
			}
		}
	}

	if( Level.NetMode==NM_DedicatedServer )
	{
		Return;
	}

	Skins[1] = Shader'KF_Specimens_Trip_T.patriarch_invisible_gun';
	Skins[0] = Shader'KF_Specimens_Trip_XMAS_T.patriarch_Santa.patriarch_santa_invisible_shdr';

	// Invisible - no shadow
	if(PlayerShadow != None)
	{
		PlayerShadow.bShadowActive = False;
	}

	// Remove/disallow projectors on invisible people
	Projectors.Remove(0, Projectors.Length);
	bAcceptsProjectors = False;
	SetOverlayMaterial(FinalBlend'KF_Specimens_Trip_T.patriarch_fizzle_FB', 1.0, True);

	// Randomly send out a message about Patriarch going invisible(10% chance)
	if ( FRand() < 0.10 )
	{
		// Pick a random Player to say the message
		Index = Rand(Level.Game.NumPlayers);

		for ( C = Level.ControllerList; C != None; C = C.NextController )
		{
			if ( PlayerController(C) != None )
			{
				if ( Index == 0 )
				{
					PlayerController(C).Speech('AUTO', 8, "");
					Break;
				}

				Index--;
			}
		}
	}
}

// Speech notifies called from the anims
function PatriarchKnockDown()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_KnockedDown', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchEntrance()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Entrance', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchVictory()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Victory', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchMGPreFire()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_WarnGun', SLOT_Misc, 2.0,True,1000.0);
}

function PatriarchMisslePreFire()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_WarnRocket', SLOT_Misc, 2.0,True,1000.0);
}

state KnockDown // Knocked
{
	function bool ShouldChargeFromDamage()
	{
		Return False;
	}

Begin:
	if ( Health > 0 )
	{
		Sleep(GetAnimDuration('KnockDown'));
		CloakBoss();
		PlaySound(sound'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_SaveMe', SLOT_Misc, 2.0,,500.0);

		if ( UM_InvasionGame(Level.Game) != None && UM_InvasionGame(Level.Game).FinalSquadNum == SyringeCount )
			UM_InvasionGame(Level.Game).AddBossBuddySquad();
		else if( KFGameType(Level.Game) != None && KFGameType(Level.Game).FinalSquadNum == SyringeCount )
    	   KFGameType(Level.Game).AddBossBuddySquad();

		GotoState('Escaping');
	}
	else
	{
	   GotoState('');
	}
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{//should be derived and used.
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.gatling_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.gatling_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.gatling_D');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.PatGungoInvisible_cmb');

	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.patriarch_Santa.patriarch_Santa_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_XMAS_T.patriarch_Santa_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_XMAS_T.patriarch_Santa_Diff');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_invisible');
	myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_invisible_gun');
    myLevel.AddPrecacheMaterial(Material'KF_Specimens_Trip_T.patriarch_fizzle_FB');
    //myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.Gore.Patriarch_Gore_Limbs_Diff');
    //myLevel.AddPrecacheMaterial(Texture'kf_fx_trip_t.Gore.Patriarch_Gore_Limbs_Spec');
 }

defaultproperties
{
     RocketFireSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_FireRocket'
     MiniGunFireSound=Sound'KF_BasePatriarch_xmas.Attack.Kev_MG_GunfireLoop'
     MiniGunSpinSound=Sound'KF_BasePatriarch_xmas.Attack.Kev_MG_TurbineFireLoop'
     MeleeImpaleHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_HitPlayer_Impale'
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_HitPlayer_Fist'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmPatriarch_XMas'
     DetachedLegClass=Class'KFChar.SeveredLegPatriarch_XMas'
     DetachedHeadClass=Class'KFChar.SeveredHeadPatriarch_XMas'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_Death'
     MenuName="Christmas Patriarch"
     AmbientSound=SoundGroup'KF_EnemiesFinalSnd_Xmas.Patriarch.Kev_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_Xmas.SantaClause_Patriarch'
     Skins(0)=Combiner'KF_Specimens_Trip_XMAS_T.patriarch_Santa.patriarch_Santa_cmb'
     Skins(1)=Combiner'KF_Specimens_Trip_XMAS_T.gatling_cmb'
}
