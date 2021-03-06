//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_GoldenFlameThrower
//	Parent class:	 UM_FlameThrower
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 09.07.2013 22:23
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_GoldenFlameThrower extends UM_FlameThrower;


defaultproperties
{
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Gold_Flamethrower'
     SkinRefs(0)="KF_Weapons_Gold_T.Weapons.Gold_Flamethrower_cmb"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Gold_Flamethrower_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Gold_Flamethrower"
     //FireModeClass(0)=Class'KFMod.GoldenFlameBurstFire'
     PickupClass=Class'UnlimaginMod.UM_GoldenFlameThrowerPickup'
     AttachmentClass=Class'UnlimaginMod.UM_GoldenFlameThrowerAttachment'
     ItemName="Golden Flamethrower"
}
