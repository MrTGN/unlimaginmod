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
class UM_StickySensorHandGrenade extends UM_BaseProjectile_HandGrenade
	DependsOn(UM_BaseActor);

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool			bEnemyDetected; // We've found an enemy
var		bool			bStuck;		// Grenade has stuck on something.

var		float			DetectionRadius;	// How far away to detect enemies

var		UM_BaseActor.SoundData		BeepSound, PickupSound;

var		Class<Emitter>	GrenadeLightClass;
var		Emitter			GrenadeLight;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
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
	if ( IsArmed() )  {
		// Idle
		if ( !bEnemyDetected )  {
			bEnemyDetected = MonsterIsInRadius(DetectionRadius);
			if ( bEnemyDetected )  {
				bAlwaysRelevant = True;
				if ( BeepSound.Snd != None )
					PlaySound(BeepSound.Snd, BeepSound.Slot, (BeepSound.Vol * 1.5), BeepSound.bNoOverride, BeepSound.Radius, BaseActor.static.GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
				SetTimer(0.2,True);
			}
		}
		// Armed
		else  {
			bEnemyDetected = MonsterIsInRadius(DamageRadius);
			if ( bEnemyDetected )  {
				if ( !FriendlyPawnIsInRadius(DamageRadius) )
					Explode(Location, Vector(Rotation));
				else if ( BeepSound.Snd != None )
					PlaySound(BeepSound.Snd, BeepSound.Slot, BeepSound.Vol, BeepSound.bNoOverride, BeepSound.Radius, BaseActor.static.GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
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

simulated function UnStick()
{
	bStuck = False;
	bCollideWorld = True;
	PrePivot = default.PrePivot;
	bOrientToVelocity = True;
	SetPhysics(PHYS_Falling);
	if ( IsInState('Stuck') )
		GotoState('');
}

simulated function Stick( Actor A )
{
	local	vector	TouchLocation, TouchNormal;
/*	local	name	NearestBone;
	local	float	dist;
	local	vector	HitDirection;	*/
	
	GetTouchLocation(A, TouchLocation, TouchNormal);
	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
	
	bStuck = True;
	bCollideWorld = False;
	DestroyTrail();
	/*
	if ( Velocity == vect(0.0, 0.0, 0.0) )
		HitDirection = Vector(Rotation);
	else
		HitDirection = Normal(Velocity);
	*/
	bOrientToVelocity = False;
	Velocity = Vect(0.0, 0.0, 0.0);
	//SetRotation( Rotator(HitDirection) );
	SetPhysics(PHYS_None);

	/*
	if ( Pawn(A) != None )
		NearestBone = A.GetClosestBone(TouchLocation, HitDirection, dist);
	
	if ( NearestBone == '' )  {
		PrePivot = CollisionExtent * LandedPrePivotCollisionScale;
		SetBase(A);
	}
	else  {
		A.AttachToBone(Self, NearestBone);
		SetRelativeLocation( TouchLocation - A.GetBoneCoords(NearestBone).Origin );
		SetRelativeRotation( Rotator(HitDirection >> A.GetBoneRotation(NearestBone, 0)) );
	}
	*/
	PrePivot = CollisionExtent * LandedPrePivotCollisionScale;
	SetBase(A);
	SpawnHitEffects(TouchLocation, TouchNormal, ,A);

	//if ( NearestBone == '' && Base == None )
	if ( Base == None )
		UnStick();
	else
		GoToState('Stuck');
}

simulated function bool CanStickTo( Actor A )
{
	if ( bStuck || A == None || A == Instigator || A.Base == Instigator )
		Return False;
	
	Return True;
}

simulated function ProcessTouchActor( Actor A )
{
	LastTouched = A;
	if ( CanStickTo(A) )
		Stick(A);
	
	LastTouched = None;
}

simulated event HitWall( vector HitNormal, Actor Wall )
{
	if ( CanStickTo(Wall) )
		Stick(Wall);
}

simulated event Landed(vector HitNormal)
{
	HitWall(HitNormal, None);
}

state Stuck
{
	Ignores HitWall, Landed, Stick;
	
	function ProcessTouchActor( Actor A )
	{
		local	Inventory	Inv;
		
		if ( Pawn(A) != None && Pawn(A) == Instigator && Pawn(A).Inventory != None )  {
			for ( Inv = Pawn(A).Inventory; Inv != None; Inv = Inv.Inventory )  {
				if ( UM_Weapon_HandGrenade(Inv) != None && UM_Weapon_HandGrenade(Inv).AmmoAmount(0) < UM_Weapon_HandGrenade(Inv).MaxAmmo(0) )  {
					UM_Weapon_HandGrenade(Inv).AddAmmo(1,0);
					if ( PickupSound.Snd != None )
						PlaySound(PickupSound.Snd, PickupSound.Slot, PickupSound.Vol, PickupSound.bNoOverride, PickupSound.Radius, BaseActor.static.GetRandPitch(PickupSound.PitchRange), PickupSound.bUse3D);
					Break;
				}
			}
			Destroy();
		}
	}
	
	simulated event BaseChange()
	{
		if ( Base == None )
			UnStick();
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
	 bCanHurtSameTypeProjectile=False
	 //Actually ExplodeTimer is a scanning delay time here
	 ExplodeTimer=0.500000
	 GrenadeLightClass=Class'UnlimaginMod.UM_StickySensorHandGrenadeLight'
	 HitEffectsClass=Class'UnlimaginMod.UM_GrenadeStickEffect'
	 //Shrapnel
	 ShrapnelClass=Class'UnlimaginMod.UM_HandGrenadeShrapnel'
	 ShrapnelAmount=(Min=6,Max=8)
	 //Sounds
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=400.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.HandGrenade.HG_Explode",Vol=2.0,Radius=400.0,bUse3D=True)
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",Vol=2.0,Radius=400.0,bUse3D=True)
	 PickupSound=(Ref="KF_InventorySnd.Ammo_GenericPickup",Slot=SLOT_Pain,Vol=2.2,Radius=400.0,PitchRange=(Min=0.95,Max=1.05),bUse3D=True)
	 DetectionRadius=170.000000
	 DamageRadius=380.000000
	 LifeSpan=0.000000
	 bUpdateSimulatedPosition=True
	 bNetTemporary=False
	 bNetNotify=True
}