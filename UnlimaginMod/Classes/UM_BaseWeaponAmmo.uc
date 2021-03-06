//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseWeaponAmmo
//	Parent class:	 KFAmmunition
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 20.06.2013 20:19
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
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
		//Todo: ����趺, ��� �瑕�韲琿���� 碚裼瑜瑰 ��頸瑯��� �� ���, 鞦� 糂� �珞�� 
		// MaxAmmo ������ ���� ����赳褪�� �� level 鞳����, ���� � � �褞襃頌琿 ��� ��� �������.
		// ﾄ�! MaxAmmo ��頸瑯��� � KFHumanPawn, �瑕 ��� ���� ����褊�韲 ��� ��褊�.

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
