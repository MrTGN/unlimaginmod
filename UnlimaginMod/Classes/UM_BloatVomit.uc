/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BloatVomit
	Creation date:	 25.12.2014 18:09
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_BloatVomit extends KFBloatVomit;

//========================================================================
//[block] Variables

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

simulated event PreBeginPlay()
{
	Super(Actor).PreBeginPlay();
	Instigator = Pawn(Owner);
}

simulated event PostBeginPlay()
{
	if ( Role == ROLE_Authority )  {
		Velocity = Vector(Rotation) * Speed;
		Velocity.Z += TossZ;
		Rand3 = Rand(3);
	}

	if ( Level.NetMode != NM_DedicatedServer && (Level.DetailMode == DM_Low || Level.bDropDetail) )  {
		bDynamicLight = False;
		LightType = LT_None;
	}

	// Difficulty Scaling
	if ( Level.Game != None )  {
		BaseDamage = Max((DifficultyDamageModifer() * BaseDamage), 1);
		Damage = Max((DifficultyDamageModifer() * Damage), 1);
	}
}

function BlowUp(Vector HitLocation)
{
    if ( Role == ROLE_Authority )  {
        //Damage = BaseDamage + Damage * GoopLevel;
		Damage = BaseDamage - Round(Damage * GoopLevel);
        DamageRadius = DamageRadius * GoopVolume;
        MomentumTransfer = MomentumTransfer * GoopVolume;
        if ( Physics == PHYS_Flying )
			MomentumTransfer *= 0.5;
		DelayedHurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation);
    }

    PlaySound(ExplodeSound, SLOT_Misc);

    Destroy();
    //GotoState('shriveling');
}


singular function SplashGlobs(int NumGloblings)
{
    local	int				g;
    local	KFBloatVomit	NewGlob;
    local	Vector			VNorm;

	for ( g = 0; g < NumGloblings; ++g )  {
		NewGlob = Spawn( Class, Instigator,, (Location + GoopVolume * (CollisionHeight + 4.0) * SurfaceNormal) );
		if ( NewGlob != None )  {
			NewGlob.InstigatorController = InstigatorController;
			NewGlob.Velocity = (GloblingSpeed + FRand()*150.0) * (SurfaceNormal + VRand()*0.8);
			if ( Physics == PHYS_Falling )  {
				VNorm = (Velocity dot SurfaceNormal) * SurfaceNormal;
				NewGlob.Velocity += (-VNorm + (Velocity - VNorm)) * 0.1;
			}
			
		}
		//else log("unable to spawn globling");
	}
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
        SetCollisionSize( (GoopVolume * 10.0), (GoopVolume * 10.0) );
        bProjTarget = True;

        NewRot = Rotator(HitNormal);
        NewRot.Roll += 32768;
        SetRotation(NewRot);
        SetPhysics(PHYS_None);
        bCheckedsurface = False;
        Fear = Spawn(class'AvoidMarker');
        GotoState('OnGround');
    }

	simulated event HitWall( Vector HitNormal, Actor Wall )
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
		if ( Instigator != None && Other.Base == Instigator )
			Return;
		
		if ( Other != Instigator && (Pawn(Other) != None || DestroyableObjective(Other) != None || Other.bProjTarget) )
			HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
		else if ( Other != Instigator && Other.bBlockActors )
			HitWall( Normal(HitLocation-Location), Other );
	}
}


//[end] Functions
//====================================================================

defaultproperties
{
     Speed=400.000000
     BaseDamage=8
	 Damage=4.000000
	 MyDamageType=Class'KFMod.DamTypeVomit'
     ImpactSound=SoundGroup'KF_EnemiesFinalSnd.Bloat.Bloat_AcidSplash'
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'kf_gore_trip_sm.puke.puke_chunk'
}
