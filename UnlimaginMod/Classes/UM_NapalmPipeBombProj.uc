//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_NapalmPipeBombProj
//	Parent class:	 PipeBombProjectile
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.07.2012 20:41
//================================================================================
class UM_NapalmPipeBombProj extends PipeBombProjectile;

#exec OBJ LOAD FILE=KF_GrenadeSnd.uax

static function PreloadAssets()
{
	default.ExplodeSounds[0] = sound(DynamicLoadObject(default.ExplodeSoundRefs[0], class'Sound', True));

	UpdateDefaultStaticMesh(StaticMesh(DynamicLoadObject(default.StaticMeshRef, class'StaticMesh', True)));
}

static function bool UnloadAssets()
{
	default.ExplodeSounds[0] = None;

	UpdateDefaultStaticMesh(None);

	Return True;
}

simulated event Destroyed()
{
	if( !bHasExploded && !bHidden && bTriggered)
		Explode(Location,vect(0,0,1));
	
	if( bHidden && !bDisintegrated )
		Disintegrate(Location,vect(0,0,1));

	if( BombLight != None )
	{
		BombLight.Destroy();
	}

	Super(Projectile).Destroyed();
}

// cut-n-paste to remove grenade smoke trail
simulated event PostBeginPlay()
{
	if ( Level.NetMode != NM_DedicatedServer)
	{
		BombLight = Spawn(class'PipebombLight',self);
		BombLight.SetBase(self);
	}

	if ( Role == ROLE_Authority )
	{
		Velocity = Speed * Vector(Rotation);
		RandSpin(25000);
		bCanHitOwner = False;
		if (Instigator.HeadVolume.bWaterVolume)
		{
			bHitWater = True;
			Velocity = 0.6*Velocity;
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	local PlayerController  LocalPlayer;

	bHasExploded = True;
	BlowUp(HitLocation);

	bTriggered = True;

	if( Role == ROLE_Authority )
	{
		SetTimer(0.1, False);
		NetUpdateTime = Level.TimeSeconds - 1;
	}

	// Incendiary Effects..
	PlaySound(sound'KF_GrenadeSnd.FlameNade_Explode',,100.5*TransientSoundVolume);

	if ( EffectIsRelevant(Location,False) )
	{
		Spawn(Class'KFIncendiaryExplosion',,, HitLocation, rotator(vect(0,0,1)));
		Spawn(ExplosionDecal,self,,HitLocation, rotator(-HitNormal));
	}

	// Shake nearby players screens
	LocalPlayer = Level.GetLocalPlayerController();
	if ( (LocalPlayer != None) && (VSize(Location - LocalPlayer.ViewTarget.Location) < (DamageRadius * 1.5)) )
		LocalPlayer.ShakeView(RotMag, RotRate, RotTime, OffsetMag, OffsetRate, OffsetTime);

	if( Role < ROLE_Authority )
	{
		Destroy();
	}
}

defaultproperties
{
     DetectionRadius=150.000000
	 StaticMeshRef="KF_pickups2_Trip.Pipebomb_Pickup"
     Damage=440.000000
     DamageRadius=360.000000
     MyDamageType=Class'UnlimaginMod.UM_DamTypeNapalmPipeBomb'
	 RemoteRole=ROLE_SimulatedProxy
     ExplosionDecal=Class'KFMod.KFScorchMark'
     DrawType=DT_StaticMesh
	 bNetTemporary=False
     Physics=PHYS_Falling
     LifeSpan=0.000000
	 bUnlit=False
	 CollisionRadius=8.000000
     CollisionHeight=3.000000
	 bProjTarget=True
     bNetNotify=True
     bBounce=True
     bFixedRotationDir=True
	 StaticMesh=StaticMesh'KF_pickups2_Trip.Pipebomb_Pickup'
}
