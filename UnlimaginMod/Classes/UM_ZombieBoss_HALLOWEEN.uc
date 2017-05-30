//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_ZombieBoss_HALLOWEEN
//	Parent class:	 UM_BaseMonster_Boss
//������������������������������������������������������������������������������
//	Copyright:		 � 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 24.10.2012 1:13
//================================================================================
class UM_ZombieBoss_HALLOWEEN extends UM_BaseMonster_Boss;


#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

simulated function CloakBoss()
{
	local Controller C;
	local int Index;

	// No cloaking if zapped
    if ( bZapped )
        Return;
	
	if ( bSpotted )  {
		Visibility = 120;
		if ( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		Skins[2] = Finalblend'KFX.StalkerGlow';
		bUnlit = True;

		Return;
	}

	Visibility = 1;
	bCloaked = True;

	if ( Level.NetMode != NM_Client )  {
		for ( C=Level.ControllerList; C!=None; C=C.NextController )  {
			if ( C.bIsPlayer && C.Enemy==Self )
				C.Enemy = None; // Make bots lose sight with me.
		}
	}

	if ( Level.NetMode == NM_DedicatedServer )
		Return;

    Skins[1] = Shader'KF_Specimens_Trip_HALLOWEEN_T.Patriarch.Patriarch_Halloween_Invisible';
	Skins[0] = Shader'KF_Specimens_Trip_T.patriarch_invisible_gun';

	// Invisible - no shadow
	if ( PlayerShadow != None )
		PlayerShadow.bShadowActive = False;

	// Remove/disallow projectors on invisible people
	Projectors.Remove(0, Projectors.Length);
	bAcceptsProjectors = False;
	SetOverlayMaterial(FinalBlend'KF_Specimens_Trip_T.patriarch_fizzle_FB', 1.0, True);

	// Randomly send out a message about Patriarch going invisible(10% chance)
	if ( FRand() < 0.10 )  {
		// Pick a random Player to say the message
		Index = Rand(Level.Game.NumPlayers);
		for ( C = Level.ControllerList; C != None; C = C.NextController )  {
			if ( PlayerController(C) != None )  {
				if ( Index == 0 )  {
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
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_KnockedDown', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchEntrance()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Entrance', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchVictory()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Victory', SLOT_Misc, 2.0,True,500.0);
}

function PatriarchMGPreFire()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_WarnGun', SLOT_Misc, 2.0,True,1000.0);
}

function PatriarchMisslePreFire()
{
	PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_WarnRocket', SLOT_Misc, 2.0,True,1000.0);
}

// Taunt to use when doing the melee exploit radial attack
function PatriarchRadialTaunt()
{
    if ( NumNinjas > 0 && NumNinjas > NumLumberJacks )
        PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_TauntNinja', SLOT_Misc, 2.0,True,500.0);
    else if ( NumLumberJacks > 0 && NumLumberJacks > NumNinjas )
        PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_TauntLumberJack', SLOT_Misc, 2.0,True,500.0);
    else
        PlaySound(SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_TauntRadial', SLOT_Misc, 2.0,True,500.0);
}

state KnockDown // Knocked
{
	function bool ShouldChargeFromDamage()
	{
		Return False;
	}

Begin:
	if ( Health > 0 )  {
		Sleep(GetAnimDuration('KnockDown'));
		CloakBoss();
		PlaySound(sound'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_SaveMe', SLOT_Misc, 2.0,,500.0);

		if ( UM_InvasionGame(Level.Game) != None && UM_InvasionGame(Level.Game).FinalSquadNum == SyringeCount )
			UM_InvasionGame(Level.Game).AddBossBuddySquad();
		else if( KFGameType(Level.Game) != None && KFGameType(Level.Game).FinalSquadNum == SyringeCount )
    	   KFGameType(Level.Game).AddBossBuddySquad();

		GotoState('Escaping');
	}
	else
	   GotoState('');
}

defaultproperties
{
     RocketFireSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_FireRocket'
     MiniGunFireSound=Sound'KF_BasePatriarch.Attack.Kev_MG_GunfireLoop'
     MiniGunSpinSound=Sound'KF_BasePatriarch.Attack.Kev_MG_TurbineFireLoop'
     MeleeImpaleHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_HitPlayer_Impale'
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_HitPlayer_Fist'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmPatriarch_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegPatriarch_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadPatriarch_HALLOWEEN'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Patriarch.Kev_Death'
     MenuName="HALLOWEEN Patriarch"
     AmbientSound=Sound'KF_BasePatriarch_HALLOWEEN.Kev_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Patriarch_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_T.gatling_cmb'
     Skins(1)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Patriarch.Patriarch_RedneckZombie_CMB'
}
