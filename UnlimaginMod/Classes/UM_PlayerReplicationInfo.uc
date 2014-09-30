//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_PlayerReplicationInfo
//	Parent class:	 KFPlayerReplicationInfo
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.09.2014 03:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_PlayerReplicationInfo extends KFPlayerReplicationInfo;

//========================================================================
//[block] Variables

var		bool			bVeterancyChangedTrigger, bClientVeterancyChangedTrigger;
var		UM_HumanPawn	PawnOwner;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	if ( Role == ROLE_Authority && bNetDirty )
		PawnOwner, bVeterancyChangedTrigger;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

function SetPawnOwner( UM_HumanPawn NewPawnOwner )
{
	PawnOwner = NewPawnOwner;
	NetUpdateTime = Level.TimeSeconds - 1.0;
}

simulated function bool NeedNetNotify()
{
	Return ( !bRegisteredChatRoom || (!bNoTeam && Team == None) );
}

simulated function NotifyPawnsAboutTeamChanged()
{
	local	Actor	A;
	local	PlayerController	PC;

	bTeamNotified = True;
	PC = Level.GetLocalPlayerController();
	
	ForEach DynamicActors(class'Actor', A)  {
		// find my pawn and tell it
		if ( Pawn(A) != None && Pawn(A).PlayerReplicationInfo == self )  {
			Pawn(A).NotifyTeamChanged();
			if ( PC.PlayerReplicationInfo != self )
				break;
		}
		else if ( A.bNotifyLocalPlayerTeamReceived && PC.PlayerReplicationInfo == self )
			A.NotifyLocalPlayerTeamReceived(); //if this is the local player's PRI, tell actors that want to know about it
	}
}

function NotifyVeterancyChanged()
{
	bVeterancyChangedTrigger = !bVeterancyChangedTrigger;
	NetUpdateTime = Level.TimeSeconds - 1.0;
	if ( PawnOwner != None )
		PawnOwner.NotifyVeterancyChanged();
}

simulated function ClientNotifyVeterancyChanged()
{
	bClientVeterancyChangedTrigger = bVeterancyChangedTrigger;
	if ( PawnOwner != None )  {
		if ( PawnOwner.UM_PlayerReplicationInfo == None )
			PawnOwner.UM_PlayerReplicationInfo = self;
		
		PawnOwner.ClientNotifyVeterancyChanged();
	}
}

simulated event PostNetReceive()
{
	if ( Team != None && !bTeamNotified )
		NotifyPawnsAboutTeamChanged();

	if ( !bRegisteredChatRoom && VoiceInfo != None && PlayerID != default.PlayerID 
		 && VoiceID != default.VoiceID )  {
		bRegisteredChatRoom = True;
		VoiceInfo.AddVoiceChatter(Self);
	}
	
	if ( Role < ROLE_Authority && bClientVeterancyChangedTrigger != bVeterancyChangedTrigger )
		ClientNotifyVeterancyChanged();
}

//[block] --- Perk bonuses ---
simulated function int GetReducedDamage( UM_HumanPawn Injured, int Damage, Pawn Instigator, class<DamageType> DmgType )
{
	if ( ClientVeteranSkill != None )
		Return ClientVeteranSkill.static.ReduceDamage(self, Injured, Instigator, Damage, DmgType);
	
	Return Damage;
}

simulated function float GetPickupCostScaling( class<Pickup> Item )
{
	if ( ClientVeteranSkill != None )
		Return ClientVeteranSkill.static.GetCostScaling(self, Item);
	
	Return 1.0;
}

simulated function int GetMaxAmmoFor( Class<Ammunition> AmmoType )
{
	if ( ClientVeteranSkill != None )
		Return int( float(AmmoType.default.MaxAmmo) * ClientVeteranSkill.static.AddExtraAmmoFor(self, AmmoType) );
	
	Return AmmoType.default.MaxAmmo;
}

simulated function float GetPawnMaxCarryWeight( float MaxCarryWeight )
{
	if ( ClientVeteranSkill != None )
		Return MaxCarryWeight + float(ClientVeteranSkill.static.AddCarryMaxWeight(self));
	
	Return MaxCarryWeight;
}

simulated function float GetPawnJumpModifier()
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetPawnJumpModifier(self);
	
	Return 1.0;
}

simulated function int GetPawnMaxBounce()
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetPawnMaxBounce(self);
	
	Return 0;
}
//[end]

//[end] Functions
//====================================================================

defaultproperties
{
     bHidden=True
	 bOnlyRelevantToOwner=False
	 bAlwaysRelevant=True
	 RemoteRole=ROLE_SimulatedProxy
}
