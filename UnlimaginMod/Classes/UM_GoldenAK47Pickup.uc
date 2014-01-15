//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenAK47Pickup
//	Parent class:	 UM_AK47Pickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:34
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenAK47Pickup extends UM_AK47Pickup;


defaultproperties
{
     Weight=6.000000
	 cost=1000
	 Description="Take a classic AK. Gold plate every visible piece of metal. Engrave the wood for good measure. Serious blingski."
     ItemName="Golden AK47"
     ItemShortName="Golden AK47"
     InventoryType=Class'UnlimaginMod.UM_GoldenAK47AssaultRifle'
     PickupMessage="You got the Golden AK47"
     Skins(0)=Texture'KF_Weapons3rd_Gold_T.Weapons.Gold_AK47_3rd'
}
