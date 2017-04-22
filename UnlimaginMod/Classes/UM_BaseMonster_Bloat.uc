//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Bloat
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 22:54
//================================================================================
class UM_BaseMonster_Bloat extends UM_BaseMonster
	Abstract;

#exec OBJ LOAD FILE=KFPlayerSound.uax
#exec OBJ LOAD FILE=KF_EnemiesFinalSnd.uax

//========================================================================
//[block] Variables

var		BileJet		BloatJet;
var		bool		bPlayBileSplash;
var		bool		bMovingPukeAttack;
var		float		RunAttackTimeout;
var		sound		DyingSound;

var	class<FleshHitEmitter>	BileExplosion;
var	class<FleshHitEmitter>	BileExplosionHeadless;
var	Class<Projectile>		BileProjectileClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

// don't interrupt the bloat while he is puking
simulated function bool HitCanInterruptAction()
{
	Return !bShotAnim;
}

state DoorBashing
{
	Begin:
	bShotAnim = True;
	if ( !bDecapitated && bDistanceAttackingDoor )
		SetAnimAction('ZombieBarf');
	else
		SetAnimAction('DoorBash');
	FinishAnim(ExpectingChannel);
	Sleep(0.1);
	GoToState('');
}

function RangedAttack(Actor A)
{
	local	float	ChargeChance;

	if ( bShotAnim || Physics == PHYS_Swimming )
		Return;

	// if in melee range
	if ( VSizeSquared(A.Location - Location) <= Square(MeleeRange + CollisionRadius + A.CollisionRadius) )  {
		bShotAnim = True;
		SetAnimAction('Claw');
		//PlaySound(sound'Claw2s', SLOT_Interact); KFTODO: Replace this
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
	}
	else if ( !bDecapitated && (KFDoorMover(A) != None || VSizeSquared(A.Location - Location) <= 62500.0) )  {
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
		if ( FRand() <= ChargeChance )  {
			SetAnimAction('ZombieBarfMoving');
			RunAttackTimeout = GetAnimDuration('ZombieBarf', 1.0);
			bMovingPukeAttack = True;
		}
		else  {
			SetAnimAction('ZombieBarf');
			Controller.bPreparingMove = True;
			Acceleration = vect(0,0,0);
		}

		// Randomly send out a message about Bloat Vomit burning(3% chance)
		if ( FRand() < 0.03 && KFHumanPawn(A) != None && PlayerController(KFHumanPawn(A).Controller) != None )
			PlayerController(KFHumanPawn(A).Controller).Speech('AUTO', 7, "");
	}
}

/*ToDo: #Âàæíî!!! ïåðåõîä â íîâûé state âñåãäà ëîêàëüíûé è íå ðåïëèöèðóåòñÿ êëèåíòàì.
	Ïîýòîìó ïåðåîïðåäåëåííûå simulated ôóíêöèè áóäóò ðàáîòàòü íà êëèåíòå òîëüêî â òîì ñëó÷àå, åñëè è íà êëèåíòå îáúåêò ïåðåøåë â ýòîò stete.
*/
state MovingAttack
{
	simulated event BeginState()
	{
		Log("Begin MovingAttack state",Name);
	}
	
	simulated event EndState()
	{
		Log("End MovingAttack state",Name);
	}
}

