//=============================================================================
// The trader menu's list with items for sale
//=============================================================================
class UM_SRBuyMenuSaleList extends KFBuyMenuSaleList;

var int ActiveCategory,SelectionOffset;
var localized string WeaponGroupText;

final function GUIBuyable GetSelectedBuyable()
{
	if ( Index >= CanBuys.Length || CanBuys[Index] > 1
		 || (Index - SelectionOffset) >= ForSaleBuyables.Length )
		Return None;
	else
		Return ForSaleBuyables[Index-SelectionOffset];
}

final function CopyAllBuyables()
{
	local UM_SRClientPerkRepLink L;
	local int i;

	L = Class'UM_SRClientPerkRepLink'.Static.FindStats(PlayerOwner());
	if ( L == None )
		Return;
	
	for( i=0; i<ForSaleBuyables.Length; ++i )  {
		if ( ForSaleBuyables[i] != None )
			L.AllocatedObjects[L.AllocatedObjects.Length] = ForSaleBuyables[i];
	}
}

final function GUIBuyable AllocateEntry( UM_SRClientPerkRepLink L )
{
	local GUIBuyable G;

	if ( L.AllocatedObjects.Length == 0 )
		Return new Class'GUIBuyable';
	
	G = L.AllocatedObjects[0];
	L.ResetItem(G);
	L.AllocatedObjects.Remove(0,1);
	
	Return G;
}

final function SetCategoryNum( int N )
{
	if ( ActiveCategory == N )
		ActiveCategory = -1;
	else
		ActiveCategory = N;
	SelectionOffset = (N+1);
	UpdateForSaleBuyables();
	Index = N;
}

event Closed(GUIComponent Sender, bool bCancelled)
{
	CopyAllBuyables();
	ForSaleBuyables.Length = 0;
	Super.Closed(Sender, bCancelled);
}

final function bool DualIsInInventory( Class<Weapon> WC )
{
	local Inventory I;
	
	for( I=PlayerOwner().Pawn.Inventory; I!=None; I=I.Inventory )  {
		if ( Weapon(I) != None && Weapon(I).DemoReplacement == WC )
			Return True;
	}
	
	Return False;
}

final function bool IsInInventoryWep( Class<Weapon> WC )
{
	local Inventory I;
	
	for( I=PlayerOwner().Pawn.Inventory; I!=None; I=I.Inventory )  {
		if ( I.Class == WC )
			Return True;
	}
	
	Return False;
}

