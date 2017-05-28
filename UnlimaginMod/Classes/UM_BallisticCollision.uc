/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_BallisticCollision
	Creation date:	 02.12.2014 12:23
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
class UM_BallisticCollision extends UM_BaseActor
	Abstract;

//========================================================================
//[block] Variables

const 	BaseActor = Class'UnlimaginMod.UM_BaseActor';

var			float			ImpactStrength;			// J / mm2
var			range			ImpactStrengthScaleRange;
var			float			FrictionCoefficient;	// Surface material friction coefficient. 1.0 - no friction. 0.0 - 100% friction.
var			float			PlasticityCoefficient;	// Plasticity coefficient of the surface material. 1.0 - not plastic material. 0.0 - 100% plastic material.
var			float			DamageScale;
var			int				Health, HealthMax;
var			range			HealthScaleRange;

var			Controller		InstigatorController;
var			int				InstigatorTeamNum;

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

// Updates InstigatorTeamNum
simulated function UpdateInstigatorTeamNum()
{
	if ( Instigator != None )
		InstigatorTeamNum = Instigator.GetTeamNum();
	else if ( InstigatorController != None )
		InstigatorTeamNum = InstigatorController.GetTeamNum();
}

// Updates and returns InstigatorTeamNum
simulated function int GetInstigatorTeamNum()
{
	Return InstigatorTeamNum;
}

// Set new Instigator
simulated function SetInstigator( Pawn NewInstigator )
{
	if ( Instigator != NewInstigator )
		Instigator = NewInstigator;
	
	// InstigatorController
	if ( Instigator != None )
		InstigatorController = Instigator.Controller;
	
	UpdateInstigatorTeamNum();
}

event PreBeginPlay()
{
	// Updating Instigator on the server
	if ( Role == ROLE_Authority )  {
		if ( Pawn(Owner) != None )
			SetInstigator( Pawn(Owner) );
		else
			SetInstigator( Instigator );
	}
}

simulated event PostNetBeginPlay()
{
	// Updating Instigator on clients
	if ( Role < ROLE_Authority )
		SetInstigator( Instigator );
}

function SetImpactStrength( float NewImpactStrength )
{
	ImpactStrength = NewImpactStrength * Lerp(FRand(), ImpactStrengthScaleRange.Min, ImpactStrengthScaleRange.Max);
}

function SetInitialHealth( float InitialHealth )
{
	HealthMax = Round( InitialHealth * Lerp(FRand(), HealthScaleRange.Min, HealthScaleRange.Max) );
	Health = HealthMax;
}

simulated function vector GetCollisionExtetnt()
{
	Return CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0);
}

simulated function float GetCollisionVSize()
{
	Return VSize(CollisionRadius * Vect(1.0, 1.0, 0.0) + CollisionHeight * Vect(0.0, 0.0, 1.0));
}

// Disable Collision 
// Useful before calling latent Destroy() function.
simulated function DisableCollision()
{
	if ( bCanBeDamaged )  {
		bCanBeDamaged = False;
		bProjTarget = False;
		bBlockZeroExtentTraces = False;
		bBlockNonZeroExtentTraces = False;
		SetCollision(False);
	}
}

simulated event BaseChange()
{
	if ( Base == None || Base.bDeleteMe )  {
		DisableCollision();
		Destroy();
	}
}

simulated function bool CanBeDamaged()
{
	Return bCanBeDamaged && Instigator != None && !Instigator.bDeleteMe && Instigator.Health > 0;
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex )
{
	if ( Role < ROLE_Authority )
		Return;
	
	if ( Instigator != None )
		Instigator.TakeDamage( Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex );
	else
		Log("No base Pawn!", Name);
}

//[end] Functions
//====================================================================

defaultproperties
{
	 // if ImpactStrength < 6.0 standard 19x9mm bullet can penetrate this area
	 // ImpactStrength * ProjectileCrossSectionalArea = Energy to penetrate this area
	 ImpactStrength=8.0
	 ImpactStrengthScaleRange=(Min=0.9,Max=1.1)
	 HealthScaleRange=(Min=0.9,Max=1.1)
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
	 bBlockHitPointTraces=False
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
	 //bReplicateMovement=True
	 bReplicateMovement=False
	 bReplicateInstigator=True
	 //bNetInitialRotation=True
	 bNetInitialRotation=False
	 //bUpdateSimulatedPosition=True
	 RemoteRole=ROLE_SimulatedProxy
	 // Display
	 DrawType=DT_None
	 SurfaceType=EST_Flesh
	 LifeSpan=0.0
	 Physics=PHYS_None
}
