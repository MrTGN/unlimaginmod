//=============================================================================
// Quick Perk Select Menu for the trader
//=============================================================================
class UM_SRKFQuickPerkSelect extends KFQuickPerkSelect;

event InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local UM_SRClientPerkRepLink S;

	Super(GUIMultiComponent).InitComponent(MyController, MyOwner);

	if ( PlayerOwner() != None )  {
		S = Class'UM_SRClientPerkRepLink'.Static.FindStats( PlayerOwner() );
		if ( S != None )
			CheckPerksX(S);
	}
}

function bool MyOnDraw(Canvas C)
{                                                                                                         
	local int i, j;
	local UM_SRClientPerkRepLink S;
	local Material M,SM;

	Super(GUIMultiComponent).OnDraw(C);
	
	C.SetDrawColor(255, 255, 255, 255);
	
	// make em square
	if ( !bResized )
		ResizeIcons(C);
		
	// Current perk background
	C.SetPos(WinLeft * C.ClipX , WinTop * C.ClipY);
	C.DrawTileScaled(CurPerkBack, (WinHeight * C.ClipY) / CurPerkBack.USize, (WinHeight * C.ClipY) / CurPerkBack.USize);

	S = Class'UM_SRClientPerkRepLink'.Static.FindStats(C.Viewport.Actor);
	if ( S != None )  {
		// check if the current perk has changed recently
		CheckPerksX(S);
		
		j = 0;
		// Draw the available perks
		for ( i = 0; i < MaxPerks; ++i )  {
			if ( i != CurPerk )  {
				S.CachePerks[i].PerkClass.Static.PreDrawPerk(C, (Max(S.CachePerks[i].CurrentLevel, 1) - 1), M, SM);
				PerkSelectIcons[j].Image = M;
				PerkSelectIcons[j].Index = i;
				PerkSelectIcons[j].ImageColor = C.DrawColor;
				PerkSelectIcons[j].ImageColor.A = 255;
				++j;
			}
		}
		
		//ToDo: what is this?
		for( i = j; i < ArrayCount(PerkSelectIcons); ++i )  {
			PerkSelectIcons[i].Image = None;
			PerkSelectIcons[i].Index = -1;
		}

		// Draw current perk
		if ( CurPerk != 255 )
			DrawCurrentPerkX(S, C, CurPerk);
	}
	
	Return False;
}

function bool InternalOnClick(GUIComponent Sender)
{
	local UM_SRClientPerkRepLink S;

	if ( Sender.IsA('KFIndexedGUIImage') && KFIndexedGUIImage(Sender).Index >= 0 )  {
		S = Class'UM_SRClientPerkRepLink'.Static.FindStats( PlayerOwner() );
		if ( S != None )
			S.ServerSelectPerk(S.CachePerks[KFIndexedGUIImage(Sender).Index].PerkClass);
		
		bPerkChange = True;
	}
	
	Return False;	
}

function DrawCurrentPerkX( UM_SRClientPerkRepLink S, Canvas C, Int PerkIndex)
{
	local Class<UM_SRVeterancyTypes> V;
	local Material M,SM;

	V = S.CachePerks[PerkIndex].PerkClass;
	C.SetPos((WinLeft * C.ClipX), (WinTop * C.ClipY));
	V.Static.PreDrawPerk(C, (Max(S.CachePerks[PerkIndex].CurrentLevel, 1) - 1), M, SM);
	if ( M != None )
		C.DrawTileScaled(M, (WinHeight * C.ClipY) / M.MaterialUSize(), (WinHeight * C.ClipY) / M.MaterialVSize());
}

function CheckPerksX( UM_SRClientPerkRepLink S )
{
	local int i;
	local KFPlayerReplicationInfo PRI;

	// Grab the Player Controller for later use
	PRI = KFPlayerReplicationInfo(PlayerOwner().PlayerReplicationInfo);
	
	// Hold onto our reference
	if ( S == None )
		Return;

	if ( S.CachePerks.Length == 0 )  {
		S.ServerRequestPerks();
		Return;
	}

	// Update the ItemCount and select the first item
	MaxPerks = Min(S.CachePerks.Length, ArrayCount(PerkSelectIcons));
	CurPerk = 255;

	for( i = 0; i < S.CachePerks.Length; ++i )  {
		if ( PRI != None && S.CachePerks[i].PerkClass == PRI.ClientVeteranSkill )  {
			CurPerk = i;
			Break;
		}
	}
	
	bPerkChange = False;
}

defaultproperties
{
     MaxPerks=6
}