function UpdateForSaleBuyables()
{
	local class<KFVeterancyTypes> PlayerVeterancy;
	local KFPlayerReplicationInfo KFPRI;
	local UM_SRClientPerkRepLink SRLR;
	local GUIBuyable ForSaleBuyable;
	local class<KFWeaponPickup> ForSalePickup;
	local int j, DualDivider, i;
	local class<KFWeapon> ForSaleWeapon;

	// Clear the ForSaleBuyables array
	CopyAllBuyables();
	ForSaleBuyables.Length = 0;

	// Grab the items for sale
	SRLR = Class'UM_SRClientPerkRepLink'.Static.FindStats(PlayerOwner());
	if ( SRLR == None )
		Return; // Hmmmm?

	// Grab Players Veterancy for quick reference
	if ( KFPlayerController(PlayerOwner()) != None )
		PlayerVeterancy = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo).ClientVeteranSkill;
	
	if( PlayerVeterancy == None )
		PlayerVeterancy = class'KFVeterancyTypes';

	KFPRI = KFPlayerReplicationInfo( PlayerOwner().PlayerReplicationInfo );

	// Grab the perk's weapons first
	for ( j = 0; j < SRLR.ShopInventory.Length; j++ )  {
		ForSalePickup = class<KFWeaponPickup>(SRLR.ShopInventory[j].PC);

		if ( ForSalePickup==None || ActiveCategory!=SRLR.ShopInventory[j].CatNum
			 || class<KFWeapon>(ForSalePickup.default.InventoryType).default.bKFNeverThrow
			 || IsInInventory(ForSalePickup) )
			continue;
			
		ForSaleWeapon = class<KFWeapon>(ForSalePickup.default.InventoryType);

		// Remove single weld.
		if ( (ForSalePickup==Class'DeaglePickup' && IsInInventory(class'DualDeaglePickup'))
			 || (ForSalePickup==Class'Magnum44Pickup' && IsInInventory(class'Dual44MagnumPickup'))
			 || (ForSalePickup==Class'MK23Pickup' && IsInInventory(class'DualMK23Pickup'))
			 || DualIsInInventory(ForSaleWeapon) )
			continue;

		DualDivider = 1;

		// Make cheaper.
		if ( (ForSalePickup==Class'DualDeaglePickup' && IsInInventory(class'DeaglePickup'))
			 || (ForSalePickup==Class'Dual44MagnumPickup' && IsInInventory(class'Magnum44Pickup'))
			 || (ForSalePickup==Class'DualMK23Pickup' && IsInInventory(class'MK23Pickup'))
			 || (ForSaleWeapon.Default.DemoReplacement!=None && IsInInventoryWep(ForSaleWeapon.Default.DemoReplacement)) )
			DualDivider = 2;

		for( i=0; i<SRLR.CachePerks.Length; ++i )
			if( !SRLR.CachePerks[i].PerkClass.Static.AllowWeaponInTrader(ForSalePickup,KFPRI,SRLR.CachePerks[i].CurrentLevel) )
				break;
		if( i<SRLR.CachePerks.Length )
			continue;

		ForSaleBuyable = AllocateEntry(SRLR);

   		ForSaleBuyable.ItemName 		= ForSalePickup.default.ItemName;
		ForSaleBuyable.ItemDescription 		= ForSalePickup.default.Description;
		ForSaleBuyable.ItemCategorie		= "Melee"; // Dummy stuff..
		ForSaleBuyable.ItemImage		= ForSaleWeapon.default.TraderInfoTexture;
		ForSaleBuyable.ItemWeaponClass		= ForSaleWeapon;
		ForSaleBuyable.ItemAmmoClass		= ForSaleWeapon.default.FireModeClass[0].default.AmmoClass;
		ForSaleBuyable.ItemPickupClass		= ForSalePickup;
		ForSaleBuyable.ItemCost			= int((float(ForSalePickup.default.Cost)
										  	  * PlayerVeterancy.static.GetCostScaling(KFPRI, ForSalePickup)) / DualDivider);
		ForSaleBuyable.ItemAmmoCost		= 0;
		ForSaleBuyable.ItemFillAmmoCost		= 0;

		ForSaleBuyable.ItemWeight	= ForSaleWeapon.default.Weight;
		if( DualDivider==2 )
		{
			if( ForSalePickup==Class'DualDeaglePickup' )
				ForSaleBuyable.ItemWeight -= class'Deagle'.default.Weight;
			else if( ForSalePickup==Class'Dual44MagnumPickup' )
				ForSaleBuyable.ItemWeight -= class'Magnum44Pistol'.default.Weight;
			else if( ForSalePickup==Class'DualMK23Pickup' )
				ForSaleBuyable.ItemWeight -= class'MK23Pickup'.default.Weight;
			else 
				ForSaleBuyable.ItemWeight -= Class<KFWeapon>(ForSaleWeapon.Default.DemoReplacement).Default.Weight;
		}

		ForSaleBuyable.ItemPower		= ForSalePickup.default.PowerValue;
		ForSaleBuyable.ItemRange		= ForSalePickup.default.RangeValue;
		ForSaleBuyable.ItemSpeed		= ForSalePickup.default.SpeedValue;
		ForSaleBuyable.ItemAmmoCurrent		= 0;
		ForSaleBuyable.ItemAmmoMax		= 0;
		ForSaleBuyable.ItemPerkIndex		= ForSalePickup.default.CorrespondingPerkIndex;

		// Make sure we mark the list as a sale list
		ForSaleBuyable.bSaleList = true;

		// Sort same perk weapons in front.
		if( ForSalePickup.default.CorrespondingPerkIndex == PlayerVeterancy.default.PerkIndex )  {
			ForSaleBuyables.Insert(0, 1);
			ForSaleBuyables[0] = ForSaleBuyable;
		}
		else 
			ForSaleBuyables[ForSaleBuyables.Length] = ForSaleBuyable;
	}

	// Now Update the list
	UpdateList();
}

