//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_GoldenBenelliM4Fire
//	Parent class:	 UM_BenelliM4Shotgun
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 10.10.2013 18:40
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_GoldenBenelliM4Shotgun extends UM_BenelliM4Shotgun;


defaultproperties
{
     FireModeClass(0)=Class'UnlimaginMod.UM_GoldenBenelliM4Fire'
	 TraderInfoTexture=Texture'KillingFloor2HUD.Trader_Weapon_Icons.Trader_Gold_Benelli'
     SkinRefs(0)="KF_Weapons_Gold_T.Weapons.Gold_Benelli_cmb"
     HudImageRef="KillingFloor2HUD.WeaponSelect.Gold_Benelli_unselected"
     SelectedHudImageRef="KillingFloor2HUD.WeaponSelect.Gold_Benelli"
     Description="Gold plating, polished until it shines and twinkles. Just the thing for the serious Zed-slayer."
     AttachmentClass=Class'UnlimaginMod.UM_GoldenBenelliM4Attachment'
	 PickupClass=Class'UnlimaginMod.UM_GoldenBenelliM4Pickup'
     ItemName="Golden Benelli M4"
}
