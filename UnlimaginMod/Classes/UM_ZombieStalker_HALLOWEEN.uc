//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieStalker_HALLOWEEN
//	Parent class:	 UM_BaseMonster_Stalker
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 1:08
//================================================================================
class UM_ZombieStalker_HALLOWEEN extends UM_BaseMonster_Stalker;


#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax
#exec OBJ LOAD FILE=KF_Specimens_Trip_HALLOWEEN_T.utx

simulated event Tick( float DeltaTime )
{
	Super(UM_BaseMonster).Tick( DeltaTime );
	
	if ( Level.NetMode == NM_DedicatedServer )
		Return; // Servers aren't intrested in this info.

	// Make sure we check if we need to be cloaked as soon as the zap wears off
	if ( bZapped )
		NextCheckTime = Level.TimeSeconds;
	else if ( Level.TimeSeconds > NextCheckTime && Health > 0 )  {
		NextCheckTime = Level.TimeSeconds + 0.5;
        if ( LocalKFHumanPawn != None && LocalKFHumanPawn.Health > 0 && LocalKFHumanPawn.ShowStalkers() 
			 && VSizeSquared(Location - LocalKFHumanPawn.Location) < (LocalKFHumanPawn.GetStalkerViewDistanceMulti() * 640000.0) ) // 640000 = 800 Units
			bSpotted = True;
		else
			bSpotted = False;

		if ( !bSpotted && !bCloaked && Skins[0] != Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB' )
			UncloakStalker();
		else if ( (Level.TimeSeconds - LastUncloakTime) > 1.2 )  {
			// if we're uberbrite, turn down the light
			if ( bSpotted && Skins[0] != Finalblend'KFX.StalkerGlow' )  {
				bUnlit = False;
				CloakStalker();
			}
            else if ( Skins[0] != Shader'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_Redneck_Invisible' )
				CloakStalker();
		}
	}
}


simulated function CloakStalker()
{
	if ( bSpotted )  {
		if( Level.NetMode == NM_DedicatedServer )
			Return;

		Skins[0] = Finalblend'KFX.StalkerGlow';
		Skins[1] = Finalblend'KFX.StalkerGlow';
		Skins[2] = Finalblend'KFX.StalkerGlow';
		bUnlit = True;
		
		Return;
	}

	// No head, no cloak, honey.  updated :  Being charred means no cloak either :D
	if ( !bDecapitated && !bCrispified )  {
		Visibility = 1;
		bCloaked = True;

		if ( Level.NetMode == NM_DedicatedServer )
			Return;
			
		Skins[0] = Shader'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_Redneck_Invisible';
		Skins[1] = Shader'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_Redneck_Invisible';
		
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
	if ( !bCrispified )  {
		LastUncloakTime = Level.TimeSeconds;
		Visibility = default.Visibility;
		bCloaked = False;

		// 25% chance of our Enemy saying something about us being invisible
		if ( KFGameType(Level.Game) != None && Level.NetMode != NM_Client && !KFGameType(Level.Game).bDidStalkerInvisibleMessage 
			 && FRand() < 0.25 && Controller.Enemy != None && PlayerController(Controller.Enemy.Controller) != None )  {
				PlayerController(Controller.Enemy.Controller).Speech('AUTO', 17, "");
				KFGameType(Level.Game).bDidStalkerInvisibleMessage = True;
		}
		
		if ( Level.NetMode == NM_DedicatedServer )
			Return;

		if ( Skins[0] != Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB' )  {
			Skins[0] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';
            Skins[1] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';

			if ( PlayerShadow != None )
				PlayerShadow.bShadowActive = True;

			bAcceptsProjectors = True;
			SetOverlayMaterial(Material'KFX.FBDecloakShader', 0.25, True);
		}
	}
}

function RemoveHead()
{
	Super.RemoveHead();

	if ( !bCrispified )  {
		Skins[0] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';
		Skins[1] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';
	}
}

simulated function PlayDying(class<DamageType> DamageType, vector HitLoc)
{
	Super(UM_BaseMonster).PlayDying(DamageType,HitLoc);

	if ( bUnlit )
		bUnlit = !bUnlit;

    LocalKFHumanPawn = None;
	if ( !bCrispified )  {
		Skins[0] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';
		Skins[1] = Combiner'KF_Specimens_Trip_HALLOWEEN_T.stalker.stalker_RedneckZombie_CMB';
	}
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_Talk'
     MoanVolume=1.000000
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_Jump'
     DetachedArmClass=Class'KFChar.SeveredArmStalker_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegStalker_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadStalker_HALLOWEEN'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Stalker.Stalker_Challenge'
     GruntVolume=0.250000
     MenuName="HALLOWEEN Stalker"
     Mesh=SkeletalMesh'KF_Freaks_Trip_HALLOWEEN.Stalker_Halloween'
     Skins(0)=Shader'KF_Specimens_Trip_HALLOWEEN_T.Stalker.stalker_Redneck_invisible'
     Skins(1)=Shader'KF_Specimens_Trip_HALLOWEEN_T.Stalker.stalker_Redneck_invisible'
     TransientSoundVolume=0.600000
}
