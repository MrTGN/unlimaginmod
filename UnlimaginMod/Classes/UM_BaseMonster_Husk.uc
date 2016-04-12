//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseMonster_Husk
//	Parent class:	 UM_BaseMonster
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.10.2012 23:18
//================================================================================
class UM_BaseMonster_Husk extends UM_BaseMonster
	Abstract;

//========================================================================
//[block] Variables

var     float   NextFireProjectileTime; // Track when we will fire again
var()   float   ProjectileFireInterval; // How often to fire the fire projectile

var		class<Projectile>				HuskProjectileClass;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PostBeginPlay()
{
	// Difficulty Scaling
	if ( Level.Game != None && !bDiffAdjusted )  {
        if ( Level.Game.GameDifficulty < 2.0 )
            ProjectileFireInterval = default.ProjectileFireInterval * 1.25;
        else if ( Level.Game.GameDifficulty < 4.0 )
            ProjectileFireInterval = default.ProjectileFireInterval * 1.0;
        else if ( Level.Game.GameDifficulty < 5.0 )
            ProjectileFireInterval = default.ProjectileFireInterval * 0.75;
        // Hardest difficulty
		else
            ProjectileFireInterval = default.ProjectileFireInterval * 0.60;
		//Randomizing
		ProjectileFireInterval *= Lerp( FRand(), 0.9, 1.1 );
	}

	Super.PostBeginPlay();
}

// don't interrupt the bloat while he is puking
simulated function bool HitCanInterruptAction()
{
    if ( bShotAnim )
		Return False;
	else
		Return True;
}

function DoorAttack(Actor A)
{
	if ( bShotAnim || Physics == PHYS_Swimming )
		Return;
	else if ( A != None )  {
		bShotAnim = True;
		if ( !bDecapitated && bDistanceAttackingDoor )
			SetAnimAction('ShootBurns');
		else  {
            SetAnimAction('DoorBash');
            GotoState('DoorBashing');
		}
	}
}

function RangedAttack(Actor A)
{
	local int LastFireTime;

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
	else if ( (KFDoorMover(A) != None || (!Region.Zone.bDistanceFog && VSize(A.Location-Location) <= 65535) 
				 || (Region.Zone.bDistanceFog && VSizeSquared(A.Location - Location) < (Square(Region.Zone.DistanceFogEnd) * 0.8)) )  // Make him come out of the fog a bit
			 && !bDecapitated )  {
        bShotAnim = True;
		SetAnimAction('ShootBurns');
		Controller.bPreparingMove = True;
		Acceleration = vect(0,0,0);
		NextFireProjectileTime = Level.TimeSeconds + ProjectileFireInterval + (FRand() * 2.0);
	}
}

// Overridden to handle playing upper body only attacks when moving
simulated event SetAnimAction(name NewAction)
{
	local int meleeAnimIndex;
	local bool bWantsToAttackAndMove;

	if ( NewAction == '' )
		Return;
	
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

function SpawnTwoShots()
{
	local vector X,Y,Z, FireStart;
	local rotator FireRotation;
	local UM_MonsterController UM_KFMonstControl;

	if ( HuskProjectileClass == None )  {
		Log("No HuskProjectileClass!", Name);
		Return;
	}

	if ( Controller != None && KFDoorMover(Controller.Target) != None )
	{
		Controller.Target.TakeDamage(22,Self,Location,vect(0,0,0),Class'DamTypeVomit');
		Return;
	}

	GetAxes(Rotation,X,Y,Z);
	FireStart = GetBoneCoords('Barrel').Origin;
	if ( !SavedFireProperties.bInitialized )  {
		SavedFireProperties.AmmoClass = Class'SkaarjAmmo';
		SavedFireProperties.ProjectileClass = HuskProjectileClass;
		SavedFireProperties.WarnTargetPct = 1;
		SavedFireProperties.MaxRange = 65535;
		SavedFireProperties.bTossed = False;
		SavedFireProperties.bTrySplash = True;
		SavedFireProperties.bLeadTarget = True;
		SavedFireProperties.bInstantHit = False;
		SavedFireProperties.bInitialized = True;
	}

    // Turn off extra collision before spawning vomit, otherwise spawn fails
    //ToggleAuxCollision(False);

	FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);

	foreach DynamicActors(class'UM_MonsterController', UM_KFMonstControl)
	{
        if ( UM_KFMonstControl != Controller && PointDistToLine(UM_KFMonstControl.Pawn.Location, vector(FireRotation), FireStart) < 75 )
			UM_KFMonstControl.GetOutOfTheWayOfShot(vector(FireRotation),FireStart);
	}

    Spawn(HuskProjectileClass, self,, FireStart, FireRotation);

	// Turn extra collision back on
	//ToggleAuxCollision(True);
}

