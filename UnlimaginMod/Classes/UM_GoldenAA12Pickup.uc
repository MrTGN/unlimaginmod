//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenAA12Pickup
//	Parent class:	 UM_AA12Pickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:30
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenAA12Pickup extends UM_AA12Pickup;


defaultproperties
{
     Weight=8.000000
	 cost=4200
	 ItemName="Golden AA12 Shotgun"
     ItemShortName="Golden AA12 Shotgun"
     AmmoItemName="12-gauge shells"
     InventoryType=Class'UnlimaginMod.UM_GoldenAA12AutoShotgun'
     PickupMessage="You got the Golden AA12 auto shotgun."
     StaticMesh=StaticMesh'KF_pickupsGold_Trip.AA12Gold_Pickup'
     Skins(0)=Texture'KF_Weapons3rd_Gold_T.Weapons.Gold_AA12_3rd'
}
