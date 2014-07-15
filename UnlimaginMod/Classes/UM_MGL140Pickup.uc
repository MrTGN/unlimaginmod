//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_MGL140Pickup
//	Parent class:	 UM_BaseGrenadeLauncherPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 05:45
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_MGL140Pickup extends UM_BaseGrenadeLauncherPickup;


defaultproperties
{
     Weight=7.000000
     cost=3000
     AmmoCost=80
     BuyClipSize=6
     PowerValue=85
     SpeedValue=65
     RangeValue=75
     Description="An advanced semi-automatic tactical grenade launcher. Launches high explosive RMC grenades."
     ItemName="MGL140 Tactical"
     ItemShortName="MGL140 Tactical"
     AmmoItemName="MGL140 RMC Grenades"
     //showMesh=SkeletalMesh'KF_Weapons3rd2_Trip.M32_MGL_3rd'
     AmmoMesh=StaticMesh'KillingFloorStatics.XbowAmmo'
     CorrespondingPerkIndex=6
     EquipmentCategoryID=2
     MaxDesireability=0.790000
     InventoryType=Class'UnlimaginMod.UM_MGL140Tactical'
     PickupMessage="You got the MGL140 Tactical."
     PickupSound=Sound'KF_M79Snd.M79_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Supers.M32_MGL_Pickup'
     CollisionRadius=25.000000
     CollisionHeight=10.000000
}
