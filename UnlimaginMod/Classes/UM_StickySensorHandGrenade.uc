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

var		bool			bEnemyDetected; // We've found an enemy
var		bool			bStuck;		// Grenade has stuck on something.

var		float			DetectionRadius;	// How far away to detect enemies

var		SoundData		BeepSound, PickupSound;

var		Class<Emitter>	GrenadeLightClass;
var		Emitter			GrenadeLight;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( bNetDirty && Role == ROLE_Authority )
		bStuck;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[block] Dynamic Loading
//static function PreloadAssets(Projectile Proj)
simulated static function PreloadAssets(Projectile Proj)
{
	default.BeepSound.Snd = BaseActor.static.LoadSound(default.BeepSound.Ref);
	default.PickupSound.Snd = BaseActor.static.LoadSound(default.PickupSound.Ref);
	
	if ( UM_StickySensorHandGrenade(Proj) != None )  {
		UM_StickySensorHandGrenade(Proj).BeepSound.Snd = default.BeepSound.Snd;
		UM_StickySensorHandGrenade(Proj).PickupSound.Snd = default.PickupSound.Snd;
	}
	
	Super.PreloadAssets(Proj);
}

//static function bool UnloadAssets()
simulated static function bool UnloadAssets()
{
	default.BeepSound.Snd = None;
	default.PickupSound.Snd = None;

	Return Super.UnloadAssets();
}
//[end]

simulated function SpawnTrail()
{
	if ( !bStuck )
		Super.SpawnTrail();
}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( Level.NetMode != NM_DedicatedServer && GrenadeLightClass != None )  {
        GrenadeLight = Spawn(GrenadeLightClass, Self);
		if ( GrenadeLight != None )
			GrenadeLight.SetBase(Self);
    }
}

simulated event PostNetBeginPlay()
{
	Super(UM_BaseExplosiveProjectile).PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
}

simulated event PostNetReceive()
{
	if ( bStuck && bTrailSpawned && !bTrailDestroyed )
		DestroyTrail();
	
	Super.PostNetReceive();
}

event Timer()
{
	local	bool	bFriendlyPawnDetected;
	
	if ( IsArmed() )  {
		// Idle
		if ( !bEnemyDetected )  {
			bEnemyDetected = MonsterIsInRadius(DetectionRadius);
			if ( bEnemyDetected )  {
				bAlwaysRelevant = True;
				if ( BeepSound.Snd != None )
					ServerPlaySoundData(BeepSound, 1.5);
				SetTimer(0.2,True);
			}
		}
		// Armed
		else  {
			bEnemyDetected = MonsterIsInRadius(DamageRadius);
			bFriendlyPawnDetected = FriendlyPawnIsInRadius(DamageRadius);
			if ( bEnemyDetected )  {
				if ( !bFriendlyPawnDetected )
					Explode(Location, vect(0,0,1));
				else if ( BeepSound.Snd != None )
					ServerPlaySoundData(BeepSound);
			}
			else  {
				bAlwaysRelevant = False;
				SetTimer(ExplodeTimer, True);
			}
		}
	}
	else
		Destroy();
}

simulated function Stick( Actor A, vector HitLocation, vector HitNormal )
{
	local	name		NearestBone;
	local	float		dist;

	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
	
	if ( A == Instigator || A.Base == Instigator )
		Return;
	
	bStuck = True;
	bCollideWorld = False;
	SetPhysics(PHYS_None);
	DestroyTrail();

	if ( Pawn(A) != None )  {
		NearestBone = GetClosestBone(HitLocation, HitLocation, dist);
		A.AttachToBone(Self, NearestBone);
	}
	else
		SetBase(A);

	SpawnHitEffects(HitLocation, HitNormal, ,A);

	if ( Base == None )  {
		bStuck = False;
		bCollideWorld = True;
		SetPhysics(PHYS_Falling);
		Return;
	}
	else
		GoToState('Stuck');
}

simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
{
	LastTouched = A;
	if ( !bStuck )
		Stick(A, TouchLocation, TouchNormal);
	
	LastTouched = None;
}

//simulated singular event HitWall( vector HitNormal, actor Wall )
simulated event HitWall( vector HitNormal, Actor Wall )
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
	
	simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
	{
		local	Inventory	Inv;
		
		if ( Role == ROLE_Authority && Pawn(A) != None && Pawn(A) == Instigator && Pawn(A).Inventory != None )  {
			for( Inv = Pawn(A).Inventory; Inv != None; Inv = Inv.Inventory )  {
				if ( UM_Weapon_HandGrenade(Inv) != None && 
					UM_Weapon_HandGrenade(Inv).AmmoAmount(0) < UM_Weapon_HandGrenade(Inv).MaxAmmo(0) )  {
					UM_Weapon_HandGrenade(Inv).AddAmmo(1,0);
					if ( PickupSound.Snd != None )
						ServerPlaySoundData(PickupSound);
					Break;
				}
			}
			Destroy();
		}
	}
	
	simulated event BaseChange()
	{
		if ( Base == None )  {
			bStuck = False;
			bCollideWorld = True;
			SetPhysics(PHYS_Falling);
			GotoState('');
		}
	}
}

simulated event Destroyed()
{
	if ( GrenadeLight != None )
        GrenadeLight.Destroy();
	
	if ( FearMarker != None )
		FearMarker.Destroy();

	Super.Destroyed();
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
	 HitEffectsClass=Class'UnlimaginMod.UM_GrenadeStickEffect'
	 //Shrapnel
	 ShrapnelClass=Class'KFMod.KFShrapnel'
	 MaxShrapnelAmount=10
	 MinShrapnelAmount=5
	 //Sounds
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.HandGrenade.HG_Explode",Vol=2.0,Radius=400.0,bUse3D=True)
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",Vol=2.0,Radius=400.0,bUse3D=True)
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",Slot=SLOT_Pain,Vol=2.2,Radius=400.0,PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 DetectionRadius=170.000000
	 DamageRadius=380.000000
	 LifeSpan=0.000000
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
}