/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BaseMonster_RocketHusk
	Creation date:	 20.03.2016 18:39
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
class UM_BaseMonster_RocketHusk extends UM_BaseMonster_Husk
	Abstract;

//========================================================================
//[block] Variables

var()   float   ExplosiveDamageScale;        // How much to reduce explosive damage for the Husk

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
            ExplosiveDamageScale = default.ExplosiveDamageScale * 2.0;
        }
        else if ( Level.Game.GameDifficulty < 4.0 )  {
            ProjectileFireInterval = default.ProjectileFireInterval * 1.0;
            ExplosiveDamageScale = default.ExplosiveDamageScale * 1.0;
        }
        else if ( Level.Game.GameDifficulty < 5.0 )  {
            ProjectileFireInterval = default.ProjectileFireInterval * 0.75;
            ExplosiveDamageScale = default.ExplosiveDamageScale * 0.75;
        }
        // Hardest difficulty
		else  {
            ProjectileFireInterval = default.ProjectileFireInterval * 0.60;
            ExplosiveDamageScale = default.ExplosiveDamageScale * 0.5;
        }
		//Randomizing
		ExplosiveDamageScale *= Lerp( FRand(), 0.95, 1.05 );
		ProjectileFireInterval *= Lerp( FRand(), 0.9, 1.1 );
	}

	Super(UM_BaseMonster).PostBeginPlay();
}

function AdjustTakenDamage( 
	out		int					Damage, 
			Pawn				InstigatedBy, 
			vector				HitLocation, 
	out		vector				Momentum, 
			class<DamageType>	DamageType, 
			bool				bIsHeadShot )
{
	// Reduced damage from explosive
	if ( Class<UM_BaseDamType_Explosive>(DamageType) != None || DamageType == class'DamTypeFrag' || DamageType == class'DamTypePipeBomb' || DamageType == class'DamTypeM79Grenade' || DamageType == class'DamTypeM32Grenade' || DamageType == class'DamTypeM203Grenade' || DamageType == class'DamTypeSPGrenade' || DamageType == class'DamTypeSealSquealExplosion' || DamageType == class'DamTypeSeekerSixRocket' )
		Damage = Round( float(Damage) * ExplosiveDamageScale );
}
//[end] Functions
//====================================================================

defaultproperties
{
     ExplosiveDamageScale=0.25
	 HuskProjectileClass=Class'UnlimaginMod.UM_HuskExplosiveProjectile'
}
