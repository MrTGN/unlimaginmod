//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ExtendedZCollision
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
class UM_ExtendedZCollision extends ExtendedZCollision
	NotPlaceable
	Transient;



defaultproperties
{
     bGameRelevant=True
	 bNetTemporary=False
	 bNetInitialRotation=True
	 bReplicateInstigator=True
	 bReplicateMovement=True
	 bUpdateSimulatedPosition=True
	 RemoteRole=ROLE_SimulatedProxy
	 LifeSpan=0.0
}
