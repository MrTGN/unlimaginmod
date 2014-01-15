//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ZombieBloat
//	Parent class:	 UM_ZombieBloatBase
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 06.10.2012 15:58
//================================================================================
class UM_ZombieBloat extends UM_ZombieBloatBase;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

//----------------------------------------------------------------------------
// NOTE: All Variables are declared in the base class to eliminate hitching
//----------------------------------------------------------------------------

var class<FleshHitEmitter> BileExplosion;
var class<FleshHitEmitter> BileExplosionHeadless;

function bool FlipOver()
{
	Return False;
}

// don't interrupt the bloat while he is puking
simulated function bool HitCanInterruptAction()
{
	if ( bShotAnim )
		Return False;

    Return True;
}


function DoorAttack(Actor A)
{
	if ( bShotAnim || Physics == PHYS_Swimming )
		Return;
	else if ( A != None )  {
		bShotAnim = True;
		if ( !bDecapitated && bDistanceAttackingDoor )
			SetAnimAction('ZombieBarf');
		else  {
			SetAnimAction('DoorBash');
			GotoState('DoorBashing');
		}
	}
}

function RangedAttack(Actor A)
{
	local int LastFireTime;
    local float ChargeChance;

	if ( bShotAnim )
		Return;

	if ( Physics == PHYS_Swimming )  {
		SetAnimAction(MeleeAnims[Rand(3)]);
		bShotAnim = True;
		LastFireTime = Level.TimeSeconds;
	}
	else if ( VSize(A.Location - Location) < (MeleeRange + CollisionRadius + A.CollisionRadius) )  {
		bShotAnim = True;
		LastFireTime = Level.TimeSeconds;
		SetAnimAction(MeleeAnims[Rand(3)]);
		//PlaySound(sound'Claw2s', SLOT_Interact); KFTODO: Replace this
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
	}
	else if ( (KFDoorMover(A) != None || VSize(A.Location-Location) <= 250) && !bDecapitated )  {
		bShotAnim = True;

        // Decide what chance the bloat has of charging during a puke attack
        if( Level.Game.GameDifficulty < 2.0 )
			ChargeChance = 0.2;
		else if( Level.Game.GameDifficulty < 4.0 )
			ChargeChance = 0.4;
        else if( Level.Game.GameDifficulty < 5.0 )
			ChargeChance = 0.6;
		else // Hardest difficulty
			ChargeChance = 0.8;

		// Randomly do a moving attack so the player can't kite the zed
        if ( FRand() < ChargeChance )  {
    		SetAnimAction('ZombieBarfMoving');
    		RunAttackTimeout = GetAnimDuration('ZombieBarf', 1.0);
    		bMovingPukeAttack=true;
		}
		else  {
    		SetAnimAction('ZombieBarf');
    		Controller.bPreparingMove = true;
    		Acceleration = vect(0,0,0);
		}

		// Randomly send out a message about Bloat Vomit burning(3% chance)
		if ( FRand() < 0.03 && KFHumanPawn(A) != none && PlayerController(KFHumanPawn(A).Controller) != none )
			PlayerController(KFHumanPawn(A).Controller).Speech('AUTO', 7, "");
	}
}

// Overridden to handle playing upper body only attacks when moving
simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;
	local bool bWantsToAttackAndMove;

	if ( NewAction == '' )
		Return;

	if ( NewAction == 'ZombieBarfMoving' )
		bWantsToAttackAndMove = True;
	else
		bWantsToAttackAndMove = False;

	if ( NewAction == 'DoorBash' )
		CurrentDamtype = ZombieDamType[Rand(3)];
	else  {
		for ( meleeAnimIndex = 0; meleeAnimIndex < 2; meleeAnimIndex++ )  {
			if ( NewAction == MeleeAnims[meleeAnimIndex] )  {
				CurrentDamtype = ZombieDamType[meleeAnimIndex];
				Break;
			}
		}
	}

	if ( bWantsToAttackAndMove )
		ExpectingChannel = AttackAndMoveDoAnimAction(NewAction);
	else
		ExpectingChannel = DoAnimAction(NewAction);

	if ( !bWantsToAttackAndMove && AnimNeedsWait(NewAction) )
		bWaitForAnim = True;
    else
		bWaitForAnim = false;

	if ( Level.NetMode != NM_Client )  {
		AnimAction = NewAction;
		bResetAnimAct = True;
		ResetAnimActTime = Level.TimeSeconds + 0.3;
	}
}