simulated function int DoAnimAction( name AnimName )
{
	if ( AnimName == 'ZombieBarfMoving' )  {
		AnimBlendParams(1, 1.0, 0.0,, FireRootBone);
		PlayAnim('ZombieBarf',, 0.1, 1);

		Return 1;
	}
	
	Return Super.DoAnimAction(AnimName);
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
		bWaitForAnim = False;

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
			PlaySound(DyingSound, SLOT_Pain,2.0,True,525);
			Return;
		}

		if( bDecapitated )
			PlaySound(HeadlessDeathSound, SLOT_Pain,1.30,True,525);
		else
			PlaySound(DyingSound, SLOT_Pain,2.0,True,525);
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
		SavedFireProperties.ProjectileClass = BileProjectileClass;
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 500;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = False;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = True;
		SavedFireProperties.bInitialized = True;
	}

	// Turn off extra collision before spawning vomit, otherwise spawn fails
	//ToggleAuxCollision(False);
	if ( Controller != None )
		FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
	else
		FireRotation = Rotation;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);

	FireStart -= 0.5 * CollisionRadius * Y;
	FireRotation.Yaw -= 1200;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);

	FireStart += CollisionRadius * Y;
	FireRotation.Yaw += 2400;
	Spawn(BileProjectileClass, self,, FireStart, FireRotation);
	// Turn extra collision back on
	//ToggleAuxCollision(True);
}


simulated event Tick( float DeltaTime )
{
	local Vector BileExplosionLoc;
	local FleshHitEmitter GibBileExplosion;

	Super.Tick( DeltaTime );

	if ( Role == ROLE_Authority && bMovingPukeAttack )  {
		// Keep moving toward the target until the timer runs out (anim finishes)
		if ( RunAttackTimeout > 0 )  {
			RunAttackTimeout -= DeltaTime;
			if ( RunAttackTimeout <= 0 )  {
				RunAttackTimeout = 0;
				bMovingPukeAttack = False;
			}
		}
		// Keep the bloat moving toward its target when attacking
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

//    if(BloatJet!=None)
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
	event Tick( float DeltaTime )
	{
		if ( BloatJet != None )  {
			BloatJet.SetLocation(location);
			BloatJet.SetRotation(GetBoneRotation(FireRootBone));
		}
		Super.Tick( DeltaTime );
	}
}

function RemoveHead()
{
	bCanDistanceAttackDoors = False;
	Super.RemoveHead();
}

function int ProcessTakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> DamageType )
{
	// Only server
	if ( Role < ROLE_Authority || Health < 1 || Damage < 1 )
		Return 0;
	
	// Bloats are volatile. They burn faster than other zeds.
	if ( damageType == class 'DamTypeBurned' )
		Damage *= 1.5;
	else if ( damageType == Class'DamTypeVomit' )
		Return 0;
	else if ( damageType == class 'DamTypeBlowerThrower' )
		Damage = Round( float(Damage) * 0.25 );	// Reduced damage from the blower thrower bile, but lets not zero it out entirely
	
	Return Super.ProcessTakeDamage( Damage, InstigatedBy, Hitlocation, Momentum, DamageType );
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

	for ( SimHitFxTicker = SimHitFxTicker; SimHitFxTicker != HitFxTicker; SimHitFxTicker = (SimHitFxTicker + 1) % ArrayCount(HitFX) )  {
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
			switch( HitFX[SimHitFxTicker].bone )  {
				 case 'head':
					if( !bHeadGibbed )  {
						if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False, True);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, True);

						bHeadGibbed = True;
					}
					Break;
			}
			Return;
		}

		if( HitFX[SimHitFxTicker].bSever )  {
			GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;
			switch( HitFX[SimHitFxTicker].bone )  {
				case 'obliterate':
					Break;

				case LeftThighBone:
					if( !bLeftLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftLegGibbed=True;
					}
					Break;

				case RightThighBone:
					if( !bRightLegGibbed )  {
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightLegGibbed=True;
					}
					Break;

				case LeftFArmBone:
					if( !bLeftArmGibbed )  {
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftArmGibbed=True;
					}
					Break;

				case RightFArmBone:
					if( !bRightArmGibbed )  {
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
						KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
						KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightArmGibbed=True;
					}
					Break;

				case 'head':
					if( !bHeadGibbed )  {
						if ( HitFX[SimHitFxTicker].damtype == class'DamTypeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeProjectileDecap' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, False, True);
						else if( HitFX[SimHitFxTicker].damtype == class'DamTypeMeleeDecapitation' )
							DecapFX( boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, True);

						bHeadGibbed = True;
					}
					Break;
			}

			// Don't do this right now until we get the effects sorted - Ramm
			if ( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone && HitFX[SimHitFXTicker].bone != LeftFArmBone && HitFX[SimHitFXTicker].bone != RightFArmBone && HitFX[SimHitFXTicker].bone != 'head' && Health <= 0 )
				HideBone(HitFX[SimHitFxTicker].bone);
		}
	}
}