function UpdateList()
{
	local int i,j;
	local UM_SRClientPerkRepLink SRLR;

	SRLR = Class'UM_SRClientPerkRepLink'.Static.FindStats( PlayerOwner() );

	// Update the ItemCount and select the first item
	ItemCount = SRLR.ShopCategories.Length + ForSaleBuyables.Length;

	// Clear the arrays
	if ( ForSaleBuyables.Length < ItemPerkIndexes.Length )  {
		ItemPerkIndexes.Length = ItemCount;
		PrimaryStrings.Length = ItemCount;
		SecondaryStrings.Length = ItemCount;
		CanBuys.Length = ItemCount;
	}

	// Update categories
	if ( ActiveCategory >= 0 )  {
		for( i=0; i<(ActiveCategory+1); ++i )  {
			PrimaryStrings[j] = SRLR.ShopCategories[i];
			CanBuys[j] = 2+i;
			++j;
		}
	}
	else  {
		for( i=0; i<SRLR.ShopCategories.Length; ++i )  {
			PrimaryStrings[j] = SRLR.ShopCategories[i];
			CanBuys[j] = 2+i;
			++j;
		}
	}

	// Update the players inventory list
	for ( i=0; i<ForSaleBuyables.Length; i++ )  {
		PrimaryStrings[j] = ForSaleBuyables[i].ItemName;
		SecondaryStrings[j] = "£" @ int(ForSaleBuyables[i].ItemCost);

		ItemPerkIndexes[j] = ForSaleBuyables[i].ItemPerkIndex;

		if ( ForSaleBuyables[i].ItemCost > PlayerOwner().PlayerReplicationInfo.Score 
			 || ForSaleBuyables[i].ItemWeight + KFHumanPawn(PlayerOwner().Pawn).CurrentWeight > KFHumanPawn(PlayerOwner().Pawn).MaxCarryWeight )
			CanBuys[j] = 0;
		else
			CanBuys[j] = 1;
		
		++j;
	}

	if ( ActiveCategory >= 0 && ActiveCategory < SRLR.ShopCategories.Length )  {
		for( i=(ActiveCategory+1); i<SRLR.ShopCategories.Length; ++i )  {
			PrimaryStrings[j] = SRLR.ShopCategories[i];
			CanBuys[j] = 2+i;
			++j;
		}
	}

	if ( bNotify )
		CheckLinkedObjects(Self);

	if ( MyScrollBar != none )
		MyScrollBar.AlignThumb();

	bNeedsUpdate = False;
}

