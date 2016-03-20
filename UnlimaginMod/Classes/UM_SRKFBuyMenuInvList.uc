//=============================================================================
// The trader menu's list with player's current inventory
//=============================================================================
class UM_SRKFBuyMenuInvList extends KFBuyMenuInvList;

final function CopyAllBuyables()
{
	local UM_ClientRepInfoLink L;
	local int i;

	L = Class'UM_ClientRepInfoLink'.Static.FindStats(PlayerOwner());
	if( L==None )
		Return;
	for( i=0; i<MyBuyables.Length; ++i )
		if( MyBuyables[i]!=None )
			L.AllocatedObjects[L.AllocatedObjects.Length] = MyBuyables[i];
}
final function GUIBuyable AllocateEntry( UM_ClientRepInfoLink L )
{
	local GUIBuyable G;

	if( L.AllocatedObjects.Length==0 )
		Return new Class'GUIBuyable';
	G = L.AllocatedObjects[0];
	L.ResetItem(G);
	L.AllocatedObjects.Remove(0,1);
	Return G;
}
final function FreeBuyable( UM_ClientRepInfoLink L, GUIBuyable B )
{
	L.AllocatedObjects[L.AllocatedObjects.Length] = B;
}

event Closed(GUIComponent Sender, bool bCancelled)
{
	CopyAllBuyables();
	MyBuyables.Length = 0;
	super.Closed(Sender, bCancelled);
}
function UpdateMyBuyables()
{
	local GUIBuyable MyBuyable, KnifeBuyable, FragBuyable;
	local array<GUIBuyable> SecTypes;
	local Inventory CurInv;
	local float CurAmmo, MaxAmmo;
	local class<KFWeaponPickup> MyPickup,MyPrimaryPickup;
	local int DualDivider,i;
	local class<KFVeterancyTypes> KFV;
	local UM_ClientRepInfoLink KFLR;
	local KFPlayerReplicationInfo PRI;

	PRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
	KFLR = Class'UM_ClientRepInfoLink'.Static.FindStats(PlayerOwner());
	if( KFLR==None || PRI==None )
		Return; // Hmmmm?

	// Let's start with our current inventory
	if ( PlayerOwner().Pawn.Inventory == None )
	{
		log("Inventory is None!");
		Return;
	}

	DualDivider = 1;
	AutoFillCost = 0.00000;

	// Clear the MyBuyables array
	CopyAllBuyables();
	MyBuyables.Length = 0;

	KFV = PRI.ClientVeteranSkill;
	if( KFV==None )
		KFV = Class'KFVeterancyTypes';

	// Fill the Buyables
	for ( CurInv = PlayerOwner().Pawn.Inventory; CurInv != None; CurInv = CurInv.Inventory )
	{
		if ( KFWeapon(CurInv)==None || CurInv.IsA('Welder') || CurInv.IsA('Syringe') )
			continue;

		if ( CurInv.IsA('DualDeagle') || CurInv.IsA('Dual44Magnum') || CurInv.IsA('DualMK23Pistol') || KFWeapon(CurInv).DemoReplacement!=None )
			DualDivider = 2;
		else DualDivider = 1;

		MyPickup = class<KFWeaponPickup>(CurInv.default.PickupClass);

		KFWeapon(CurInv).GetAmmoCount(MaxAmmo, CurAmmo);

		if ( KFWeapon(CurInv).bHasSecondaryAmmo )
			MyPrimaryPickup = MyPickup.default.PrimaryWeaponPickup;
		else MyPrimaryPickup = MyPickup;

		MyBuyable = AllocateEntry(KFLR);

		MyBuyable.ItemName 		= MyPickup.default.ItemShortName;
		MyBuyable.ItemDescription 	= KFWeapon(CurInv).default.Description;
		MyBuyable.ItemCategorie		= "Melee"; // More dummy.
		MyBuyable.ItemImage		= KFWeapon(CurInv).default.TraderInfoTexture;
		MyBuyable.ItemWeaponClass	= KFWeapon(CurInv).class;
		MyBuyable.ItemAmmoClass		= KFWeapon(CurInv).default.FireModeClass[0].default.AmmoClass;
		MyBuyable.ItemPickupClass	= MyPrimaryPickup;
		MyBuyable.ItemCost		= (float(MyPickup.default.Cost) * KFV.static.GetCostScaling(PRI, MyPickup)) / DualDivider;
		MyBuyable.ItemAmmoCost		= MyPrimaryPickup.default.AmmoCost * KFV.static.GetAmmoCostScaling(PRI, MyPrimaryPickup)
										  * KFV.static.GetMagCapacityMod(PRI, KFWeapon(CurInv));
		if( MyPickup==class'HuskGunPickup' )
			MyBuyable.ItemFillAmmoCost	= (int(((MaxAmmo - CurAmmo) * float(MyPrimaryPickup.default.AmmoCost)) / float(MyPrimaryPickup.default.BuyClipSize))) * KFV.static.GetAmmoCostScaling(PRI, MyPrimaryPickup);
		else MyBuyable.ItemFillAmmoCost		= (int(((MaxAmmo - CurAmmo) * float(MyPrimaryPickup.default.AmmoCost)) / float(KFWeapon(CurInv).default.MagCapacity))) * KFV.static.GetAmmoCostScaling(PRI, MyPrimaryPickup);
		MyBuyable.ItemWeight		= KFWeapon(CurInv).Weight;
		MyBuyable.ItemPower		= MyPickup.default.PowerValue;
		MyBuyable.ItemRange		= MyPickup.default.RangeValue;
		MyBuyable.ItemSpeed		= MyPickup.default.SpeedValue;
		MyBuyable.ItemAmmoCurrent	= CurAmmo;
		MyBuyable.ItemAmmoMax		= MaxAmmo;
		MyBuyable.bMelee			= (KFMeleeGun(CurInv)!=None || MyBuyable.ItemAmmoClass==None);
		MyBuyable.bSaleList		= False;
		MyBuyable.ItemPerkIndex		= MyPickup.default.CorrespondingPerkIndex;

		if ( KFWeapon(CurInv) != None && KFWeapon(CurInv).SellValue != -1 )
			MyBuyable.ItemSellValue = KFWeapon(CurInv).SellValue;
		else MyBuyable.ItemSellValue = MyBuyable.ItemCost * 0.75;

		if ( !MyBuyable.bMelee && int(MaxAmmo)>int(CurAmmo) )
			AutoFillCost += MyBuyable.ItemFillAmmoCost;

		if ( CurInv.IsA('Knife') )
		{
			MyBuyable.bSellable	= False;
			KnifeBuyable = MyBuyable;
		}
		else if ( CurInv.IsA('Frag') )
		{
			MyBuyable.bSellable	= False;
			FragBuyable = MyBuyable;
		}
		else
		{
			MyBuyable.bSellable	= !KFWeapon(CurInv).default.bKFNeverThrow;
			MyBuyables.Insert(0,1);
			MyBuyables[0] = MyBuyable;
		}

		if ( !KFWeapon(CurInv).bHasSecondaryAmmo )
			continue;

		// Add secondary ammo.
		KFWeapon(CurInv).GetSecondaryAmmoCount(MaxAmmo, CurAmmo);

		MyBuyable = AllocateEntry(KFLR);

		MyBuyable.ItemName 		= MyPickup.default.SecondaryAmmoShortName;
		MyBuyable.ItemDescription 	= KFWeapon(CurInv).default.Description;
		MyBuyable.ItemCategorie		= "Melee";
		MyBuyable.ItemImage		= KFWeapon(CurInv).default.TraderInfoTexture;
		MyBuyable.ItemWeaponClass	= KFWeapon(CurInv).class;
		MyBuyable.ItemAmmoClass		= KFWeapon(CurInv).default.FireModeClass[1].default.AmmoClass;
		MyBuyable.ItemPickupClass	= MyPickup;
		MyBuyable.ItemCost		= (float(MyPickup.default.Cost) * KFV.static.GetCostScaling(PRI, MyPickup)) / DualDivider;
		MyBuyable.ItemAmmoCost		= MyPickup.default.AmmoCost * KFV.static.GetAmmoCostScaling(PRI, MyPickup) * KFV.static.GetMagCapacityMod(PRI, KFWeapon(CurInv));
		MyBuyable.ItemFillAmmoCost	= (int(((MaxAmmo - CurAmmo) * float(MyPickup.default.AmmoCost)) /* Secondary Mags always have a Mag Capacity of 1? / float(KFWeapon(CurInv).default.MagCapacity)*/)) * KFV.static.GetAmmoCostScaling(PRI, MyPickup);
		MyBuyable.ItemWeight		= KFWeapon(CurInv).Weight;
		MyBuyable.ItemPower		= MyPickup.default.PowerValue;
		MyBuyable.ItemRange		= MyPickup.default.RangeValue;
		MyBuyable.ItemSpeed		= MyPickup.default.SpeedValue;
		MyBuyable.ItemAmmoCurrent	= CurAmmo;
		MyBuyable.ItemAmmoMax		= MaxAmmo;
		MyBuyable.bMelee		= (KFMeleeGun(CurInv) != None);
		MyBuyable.bSaleList		= False;
		MyBuyable.ItemPerkIndex		= MyPickup.default.CorrespondingPerkIndex;
		MyBuyable.bSellable		= !KFWeapon(CurInv).default.bKFNeverThrow;

		if ( KFWeapon(CurInv) != None && KFWeapon(CurInv).SellValue != -1 )
			MyBuyable.ItemSellValue = KFWeapon(CurInv).SellValue;
		else MyBuyable.ItemSellValue = MyBuyable.ItemCost * 0.75;

		if ( !MyBuyable.bMelee && int(MaxAmmo) > int(CurAmmo))
			AutoFillCost += MyBuyable.ItemFillAmmoCost;

		SecTypes[SecTypes.Length] = MyBuyable;
	}

	MyBuyable = AllocateEntry(KFLR);

	MyBuyable.ItemName 		= class'BuyableVest'.default.ItemName;
	MyBuyable.ItemDescription 	= class'BuyableVest'.default.ItemDescription;
	MyBuyable.ItemCategorie		= "";
	MyBuyable.ItemImage		= class'BuyableVest'.default.ItemImage;
	MyBuyable.ItemAmmoCurrent	= PlayerOwner().Pawn.ShieldStrength;
	MyBuyable.ItemAmmoMax		= 100;
	MyBuyable.ItemCost		= int(class'BuyableVest'.default.ItemCost * KFV.static.GetCostScaling(PRI, class'Vest'));
	MyBuyable.ItemAmmoCost		= MyBuyable.ItemCost / 100;
	MyBuyable.ItemFillAmmoCost	= int((100.0 - MyBuyable.ItemAmmoCurrent) * MyBuyable.ItemAmmoCost);
	MyBuyable.bIsVest			= True;
	MyBuyable.bMelee			= False;
	MyBuyable.bSaleList		= False;
	MyBuyable.bSellable		= False;
	MyBuyable.ItemPerkIndex		= class'BuyableVest'.default.CorrespondingPerkIndex;

	if( MyBuyables.Length<=(7-SecTypes.Length) )
	{
		MyBuyables.Length = 11;
		for( i=(SecTypes.Length-1); i>=0; --i )
			MyBuyables[7-i] = SecTypes[i];
		MyBuyables[8] = KnifeBuyable;
		MyBuyables[9] = FragBuyable;
		MyBuyables[10] = MyBuyable;
	}
	else
	{
		MyBuyables[MyBuyables.Length] = None;
		for( i=(SecTypes.Length-1); i>=0; --i )
			MyBuyables[MyBuyables.Length] = SecTypes[i];
		MyBuyables[MyBuyables.Length] = KnifeBuyable;
		MyBuyables[MyBuyables.Length] = FragBuyable;
		MyBuyables[MyBuyables.Length] = MyBuyable;
	}

	//Now Update the list
	UpdateList();
}

