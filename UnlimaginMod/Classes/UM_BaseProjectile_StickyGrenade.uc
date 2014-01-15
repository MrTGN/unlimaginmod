//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_StickyGrenade
//	Parent class:	 UM_BaseProjectile_Grenade
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 11.07.2013 21:25
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_BaseProjectile_StickyGrenade extends UM_BaseProjectile_Grenade
	Abstract;

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool		bStuck;	// Grenade has stuck on something
var		bool		bTriggered, bTimerSet; 	// We've found an enemy. | This thing has exploded.

var		float		ExplodeTimer;	// How far away to detect enemies

struct	SoundData
{
	var	string	Ref;	//Dynamic Loading Sound
	var	sound	S;		//Sound
	var	float	V;		//Volume
	var	float	R;		//Radius
};

var		SoundData	BeepSound, StickSound;

var		Class<Emitter>	GrenadeLightClass;
var		Emitter			GrenadeLight;
var		int				ExplodeDelay;

var		Actor			StickActor;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	//ﾎ��鈞�褄���� �褞裝璞�
	reliable if ( bNetDirty && Role == ROLE_Authority )
		/*ExplodeTimer,*/ bTriggered, bStuck;
	
	//ﾏ褞裝璞� ������ � ��� ����瑯, 褥�� �� 鈞礪� �瑙琿
	unreliable if ( bNetDirty && Role == ROLE_Authority )
		StickActor;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[block] Dynamic Loading
//static function PreloadAssets(Projectile Proj)
simulated static function PreloadAssets(Projectile Proj)
{
	if ( default.BeepSound.Ref != "" && default.BeepSound.S == None )
		default.BeepSound.S = sound(DynamicLoadObject(default.BeepSound.Ref, class'Sound', True));
	
	if ( default.StickSound.Ref != "" && default.StickSound.S == None )
		default.StickSound.S = sound(DynamicLoadObject(default.StickSound.Ref, class'Sound', True));
	
	if ( UM_BaseProjectile_StickyGrenade(Proj) != None )
	{
		if ( default.BeepSound.S != None && UM_BaseProjectile_StickyGrenade(Proj).BeepSound.S == None )
			UM_BaseProjectile_StickyGrenade(Proj).BeepSound.S = default.BeepSound.S;
		
		if ( default.StickSound.S != None && UM_BaseProjectile_StickyGrenade(Proj).StickSound.S == None )
			UM_BaseProjectile_StickyGrenade(Proj).StickSound.S = default.StickSound.S;
	}
	
	Super.PreloadAssets(Proj);
}

//static function bool UnloadAssets()
simulated static function bool UnloadAssets()
{
	if ( default.BeepSound.S != None )
		default.BeepSound.S = None;
	
	if ( default.StickSound.S != None )
		default.StickSound.S = None;
	
	Return Super.UnloadAssets();
}
//[end]

simulated function SpawnTrails()
{
	if ( !bStuck )
		Super.SpawnTrails();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( Level.NetMode != NM_DedicatedServer && GrenadeLightClass != None )
    {
        GrenadeLight = Spawn(GrenadeLightClass, Self);
		if ( GrenadeLight != None )
			GrenadeLight.SetBase(Self);
    }
}

simulated event PostNetReceive()
{
	if ( bHidden && !bDisintegrated )
        Disintegrate(Location,vect(0,0,1));
	else if ( bTriggered && !bHasExploded )
        Explode(Location,vect(0,0,1));
	
	if ( bStuck && bTrailsSpawned && !bTrailsDestroyed )
		DestroyTrails();
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local	int		i;

	//log(self$": Grenade is Exploading.");
	bHasExploded = True;
	BlowUp(HitLocation);
	
	bTriggered = True;
	
	if ( Role == ROLE_Authority )
	{
		SetTimer(0.1, false);
		NetUpdateTime = Level.TimeSeconds - 1;
	}
	
	if ( !Level.bDropDetail && Level.NetMode != NM_DedicatedServer )
	{
		if ( ExplodeSounds.length > 1 )
			PlaySound(ExplodeSounds[Rand(ExplodeSounds.length)],, SoundEffectsVolume);
		else if ( ExplodeSounds.length == 1 )
			PlaySound(ExplodeSounds[0],, SoundEffectsVolume);
		
		if ( EffectIsRelevant(Location, False) )
		{
			if ( ExplosionVisualEffect != None )
				Spawn(ExplosionVisualEffect,,, HitLocation, rotator(vect(0,0,1)));
			
			if ( ExplosionDecal != None )
				Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
		}
	}
	
	// Shrapnel
	if ( Role == ROLE_Authority && ShrapnelClass != None && MaxShrapnelAmount > 0 )
	{
		if ( MaxShrapnelAmount > 1 )
		{
			for ( i = Rand(Max((MaxShrapnelAmount - MinShrapnelAmount), 2)); i < MaxShrapnelAmount; i++ )
			{
				Spawn(ShrapnelClass, Instigator,, Location, RotRand(True));
			}
		}
		else
			Spawn(ShrapnelClass, Instigator,, Location, RotRand(True));
	}
	// Shake nearby players screens
	ShakePlayersView();
	
	if ( Role < ROLE_Authority )
		Destroy();
}

