//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_GoldenFlameThrowerPickup
//	Parent class:	 UM_FlameThrowerPickup
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 01.11.2013 09:37
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_GoldenFlameThrowerPickup extends UM_FlameThrowerPickup;


defaultproperties
{
     Weight=9.000000
	 cost=950
	 ItemName="Golden Flamethrower"
     ItemShortName="Golden Flamethrower"
     InventoryType=Class'UnlimaginMod.UM_GoldenFlameThrower'
     PickupMessage="You got the Golden Flamethrower."
     StaticMesh=StaticMesh'KF_pickupsGold_Trip.FlamethrowerGold_Pickup'
     Skins(0)=Texture'KF_Weapons3rd_Gold_T.Weapons.Gold_Flamethrower_3rd'
}