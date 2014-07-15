//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MK23Pickup
//	Parent class:	 MK23Pickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.07.2012 9:28
//================================================================================
class UM_MK23Pickup extends MK23Pickup;

function inventory SpawnCopy( pawn Other )
{
	local Inventory I;

	For( I=Other.Inventory; I!=None; I=I.Inventory )
	{
		if( UM_MK23Pistol(I)!=None )
		{
			if( Inventory!=None )
				Inventory.Destroy();
			InventoryType = class'UM_DualMK23Pistol';
			AmmoAmount[0] += UM_MK23Pistol(I).AmmoAmount(0);
			I.Destroyed();
			I.Destroy();
			Return Super(KFWeaponPickup).SpawnCopy(Other);
		}
	}
	InventoryType = Default.InventoryType;
	Return Super(KFWeaponPickup).SpawnCopy(Other);
}

defaultproperties
{
     Weight=2.000000
     cost=500
     AmmoCost=18
     BuyClipSize=15
     ItemName="MK23"
     ItemShortName="MK23"
     InventoryType=Class'UnlimaginMod.UM_MK23Pistol'
     PickupMessage="You got the MK23"
}
