//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPSniperPickup
//	Parent class:	 UM_BaseSniperRiflePickup
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 01.11.2013 10:22
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SPSniperPickup extends UM_BaseSniperRiflePickup;


defaultproperties
{
     Weight=6.000000
     cost=1600
     AmmoCost=25
	 BuyClipSize=10
     PowerValue=60
     SpeedValue=10
     RangeValue=95
     Description="A finely crafted long rifle from the Victorian era fitted with telescopic aiming optics."
     ItemName="Single Piston Longmusket"
     ItemShortName="S.P. Musket"
     AmmoItemName="S.P. Musket bullets"
     CorrespondingPerkIndex=2
     EquipmentCategoryID=3
     InventoryType=Class'UnlimaginMod.UM_SPSniperRifle'
     PickupMessage="You got the Single Piston Longmusket"
     PickupSound=Sound'KF_SP_LongmusketSnd.KFO_Sniper_Pickup'
     PickupForce="AssaultRiflePickup"
     StaticMesh=StaticMesh'KF_IJC_Summer_Weps.SniperRifle'
     CollisionRadius=25.000000
     CollisionHeight=5.000000
}
