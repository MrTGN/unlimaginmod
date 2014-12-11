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

var		bool				bVeterancyChangedTrigger, bClientVeterancyChangedTrigger;
var		UM_HumanPawn		HumanOwner;

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

replication
{
	if ( Role == ROLE_Authority && bNetDirty )
		HumanOwner;
	
	// Replication from the server to the client-owner
	if ( Role == ROLE_Authority && bNetDirty && bNetOwner )
		bVeterancyChangedTrigger;
}

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

function SetHumanOwner( UM_HumanPawn NewHumanOwner )
{
	HumanOwner = NewHumanOwner;
}

simulated function bool NeedNetNotify()
{
	Return !bRegisteredChatRoom || (!bNoTeam && Team == None);
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

// Notification on the server and on the client-owner that veterancy has been changed.
simulated function NotifyVeterancyChanged()
{
	// Server trigger
	if ( Role == ROLE_Authority )  {
		bVeterancyChangedTrigger = !bVeterancyChangedTrigger;
		NetUpdateTime = Level.TimeSeconds - 1.0;
	}
	// client-owner trigger
	else
		bClientVeterancyChangedTrigger = bVeterancyChangedTrigger;
	
	if ( HumanOwner != None )  {
		if ( HumanOwner.UM_PlayerReplicationInfo == None )
			HumanOwner.UM_PlayerReplicationInfo = self;
		// Notify that veterancy has been changed.
		HumanOwner.NotifyVeterancyChanged();
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
	
	// client-owner
	if ( Role < ROLE_Authority && bClientVeterancyChangedTrigger != bVeterancyChangedTrigger )
		NotifyVeterancyChanged();
}

//[block] --- Perk bonuses ---
// Perk weapon restriction
simulated function bool CanUseThisWeapon( Weapon W )
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.CanUseThisWeapon(self, W);
	
	Return True;
}

simulated function float GetMovementSpeedModifier()
{
	if ( ClientVeteranSkill != None )
		Return ClientVeteranSkill.static.GetMovementSpeedModifier( self, KFGameReplicationInfo(Level.GRI) );
	
	Return 1.0;
}

// Weapon Fire Spread
simulated function float GetSpreadModifier( WeaponFire WF )
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetSpreadModifier(self, WF);
	
	Return 1.0;
}

// Weapon Fire AimError
simulated function float GetAimErrorModifier( WeaponFire WF )
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetAimErrorModifier(self, WF);
	
	Return 1.0;
}

simulated function float GetHealPotency()
{
	if ( ClientVeteranSkill != None )
		Return ClientVeteranSkill.static.GetHealPotency(self);
	
	Return 1.0;
}

// On how much this human can overheal somebody
simulated function float GetOverhealingModifier()
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetOverhealingModifier(Self);
	
	Return 1.0;
}

// Maximum Health that Human can have when he has been overhealed
simulated function float GetOverhealedHealthMaxModifier()
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetOverhealedHealthMaxModifier(Self);
	
	Return 1.0;
}

// New function to reduce taken damage
simulated function float GetHumanTakenDamageModifier( UM_HumanPawn Victim, Pawn Aggressor, class<DamageType> DamageType )
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetTakenDamageModifier(Self, Victim, Aggressor, DamageType);
	
	Return 1.0;
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

// Pawn Movement Bonus while wielding this weapon
simulated function float GetWeaponPawnMovementBonus( Weapon W )
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetWeaponPawnMovementBonus(self, W);
	
	Return 1.0;
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

simulated function float GetIntuitiveShootingModifier()
{
	if ( Class<UM_SRVeterancyTypes>(ClientVeteranSkill) != None )
		Return Class<UM_SRVeterancyTypes>(ClientVeteranSkill).static.GetIntuitiveShootingModifier(self);
	
	Return 1.0;
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