// Handle playing the anim action on the upper body only if we're attacking and moving
simulated function int AttackAndMoveDoAnimAction( name AnimName )
{
    if( AnimName=='ZombieBarfMoving' )  {
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim('ZombieBarf',, 0.1, 1);

		Return 1;
	}
	else
		Return Super.DoAnimAction( AnimName );
}


function PlayDyingSound()
{
	if ( Level.NetMode != NM_Client )  {
    	if ( bGibbed )  {
    		PlaySound(sound'KF_EnemiesFinalSnd.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
    		Return;
    	}

        if( bDecapitated )
            PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,true,525);
    	else
            PlaySound(sound'KF_EnemiesFinalSnd.Bloat_DeathPop', SLOT_Pain,2.0,true,525);
	}
}



// Barf Time.

function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;

	if ( Controller != None && KFDoorMover(Controller.Target) != None )  {
		Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
		Return;
	}

	GetAxes(Rotation,X,Y,Z);
	FireStart = Location + (vect(30,0,64) >> Rotation) * DrawScale;
	if ( !SavedFireProperties.bInitialized )  {
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = Class'KFBloatVomit';
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 500;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = False;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = True;
		SavedFireProperties.bInitialized = True;
	}

    // Turn off extra collision before spawning vomit, otherwise spawn fails
    ToggleAuxCollision(false);
	// Fix By Tsiryuta G. N. for prevent Accessed None 'Controller'
	if ( Controller != None )
		FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	else
		FireRotation = Rotation;
	Spawn(Class'KFBloatVomit',,,FireStart,FireRotation);

	FireStart-=(0.5*CollisionRadius*Y);
	FireRotation.Yaw -= 1200;
	spawn(Class'KFBloatVomit',,,FireStart, FireRotation);

	FireStart+=(CollisionRadius*Y);
	FireRotation.Yaw += 2400;
	spawn(Class'KFBloatVomit',,,FireStart, FireRotation);
	// Turn extra collision back on
	ToggleAuxCollision(true);
}


simulated function Tick(float deltatime)
{
    local Vector BileExplosionLoc;
    local FleshHitEmitter GibBileExplosion;

    Super.tick(deltatime);

    if ( Role == ROLE_Authority && bMovingPukeAttack )  {
		// Keep moving toward the target until the timer runs out (anim finishes)
        if ( RunAttackTimeout > 0 )  {
            RunAttackTimeout -= DeltaTime;
            if ( RunAttackTimeout <= 0 )  {
                RunAttackTimeout = 0;
                bMovingPukeAttack = False;
            }
		}
        // Keep the gorefast moving toward its target when attacking
    	if ( bShotAnim && !bWaitForAnim && LookTarget != None )
   		    Acceleration = AccelRate * Normal(LookTarget.Location - Location);
    }

    // Hack to force animation updates on the server for the bloat if he is relevant to someone
    // He has glitches when some of his animations don't play on the server. If we
    // find some other fix for the glitches take this out - Ramm
    if ( Level.NetMode != NM_Client && Level.NetMode != NM_Standalone )  {
        if ( (Level.TimeSeconds-LastSeenOrRelevantTime) < 1.0  )
            bForceSkelUpdate = True;
        else
            bForceSkelUpdate = False;
    }

    if ( Level.NetMode!=NM_DedicatedServer && /*Gored>0*/Health <= 0 && !bPlayBileSplash &&
        HitDamageType != class'DamTypeBleedOut' )  {
        if ( !class'GameInfo'.static.UseLowGore() )  {
			BileExplosionLoc = Location;
			BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));
			if ( bDecapitated )
				GibBileExplosion = Spawn(BileExplosionHeadless,self,, BileExplosionLoc );
			else
				GibBileExplosion = Spawn(BileExplosion,self,, BileExplosionLoc );
			bPlayBileSplash = True;
	    }
	    else  {
			BileExplosionLoc = Location;
			BileExplosionLoc.z += (CollisionHeight - (CollisionHeight * 0.5));
			GibBileExplosion = Spawn(class 'LowGoreBileExplosion',self,, BileExplosionLoc );
			bPlayBileSplash = True;
		}
    }
}

