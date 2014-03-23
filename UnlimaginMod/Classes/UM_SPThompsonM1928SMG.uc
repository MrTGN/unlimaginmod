//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_SPThompsonM1928SMG
//	Parent class:	 UM_ThompsonM1928SMG
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.07.2013 17:11
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_SPThompsonM1928SMG extends UM_ThompsonM1928SMG;


defaultproperties
{
     MeshRef="KF_IJC_Summer_Weps1.Steampunk_Thompson"
     SkinRefs(1)="KF_IJC_Summer_Weapons.Steampunk_Thompson.Steampunk_Thompson_cmb"
     SelectSoundRef="KF_SP_ThompsonSnd.KFO_SP_Thompson_Select"
     HudImageRef="KF_IJC_HUD.WeaponSelect.SteamPunk_Tommygun_Unselected"
     SelectedHudImageRef="KF_IJC_HUD.WeaponSelect.SteamPunk_Tommygun_Selected"
	 ReloadRate=3.930000
	 TacticalReloadTime=2.725000
     WeaponReloadAnim="Reload_IJC_spThompson_Drum"
     SleeveNum=0
     TraderInfoTexture=Texture'KF_IJC_HUD.Trader_Weapon_Icons.Trader_SteamPunk_Tommygun'
     FireModeClass(0)=Class'UnlimaginMod.UM_SPThompsonM1928Fire'
     Description="Thy weapon is before you. May it's drum beat a sound of terrible fear into your enemies."
     Priority=123
     GroupOffset=19
     PickupClass=Class'UnlimaginMod.UM_SPThompsonM1928Pickup'
     AttachmentClass=Class'UnlimaginMod.UM_SPThompsonM1928Attachment'
     ItemName="Dr. T's Lead Delivery System"
}
