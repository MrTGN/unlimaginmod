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
	Abstract;

#exec OBJ LOAD FILE=ProjectileSounds.uax
#exec OBJ LOAD FILE=KF_FoundrySnd.uax

//========================================================================
//[block] Variables

var		bool			bStuck;	// Grenade has stuck on something
var		bool			bTimerSet;
var		float			ExplodeTimer;

var		SoundData		BeepSound;

var		Class<Emitter>	GrenadeLightClass;
var		Emitter			GrenadeLight;
var		Actor			StickActor;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		ExplodeTimer, bStuck;
	
	unreliable if ( Role == ROLE_Authority && bNetDirty )
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

simulated function Stick( Actor HitActor, vector HitLocation, vector HitNormal )
{
	local	name		NearestBone;
	local	float		dist;
	
	if ( HitActor == Instigator || HitActor.Base == Instigator )
		Return;
	
	bStuck = True;
	bCollideWorld = False;
	SetPhysics(PHYS_None);
	DestroyTrail();
	StickActor = HitActor;

	if ( Pawn(StickActor) != None )  {
		NearestBone = GetClosestBone(HitLocation, HitLocation, dist);
		StickActor.AttachToBone(Self, NearestBone);
	}
	else
		SetBase(StickActor);
	
	SpawnHitEffects(HitLocation, HitNormal, ,StickActor);
	
	if ( Base == None )  {
		bStuck = False;
		bCollideWorld = True;
		SetPhysics(PHYS_Falling);
		Return;
	}
	else
		GoToState('Stuck');
}

simulated function ProcessTouch( Actor Other, Vector HitLocation )
{
	LastTouched = Other;
	if ( !bStuck )
		Stick(Other, HitLocation, Normal(HitLocation - Other.Location));
	LastTouched = None;
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
	 BallisticCoefficient=0.150000
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