function DrawInvItem(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	local float TempX, TempY, TempHeight;
	local float StringHeight, StringWidth;
	local UM_SRClientPerkRepLink SRLR;

	OnClickSound=CS_Click;

	// Offset for the Background
	TempX = X;
	TempY = Y + ItemSpacing / 2.0;

	// Initialize the Canvas
	Canvas.Style = 1;
	//Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	// Draw Item Background
	Canvas.SetPos(TempX, TempY);

	if ( CanBuys[CurIndex] == 0 )  {
		Canvas.DrawTileStretched(DisabledItemBackgroundLeft, Height - ItemSpacing, Height - ItemSpacing);

		TempX += ((Height - ItemSpacing) - 1);
		TempHeight = Height - 12;
		TempY += 6;//(Height - TempHeight) / 2;

		Canvas.SetPos(TempX, TempY);

		Canvas.DrawTileStretched(DisabledItemBackgroundRight, Width - (Height - ItemSpacing), Height - 12);
	}
	else if ( CanBuys[CurIndex] > 1 )  {
		// Drawing without perk icon.
		TempHeight = Height - 12;
		TempY += 6;
		Canvas.SetPos(TempX, TempY);

		if ( bSelected )
			Canvas.DrawTileStretched(SelectedItemBackgroundRight, Width - (Height - ItemSpacing), Height - 12);
		else 
			Canvas.DrawTileStretched(ItemBackgroundRight, Width - (Height - ItemSpacing), Height - 12);
	}
	else if ( bSelected )  {
		Canvas.DrawTileStretched(SelectedItemBackgroundLeft, Height - ItemSpacing, Height - ItemSpacing);

		TempX += ((Height - ItemSpacing) - 1);
		TempHeight = Height - 12;
		TempY += 6;//(Height - TempHeight) / 2;

		Canvas.SetPos(TempX, TempY);
		Canvas.DrawTileStretched(SelectedItemBackgroundRight, Width - (Height - ItemSpacing), Height - 12);
	}
	else  {
		Canvas.DrawTileStretched(ItemBackgroundLeft, Height - ItemSpacing, Height - ItemSpacing);

		TempX += ((Height - ItemSpacing) - 1);
		TempHeight = Height - 12;
		TempY += 6;//(Height - TempHeight) / 2;

		Canvas.SetPos(TempX, TempY);

		Canvas.DrawTileStretched(ItemBackgroundRight, Width - (Height - ItemSpacing), Height - 12);
	}

	if ( CanBuys[CurIndex] < 2 )  {
		Canvas.SetPos(X + 4, Y + 4);

		SRLR = Class'UM_SRClientPerkRepLink'.Static.FindStats(PlayerOwner());
		if( SRLR!=None && SRLR.ShopPerkIcons.Length>ItemPerkIndexes[CurIndex] )
			Canvas.DrawTile(SRLR.ShopPerkIcons[ItemPerkIndexes[CurIndex]], Height - 8, Height - 8, 0, 0, 256, 256);
	}

	// Select Text color
	if ( CurIndex == MouseOverIndex )
		Canvas.SetDrawColor(255, 255, 255, 255);
	else
		Canvas.SetDrawColor(0, 0, 0, 255);

	// Draw the item's name or category
	Canvas.StrLen(PrimaryStrings[CurIndex], StringWidth, StringHeight);
	Canvas.SetPos(TempX + (0.2 * Height), TempY + ((TempHeight - StringHeight) / 2));
	Canvas.DrawText(PrimaryStrings[CurIndex]);

	// Draw the item's price
	if ( CanBuys[CurIndex] < 2 )  {
		Canvas.StrLen(SecondaryStrings[CurIndex], StringWidth, StringHeight);
		Canvas.SetPos((TempX - Height) + Width - (StringWidth + (0.2 * Height)), TempY + ((TempHeight - StringHeight) / 2));
		Canvas.DrawText(SecondaryStrings[CurIndex]);
	}
	else  {
		Canvas.StrLen(WeaponGroupText, StringWidth, StringHeight);
		Canvas.SetPos((TempX - Height) + Width - (StringWidth + (0.2 * Height)), TempY + ((TempHeight - StringHeight) / 2));
		Canvas.DrawText(WeaponGroupText);
	}

	Canvas.SetDrawColor(255, 255, 255, 255);
}

function IndexChanged(GUIComponent Sender)
{
	if ( CanBuys[Index] == 0 )  {
		if ( ForSaleBuyables[Index-SelectionOffset].ItemCost > PlayerOwner().PlayerReplicationInfo.Score )
			PlayerOwner().Pawn.DemoPlaySound(TraderSoundTooExpensive, SLOT_Interface, 2.0);
		else if ( ForSaleBuyables[Index-SelectionOffset].ItemWeight + KFHumanPawn(PlayerOwner().Pawn).CurrentWeight > KFHumanPawn(PlayerOwner().Pawn).MaxCarryWeight )
			PlayerOwner().Pawn.DemoPlaySound(TraderSoundTooHeavy, SLOT_Interface, 2.0);
	}
	
	Super(GUIVertList).IndexChanged(Sender);
}

defaultproperties
{
	ActiveCategory=-1
	WeaponGroupText="Weapon group"
}
