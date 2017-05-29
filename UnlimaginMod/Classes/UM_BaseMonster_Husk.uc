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
//[end] Functions
//====================================================================

defaultproperties
{
	 // Explosion parametrs
	 KilledExplodeChance=1.0
	 ExplosionDamage=80
	 ExplosionDamageType=Class'DamTypeHuskGun'
	 ExplosionRadius=320.0
	 ExplosionMomentum=8000.0
	 ExplosionShrapnelClass=Class'KFMod.FlameTendril'
	 ExplosionShrapnelAmount=(Min=4,Max=6)
	 ExplosionVisualEffect=Class'KFMod.KFIncendiaryExplosion'
	 ExplosionSound=(Snd='Artillery.explosions.explo021',Vol=1.8,Radius=600.0)
	 
	 KnockDownHealthPct=0.65
	 ExplosiveKnockDownHealthPct=0.6
	 
	 ImpressiveKillChance=0.2
	 KilledWaveCountDownExtensionTime=8.0
	 
	 HeadShotSlowMoChargeBonus=0.25
	 ProjectileFireInterval=5.500000
     BleedOutDuration=6.000000
     ZapThreshold=0.750000
     bHarpoonToBodyStuns=False
     ZombieFlag=1
     MeleeDamage=15
     damageForce=70000
     bFatAss=True
     KFRagdollName="Burns_Trip"
     //Intelligence=BRAINS_Mammal
	 Intelligence=BRAINS_Human
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
	 
	 // JumpZ
	 JumpZ=320.0
	 JumpSpeed=150.0
	 
     HeadHeight=1.000000
     HeadScale=1.500000
     AmbientSoundScaling=8.000000
     MenuName="Husk"
	 // MeleeAnims
	 MeleeAnims(0)="Strike"
     MeleeAnims(1)="Strike"
     MeleeAnims(2)="Strike"
	 // MovementAnims
	 MovementAnims(0)="WalkF"
     MovementAnims(1)="WalkB"
     MovementAnims(2)="WalkL"
     MovementAnims(3)="WalkR"
	 TurnLeftAnim="TurnLeft"
     TurnRightAnim="TurnRight"
	 // WalkAnims
	 WalkAnims(0)="WalkF"
     WalkAnims(1)="WalkB"
     WalkAnims(2)="WalkL"
     WalkAnims(3)="WalkR"
	 // HeadlessWalkAnims
	 HeadlessWalkAnims(0)="WalkF_Headless"
     HeadlessWalkAnims(1)="WalkB_Headless"
     HeadlessWalkAnims(2)="WalkL_Headless"
     HeadlessWalkAnims(3)="WalkR_Headless"
     // BurningWalkFAnims
	 BurningWalkFAnims(0)="WalkF_Fire"
     BurningWalkFAnims(1)="WalkF_Fire"
     BurningWalkFAnims(2)="WalkF_Fire"
     // BurningWalkAnims
	 BurningWalkAnims(0)="WalkB_Fire"
     BurningWalkAnims(1)="WalkL_Fire"
     BurningWalkAnims(2)="WalkR_Fire"
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
