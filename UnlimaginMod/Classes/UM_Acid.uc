//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Acid
//	Parent class:	 KFBloatVomit
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 24.07.2013 01:22
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_Acid extends KFBloatVomit;

//ToDo: Äîïèñàòü êèñëîòó äëÿ ãðàíàòû áåðñåðêà.

simulated event PostBeginPlay()
{
	Super(Projectile).PostBeginPlay();
	
	SetOwner(None);

	if (Role == ROLE_Authority)
	{
		Velocity = Vector(Rotation) * Speed;
		Velocity.Z += TossZ;
		Rand3 = Rand(3);
	}

	if ( Level.NetMode != NM_DedicatedServer && (Level.DetailMode == DM_Low || Level.bDropDetail) )
	{
		bDynamicLight = False;
		LightType = LT_None;
	}
}

state OnGround
{
	simulated event BeginState()
	{
        SetTimer(RestTime, False);
		BlowUp(Location);
	}
	
	simulated event Timer()
	{
		if (bDrip)
		{
			bDrip = False;
			SetCollisionSize(default.CollisionHeight, default.CollisionRadius);
			Velocity = PhysicsVolume.Gravity * 0.2;
			SetPhysics(PHYS_Falling);
			bCollideWorld = True;
			bCheckedsurface = False;
			bProjTarget = False;
			GotoState('Flying');
		}
		else 
			BlowUp(Location);
	}

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
        if ( Other != None )
			BlowUp(Location);
	}

	function TakeDamage( int Damage, Pawn InstigatedBy, Vector Hitlocation, Vector Momentum, class<DamageType> damageType, optional int HitIndex)
	{
		if ( DamageType.default.bDetonatesGoop )
		{
			bDrip = False;
			SetTimer(0.1, False);
		}
	}
	
	simulated function AnimEnd(int Channel)
	{
		local float DotProduct;

		if ( !bCheckedSurface )
		{
			DotProduct = SurfaceNormal dot Vect(0,0,-1);
			if (DotProduct > 0.7)
			{
				bDrip = True;
				SetTimer(DripTime, False);
				if (bOnMover)
					BlowUp(Location);
			}
			else if (DotProduct > -0.5)
			{
				if (bOnMover)
					BlowUp(Location);
			}
			bCheckedSurface = True;
		}
	}
	
	simulated function MergeWithGlob(int AdditionalGoopLevel)
	{
		local int NewGoopLevel, ExtraSplash;
		NewGoopLevel = AdditionalGoopLevel + GoopLevel;
		if (NewGoopLevel > MaxGoopLevel)
		{
			Rand3 = (Rand3 + 1) % 3;
			ExtraSplash = Rand3;
			if ( Role == ROLE_Authority )
				SplashGlobs(NewGoopLevel - MaxGoopLevel + ExtraSplash);
			NewGoopLevel = MaxGoopLevel - ExtraSplash;
		}
		SetGoopLevel(NewGoopLevel);
		SetCollisionSize( (GoopVolume * 10.0), (GoopVolume * 10.0));
		PlaySound(ImpactSound, SLOT_Misc);
		bCheckedSurface = False;
		SetTimer(RestTime, False);
	}
}

singular function SplashGlobs(int NumGloblings)
{
    local int g;
    local KFBloatVomit NewGlob;
    local Vector VNorm;

    for (g=0; g<NumGloblings; g++)
    {
        NewGlob = Spawn(Class, Instigator,, (Location + GoopVolume * (CollisionHeight + 4.0) * SurfaceNormal));
        if (NewGlob != None)
        {
            NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
            if (Physics == PHYS_Falling)
            {
                VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
                NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
            }
            NewGlob.InstigatorController = InstigatorController;
        }
        //else log("unable to spawn globling");
    }
}

simulated event Destroyed()
{
    if ( !bNoFX && EffectIsRelevant(Location,False) )
    {
        //Spawn(class'xEffects.GoopSmoke');
        Spawn(class'KFmod.VomGroundSplash');
    }
    if ( Fear != None )
        Fear.Destroy();
    if (Trail != None)
        Trail.Destroy();
    //Super.Destroyed();
}


auto state Flying
{
    simulated event Landed( Vector HitNormal )
    {
        local Rotator NewRot;
        local int CoreGoopLevel;

        if ( Level.NetMode != NM_DedicatedServer )
        {
            PlaySound(ImpactSound, SLOT_Misc);
            // explosion effects
        }

        SurfaceNormal = HitNormal;

        // spawn globlings
        CoreGoopLevel = Rand3 + MaxGoopLevel - 3;
        if (GoopLevel > CoreGoopLevel)
        {
            if (Role == ROLE_Authority)
                SplashGlobs(GoopLevel - CoreGoopLevel);
            SetGoopLevel(CoreGoopLevel);
        }
        Spawn(class'KFMod.VomitDecal',,,, rotator(-HitNormal));

        bCollideWorld = False;
        SetCollisionSize(GoopVolume*10.0, GoopVolume*10.0);
        bProjTarget = True;

        NewRot = Rotator(HitNormal);
        NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = False;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

	simulated singular event HitWall( Vector HitNormal, Actor Wall )
	{
		Landed(HitNormal);
		if ( !Wall.bStatic && !Wall.bWorldGeometry )
		{
			bOnMover = True;
			SetBase(Wall);
			if (Base == None)
				BlowUp(Location);
		}
	}

	simulated function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if( ExtendedZCollision(Other)!=None )
			Return;
		if (Other != Instigator && (Other.IsA('Pawn') || Other.IsA('DestroyableObjective') || Other.bProjTarget))
			HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
		else if ( Other != Instigator && Other.bBlockActors )
			HitWall( Normal(HitLocation-Location), Other );
	}
}

defaultproperties
{
     BaseDamage=3
     TouchDetonationDelay=0.000000
     Speed=400.000000
     Damage=4.000000
     MomentumTransfer=2000.000000
     MyDamageType=Class'KFMod.DamTypeVomit'
     ImpactSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_AcidSplash'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'kf_gore_trip_sm.puke.puke_chunk'
     bDynamicLight=False
     LifeSpan=8.000000
     Skins(0)=Texture'kf_fx_trip_t.Gore.pukechunk_diffuse'
     bUseCollisionStaticMesh=False
     bBlockHitPointTraces=False
}