function UpdateList()
{
	local int i;
	local UM_ClientRepInfoLink KFLR;

	KFLR = Class'UM_ClientRepInfoLink'.Static.FindStats(PlayerOwner());

	if ( MyBuyables.Length < 1 )
	{
		bNeedsUpdate = True;
		Return;
	}

	// Clear the arrays
	NameStrings.Remove(0, NameStrings.Length);
	AmmoStrings.Remove(0, AmmoStrings.Length);
	ClipPriceStrings.Remove(0, ClipPriceStrings.Length);
	FillPriceStrings.Remove(0, FillPriceStrings.Length);
	PerkTextures.Remove(0, PerkTextures.Length);

	// Update the ItemCount and select the first item
	ItemCount = MyBuyables.Length;

	// Update the players inventory list
	for ( i = 0; i < ItemCount; i++ )
	{
		if ( MyBuyables[i] == None )
			continue;

		NameStrings[i] = MyBuyables[i].ItemName;

		if ( !MyBuyables[i].bIsVest )
		{
			AmmoStrings[i] = int(MyBuyables[i].ItemAmmoCurrent)$"/"$int(MyBuyables[i].ItemAmmoMax);

			if ( MyBuyables[i].ItemAmmoCurrent < MyBuyables[i].ItemAmmoMax )
			{
				if ( MyBuyables[i].ItemAmmoCost > MyBuyables[i].ItemFillAmmoCost )
				{
					ClipPriceStrings[i] = "£" @ int(MyBuyables[i].ItemFillAmmoCost);
				}
				else
				{
					ClipPriceStrings[i] = "£" @ int(MyBuyables[i].ItemAmmoCost);
				}
			}
			else
			{
				ClipPriceStrings[i] = "£ 0";
			}

			FillPriceStrings[i] = "£" @ int(MyBuyables[i].ItemFillAmmoCost);
		}
		else
		{
			AmmoStrings[i] = int((MyBuyables[i].ItemAmmoCurrent / MyBuyables[i].ItemAmmoMax) * 100.0)$"%";

			if ( MyBuyables[i].ItemAmmoCurrent == 0 )
			{
				FillPriceStrings[i] = BuyString @ ": £" @ int(MyBuyables[i].ItemFillAmmoCost);
			}
			else if ( MyBuyables[i].ItemAmmoCurrent == 100 )
			{
				FillPriceStrings[i] = PurchasedString;
			}
			else
			{
				FillPriceStrings[i] = RepairString @ ": £" @ int(MyBuyables[i].ItemFillAmmoCost);
			}
		}
		if( KFLR!=None && KFLR.ShopPerkIcons.Length>MyBuyables[i].ItemPerkIndex )
			PerkTextures[i] = Texture(KFLR.ShopPerkIcons[MyBuyables[i].ItemPerkIndex]);
	}

	if ( bNotify )
		CheckLinkedObjects(Self);
	if ( MyScrollBar != None )
		MyScrollBar.AlignThumb();
}
function DrawInvItem(Canvas Canvas, int CurIndex, float X, float Y, float Width, float Height, bool bSelected, bool bPending)
{
	local float IconBGSize, ItemBGWidth, AmmoBGWidth, ClipButtonWidth, FillButtonWidth;
	local float TempX, TempY;
	local float StringHeight, StringWidth;

	OnClickSound=CS_Click;

	// Initialize the Canvas
	Canvas.Style = 1;
	// Canvas.Font = class'ROHUD'.Static.GetSmallMenuFont(Canvas);
	Canvas.SetDrawColor(255, 255, 255, 255);

	if ( MyBuyables[CurIndex]==None )
	{
		if( MyBuyables.Length==(CurIndex+1) || MyBuyables[CurIndex+1]==None )
			Return;

		Canvas.SetPos(X + EquipmentBGXOffset, Y + Height - EquipmentBGYOffset - EquipmentBGHeightScale * Height);
		Canvas.DrawTileStretched(AmmoBackground, EquipmentBGWidthScale * Width, EquipmentBGHeightScale * Height);

		Canvas.SetDrawColor(175, 176, 158, 255);
		Canvas.StrLen(EquipmentString, StringWidth, StringHeight);
		Canvas.SetPos(X + EquipmentBGXOffset + ((EquipmentBGWidthScale * Width - StringWidth) / 2.0), Y + Height - EquipmentBGYOffset - EquipmentBGHeightScale * Height + ((EquipmentBGHeightScale * Height - StringHeight) / 2.0));
		Canvas.DrawText(EquipmentString);
	}
	else
	{
		// Calculate Widths for all components
		IconBGSize = Height;
		ItemBGWidth = (Width * ItemBGWidthScale) - IconBGSize;
		AmmoBGWidth = Width * AmmoBGWidthScale;

		if ( !MyBuyables[CurIndex].bIsVest )
		{
			FillButtonWidth = ((1.0 - ItemBGWidthScale - AmmoBGWidthScale) * Width) - ButtonSpacing;
			ClipButtonWidth = FillButtonWidth * ClipButtonWidthScale;
			FillButtonWidth -= ClipButtonWidth;
		}
		else
		{
			FillButtonWidth = ((1.0 - ItemBGWidthScale - AmmoBGWidthScale) * Width);
		}

		// Offset for the Background
		TempX = X;
		TempY = Y;

		// Draw Item Background
		Canvas.SetPos(TempX, TempY);

		if ( bSelected )
		{
			Canvas.DrawTileStretched(SelectedItemBackgroundLeft, IconBGSize, IconBGSize);
			Canvas.SetPos(TempX + 4, TempY + 4);
			Canvas.DrawTile(PerkTextures[CurIndex], IconBGSize - 8, IconBGSize - 8, 0, 0, 256, 256);

			TempX += IconBGSize;
			Canvas.SetPos(TempX, TempY + ItemBGYOffset);
			Canvas.DrawTileStretched(SelectedItemBackgroundRight, ItemBGWidth, IconBGSize - (2.0 * ItemBGYOffset));
		}
		else
		{
			Canvas.DrawTileStretched(ItemBackgroundLeft, IconBGSize, IconBGSize);
			Canvas.SetPos(TempX + 4, TempY + 4);
			Canvas.DrawTile(PerkTextures[CurIndex], IconBGSize - 8, IconBGSize - 8, 0, 0, 256, 256);

			TempX += IconBGSize;
			Canvas.SetPos(TempX, TempY + ItemBGYOffset);
			Canvas.DrawTileStretched(ItemBackgroundRight, ItemBGWidth, IconBGSize - (2.0 * ItemBGYOffset));
		}

		// Select Text color
		if ( CurIndex == MouseOverIndex && MouseOverXIndex == 0 )
			Canvas.SetDrawColor(255, 255, 255, 255);
		else Canvas.SetDrawColor(0, 0, 0, 255);

		// Draw the item's name
		Canvas.StrLen(NameStrings[CurIndex], StringWidth, StringHeight);
		Canvas.SetPos(TempX + ItemNameSpacing, Y + ((Height - StringHeight) / 2.0));
		Canvas.DrawText(NameStrings[CurIndex]);

		// Draw the item's ammo status if it is not a melee weapon
		if ( !MyBuyables[CurIndex].bMelee )
		{
			TempX += ItemBGWidth + AmmoSpacing;

			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.SetPos(TempX, TempY + ((Height - AmmoBGHeightScale * Height) / 2.0));
			Canvas.DrawTileStretched(AmmoBackground, AmmoBGWidth, AmmoBGHeightScale * Height);

			Canvas.SetDrawColor(175, 176, 158, 255);
			Canvas.StrLen(AmmoStrings[CurIndex], StringWidth, StringHeight);
			Canvas.SetPos(TempX + ((AmmoBGWidth - StringWidth) / 2.0), TempY + ((Height - StringHeight) / 2.0));
			Canvas.DrawText(AmmoStrings[CurIndex]);

			TempX += AmmoBGWidth + AmmoSpacing;

			Canvas.SetDrawColor(255, 255, 255, 255);
			Canvas.SetPos(TempX, TempY + ((Height - ButtonBGHeightScale * Height) / 2.0));

			if ( !MyBuyables[CurIndex].bIsVest )
			{
				if ( MyBuyables[CurIndex].ItemAmmoCurrent >= MyBuyables[CurIndex].ItemAmmoMax ||
					 (PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemFillAmmoCost && PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemAmmoCost) )
				{
					Canvas.DrawTileStretched(DisabledButtonBackground, ClipButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}
				else if ( CurIndex == MouseOverIndex && MouseOverXIndex == 1 )
				{
					Canvas.DrawTileStretched(HoverButtonBackground, ClipButtonWidth, ButtonBGHeightScale * Height);
				}
				else
				{
					Canvas.DrawTileStretched(ButtonBackground, ClipButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}

				Canvas.StrLen(ClipPriceStrings[CurIndex], StringWidth, StringHeight);
				Canvas.SetPos(TempX + ((ClipButtonWidth - StringWidth) / 2.0), TempY + ((Height - StringHeight) / 2.0));
				Canvas.DrawText(ClipPriceStrings[CurIndex]);

				TempX += ClipButtonWidth + ButtonSpacing;

				Canvas.SetDrawColor(255, 255, 255, 255);
				Canvas.SetPos(TempX, TempY + ((Height - ButtonBGHeightScale * Height) / 2.0));

				if ( MyBuyables[CurIndex].ItemAmmoCurrent >= MyBuyables[CurIndex].ItemAmmoMax ||
					 (PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemFillAmmoCost && PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemAmmoCost) )
				{
					Canvas.DrawTileStretched(DisabledButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}
				else if ( CurIndex == MouseOverIndex && MouseOverXIndex == 2 )
				{
					Canvas.DrawTileStretched(HoverButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
				}
				else
				{
					Canvas.DrawTileStretched(ButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}
			}
			else
			{
				if ( (PlayerOwner().Pawn.ShieldStrength > 0 && PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemAmmoCost) ||
					 (PlayerOwner().Pawn.ShieldStrength <= 0 && PlayerOwner().PlayerReplicationInfo.Score < MyBuyables[CurIndex].ItemCost) ||
					 MyBuyables[CurIndex].ItemAmmoCurrent >= MyBuyables[CurIndex].ItemAmmoMax )
				{
					Canvas.DrawTileStretched(DisabledButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}
				else if ( CurIndex == MouseOverIndex && MouseOverXIndex >= 1 )
				{
					Canvas.DrawTileStretched(HoverButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
				}
				else
				{
					Canvas.DrawTileStretched(ButtonBackground, FillButtonWidth, ButtonBGHeightScale * Height);
					Canvas.SetDrawColor(0, 0, 0, 255);
				}
			}

			Canvas.StrLen(FillPriceStrings[CurIndex], StringWidth, StringHeight);
			Canvas.SetPos(TempX + ((FillButtonWidth - StringWidth) / 2.0), TempY + ((Height - StringHeight) / 2.0));
			Canvas.DrawText(FillPriceStrings[CurIndex]);
		}
		Canvas.SetDrawColor(255, 255, 255, 255);
	}
}

defaultproperties
{
}
