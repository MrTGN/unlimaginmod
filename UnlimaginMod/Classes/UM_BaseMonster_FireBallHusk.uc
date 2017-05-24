/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseMonster_FireBallHusk
	Creation date:	 20.03.2016 18:38
----------------------------------------------------------------------------------
	Copyright © 2016 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

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
class UM_BaseMonster_FireBallHusk extends UM_BaseMonster_Husk
	Abstract;

//========================================================================
//[block] Variables

var()   float   BurnDamageScale;        // How much to reduce fire damage for the Husk

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
	// Difficulty Scaling
	if ( Level.Game != None && !bDiffAdjusted )  {
        if ( Level.Game.GameDifficulty < 2.0 )  {
            ProjectileFireInterval = default.ProjectileFireInterval * 1.25;
            BurnDamageScale = default.BurnDamageScale * 2.0;
        }
        else if ( Level.Game.GameDifficulty < 4.0 )  {
            ProjectileFireInterval = default.ProjectileFireInterval * 1.0;
            BurnDamageScale = default.BurnDamageScale * 1.0;
        }
        else if ( Level.Game.GameDifficulty < 5.0 )  {
            ProjectileFireInterval = default.ProjectileFireInterval * 0.75;
            BurnDamageScale = default.BurnDamageScale * 0.75;
        }
        // Hardest difficulty
		else  {
            ProjectileFireInterval = default.ProjectileFireInterval * 0.60;
            BurnDamageScale = default.BurnDamageScale * 0.5;
        }
		//Randomizing
		BurnDamageScale *= Lerp( FRand(), 0.95, 1.05 );
		ProjectileFireInterval *= Lerp( FRand(), 0.9, 1.1 );
	}

	Super(UM_BaseMonster).PostBeginPlay();
}

function int AdjustTakenDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, class<DamageType> DamageType, bool bIsHeadShot )
{
	// Reduced damage from fire
	if ( DamageType == class 'DamTypeBurned' || DamageType == class 'DamTypeFlamethrower'
		 || Class<UM_BaseDamType_Flame>(DamageType) != None )
		Return Round( float(Damage) * BurnDamageScale );
	
	Return Damage;
}
//[end] Functions
//====================================================================


defaultproperties
{
     BurnDamageScale=0.25
	 HuskProjectileClass=Class'UnlimaginMod.UM_HuskNapalmProjectile'
}
