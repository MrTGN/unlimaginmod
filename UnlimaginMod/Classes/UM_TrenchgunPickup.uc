//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_TrenchgunPickup
//	Parent class:	 UM_BaseShotgunPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:39
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_TrenchgunPickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=6.000000
     cost=1250
     BuyClipSize=6
     PowerValue=75
     SpeedValue=40
     RangeValue=15
     Description="A WWII era trench shotgun. Oh, this one has been filled with dragon's breath flame rounds."
     ItemName="Winchester Model 1897"
     ItemShortName="Winchester M1897"
     AmmoItemName="Dragon's breath shells"
     CorrespondingPerkIndex=5
     EquipmentCategoryID=2
     InventoryType=Class'UnlimaginMod.UM_Trenchgun'
     PickupMessage="You got the Winchester M1897."
     PickupSound=Sound'KF_ShotgunDragonsBreathSnd.Handling.TrenchGun_Pump_Back'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups5_Trip.Rifles.TrenchGun_Pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
