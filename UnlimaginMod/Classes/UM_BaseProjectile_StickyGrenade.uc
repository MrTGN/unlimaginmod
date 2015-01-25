//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_StickyGrenade
//	Parent class:	 UM_BaseProjectile_LowVelocityGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 21:25
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_StickyGrenade extends UM_BaseProjectile_LowVelocityGrenade
	DependsOn(UM_BaseActor)
	Abstract;

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool			bStuck;	// Grenade has stuck on something
var		bool			bTimerSet;
var		float			ExplodeTimer;

var		UM_BaseActor.SoundData		BeepSound;

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

	if ( UM_BaseProjectile_StickyGrenade(Proj) != None )
		UM_BaseProjectile_StickyGrenade(Proj).BeepSound.Snd = default.BeepSound.Snd;
	
	Super.PreloadAssets(Proj);
}

//static function bool UnloadAssets()
simulated static function bool UnloadAssets()
{
	default.BeepSound.Snd = None;
	
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

simulated event PostNetReceive()
{
	if ( bStuck && bTrailSpawned && !bTrailDestroyed )
		DestroyTrail();
	
	Super.PostNetReceive();
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

simulated function Stick( Actor A, vector HitLocation, vector HitNormal )
{
	local	name		NearestBone;
	local	float		dist;
	
	bStuck = True;
	bCollideWorld = False;
	DestroyTrail();
	bOrientToVelocity = False;
	PrePivot = CollisionExtent * LandedPrePivotCollisionScale;
	SetPhysics(PHYS_None);
	
	if ( Pawn(A) != None )  {
		NearestBone = GetClosestBone(HitLocation, HitLocation, dist);
		A.AttachToBone(Self, NearestBone);
	}
	else
		SetBase(A);
	
	SpawnHitEffects(HitLocation, HitNormal, ,A);
	
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

simulated function ProcessTouchActor( Actor A, Vector TouchLocation, Vector TouchNormal )
{
	LastTouched = A;
	if ( CanStickTo(A) )
		Stick(A, TouchLocation, TouchNormal);
	
	LastTouched = None;
}

simulated event HitWall( vector HitNormal, actor Wall )
{
	if ( CanStickTo(Wall) )
		Stick(Wall, (Location + HitNormal), HitNormal);
}

simulated event Landed(vector HitNormal)
{
	HitWall(HitNormal, None);
}

state Stuck
{
	Ignores HitWall, Landed, ProcessTouchActor, Stick;
	
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
		
	Super.Destroyed();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 ProjectileDiameter=40.0
	 bIgnoreSameClassProj=True
	 ExplodeTimer=0.500000
	 BallisticCoefficient=0.140000
	 //Shrapnel
	 ShrapnelClass=None
	 DisintegrateChance=0.950000
	 //Sounds
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 TransientSoundVolume=2.000000
	 DisintegrateSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=360.0,bUse3D=True)
	 ExplodeSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=360.0,bUse3D=True)
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",Vol=2.0,Radius=360.0,bUse3D=True)
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
	 HitEffectsClass=Class'UnlimaginMod.UM_GrenadeStickEffect'
	 //StaticMesh
     DrawType=DT_StaticMesh
	 StaticMesh=StaticMesh'kf_generic_sm.40mm_Warhead'
	 GrenadeLightClass=Class'UnlimaginMod.UM_StickyGrenadeLight'
	 //StaticMeshRef="kf_generic_sm.40mm_Warhead"
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
