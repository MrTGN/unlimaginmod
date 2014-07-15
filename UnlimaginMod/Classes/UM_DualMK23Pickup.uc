//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_DualMK23Pickup
//	Parent class:	 DualMK23Pickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 13.07.2012 9:28
//================================================================================
class UM_DualMK23Pickup extends DualMK23Pickup;

defaultproperties
{
     Weight=4.000000
     cost=1000
     AmmoCost=18
     BuyClipSize=15
     ItemName="Dual MK23"
     ItemShortName="Dual MK23"
     InventoryType=Class'UnlimaginMod.UM_DualMK23Pistol';
     PickupMessage="You found another - MK23"
}