//[end] Functions
//====================================================================

defaultproperties
{
	 ImpressiveKillChance=0.15
	 HeadShotSlowMoChargeBonus=0.25
	 KilledWaveCountDownExtensionTime=5.0
	 
	 BileExplosion=Class'KFMod.BileExplosion'
	 BileExplosionHeadless=Class'KFMod.BileExplosionHeadless'
	 BileProjectileClass=Class'UnlimaginMod.UM_BloatVomit'
	 AlphaSpeedScaleRange=(Max=2.8)
	 MeleeAnims(0)="BloatChop2"
	 MeleeAnims(1)="BloatChop2"
	 MeleeAnims(2)="BloatChop2"
	 BleedOutDuration=6.000000
	 ZapThreshold=0.500000
	 ZappedDamageMod=1.500000
	 bHarpoonToBodyStuns=False
	 ZombieFlag=1
	 MeleeDamage=14
	 damageForce=70000
	 bFatAss=True
	 KFRagdollName="Bloat_Trip"
	 PuntAnim="BloatPunt"
	 Intelligence=BRAINS_Stupid
	 AlphaIntelligence=BRAINS_Mammal
	 bCanDistanceAttackDoors=True
	 SeveredArmAttachScale=1.100000
	 SeveredLegAttachScale=1.300000
	 SeveredHeadAttachScale=1.700000
	 AmmunitionClass=Class'KFMod.BZombieAmmo'
	 ScoringValue=17
	 IdleHeavyAnim="BloatIdle"
	 IdleRifleAnim="BloatIdle"
	 MeleeRange=30.000000
	 GroundSpeed=75.000000
	 WaterSpeed=102.000000
	 
	 // JumpZ
	 JumpZ=320.0
	 JumpSpeed=110.0
	 
	 HeadHeight=2.500000
	 HeadScale=1.500000
	 AmbientSoundScaling=8.000000
	 MenuName="Bloat"
	 // MovementAnims
	 MovementAnims(0)="WalkBloat"
	 MovementAnims(1)="WalkBloat"
	 MovementAnims(2)="RunL"
	 MovementAnims(3)="RunR"
	 // WalkAnims
	 WalkAnims(0)="WalkBloat"
	 WalkAnims(1)="WalkBloat"
	 WalkAnims(2)="RunL"
	 WalkAnims(3)="RunR"
	 // AirAnims
	 AirAnims(0)="InAir"
	 AirAnims(1)="InAir"
	 AirAnims(2)="InAir"
	 AirAnims(3)="InAir"
	 // LandAnims
	 LandAnims(0)="Landed"
	 LandAnims(1)="Landed"
	 LandAnims(2)="Landed"
	 LandAnims(3)="Landed"
	 IdleCrouchAnim="BloatIdle"
	 IdleWeaponAnim="BloatIdle"
	 IdleRestAnim="BloatIdle"
	 HeadlessIdleAnim="BloatIdle_Headless"
	 SoundVolume=200
	 RotationRate=(Yaw=45000,Roll=0)
	 
	 HealthMax=525.0
	 Health=525
	 HeadHealth=35.0
	 //PlayerCountHealthScale=0.25
	 PlayerCountHealthScale=0.15
	 //PlayerNumHeadHealthScale=0.0
	 PlayerNumHeadHealthScale=0.05
	 Mass=460.000000
}