event Timer()
{
	if( !bHidden && !bTriggered )
		Explode(Location, vect(0,0,1));
	else
		Destroy();
}

simulated function Stick(actor HitActor, vector HitLocation, vector HitNormal)
{
	local	name		NearestBone;
	local	float		dist;

	bStuck = True;
	
	/*
	if ( Role == ROLE_Authority && !bTimerSet )
	{
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	} */
	
	bCollideWorld = False;
	SetPhysics(PHYS_None);
	DestroyTrails();
	StickActor = HitActor;

	if ( Pawn(StickActor) != None )
	{
		NearestBone = GetClosestBone(HitLocation, HitLocation, dist);
		StickActor.AttachToBone(Self, NearestBone);
	}
	else
		SetBase(StickActor);
	
	SpawnHitEffects(HitLocation, HitNormal, , , StickActor, StickSound.S, StickSound.V, StickSound.R);
	
	if ( Base == None )
	{
		bStuck = False;
		bCollideWorld = True;
		SetPhysics(PHYS_Falling);
		Return;
	}
	else
		GoToState('Stuck');
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{
	if ( !bStuck )
	{
		// Don't allow hits on poeple on the same team
		if ( Other == None || Other == Instigator || Other.Base == Instigator || 
			 (KFHumanPawn(Other) != None && Instigator != None &&
				 KFHumanPawn(Other).PlayerReplicationInfo.Team.TeamIndex == Instigator.PlayerReplicationInfo.Team.TeamIndex) )
			Return;
		
		Stick(Other, HitLocation, Normal(HitLocation - Other.Location));
	}
}

//simulated singular event HitWall( vector HitNormal, actor Wall )
simulated event HitWall( vector HitNormal, actor Wall )
{
	if ( !bStuck )
		Stick(Wall, (Location + HitNormal), HitNormal);
}

simulated event Landed(vector HitNormal)
{
	HitWall(HitNormal, None);
}

state Stuck
{
	Ignores HitWall, Landed, ProcessTouch, Stick;
	
	/*
	simulated event BeginState()
	{
		//log(self$": Grenade is in the Stuck State.");
	} */
	
	simulated event BaseChange()
	{
		if ( Base == None )
		{
			bStuck = False;
			bCollideWorld = True;
			SetPhysics(PHYS_Falling);
			GotoState('');
		}
	}
}

simulated event Destroyed()
{
	DestroyTrails();
	
	if( !bHasExploded && !bHidden && bTriggered )
		Explode(Location,vect(0,0,1));
	
	if( bHidden && !bDisintegrated )
		Disintegrate(Location,vect(0,0,1));
	
	if( GrenadeLight != None )
        GrenadeLight.Destroy();
		
	Super(Projectile).Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 bIgnoreSameClassProj=True
	 ExplodeTimer=0.500000
	 BallisticCoefficient=0.150000
	 //Shrapnel
	 ShrapnelClass=None
	 DisintegrateChance=0.950000
	 //Sounds
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 SoundEffectsVolume=2.000000
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.Nade_Explode_1"
     ExplodeSoundsRef(1)="KF_GrenadeSnd.Nade_Explode_2"
     ExplodeSoundsRef(2)="KF_GrenadeSnd.Nade_Explode_3"
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",V=2.0,R=400.0)
	 StickSound=(Ref="ProjectileSounds.PTRD_deflect04",V=2.2,R=400.0)
	 LifeSpan=0.000000
	 ProjectileMass=0.230000
     //DisintegrateDamageTypes
	 DisintegrateDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrateDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrateDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
	 //Visual Effects
	 ExplosionVisualEffect=Class'KFmod.KFNadeExplosion'
	 ExplosionDecal=Class'KFMod.KFScorchMark'
	 DisintegrationVisualEffect=Class'KFMod.SirenNadeDeflect'
	 //StaticMesh
     DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'kf_generic_sm.40mm_Warhead'
	 GrenadeLightClass=Class'UnlimaginMod.UM_StickyGrenadeLight'
	 //StaticMeshRef="kf_generic_sm.40mm_Warhead"
	 //Booleans
     bBlockHitPointTraces=False
     bUnlit=False
	 bBounce=True
     //bFixedRotationDir=True
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
	 //Collision
	 bCollideActors=True
     bCollideWorld=True
     bUseCylinderCollision=True
	 CollisionRadius=1.000000
     CollisionHeight=2.000000
	 //DrawScale
     DrawScale=2.000000
}
