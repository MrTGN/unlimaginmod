//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M99Pickup
//	Parent class:	 UM_BaseSniperRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:59
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M99Pickup extends UM_BaseSniperRiflePickup;


defaultproperties
{
     Weight=11.000000
     cost=4200
     AmmoCost=40
     BuyClipSize=1
     PowerValue=95
     SpeedValue=30
     RangeValue=100
     Description="M99 50 Caliber Single Shot Sniper Rifle - The ultimate in long range accuracy and knock down power."
     ItemName="M99 AMR"
     ItemShortName="M99 AMR"
     AmmoItemName="50 Cal Bullets"
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     MaxDesireability=0.790000
     InventoryType=Class'UnlimaginMod.UM_M99SniperRifle'
     PickupMessage="You got the M99 Sniper Rifle."
     PickupSound=Sound'KF_M99Snd.M99_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups4_Trip.Rifles.M99_Sniper_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=10.000000
}
