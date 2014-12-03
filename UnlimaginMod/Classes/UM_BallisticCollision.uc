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

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

//[end] Functions
//====================================================================

defaultproperties
{
	 ImpactStrength=0.025
	 FrictionCoefficient=0.54
	 PlasticityCoefficient=0.39
	 // Lighting
	 bLightingVisibility=False
	 bAcceptsProjectors=False
	 // Collision flags
	 bCollideActors=False
	 bCollideWorld=False
	 bBlockActors=False
	 bBlockPlayers=False
	 bBlockProjectiles=True
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
	 CollisionRadius=1.0
	 CollisionHeight=1.0
	 // Advanced
	 bGameRelevant=True
	 bMovable=True
	 bCanBeDamaged=True
     // Networking flags
	 bNetTemporary=False
	 bReplicateMovement=True
	 bReplicateInstigator=True
	 bNetInitialRotation=True
	 bUpdateSimulatedPosition=True
	 RemoteRole=ROLE_SimulatedProxy
	 // Display
	 DrawType=DT_None
	 SurfaceType=EST_Flesh
	 LifeSpan=0.0
}
