//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_StickyGrenade
//	Parent class:	 UM_BaseProjectile_LowVelocityGrenade
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
class UM_BaseProjectile_StickyGrenade extends UM_BaseProjectile_LowVelocityGrenade
	DependsOn(UM_BaseActor)
	Abstract;

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool						bStuck;	// Grenade has stuck on something

var		UM_BaseActor.SoundData		BeepSound;

var		Class<Emitter>				GrenadeLightClass;
var		Emitter						GrenadeLight;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

/*
replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		bStuck;
}	*/

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
	if ( bStuck && bTrailSpawned )
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
	GotoState('');
}

simulated function Stick( Actor A )
{
	local	vector	TouchLocation, TouchNormal;
/*	local	name	NearestBone;
	local	float	dist;
	local	vector	HitDirection;	*/
	
	GetTouchLocation(A, TouchLocation, TouchNormal);
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
	SpawnHitEffects(TouchLocation, TouchNormal, A);

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

simulated event HitWall( vector HitNormal, actor Wall )
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
	 bCanHurtSameTypeProjectile=False
	 bDelayArming=True
	 ArmingDelay=0.500000
	 BallisticCoefficient=0.140000
	 //Shrapnel
	 ShrapnelClass=None
	 DisintegrationChance=0.950000
	 //Sounds
	 MuzzleVelocity=70.000000	//m/s
	 Speed=0.000000
     MaxSpeed=0.000000
	 TransientSoundVolume=2.000000
	 DisintegrationSound=(Ref="UnlimaginMod_Snd.Grenade.G_Disintegrate",Vol=2.0,Radius=360.0,bUse3D=True)
	 ExplosionSound=(Ref="UnlimaginMod_Snd.Grenade.G_Explode",Vol=2.0,Radius=360.0,bUse3D=True)
	 BeepSound=(Ref="KF_FoundrySnd.1Shot.Keypad_beep01",Vol=2.0,Radius=360.0,bUse3D=True)
	 LifeSpan=0.000000
	 ProjectileMass=230.0
     //DisintegrationDamageTypes
	 DisintegrationDamageTypes(0)=Class'SirenScreamDamage'
	 DisintegrationDamageTypes(1)=Class'DamTypeVomit'
	 DisintegrationDamageTypes(2)=Class'UM_ZombieDamType_SirenScream'
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