function BileBomb()
{
	BloatJet = spawn(class'BileJet', self,,Location,Rotator(-PhysicsVolume.Gravity));
}

function PlayDyingAnimation(class<DamageType> DamageType, vector HitLoc)
{
//    local bool AttachSucess;

    Super.PlayDyingAnimation(DamageType, HitLoc);

    // Don't blow up with bleed out
    if ( bDecapitated && DamageType == class'DamTypeBleedOut' )
        Return;

    if ( !class'GameInfo'.static.UseLowGore() )
		HideBone(SpineBone2);

    if ( Role == ROLE_Authority )  {
        BileBomb();

//    if(BloatJet!=none)
//    {
//    if(Gored < 5)
//    AttachSucess=AttachToBone(BloatJet,FireRootBone);
//    // else
//    // AttachSucess=AttachToBone(BloatJet,SpineBone1);
//
//    if(!AttachSucess)
//    {
//    log("DEAD Bloaty Bile didn't like the Boning :o");
//    BloatJet.SetBase(self);
//    }
//    BloatJet.SetRelativeRotation(rot(0,-4096,0));
//    }
    }
}

simulated function HideBone(name boneName)
{
	local int BoneScaleSlot;
	local coords boneCoords;
	local bool bValidBoneToHide;

   	if ( boneName == LeftThighBone )  {
		boneScaleSlot = 0;
		bValidBoneToHide = True;
		if ( SeveredLeftLeg == None )  {
			SeveredLeftLeg = Spawn(SeveredLegAttachClass,self);
			SeveredLeftLeg.SetDrawScale(SeveredLegAttachScale);
			boneCoords = GetBoneCoords( 'lleg' );
			AttachEmitterEffect( LimbSpurtEmitterClass, 'lleg', boneCoords.Origin, rot(0,0,0) );
			AttachToBone(SeveredLeftLeg, 'lleg');
		}
	}
	else if ( boneName == RightThighBone )  {
		boneScaleSlot = 1;
		bValidBoneToHide = True;
		if ( SeveredRightLeg == None )  {
			SeveredRightLeg = Spawn(SeveredLegAttachClass,self);
			SeveredRightLeg.SetDrawScale(SeveredLegAttachScale);
			boneCoords = GetBoneCoords( 'rleg' );
			AttachEmitterEffect( LimbSpurtEmitterClass, 'rleg', boneCoords.Origin, rot(0,0,0) );
			AttachToBone(SeveredRightLeg, 'rleg');
		}
	}
	else if ( boneName == RightFArmBone )  {
		boneScaleSlot = 2;
		bValidBoneToHide = True;
		if ( SeveredRightArm == None )  {
			SeveredRightArm = Spawn(SeveredArmAttachClass,self);
			SeveredRightArm.SetDrawScale(SeveredArmAttachScale);
			boneCoords = GetBoneCoords( 'rarm' );
			AttachEmitterEffect( LimbSpurtEmitterClass, 'rarm', boneCoords.Origin, rot(0,0,0) );
			AttachToBone(SeveredRightArm, 'rarm');
		}
	}
	else if ( boneName == LeftFArmBone )  {
		boneScaleSlot = 3;
		bValidBoneToHide = True;
		if ( SeveredLeftArm == None )  {
			SeveredLeftArm = Spawn(SeveredArmAttachClass,self);
			SeveredLeftArm.SetDrawScale(SeveredArmAttachScale);
			boneCoords = GetBoneCoords( 'larm' );
			AttachEmitterEffect( LimbSpurtEmitterClass, 'larm', boneCoords.Origin, rot(0,0,0) );
			AttachToBone(SeveredLeftArm, 'larm');
		}
	}
	else if ( boneName == HeadBone )  {
    	// Only scale the bone down once
        if ( SeveredHead == None ) {
            bValidBoneToHide = True;
            boneScaleSlot = 4;
            SeveredHead = Spawn(SeveredHeadAttachClass,self);
			SeveredHead.SetDrawScale(SeveredHeadAttachScale);
			boneCoords = GetBoneCoords( 'neck' );
			AttachEmitterEffect( NeckSpurtEmitterClass, 'neck', boneCoords.Origin, rot(0,0,0) );
			AttachToBone(SeveredHead, 'neck');
		}
		else
            Return;
	}
	else if ( boneName == 'spine' )  {
	    bValidBoneToHide = True;
    	boneScaleSlot = 5;
	}
	else if ( boneName == SpineBone2 )  {
	    bValidBoneToHide = True;
    	boneScaleSlot = 6;
    }

    // Only hide the bone if it is one of the arms, legs, or head, don't hide other misc bones
    if( bValidBoneToHide )
        SetBoneScale(BoneScaleSlot, 0.0, BoneName);
}


