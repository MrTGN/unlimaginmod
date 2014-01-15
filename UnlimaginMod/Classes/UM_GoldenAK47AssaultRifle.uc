//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenAK47AssaultRifle
//	Parent class:	 UM_AK47AssaultRifle
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 30.05.2013 23:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenAK47AssaultRifle extends UM_AK47AssaultRifle;


defaultproperties
{
     TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Gold_AK47'
     SkinRefs(0)="KF_Weapons_Gold_T.Weapons.Gold_AK47_cmb"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Gold_AK47_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Gold_AK47"
     Description="Take a classic AK. Gold plate every visible piece of metal. Engrave the wood for good measure. Serious blingski."
     PickupClass=Class'UnlimaginMod.UM_GoldenAK47Pickup'
     AttachmentClass=Class'UnlimaginMod.UM_GoldenAK47Attachment'
     ItemName="Golden AK47"
	 FireModeClass(0)=Class'UnlimaginMod.UM_GoldenAK47Fire'
}
