//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_ThompsonM1928SMG
//	Parent class:	 UM_ThompsonM4A1SMG
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.07.2013 16:28
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Thompson SMG Model 1928
//================================================================================
class UM_ThompsonM1928SMG extends UM_ThompsonM4A1SMG;


defaultproperties
{
     MeshRef="KF_IJC_Summer_Weps1.ThompsonDrum"
     SkinRefs(1)="KF_IJC_Summer_Weapons.Thompson_Drum.thompson_drum_cmb"
     HudImageRef="KF_IJC_HUD.WeaponSelect.Thompson_Drum_unselected"
     SelectedHudImageRef="KF_IJC_HUD.WeaponSelect.Thompson_Drum"
	 MagCapacity=75
	 Weight=6.000000
     ReloadRate=3.930000
	 TacticalReloadRate=2.725000
     WeaponReloadAnim="Reload_IJC_spThompson_Drum"
     SleeveNum=0
     TraderInfoTexture=Texture'KF_IJC_HUD.Trader_Weapon_Icons.Trader_Thompson_Drum'
     FireModeClass(0)=Class'UnlimaginMod.UM_ThompsonM1928Fire'
     Description="This Tommy gun M1928 with a drum magazine was used heavily during the WWII pacific battles as seen in Rising Storm."
     Priority=124
     GroupOffset=20
     PickupClass=Class'UnlimaginMod.UM_ThompsonM1928Pickup'
     AttachmentClass=Class'UnlimaginMod.UM_ThompsonM1928Attachment'
     ItemName="Thompson SMG M1928"
}
