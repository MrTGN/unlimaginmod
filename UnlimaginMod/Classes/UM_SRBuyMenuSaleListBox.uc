//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UM_SRBuyMenuSaleListBox extends KFBuyMenuSaleListBox;


function GUIBuyable GetSelectedBuyable()
{
	Return UM_SRBuyMenuSaleList(List).GetSelectedBuyable();
}

defaultproperties
{
     DefaultListClass="UnlimaginMod.UM_SRBuyMenuSaleList"
}
