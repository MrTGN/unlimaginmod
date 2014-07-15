//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenBenelliM4Pickup
//	Parent class:	 UM_BenelliM4Pickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:46
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenBenelliM4Pickup extends UM_BenelliM4Pickup;


defaultproperties
{
     Weight=5.000000
	 cost=2200
	 BuyClipSize=6
	 Description="Gold plating, polished until it shines and twinkles. Just the thing for the serious Zed-slayer."
     ItemName="Golden Benelli M4 Super 90"
     ItemShortName="Golden Benelli M4"
     InventoryType=Class'UnlimaginMod.UM_GoldenBenelliM4Shotgun'
     PickupMessage="You got the Golden Benelli M4."
     Skins(0)=Texture'KF_Weapons3rd_Gold_T.Weapons.Gold_Benelli_3rd'
}
