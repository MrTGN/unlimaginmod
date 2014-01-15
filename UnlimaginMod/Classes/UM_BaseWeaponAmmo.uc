//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponAmmo
//	Parent class:	 KFAmmunition
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.06.2013 20:19
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseWeaponAmmo extends KFAmmunition
	Abstract;


//========================================================================
//[block] Variables

var		int		RoundsPerBox;	// How Much Rounds in ammo box. Used for extended bonuses calculation

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

/* 
function bool HandlePickupQuery( pickup Item )
{
	if ( class == Item.InventoryType )
	{
		//Todo: ïîõîæå, ÷òî ìàêñèìàëüíûå áîåçàïàñ ñ÷èòàåòñÿ íå òóò, èáî âñå ðàâíî 
		// MaxAmmo ïðîñòî òóïî óìíîæàåòñÿ íà level èãðîêà, õîòÿ ÿ è ïåðåïèñàë òóò ýòó ôóíêöèþ.
		// Äà! MaxAmmo ñ÷èòàåòñÿ â KFHumanPawn, òàê ÷òî ïîêà êîììåíòèì ýòó õðåíü.

		if ( KFPawn(Owner) != None &&
			 KFPlayerReplicationInfo(KFPawn(Owner).PlayerReplicationInfo) != None &&
			 KFPlayerReplicationInfo(KFPawn(Owner).PlayerReplicationInfo).ClientVeteranSkill != None )
			MaxAmmo = Default.MaxAmmo + (RoundsPerBox * KFPlayerReplicationInfo(KFPawn(Owner).PlayerReplicationInfo).ClientVeteranSkill.Static.AddExtraAmmoFor(KFPlayerReplicationInfo(KFPawn(Owner).PlayerReplicationInfo), Class));
		else
			MaxAmmo = Default.MaxAmmo;

		if ( AmmoAmount == MaxAmmo )
			Return True;

		Item.AnnouncePickup(KFPawn(Owner));
		AddAmmo(UM_BaseWeaponAmmoPickup(Item).AmmoAmount);
        Item.SetRespawn();

		Return True;
	}

	if ( Inventory == None )
		Return False;

	Return Inventory.HandlePickupQuery(Item);
} */

function bool AddAmmo(int AmmoToAdd)
{
	if ( Level.GRI.WeaponBerserk > 1.0 )
		AmmoAmount = MaxAmmo;
	else if ( AmmoAmount < MaxAmmo )
		AmmoAmount = Min(MaxAmmo, (AmmoAmount + AmmoToAdd));
    
	NetUpdateTime = Level.TimeSeconds - 1;
	
	Return True;
}

//[end] Functions
//====================================================================


defaultproperties
{
     RoundsPerBox=30
}