// Get the closest point along a line to another point
simulated function float PointDistToLine(vector Point, vector Line, vector Origin, optional out vector OutClosestPoint)
{
	local vector SafeDir;

    SafeDir = Normal(Line);
	OutClosestPoint = Origin + (SafeDir * ((Point-Origin) dot SafeDir));
	Return VSize(OutClosestPoint-Point);
}

simulated event Tick( float DeltaTime )
{
    Super.Tick( DeltaTime );

    // Hack to force animation updates on the server for the bloat if he is relevant to someone
    // He has glitches when some of his animations don't play on the server. If we
    // find some other fix for the glitches take this out - Ramm
    if ( Level.NetMode != NM_Client && Level.NetMode != NM_Standalone )  {
        if( (Level.TimeSeconds-LastSeenOrRelevantTime) < 1.0  )
            bForceSkelUpdate = True;
        else
            bForceSkelUpdate = False;
    }
}

function RemoveHead()
{
	bCanDistanceAttackDoors = False;
	Super.RemoveHead();
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

		if( HitFX[SimHitFxTicker].bone == 'obliterate' && !class'GameInfo'.static.UseLowGore())  {
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
			if( !PhysicsVolume.bWaterVolume )  {
				for( i = 0; i < ArrayCount(HitEffects); i++ )  {
					if( HitEffects[i] == None )
						Continue;
					AttachEffect( HitEffects[i], HitFX[SimHitFxTicker].bone, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir );
				}
			}
		}
		
        if ( class'GameInfo'.static.UseLowGore() )
			HitFX[SimHitFxTicker].bSever = False;

        if( HitFX[SimHitFxTicker].bSever )  {
            GibPerterbation = HitFX[SimHitFxTicker].damtype.default.GibPerterbation;

            switch( HitFX[SimHitFxTicker].bone )
            {
                case 'obliterate':
                    Break;

                case LeftThighBone:
                	if( !bLeftLegGibbed )
					{
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftLegGibbed=True;
                    }
                    Break;

                case RightThighBone:
                	if( !bRightLegGibbed )
					{
	                    SpawnSeveredGiblet( DetachedLegClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bRightLegGibbed=True;
                    }
                    Break;

                case LeftFArmBone:
                	if( !bLeftArmGibbed )
					{
	                    SpawnSeveredGiblet( DetachedArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
                		KFSpawnGiblet( class 'KFMod.KFGibBrain',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
                		KFSpawnGiblet( class 'KFMod.KFGibBrainb',boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, 250 ) ;
	                    bLeftArmGibbed=True;
                    }
                    Break;

                case RightFArmBone:
                	if( !bRightArmGibbed )
					{
	                    SpawnSeveredGiblet( DetachedSpecialArmClass, boneCoords.Origin, HitFX[SimHitFxTicker].rotDir, GibPerterbation, GetBoneRotation(HitFX[SimHitFxTicker].bone) );
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


			if( HitFX[SimHitFXTicker].bone != 'Spine' && HitFX[SimHitFXTicker].bone != FireRootBone &&
                HitFX[SimHitFXTicker].bone != 'head' && Health <=0 )
            	HideBone(HitFX[SimHitFxTicker].bone);
        }
    }
}

// New Hit FX for Zombies!
function PlayHit(float Damage, Pawn InstigatedBy, vector HitLocation, class<DamageType> damageType, vector Momentum, optional int HitIdx )
{
	local Vector HitNormal;
	local Vector HitRay ;
	local Name HitBone;
	local float HitBoneDist;
	local PlayerController PC;
	local bool bShowEffects, bRecentHit;
	local ProjectileBloodSplat BloodHit;
	local rotator SplatRot;

	bRecentHit = Level.TimeSeconds - LastPainTime < 0.2;

    LastDamageAmount = Damage;

	// Call the modified version of the original Pawn playhit
	OldPlayHit(Damage, InstigatedBy, HitLocation, DamageType,Momentum);

	if ( Damage <= 0 )
		Return;

	if( Health>0 && Damage>(float(Default.Health)/1.5) )
	{
		FlipOver();
	}
	else if ( Health > 0 
			 && (Class<UM_BaseDamType_SniperRifle>(damageType) != None 
				 || damageType == class'DamTypeCrossbow' || damageType == class'DamTypeCrossbowHeadShot' 
				 || damageType == class'DamTypeWinchester' || damageType == class'DamTypeM14EBR'
				 || damageType == class'DamTypeM99HeadShot' || damageType == class'DamTypeM99SniperRifle' 
				 || damageType == class'DamTypeSPSniper')
			 &&  Damage > 200 ) // 200 Damage will be a headshot with the Winchester or EBR, or a hit with the Crossbow
        FlipOver();

	PC = PlayerController(Controller);
	bShowEffects = ( Level.NetMode != NM_Standalone || (Level.TimeSeconds - LastRenderTime) < 2.5
					 || (InstigatedBy != None && PlayerController(InstigatedBy.Controller) != None)
					 || PC != None );
	
	if ( !bShowEffects )
		Return;

	if ( BurnDown > 0 && !bBurnified )
    	bBurnified = True;

	HitRay = vect(0,0,0);
	if ( InstigatedBy != None )
		HitRay = Normal(HitLocation-(InstigatedBy.Location+(vect(0,0,1)*InstigatedBy.EyeHeight)));

	if ( DamageType.default.bLocationalHit )  {
		CalcHitLoc( HitLocation, HitRay, HitBone, HitBoneDist );
        // Do a zapped effect is someone shoots us and we're zapped to help show that the zed is taking more damage
        if ( bZapped && DamageType.name != 'DamTypeZEDGun' )  {
            PlaySound(class'ZedGunProjectile'.default.ExplosionSound,,class'ZedGunProjectile'.default.ExplosionSoundVolume);
            Spawn(class'ZedGunProjectile'.default.ExplosionEmitter,,,HitLocation + HitNormal*20,rotator(HitNormal));
        }
	}
	else  {
		HitLocation = Location ;
		HitBone = FireRootBone;
		HitBoneDist = 0.0f;
	}

	if ( DamageType.default.bAlwaysSevers && DamageType.default.bSpecial )
		HitBone = 'head';

	if ( InstigatedBy != None )
		HitNormal = Normal( Normal(InstigatedBy.Location-HitLocation) + VRand() * 0.2 + vect(0,0,2.8) );
	else
		HitNormal = Normal( Vect(0,0,1) + VRand() * 0.2 + vect(0,0,2.8) );

	//log("HitLocation "$Hitlocation) ;

	if ( DamageType.Default.bCausesBlood && (!bRecentHit || (bRecentHit && (FRand() > 0.8))) )  {
		if ( !class'GameInfo'.static.NoBlood() && !class'GameInfo'.static.UseLowGore() )  {
        	if ( Momentum != vect(0,0,0) )
				SplatRot = rotator(Normal(Momentum));
			else  {
				if ( InstigatedBy != None )
					SplatRot = rotator(Normal(Location - InstigatedBy.Location));
				else
					SplatRot = rotator(Normal(Location - HitLocation));
			}
		 	BloodHit = Spawn(ProjectileBloodSplatClass,InstigatedBy,, HitLocation, SplatRot);
		}
	}

	if ( InstigatedBy != None && InstigatedBy.PlayerReplicationInfo != None 
		 && KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements) != None 
		 && Health <= 0 && Damage > DamageType.default.HumanObliterationThreshhold 
		 && Damage != 1000 && (!bDecapitated || bPlayBrainSplash) )  {
		KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements).AddGibKill(class<DamTypeM79Grenade>(damageType) != None);
		if ( self.IsA('ZombieFleshPound') )
			KFSteamStatsAndAchievements(InstigatedBy.PlayerReplicationInfo.SteamStatsAndAchievements).AddFleshpoundGibKill();
	}

	DoDamageFX( HitBone, Damage, DamageType, Rotator(HitNormal) );

	if ( DamageType.default.DamageOverlayMaterial != None && Damage > 0 ) // additional check in case shield absorbed
		SetOverlayMaterial( DamageType.default.DamageOverlayMaterial, DamageType.default.DamageOverlayTime, False );
}

//[end] Functions
//====================================================================

defaultproperties
{
     ImpressiveKillChance=0.2
	 
	 HeadShotSlowMoChargeBonus=0.25
	 ProjectileFireInterval=5.500000
     MeleeAnims(0)="Strike"
     MeleeAnims(1)="Strike"
     MeleeAnims(2)="Strike"
     BleedOutDuration=6.000000
     ZapThreshold=0.750000
     bHarpoonToBodyStuns=False
     ZombieFlag=1
     MeleeDamage=15
     damageForce=70000
     bFatAss=True
     KFRagdollName="Burns_Trip"
     Intelligence=BRAINS_Mammal
     bCanDistanceAttackDoors=True
     SeveredArmAttachScale=0.900000
     SeveredLegAttachScale=0.900000
     SeveredHeadAttachScale=0.900000
     AmmunitionClass=Class'KFMod.BZombieAmmo'
     ScoringValue=17
     IdleHeavyAnim="Idle"
     IdleRifleAnim="Idle"
     MeleeRange=30.000000
     GroundSpeed=115.000000
     WaterSpeed=102.000000
     HeadHeight=1.000000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="Husk"
     MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="WalkL"
     WalkAnims(3)="WalkR"
     IdleCrouchAnim="Idle"
     IdleWeaponAnim="Idle"
     IdleRestAnim="Idle"
	 RotationRate=(Yaw=45000,Roll=0)
     
	 HealthMax=600.0
     Health=600
	 HeadHealth=200.0
	 //PlayerCountHealthScale=0.100000
	 //PlayerNumHeadHealthScale=0.050000
	 PlayerCountHealthScale=0.1
	 PlayerNumHeadHealthScale=0.05
	 Mass=320.000000
	 
	 BallisticCollision(0)=(AreaClass=Class'UnlimaginMod.UM_PawnHeadCollision',AreaRadius=6.2,AreaHeight=6.4,AreaSizeScale=1.05,AreaBone="CHR_Head",AreaOffset=(X=1.0,Y=0.2,Z=0.0),AreaImpactStrength=6.8)
	 //ToDo: UM_PawnBodyCollision - ýòî âðåìåííàÿ êîëèçèÿ òóëîâèùà. Â äàëüíåéøåì çàìåíèòü íà áîëåå äåòàëüíóþ.
	 BallisticCollision(1)=(AreaClass=Class'UnlimaginMod.UM_PawnBodyCollision',AreaRadius=16.0,AreaHeight=32.2,AreaImpactStrength=9.0)
}
