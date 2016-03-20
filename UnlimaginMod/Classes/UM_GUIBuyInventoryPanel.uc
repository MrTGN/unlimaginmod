/*==================================================================================
	Package:		 UnlimaginMod
	Class name:		 UM_GUIBuyInventoryPanel
	Creation date:	 03.10.2015 20:12
----------------------------------------------------------------------------------
	Copyright © 2015 Tsiryuta G. N. <spbtgn@gmail.com>  <github.com/spbtgn>

	May contain some parts of the code from: 
	Killing Floor Source, Copyright © 2009-2014 Tripwire Interactive, LLC 
	Unreal Tournament 2004 Source, Copyright © 2004-2014 Epic Games, Inc.

	This program is free software; you can redistribute and/or modify
	it under the terms of the Open Unreal Mod License version 1.1.
----------------------------------------------------------------------------------
	GitHub:			 github.com/unlimagin/unlimaginmod
----------------------------------------------------------------------------------
	Comment:		 This GUI object is automated. It will be automatically added.
==================================================================================*/
class UM_GUIBuyInventoryPanel extends GUIBuyPlayerInventoryPanel;

//========================================================================
//[block] Functions

function Update()
{
	local	float					OldX, CurAmmo, MaxAmmo, /* GameDifficulty, */ FillCost, FillAllAmmoCost;
	local	Inventory				CurInv;
	local	GUIInvBodyTabPanel		NewInvTabPanel;
	local	class<Ammunition>		AmmoClass;
	local	class<KFWeaponPickUp>	WeaponItem;
	local	bool					bHasDual;
	local	int						i;
	local	PlayerController		PC;

	OldX = TabPanelInventoryHeader.WinTop + 0.017000;
	PC = PlayerOwner();
	if ( PC == None || PC.Pawn == None || PC.Pawn.Inventory == None )  {
		Log("Inventory is None!", Name);
		Return;
	}

	// Remove any old items from the components list
	for ( i = 0; i < InvBodyTabPanelArray.Length; ++i )
		RemoveComponent(InvBodyTabPanelArray[i]);

	// Clear the component array
	InvBodyTabPanelArray.Remove(0, InvBodyTabPanelArray.Length);
	// Clear the FillAllAmmo weapons array
	FillAllAmmoAmmunitions.Remove(0, FillAllAmmoAmmunitions.Length);

	// We need the difficulty to calculate the price
	//if ( UM_GameReplicationInfo(PC.GameReplicationInfo) != None )
		//GameDifficulty = UM_GameReplicationInfo(PC.GameReplicationInfo).GameDifficulty;

	// Let's build the list of the stiff we already have in our inevntory
	for ( CurInv = PC.Pawn.Inventory; CurInv != None; CurInv = CurInv.Inventory )  {
		if ( CurInv.IsA('KFAmmunition') )  {
			// Store the weapon for later use (FillAllAmmoButton)
			FillAllAmmoAmmunitions.Insert(0, 1);
			FillAllAmmoAmmunitions[0] = KFAmmunition(CurInv);
			Continue;
		}

		// We do not want ammunition to be a seperate item in the list
		if ( CurInv.IsA('KFWeapon') )  {
			// if we already own dualies, we do not need the single 9mm in the list
			if ( bHasDual && KFWeapon(CurInv).ItemName == "9mm Tactical" )
				Continue;

			NewInvTabPanel = GUIInvBodyTabPanel(AddComponent("KFGUI.GUIInvBodyTabPanel"));
			NewInvTabPanel.WinHeight = 0.080000;
			NewInvTabPanel.bBoundToParent = True;
			NewInvTabPanel.bScaleToParent = True;
			// GUILabel
			GUILabel(NewInvTabPanel.Controls[0]).Caption = CurInv.ItemName;
			GUILabel(NewInvTabPanel.Controls[0]).TextAlign = TXTA_Left;
			GUILabel(NewInvTabPanel.Controls[0]).TextFont = "UT2SmallFont";
			GUILabel(NewInvTabPanel.Controls[0]).FontScale = FNS_Small;

			// Melee weapons do not use ammo, so no need for the buy clip / fill ammo buttons
			if ( !CurInv.IsA('KFMeleeGun') )  {
				KFWeapon(CurInv).GetAmmoCount(MaxAmmo, CurAmmo);
				AmmoClass = KFWeapon(CurInv).default.FireModeClass[0].default.AmmoClass;
				// GUILabel
				GUILabel(NewInvTabPanel.Controls[1]).Caption = int(CurAmmo) $ "/" $ int(MaxAmmo);
				GUILabel(NewInvTabPanel.Controls[1]).TextFont = "UT2SmallFont";
				GUILabel(NewInvTabPanel.Controls[1]).FontScale = FNS_Small;

				foreach PC.DynamicActors( class'KFLevelRules', KFLRit )  {
					KFLR = KFLRit;
					Break;
	            }

				for( i = 0; i < KFLR.MAX_BUYITEMS; ++i )  {
					// If we got the weapon in the inventory, store the corresponding weapon pickup for later use
					if ( KFLR.ItemForSale[i] != None && KFWeapon(CurInv).default.PickupClass == class<KFWeaponPickup>(KFLR.ItemForSale[i]) )  {
						WeaponItem = class<KFWeaponPickup>(KFLR.ItemForSale[i]);
						// Dualies?
						if ( WeaponItem.default.ItemName == "Dual 9mms" )
							bHasDual = True;

						Break;
					}
				}

				// Single Clip Button
				if ( CurAmmo >= MaxAmmo )  {
					// Ammo is at 100%
					GUIInvButton(NewInvTabPanel.Controls[2]).Caption = "100%";
					GUIInvButton(NewInvTabPanel.Controls[2]).bAcceptsInput = False;
				}
				else if ( PC.PlayerReplicationInfo.Score < WeaponItem.default.AmmoCost )  {
					// Not enough money
					GUIInvButton(NewInvTabPanel.Controls[2]).Caption = "Low Cash";
					GUIInvButton(NewInvTabPanel.Controls[2]).bAcceptsInput = False;

					// If we do not even have enough money to buy a single clip we do not want to show the Fill Up All Button
					FillAllAmmoCost = -100000.f;
				}
				else  {
					// Set the ammo clip price and store the ammopickup class
					GUIInvButton(NewInvTabPanel.Controls[2]).Caption =  "£" $ string(WeaponItem.default.AmmoCost);
					GUIInvButton(NewInvTabPanel.Controls[2]).Inv = KFWeapon(CurInv).GetAmmoClass(0);
					GUIInvButton(NewInvTabPanel.Controls[2]).OnClick = DoBuyClip;
				}

				// Fill Up Ammo
				FillCost = (MaxAmmo - CurAmmo) * ((WeaponItem.default.AmmoCost) / KFWeapon(CurInv).default.MagCapacity);

				if ( CurAmmo >= MaxAmmo )  {
					// Ammo is at 100%
					GUIInvButton(NewInvTabPanel.Controls[3]).Caption = "100%";
					GUIInvButton(NewInvTabPanel.Controls[3]).bAcceptsInput = False;
				}
				else if ( PC.PlayerReplicationInfo.Score >= int(FillCost) )  {
					// Enough money
					GuiInvButton(NewInvTabPanel.Controls[3]).Caption = "£" $ string(int(FillCost));
					GuiInvButton(NewInvTabPanel.Controls[3]).Inv = KFWeapon(CurInv).GetAmmoClass(0);
					GuiInvButton(NewInvTabPanel.Controls[3]).OnClick = DoFillOneAmmo;
					FillAllAmmoCost += FillCost;
				}
				else  {
					// Not enough money to fill up ammo for this weapon.
					GUIInvButton(NewInvTabPanel.Controls[3]).Caption = "Low Cash";
					GUIInvButton(NewInvTabPanel.Controls[3]).bAcceptsInput = False;

					// If we do not have enough money to fill up a single weapons we do not want to show the Fill Up All Button
					FillAllAmmoCost = -100000.0;
				}
			}
			else
				GUILabel(NewInvTabPanel.Controls[1]).Caption = ""; // Melees don't have ammo

			// Default Inventory can't be sold
			if ( KFWeapon(CurInv).default.bKFNeverThrow )  {
				GUILabel(NewInvTabPanel.Controls[4]).bVisible = False;
				GUILabel(NewInvTabPanel.Controls[4]).bAcceptsInput = False;
				GUIInvButton(NewInvTabPanel.Controls[5]).bVisible = False;
				GUIInvButton(NewInvTabPanel.Controls[5]).bAcceptsInput = False;
			}
			else  {
				foreach PC.DynamicActors( class'KFLevelRules', KFLRit )  {
					KFLR = KFLRit;
					Break;
	            }

				for( i = 0; i < KFLR.MAX_BUYITEMS; ++i )  {
					// If we got the weapon in the inventory, store the corresponding weapon pickup for later use
					if ( KFLR.ItemForSale[i] != None && KFWeapon(CurInv).default.PickupClass == class<KFWeaponPickup>(KFLR.ItemForSale[i]) )  {
						WeaponItem = class<KFWeaponPickup>(KFLR.ItemForSale[i]);
						Break;
					}
				}

				GUILabel(NewInvTabPanel.Controls[4]).Caption =  "£" $ string(int(WeaponItem.default.Cost * 0.75));
				GUIInvButton(NewInvTabPanel.Controls[5]).Caption = "Sell";
				GUIInvButton(NewInvTabPanel.Controls[5]).Inv = CurInv.class;
				GUIInvButton(NewInvTabPanel.Controls[5]).OnClick = DoSellItem;
			}

			// No ammo buttons for the melees
			if ( CurInv.IsA('KFMeleeGun') )  {
				for ( i = 1; i <= 3; i++ )  {
					NewInvTabPanel.Controls[i].bVisible = False;
					NewInvTabPanel.Controls[i].bAcceptsInput = False;
				}
			}

			NewInvTabPanel.WinTop = OldX + 0.080000;
			NewInvTabPanel.WinLeft = TabPanelInventoryHeader.WinLeft;
			NewInvTabPanel.WinHeight = TabPanelInventoryHeader.WinHeight;
			NewInvTabPanel.WinWidth = TabPanelInventoryHeader.WinWidth;

			OldX = NewInvTabPanel.WinTop;

			InvBodyTabPanelArray.Insert(0, 1);
			InvBodyTabPanelArray[0] = NewInvTabPanel;
		}
	}

	bNeedsUpdate = False;

	//SetFocus(TabPanelInventoryHeader);

	// Fill All Ammo
	if ( FillAllAmmoCost < 1 )
		Return;

	NewInvTabPanel = GUIInvBodyTabPanel(AddComponent("KFGUI.GUIInvBodyTabPanel"));
	NewInvTabPanel.bBoundToParent = True;
	NewInvTabPanel.bScaleToParent = True;
	NewInvTabPanel.WinTop = OldX + 0.130000;
	NewInvTabPanel.WinLeft = TabPanelInventoryHeader.WinLeft;
	NewInvTabPanel.WinHeight = TabPanelInventoryHeader.WinHeight;
	NewInvTabPanel.WinWidth = TabPanelInventoryHeader.WinWidth;
	GUILabel(NewInvTabPanel.Controls[0]).TextAlign = TXTA_Left;
	GUILabel(NewInvTabPanel.Controls[0]).TextFont = "UT2SmallFont";
	GUILabel(NewInvTabPanel.Controls[0]).FontScale = FNS_Small;
	GUILabel(NewInvTabPanel.Controls[0]).Caption = "Fill Up Ammo";
	GUILabel(NewInvTabPanel.Controls[1]).bVisible = False;
	GUIButton(NewInvTabPanel.Controls[2]).bVisible = False;
	GUIButton(NewInvTabPanel.Controls[2]).bAcceptsInput = False;

	if ( PC.PlayerReplicationInfo.Score >= int(FillAllAmmoCost) )  {
		GUIButton(NewInvTabPanel.Controls[3]).Caption =  "£" $ string(int(FillAllAmmoCost));
		GUIButton(NewInvTabPanel.Controls[3]).OnClick = DoFillAllAmmo;
	}
	else if ( PC.PlayerReplicationInfo.Score >= FindCheapestAmmo() )  {
		GUIButton(NewInvTabPanel.Controls[3]).Caption = "Auto Fill";
		GUIButton(NewInvTabPanel.Controls[3]).OnClick = DoFillAllAmmo;
	}
	else  {
		GUIButton(NewInvTabPanel.Controls[3]).Caption = "Low Cash";
		GUIButton(NewInvTabPanel.Controls[3]).bAcceptsInput = False;
	}

	// Just filling up all weapons, can't sell
	GUILabel(NewInvTabPanel.Controls[4]).bVisible = False;
	GUIButton(NewInvTabPanel.Controls[5]).bVisible = False;
	GUIButton(NewInvTabPanel.Controls[5]).bAcceptsInput = False;

	// Add this last tab bar to the component list
	InvBodyTabPanelArray.Insert(0, 1);
	InvBodyTabPanelArray[0] = NewInvTabPanel;
}

function UpDateCheck( GUIComponent Sender )
{
	if ( bNeedsUpdate )
		Update();
}

//[end] Functions
//====================================================================

defaultproperties
{
	 Begin Object Class=GUIInvHeaderTabPanel Name=UM_InventoryHeaderTabPanel
		 WinHeight=0.080000
		 bBoundToParent=True
		 bScaleToParent=True
	 End Object
	 TabPanelInventoryHeader=GUIInvHeaderTabPanel'UnlimaginMod.UM_GUIBuyInventoryPanel.UM_InventoryHeaderTabPanel'
}
