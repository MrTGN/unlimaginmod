//=============================================================================
// The actual trader menu
//=============================================================================
class UM_SRKFTab_BuyMenu extends KFTab_BuyMenu;

var Class<Pickup> SelectedItem;

final function RefreshSelection()
{
	if ( SaleSelect.List.Index == -1 )  {
		if ( InvSelect.List.Index != -1 )
			TheBuyable = InvSelect.GetSelectedBuyable();
		else 
			TheBuyable = None;
	}
	else 
		TheBuyable = SaleSelect.GetSelectedBuyable();
}

function OnAnychange()
{
	RefreshSelection();
	Super.OnAnychange();
}

function bool InternalOnClick(GUIComponent Sender)
{
	RefreshSelection();
	
	Return Super.InternalOnClick(Sender);
}

function UpdateAll()
{
	KFPlayerController(PlayerOwner()).bDoTraderUpdate = False;
	InvSelect.List.UpdateMyBuyables();
	SaleSelect.List.UpdateForSaleBuyables();

	RefreshSelection();
	GetUpdatedBuyable();
	UpdatePanel();
}

function UpdateBuySellButtons()
{
	RefreshSelection();
	//if ( InvSelect.List.Index == -1 || TheBuyable==None || !TheBuyable.bSellable )
	if ( InvSelect.List.Index < 0 || TheBuyable==None || !TheBuyable.bSellable )
		SaleButton.DisableMe();
	else
		SaleButton.EnableMe();

	//if ( SaleSelect.List.Index == -1 || TheBuyable == None || (TheBuyable.ItemCost > PlayerOwner().PlayerReplicationInfo.Score) )
	if ( SaleSelect.List.Index < 0 || TheBuyable == None || (TheBuyable.ItemCost > PlayerOwner().PlayerReplicationInfo.Score) )
		PurchaseButton.DisableMe();
	else
		PurchaseButton.EnableMe();
}

function GetUpdatedBuyable(optional bool bSetInvIndex)
{
	InvSelect.List.UpdateMyBuyables();
	RefreshSelection();
}

function UpdateAutoFillAmmo()
{
	Super.UpdateAutoFillAmmo();
	RefreshSelection();
}

function SaleChange(GUIComponent Sender)
{
	InvSelect.List.Index = -1;
	
	TheBuyable = SaleSelect.GetSelectedBuyable();

	// Selected category.
	if ( TheBuyable == None )  {
		GUIBuyMenu(OwnerPage()).WeightBar.NewBoxes = 0;
		if ( SaleSelect.List.CanBuys[SaleSelect.List.Index] > 1 )
			UM_SRBuyMenuSaleList(SaleSelect.List).SetCategoryNum(SaleSelect.List.CanBuys[SaleSelect.List.Index]-2);
	}
	else 
		GUIBuyMenu(OwnerPage()).WeightBar.NewBoxes = TheBuyable.ItemWeight;
	
	OnAnychange();
}

function bool SaleDblClick(GUIComponent Sender)
{
	InvSelect.List.Index = -1;
	
	TheBuyable = SaleSelect.GetSelectedBuyable();

	// Selected category.
	if ( TheBuyable == None )
		GUIBuyMenu(OwnerPage()).WeightBar.NewBoxes = 0;
	else  {
		GUIBuyMenu(OwnerPage()).WeightBar.NewBoxes = TheBuyable.ItemWeight;
		if ( SaleSelect.List.CanBuys[SaleSelect.List.Index] == 1 )  {
			DoBuy();
   			TheBuyable = None;
		}
	}
	OnAnychange();
	
	Return False;
}

defaultproperties
{
	Begin Object Class=UM_SRKFBuyMenuInvListBox Name=InventoryBox
		WinTop=0.070841
		WinLeft=0.000108
		WinWidth=0.328204
		WinHeight=0.521856
	End Object
	InvSelect=UM_SRKFBuyMenuInvListBox'UnlimaginMod.UM_SRKFTab_BuyMenu.InventoryBox'

	Begin Object class=UM_SRBuyMenuSaleListBox Name=SaleBox
		WinTop=0.064312
		WinLeft=0.672632
		WinWidth=0.325857
		WinHeight=0.674039
	End Object
	SaleSelect=UM_SRBuyMenuSaleListBox'UnlimaginMod.UM_SRKFTab_BuyMenu.SaleBox'
}
