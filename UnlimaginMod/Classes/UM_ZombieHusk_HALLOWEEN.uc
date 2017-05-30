//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieHusk_HALLOWEEN
//	Parent class:	 UM_BaseMonster_FireBallHusk
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.10.2012 1:17
//================================================================================
class UM_ZombieHusk_HALLOWEEN extends UM_BaseMonster_FireBallHusk;


#exec OBJ LOAD FILE=KF_EnemiesFinalSnd_HALLOWEEN.uax

function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local UM_MonsterController UM_KFMonstControl;

	if ( Controller != None && KFDoorMover(Controller.Target) != None )  {
		Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
		Return;
	}

	GetAxes(Rotation,X,Y,Z);
	FireStart = GetBoneCoords('Barrel').Origin;
	if ( !SavedFireProperties.bInitialized )  {
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = Class'HuskFireProjectile_HALLOWEEN';
		//SavedFireProperties.ProjectileClass = Class'HuskFireProjectile';
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 65535;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = True;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = False;
		SavedFireProperties.bInitialized = True;
	}

    // Turn off extra collision before spawning vomit, otherwise spawn fails
    ToggleAuxCollision(False);
	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	foreach DynamicActors(class'UM_MonsterController', UM_KFMonstControl)
	{
        if( UM_KFMonstControl != Controller && PointDistToLine(UM_KFMonstControl.Pawn.Location, vector(FireRotation), FireStart) < 75 )
			UM_KFMonstControl.GetOutOfTheWayOfShot(vector(FireRotation),FireStart);
	}

    //Spawn(Class'HuskFireProjectile_HALLOWEEN',,,FireStart,FireRotation);
	Spawn(Class'HuskFireProjectile',,,FireStart,FireRotation);

	// Turn extra collision back on
	ToggleAuxCollision(True);
}

defaultproperties
{
     MoanVoice=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Husk.Husk_Talk'
     MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Bloat.Bloat_HitPlayer'
     JumpSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Husk.Husk_Jump'
     ProjectileBloodSplatClass=None
     DetachedArmClass=Class'KFChar.SeveredArmHusk_HALLOWEEN'
     DetachedLegClass=Class'KFChar.SeveredLegHusk_HALLOWEEN'
     DetachedHeadClass=Class'KFChar.SeveredHeadHusk_HALLOWEEN'
     DetachedSpecialArmClass=Class'KFChar.SeveredArmHuskGun_HALLOWEEN'
     PainSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Husk.Husk_Pain'
     DyingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Husk.Husk_Death'
     ChallengingSound=SoundGroup'KF_EnemiesFinalSnd_HALLOWEEN.Husk.Husk_Challenge'
     MenuName="HALLOWEEN Husk"
     AmbientSound=Sound'KF_BaseHusk_HALLOWEEN.Husk_IdleLoop'
     Mesh=SkeletalMesh'KF_Freaks2_Trip_HALLOWEEN.Husk_Halloween'
     Skins(0)=Combiner'KF_Specimens_Trip_HALLOWEEN_T.Husk.husk_RedneckZombie_CMB'
}
