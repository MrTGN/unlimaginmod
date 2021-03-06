/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseMonsterExplosiveProjectile
	Creation date:	 25.12.2014 12:40
----------------------------------------------------------------------------------
	Copyright � 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright � 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright � 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/MrTGN/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_BaseMonsterExplosiveProjectile extends UM_BaseExplosiveProjectile
	Abstract;

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

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	if ( UM_GameReplicationInfo(Level.GRI) != None )  {
		if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 2.0 )
			Damage = default.Damage * 0.75 * Lerp( FRand(), 0.95, 1.05 );
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 4.0 )
			Damage = default.Damage * 1.0 * Lerp( FRand(), 0.95, 1.05 );
		else if ( UM_GameReplicationInfo(Level.GRI).GameDifficulty < 5.0 )
			Damage = default.Damage * 1.15 * Lerp( FRand(), 0.95, 1.05 );
		// Hardest difficulty
		else
			Damage = default.Damage * 1.25 * Lerp( FRand(), 0.95, 1.05 );
	}
}

simulated event Landed( vector HitNormal )
{
	Super(UM_BaseProjectile).Landed(HitNormal);
	if ( IsArmed() )
		Explode((Location + ExploWallOut * HitNormal), HitNormal);
}

simulated singular event HitWall(vector HitNormal, actor Wall)
{
	if ( CanTouchActor(Wall) )  {
		HurtWall = Wall;
		ProcessTouchActor(Wall);
	}
	else
		Landed(HitNormal);
	HurtWall = None;
}

//[end] Functions
//====================================================================

defaultproperties
{
     bAutoLifeSpan=True
	 bDelayArming=True
	 ArmingDelay=0.2
	 UpdateTimeDelay=0.100000
	 ShrapnelClass=None
	 CullDistance=5000.000000
	 ImpactDamage=0.0
	 ImpactDamageType=None
	 bCanHurtSameTypeProjectile=False
	 bCanHurtOwner=False
	 ProjectileDiameter=40.0
	 ProjectileMass=250.0	// grams
     //MuzzleVelocity
	 MuzzleVelocity=80.000000	// m/sec
	 //EffectiveRange
	 EffectiveRange=500.000000	// Meters
	 BallisticRandRange=(Min=0.85,Max=1.15)
	 bBounce=True
	 bCanRicochet=False
	 bOrientToVelocity=True
	 //Physics
	 Physics=PHYS_Projectile
	 //RemoteRole
     RemoteRole=ROLE_SimulatedProxy
	 bNetNotify=True
}
