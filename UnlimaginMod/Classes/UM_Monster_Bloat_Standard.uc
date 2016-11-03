//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Monster_Bloat_Standard
//	Parent class:	 UM_BaseMonster_Bloat
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 15:58
//================================================================================
class UM_Monster_Bloat_Standard extends UM_BaseMonster_Bloat;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{
    Super.PreCacheStaticMeshes(myLevel);
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.limbs.bloat_head');
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	Super.PreCacheMaterials(myLevel);
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.bloat_diffuse');
}

// Overridden so that anims don't get interrupted on the server if one is already playing
function bool IsHeadShot(vector loc, vector ray, float AdditionalScale)
{
	local coords C;
	local vector HeadLoc, B, M, diff;
	local float t, DotMM, Distance;
	local int look;
	local bool bUseAltHeadShotLocation;
	local bool bWasAnimating;

	if ( bDecapitated || HeadBone == '' )
		Return False;

	// If we are a dedicated server estimate what animation is most likely playing on the client
	if ( Level.NetMode == NM_DedicatedServer )  {
		if ( Physics == PHYS_Falling )
			PlayAnim(AirAnims[0], 1.0, 0.0);
		else if ( Physics == PHYS_Walking )  {
			// Only play the idle anim if we're not already doing a different anim.
			// This prevents anims getting interrupted on the server and borking things up - Ramm
			if ( !IsAnimating(0) && !IsAnimating(1) )  {
				if ( bIsCrouched )
					PlayAnim(IdleCrouchAnim, 1.0, 0.0);
				else
					bUseAltHeadShotLocation = True;
			}
			else
				bWasAnimating = True;

			if ( bDoTorsoTwist )  {
				SmoothViewYaw = Rotation.Yaw;
				SmoothViewPitch = ViewPitch;
				look = (256 * ViewPitch) & 65535;
				if ( look > 32768 )
					look -= 65536;
				SetTwistLook(0, look);
			}
		}
		else if ( Physics == PHYS_Swimming )
			PlayAnim(SwimAnims[0], 1.0, 0.0);

		if( !bWasAnimating )
			SetAnimFrame(0.5);
	}

	if ( bUseAltHeadShotLocation )  {
		HeadLoc = Location + (OnlineHeadshotOffset >> Rotation);
		AdditionalScale *= OnlineHeadshotScale;
	}
	else  {
		C = GetBoneCoords('HitPoint_Head');
		HeadLoc = C.Origin;
		//HeadLoc = C.Origin + (HeadHeight * HeadScale * AdditionalScale * C.XAxis);
	}
	
	// Headshot debugging
	if ( Role == ROLE_Authority )
		ServerHeadLocation = HeadLoc;

	// Express snipe trace line in terms of B + tM
	B = loc;
	M = ray * (2.0 * CollisionHeight + 2.0 * CollisionRadius);

	// Find Point-Line Squared Distance
	diff = HeadLoc - B;
	t = M Dot diff;
	if ( t > 0 )  {
		DotMM = M dot M;
		if ( t < DotMM )  {
			t = t / DotMM;
			diff = diff - (t * M);
		}
		else  {
			t = 1;
			diff -= M;
		}
	}
	else
		t = 0;

	Distance = Sqrt(diff Dot diff);

	Return Distance < (HeadRadius * HeadScale * AdditionalScale);
}

defaultproperties
{
     //HeadBone="HitPoint_Head"
	 // DetachedBodyParts
	 DetachedArmClass=Class'KFChar.SeveredArmBloat'
     DetachedLegClass=Class'KFChar.SeveredLegBloat'
     DetachedHeadClass=Class'KFChar.SeveredHeadBloat'
     // ControllerClass
	 ControllerClass=Class'UnlimaginMod.UM_ZombieBloatController'
	 // Mesh
	 Mesh=SkeletalMesh'UM_Bloat_A.UM_Bloat_Mesh'
	 // MeshTestCollision
	 MeshTestCollisionHeight=63.0
	 MeshTestCollisionRadius=25.0
	 // DrawScale
	 DrawScale=1.075000
	 // Collision
	 // CollisionHeight = MeshTestCollisionHeight * DrawScale;
	 // CollisionRadius = MeshTestCollisionRadius * DrawScale;
	 CollisionHeight=67.725
	 CollisionRadius=26.875
	 // EyeHeight
	 // MeshTestEyeHeight=55.0
	 BaseEyeHeight=59.125
	 EyeHeight=59.125
	 // CrouchHeight = MeshTestCollisionHeight / 1.5625 * DrawScale;
	 // CrouchRadius = MeshTestCollisionRadius * DrawScale;
	 CrouchHeight=43.344
	 CrouchRadius=26.875
	 // OnlineHeadshotOffset=(X=5.0,Z=58.0) // old
	 // MeshTestOnlineHeadshotOffset=(X=2.0,Y=0.0,Z=53.0)
	 OnlineHeadshotOffset=(X=2.15,Y=0.0,Z=56.975)
	 OnlineHeadshotScale=1.5
	 // Mass
	 Mass=460.000000
	 // Skins
	 Skins(0)=Combiner'KF_Specimens_Trip_T.bloat_cmb'
	 // Sounds
	 AmbientSound=Sound'KF_BaseBloat.Bloat_Idle1Loop'
	 MoanVoice=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Talk'
	 JumpSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Jump'
	 MeleeAttackHitSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_HitPlayer'
	 HitSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Pain'
	 DeathSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Death'
	 ChallengeSound(0)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(1)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(2)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 ChallengeSound(3)=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_Challenge'
	 DyingSound=Sound'KF_EnemiesFinalSnd.Bloat_DeathPop'
	 // BallisticCollision
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=7.5,AreaHeight=9.5,AreaBone="HitPoint_Head",AreaImpactStrength=7.6)
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=24.0,AreaHeight=53.5,AreaOffset=(X=0.0,Y=0.0,Z=-9.5),AreaImpactStrength=14.6)
}
