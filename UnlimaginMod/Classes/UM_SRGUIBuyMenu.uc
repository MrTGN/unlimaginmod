//=============================================================================
// The Trader menu with a tab for the store and the perks
//=============================================================================
class UM_SRGUIBuyMenu extends GUIBuyMenu;

function bool NotifyLevelChange()
{
	bPersistent = False;
	Return True;
}
/*
function InitTabs()
{
	c_Tabs.AddTab(PanelCaption[0], string(Class'UM_SRKFTab_BuyMenu'),, PanelHint[0]);
	c_Tabs.AddTab(PanelCaption[1], string(Class'UM_SRKFTab_Perks'),, PanelHint[1]);
} */

defaultproperties
{
	Begin Object Class=UM_SRKFQuickPerkSelect Name=QS
		WinTop=0.011906
		WinLeft=0.008008
		WinWidth=0.316601
		WinHeight=0.082460
	End Object
	QuickPerkSelect=UM_SRKFQuickPerkSelect'UnlimaginMod.UM_SRGUIBuyMenu.QS'

	
	Begin Object Class=UM_SRWeightBar Name=WeightB
		WinTop=0.945302
		WinLeft=0.055266
		WinWidth=0.443888
		WinHeight=0.053896
	End Object
	WeightBar=UM_SRWeightBar'UnlimaginMod.UM_SRGUIBuyMenu.WeightB'

	
	 PanelClass(0)="UnlimaginMod.UM_SRKFTab_BuyMenu"
     PanelClass(1)="UnlimaginMod.UM_SRKFTab_Perks"
     PanelCaption(0)="Store"
     PanelCaption(1)="Perks"
     PanelHint(0)="Trade equipment and ammunition"
     PanelHint(1)="Select your current Perk"
}