//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12Pickup
//	Parent class:	 UM_BaseShotgunPickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 09:08
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_AA12Pickup extends UM_BaseShotgunPickup;


defaultproperties
{
     Weight=8.000000
	 cost=4000
     AmmoCost=40
     BuyClipSize=20
     PowerValue=85
     SpeedValue=65
     RangeValue=20
     Description="An advanced fully automatic shotgun."
     ItemName="AA12 Shotgun"
     ItemShortName="AA12 Shotgun"
     AmmoItemName="12-gauge drum"
     showMesh=SkeletalMesh'KF_Weapons3rd2_Trip.AA12_3rd'
     CorrespondingPerkIndex=1
     EquipmentCategoryID=3
     //VariantClasses(0)=Class'UnlimaginMod.UM_GoldenAA12AutoShotgun'
     InventoryType=Class'UnlimaginMod.UM_AA12AutoShotgun'
     PickupMessage="You got the AA12 auto shotgun."
     PickupSound=Sound'KF_AA12Snd.AA12_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_pickups2_Trip.Shotguns.AA12_Pickup'
     CollisionRadius=35.000000
     CollisionHeight=5.000000
}
