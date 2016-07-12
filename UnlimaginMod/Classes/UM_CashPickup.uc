/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_CashPickup
	Creation date:	 04.10.2015 00:14
----------------------------------------------------------------------------------
	Copyright © 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/MrTGN>

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
class UM_CashPickup extends CashPickup;

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

event Landed(vector HitNormal)
{
	local	StaticMeshActor	SMBase;
	local	Actor			HitActor;
	local	vector			HitLoc, HitNorm;
	local	vector			StartTrace, EndTrace;

	Super.Landed(HitNormal);

	StartTrace = Location - (vect(0,0,1) * (CollisionHeight * 0.5));
	EndTrace = StartTrace + Vect(0,0,-8) ;

	HitActor = Trace( HitLoc, HitNorm, EndTrace, StartTrace, True );
	
	SMBase = StaticMeshActor(HitActor);
	if ( SMBase != None )  {
		SetBase(SMBase);
		SMBase.OnActorLanded(self);
	}
}

function GiveCashTo( Pawn Other )
{
	if ( Other == None || Role < ROLE_Authority )
		Return;
	
	// You all love the mental-mad typecasting XD
	if( !bDroppedCash )
		CashAmount = (default.CashAmount + Rand(0.5 * default.CashAmount)) * Level.Game.GameDifficulty  * 0.5;
	else if ( PlayerController(DroppedBy) != None && Other.PlayerReplicationInfo != None && Other.PlayerReplicationInfo != DroppedBy.PlayerReplicationInfo
			  && KFSteamStatsAndAchievements(PlayerController(DroppedBy).SteamStatsAndAchievements) != None
			  && ((DroppedBy.PlayerReplicationInfo.Score + float(CashAmount)) / Other.PlayerReplicationInfo.Score) >= 0.50 )
		KFSteamStatsAndAchievements(PlayerController(DroppedBy).SteamStatsAndAchievements).AddDonatedCash(CashAmount);

	if ( Other.Controller != None && Other.Controller.PlayerReplicationInfo != None )
		Other.Controller.PlayerReplicationInfo.Score += CashAmount;

	AnnouncePickup(Other);
	SetRespawn();
}

auto state Pickup
{
	// When touched by an actor.
	event Touch( actor Other )
	{
		// If touched by a player pawn, let him pick this up.
		if ( ValidTouch(Other) )
			GiveCashTo(Pawn(Other));
	}

	function bool ValidTouch(Actor Other)
	{
		if ( bOnlyOwnerCanPickup && DroppedBy != None && Pawn(Other) != None && Pawn(Other).Controller != DroppedBy )
			Return False;

		Return Super.ValidTouch(Other);
	}

	event Timer()
	{
		if ( bDropped && !bPreventFadeOut )
			GotoState('FadeOut');
	}
}

state FallingPickup
{
	event Touch( actor Other )
	{
		if ( ValidTouch(Other) )
			GiveCashTo(Pawn(Other));
	}

	event Timer()
	{
		if ( !bPreventFadeOut )
			GotoState('FadeOut');
	}
}

State FadeOut
{
	event Touch( actor Other )
	{
		if ( ValidTouch(Other) )
			GiveCashTo(Pawn(Other));
	}
}

function AnnouncePickup( Pawn Receiver )
{
	if ( Receiver == None )
		Return;
	
	Receiver.MakeNoise(0.2);
	
	if ( Receiver.Controller != None )  {
		if ( PlayerController(Receiver.Controller) != None )
			PlayerController(Receiver.Controller).ReceiveLocalizedMessage( MessageClass, CashAmount,,, Class );
		else if ( Receiver.Controller.MoveTarget == Self )  {
			if ( MyMarker != None )  {
				Receiver.Controller.MoveTarget = MyMarker;
				Receiver.Anchor = MyMarker;
				Receiver.Controller.MoveTimer = 0.5;
			}
			else 
				Receiver.Controller.MoveTimer = -1.0;
		}
	}
	
	PlaySound( PickupSound, SLOT_Interact );
}

//[end] Functions
//====================================================================

defaultproperties
{
	 RespawnTime=0.000000
	 bPreventFadeOut=True
	 LifeSpan=0.0
}
