//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenAA12AutoShotgun
//	Parent class:	 UM_AA12AutoShotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 09.07.2013 21:02
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenAA12AutoShotgun extends UM_AA12AutoShotgun;


defaultproperties
{
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Gold_AA12'
     SkinRefs(0)="KF_Weapons_Gold_T.Weapons.Gold_AA12_cmb"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Gold_AA12_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Gold_AA12"
     PickupClass=Class'UnlimaginMod.UM_GoldenAA12Pickup'
     AttachmentClass=Class'UnlimaginMod.UM_GoldenAA12Attachment'
     ItemName="Golden AA12"
	 FireModeClass(0)=Class'UnlimaginMod.UM_GoldenAA12Fire'
}
