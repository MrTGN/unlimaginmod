//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ExtendedCollision
//	Parent class:	 ExtendedZCollision
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 23.04.2014 21:49
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_ExtendedCollision extends ExtendedZCollision
	NotPlaceable
	Transient;

// Damage the player this is attached to
event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional int HitIndex)
{
	if ( Owner != None )
		Owner.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitIndex);
}

defaultproperties
{
     bGameRelevant=True
	 bNetTemporary=False
	 bNetInitialRotation=True
	 bReplicateInstigator=True
	 bReplicateMovement=True
	 RemoteRole=ROLE_SimulatedProxy
	 NetUpdateFrequency=100.000000
     LifeSpan=0.0
	 DrawType=DT_None
     bIgnoreEncroachers=True
     SurfaceType=EST_Flesh
     bCollideActors=True
     bProjTarget=True
     bUseCylinderCollision=True
}
