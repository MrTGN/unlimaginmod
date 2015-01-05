/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BallisticCollision
	Creation date:	 02.12.2014 12:23
----------------------------------------------------------------------------------
	Copyright © 2014 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 
==================================================================================*/
class UM_BallisticCollision extends UM_BaseActor
	Abstract;

//========================================================================
//[block] Variables

var			float			ImpactStrength;			// J / mm2
var			float			FrictionCoefficient;	// Surface material friction coefficient. 1.0 - no friction. 0.0 - 100% friction.
var			float			PlasticityCoefficient;	// Plasticity coefficient of the surface material. 1.0 - not plastic material. 0.0 - 100% plastic material.
var			float			DamageScale;
var			int				Health, HealthMax;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	reliable if ( Role == ROLE_Authority && bNetDirty )
		ImpactStrength, DamageScale, Health, HealthMax;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

event PreBeginPlay()
{
	if ( Pawn(Owner) != None )
		Instigator = Pawn(Owner);
}

simulated function vector GetCollisionExtetnt()
{
	Return CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0);
}

simulated function float GetCollisionVSize()
{
	Return VSize(CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0));
}

simulated event BaseChange()
{
	if ( Base == None || Base.bDeleteMe )
		Destroy();
}

simulated function bool CanBeDamaged()
{
	Return bCanBeDamaged && Base != None && !Base.bDeleteMe;
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	if ( Base != None )
		Base.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex );
	else
		Log("No base Pawn!",Name);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // if ImpactStrength < 6.0 standard 19x9mm bullet can penetrate this area
	 // ImpactStrength * ProjectileCrossSectionalArea = Energy to penetrate this area
	 ImpactStrength=8.0
	 FrictionCoefficient=0.54
	 PlasticityCoefficient=0.39
	 // Lighting
	 bLightingVisibility=False
	 bAcceptsProjectors=False
	 // Collision flags
	 bCollideActors=True
	 bCollideWorld=False
	 bBlockActors=False
	 bBlockPlayers=False
	 bProjTarget=True
	 bBlockZeroExtentTraces=True
	 bBlockNonZeroExtentTraces=True
	 bUseCylinderCollision=True
	 bBlockKarma=False
	 bBlocksTeleport=False
	 bPathColliding=False
	 bIgnoreEncroachers=True
	 bIgnoreOutOfWorld=True
	 // Just default values
	 CollisionRadius=0.0
	 CollisionHeight=0.0
	 // Advanced
	 bGameRelevant=True
	 bMovable=True
	 bCanBeDamaged=True
     // Networking flags
	 bNetTemporary=False
	 bReplicateMovement=True
	 bReplicateInstigator=True
	 bNetInitialRotation=True
	 //bUpdateSimulatedPosition=True
	 RemoteRole=ROLE_SimulatedProxy
	 // Display
	 DrawType=DT_None
	 SurfaceType=EST_Flesh
	 LifeSpan=0.0
	 Physics=PHYS_None
}