State Dying
{
	event Tick(float deltaTime)
	{
		if ( BloatJet != None )  {
			BloatJet.SetLocation(location);
			BloatJet.SetRotation(GetBoneRotation(FireRootBone));
		}
		Super.Tick(deltaTime);
	}
}

function RemoveHead()
{
	bCanDistanceAttackDoors = False;
	Super.RemoveHead();
}

function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
{
	// Bloats are volatile. They burn faster than other zeds.
	if ( damageType == class 'DamTypeBurned' )
		Damage *= 1.5;
	else if( damageType == Class'DamTypeVomit' )
		Return;
	else if ( damageType == class 'DamTypeBlowerThrower' )
		Damage *= 0.25;	// Reduced damage from the blower thrower bile, but lets not zero it out entirely
	
	Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType, HitIndex);
}

simulated function ProcessHitFX()
{
    local Coords boneCoords;
	local class<xEmitter> HitEffects[4];
	local int i,j;
    local float GibPerterbation;

    if ( Level.NetMode == NM_DedicatedServer || bSkeletized || Mesh == SkeletonMesh )  {
		SimHitFxTicker = HitFxTicker;
        Return;
    }

    for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )
    {
		j++;
		if ( j > 30 )  {
			SimHitFxTicker = HitFxTicker;
			Return;
		}

        if ( HitFX[SimHitFxTicker].damtype == None 
			 || (Level.bDropDetail && (Level.TimeSeconds - LastRenderTime) > 3 && !IsHumanControlled()) )
            Continue;

		//log("Processing effects for damtype "$HitFX[SimHitFxTicker].damtype);

		if ( HitFX[SimHitFxTicker].bone == 'obliterate' && !class'GameInfo'.static.UseLowGore() )  {
			SpawnGibs( HitFX[SimHitFxTicker].rotDir, 1);
			bGibbed = True;
			// Wait a tick on a listen server so the obliteration can replicate before the pawn is destroyed
            if ( Level.NetMode == NM_ListenServer )  {
                bDestroyNextTick = True;
                TimeSetDestroyNextTickTime = Level.TimeSeconds;
            }
            else
                Destroy();
			
			Return;
		}

        boneCoords = GetBoneCoords( HitFX[SimHitFxTicker].bone );

        if ( !Level.bDropDetail && !class'GameInfo'.static.NoBlood() 
			 && !bSkeletized && !class'GameInfo'.static.UseLowGore() )  {
            //AttachEmitterEffect( BleedingEmitterClass, HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
			HitFX[SimHitFxTicker].damtype.static.GetHitEffects( HitEffects, Health );
			// don't attach effects under water
			if ( !PhysicsVolume.bWaterVolume )  {
				for( i = 0; i < ArrayCount(HitEffects); i++ )  {
					if ( HitEffects[i] == None )
						Continue;
					AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
				}
			}
		}

		if ( class'GameInfo'.static.UseLowGore() )  {
			HitFX[SimHitFxTicker].bSever = False;
			switch( HitFX[SimHitFxTicker].bone )
            {
                 case 'head':
                    if( !bHeadGibbed )  {
                        if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
                            DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false, true);
                        else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
                            DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, true);

                      	bHeadGibbed = True;
                  	}
                    Break;
			}
			Return;
		}

        if( HitFX[SimHitFxTicker].bSever )  {
            GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;
            switch( HitFX[SimHitFxTicker].bone )
            {
                case 'obliterate':
                    break;

                case LeftThighBone:
                	if( !bLeftLegGibbed )
					{
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftLegGibbed=true;
                    }
                    break;

                case RightThighBone:
                	if( !bRightLegGibbed )
					{
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightLegGibbed=true;
                    }
                    break;

                case LeftFArmBone:
                	if( !bLeftArmGibbed )
					{
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftArmGibbed=true;
                    }
                    break;

                case RightFArmBone:
                	if( !bRightArmGibbed )
					{
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightArmGibbed=true;
                    }
                    break;

                case 'head':
                    if( !bHeadGibbed )  {
                        if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
                            DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, false, true);
                        else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
                            DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, true);

                      	bHeadGibbed = True;
                  	}
                    break;
            }

            // Don't do this right now until we get the effects sorted - Ramm
			if ( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone 
				 && HitFX[SimHitFXTicker].bone != LeftFArmBone && HitFX[SimHitFXTicker].bone != RightFArmBone 
				 && HitFX[SimHitFXTicker].bone != 'head' && Health <= 0 )
				HideBone(HitFX[SimHitFxTicker].bone);
        }
    }
}
static simulated function PreCacheStaticMeshes(LevelInfo myLevel)
{//should be derived and used.
    Super.PreCacheStaticMeshes(myLevel);
	myLevel.AddPrecacheStaticMesh(StaticMesh'kf_gore_trip_sm.limbs.bloat_head');
}

static simulated function PreCacheMaterials(LevelInfo myLevel)
{
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_cmb');
	myLevel.AddPrecacheMaterial(Combiner'KF_Specimens_Trip_T.bloat_env_cmb');
	myLevel.AddPrecacheMaterial(Texture'KF_Specimens_Trip_T.bloat_diffuse');
}

defaultproperties
{
     BileExplosion=Class'KFMod.BileExplosion'
     BileExplosionHeadless=Class'KFMod.BileExplosionHeadless'
     EventClasses(0)="UnlimaginMod.UM_ZombieBloat"
     EventClasses(1)="UnlimaginMod.UM_ZombieBloat"
     EventClasses(2)="UnlimaginMod.UM_ZombieBloat_HALLOWEEN"
     EventClasses(3)="UnlimaginMod.UM_ZombieBloat_XMas"
     DetachedArmClass=Class'KFChar.SeveredArmBloat'
     DetachedLegClass=Class'KFChar.SeveredLegBloat'
     DetachedHeadClass=Class'KFChar.SeveredHeadBloat'
     ControllerClass=Class'UnlimaginMod.UM_ZombieBloatController'
}
