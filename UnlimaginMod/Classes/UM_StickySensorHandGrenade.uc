//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_StickySensorHandGrenade
//	Parent class:	 UM_BaseProjectile_HandGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.10.2012 5:44
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Sticky hand grenade with Sensor
//================================================================================
class UM_StickySensorHandGrenade extends UM_BaseProjectile_HandGrenade;

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool		bEnemyDetected; // We've found an enemy
var		bool		bTriggered; // This thing has exploded
var		bool		bStuck;		// Grenade has stuck on something.

var		float		DetectionRadius;// How far away to detect enemies

struct	SoundData
{
	var	string	Ref;	//Dynamic Loading Sound
	var	sound	S;		//Sound
	var	float	V;		//Volume
	var	float	R;		//Radius
};

var		SoundData	BeepSound, StickSound, PickupSound;

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
	reliable if ( bNetDirty && Role == ROLE_Authority )
		bTriggered, bStuck;
	
	//Ïåðåäà÷à òîëüêî â òîì ñëó÷àå, åñëè íå çàáèò êàíàë
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
	
	if ( default.PickupSound.Ref != "" && default.PickupSound.S == None )
		default.PickupSound.S = sound(DynamicLoadObject(default.PickupSound.Ref, class'Sound', True));
	
	if ( UM_StickySensorHandGrenade(Proj) != None )
	{
		if ( default.BeepSound.S != None && UM_StickySensorHandGrenade(Proj).BeepSound.S == None )
			UM_StickySensorHandGrenade(Proj).BeepSound.S = default.BeepSound.S;
		
		if ( default.StickSound.S != None && UM_StickySensorHandGrenade(Proj).StickSound.S == None )
			UM_StickySensorHandGrenade(Proj).StickSound.S = default.StickSound.S;
		
		if ( default.PickupSound.S != None && UM_StickySensorHandGrenade(Proj).PickupSound.S == None )
			UM_StickySensorHandGrenade(Proj).PickupSound.S = default.PickupSound.S;
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
	
	if ( default.PickupSound.S != None )
		default.PickupSound.S = None;

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

simulated event PostNetBeginPlay()
{
	Super(UM_BaseExplosiveProjectile).PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )
	{
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
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
	local	Pawn		CheckPawn;
	local	Pawn		CheckKFMonster;
	
	if( !bHidden && !bTriggered )
	{
		if( !bEnemyDetected )
		{
			bAlwaysRelevant = False;
			foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DetectionRadius, Location )
			{
				if( KFMonster(CheckPawn) != None )
				{
					bEnemyDetected = True;
					bAlwaysRelevant = True;
					PlaySound(BeepSound.S,,(BeepSound.V * 1.5),,BeepSound.R);
					SetTimer(0.2,True);
					Break;
				}
			}
		}
		else
		{
			foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DamageRadius, Location )
			{
				if( CheckPawn == Instigator )
					ExplodeDelay++;
				else if( KFMonster(CheckPawn) != None )
					CheckKFMonster = CheckPawn;
			}
			
			if ( CheckKFMonster == None )
			{
				bEnemyDetected = False;
				SetTimer(ExplodeTimer, True);
				if( ExplodeDelay > 0)
					ExplodeDelay = 0;
				
				Return;
			}
			
			if ( ExplodeDelay > 0 )
			{
				PlaySound(BeepSound.S,SLOT_Misc,BeepSound.V,,DamageRadius);
				ExplodeDelay--;
			}
			else
				Explode(Location,vect(0,0,1));
		}
	}
	else
		Destroy();
}

simulated function Stick(actor HitActor, vector HitLocation, vector HitNormal)
{
	local	name		NearestBone;
	local	float		dist;
	//local	Inventory	Inv;

	bStuck = True;
	
	if ( Role == ROLE_Authority && !bTimerSet )
	{
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
	
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
	Ignores HitWall, Landed, Stick;
	
	function ProcessTouch(Actor Other, vector HitLocation)
	{
		local	Inventory	Inv;
		
		if ( Pawn(Other) != None && Pawn(Other) == Instigator && Pawn(Other).Inventory != None )
		{
			for( Inv = Pawn(Other).Inventory; Inv != None; Inv = Inv.Inventory )
			{
				if ( UM_Weapon_HandGrenade(Inv) != None && 
					UM_Weapon_HandGrenade(Inv).AmmoAmount(0) < UM_Weapon_HandGrenade(Inv).MaxAmmo(0) )
				{
					UM_Weapon_HandGrenade(Inv).AddAmmo(1,0);
					PlaySound(PickupSound.S, SLOT_Pain,PickupSound.V,,PickupSound.R);
					Break;
				}
			}
			Destroy();
		}
	}
	
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
	
	if ( FearMarker != None )
		FearMarker.Destroy();

	Super(Projectile).Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 FearMarkerClass=None
	 bIgnoreSameClassProj=True
	 //Actually ExplodeTimer is a scanning delay time here
	 ExplodeTimer=0.500000
	 GrenadeLightClass=Class'UnlimaginMod.UM_StickySensorHandGrenadeLight'
	 //Shrapnel
	 ShrapnelClass=Class'KFMod.KFShrapnel'
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 //Sounds
	 DisintegrateSoundsRef(0)="Inf_Weapons.panzerfaust60.faust_explode_distant02"
	 ExplodeSoundsRef(0)="KF_GrenadeSnd.Nade_Explode_1"
     ExplodeSoundsRef(1)="KF_GrenadeSnd.Nade_Explode_2"
     ExplodeSoundsRef(2)="KF_GrenadeSnd.Nade_Explode_3"
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",V=2.0,R=400.0)
	 StickSound=(Ref="ProjectileSounds.PTRD_deflect04",V=2.2,R=400.0)
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",V=2.2,R=400.0)
	 DetectionRadius=170.000000
	 DamageRadius=380.000000
	 LifeSpan=0.000000
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
}