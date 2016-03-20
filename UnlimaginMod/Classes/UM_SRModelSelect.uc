class UM_SRModelSelect extends KFModelSelect;

var int CustomOffset;
var localized string AllText,CustomText,StockText;
var array<int> CharCategories;
var array<string> CategoryNames;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	local UM_ClientRepInfoLink S;
	local int i,j;
	local string C,G;
	local xUtil.PlayerRecord PR;

	Super(LockedFloatingWindow).Initcomponent(MyController, MyOwner);

	co_Race.MyComboBox.List.bInitializeList = True;
	co_Race.ReadOnly(True);
	co_Race.AddItem(AllText);

	sb_Main.SetPosition(0.040000,0.075000,0.680742,0.555859);
	sb_Main.RightPadding = 0.5;
	sb_Main.ManageComponent(CharList);

	S = Class'UM_ClientRepInfoLink'.Static.FindStats(PlayerOwner());
	if ( S == None || !S.bNoStandardChars )  {
		class'xUtil'.static.GetPlayerList(PlayerList);
		co_Race.AddItem(StockText);
		CategoryNames.Length = 1;
		CategoryNames[0] = StockText;
	}
	
	CustomOffset = 0;
	CharCategories.Length = PlayerList.Length;

	// Add in custom mod chars.
	if ( S != None )  {
		for( i = 0; i < S.CustomChars.Length; ++i )  {
			C = S.CustomChars[i];
			j = InStr(C,":");
			
			if ( j == -1 )
				G = CustomText;
			else  {
				G = Left(C,j);
				C = Mid(C,j+1);
			}
			
			PR = Class'xUtil'.Static.FindPlayerRecord(C);
			
			if ( PR.DefaultName ~= C )  {
				++CustomOffset;
				PlayerList.Insert(0,1);
				PlayerList[0] = PR;
				for( j = 0; j < CategoryNames.Length; ++j )  {
					if ( CategoryNames[j] ~= G )
						Break;
				}
				
				if ( j == CategoryNames.Length )  {
					CategoryNames.Length = j + 1;
					CategoryNames[j] = G;
					co_Race.AddItem(G);
				}
				CharCategories.Insert(0,1);
				CharCategories[0] = j;
			}
		}
	}

	co_Race.OnChange=RaceChange;

	for( i = (PlayerList.Length - 1); i >= CustomOffset; --i )  {
		if ( !IsUnLocked(PlayerList[i]) )
			PlayerList.Remove(i, 1);
	}

	RefreshCharacterList("");

	// Spawn spinning character actor
	if ( SpinnyDude == None )
		SpinnyDude = PlayerOwner().spawn(class'XInterface.SpinnyWeap');

	SpinnyDude.SetDrawType(DT_Mesh);
	SpinnyDude.SetDrawScale(0.9);
	SpinnyDude.SpinRate = 0;
}

function RefreshCharacterList(string ExcludedChars, optional string Race)
{
	local int i,iCategory;

	// Prevent list from calling OnChange events
	CharList.List.bNotify = False;
	CharList.Clear();

	if ( Race == "" )
		iCategory = -1;
	else  {
		for( i = 0; i < CategoryNames.Length; ++i )  {
			if ( CategoryNames[i] ~= Race )  {
				iCategory = i;
				Break;
			}
		}
	}

	for ( i = 0; i < PlayerList.Length; i++ )  {
		if ( iCategory == -1 || iCategory == CharCategories[i] )
			CharList.List.Add( Playerlist[i].Portrait, i, 0 );
	}
	
	CharList.List.bNotify = True;
}

function RaceChange(GUIComponent Sender)
{
	local string specName;

	specName = co_Race.GetText();
	
	if ( specName ~= AllText )
		specName = "";

	RefreshCharacterList("", specName);
}

function ListChange(GUIComponent Sender)
{
	local ImageListElem Elem;

	CharList.List.GetAtIndex(CharList.List.Index, Elem.Image, Elem.Item,Elem.Locked);

	if ( Elem.Item >= 0 && Elem.Item < Playerlist.Length )  {
		if ( Elem.Locked == 1 )
			b_Ok.DisableMe();
		else
			b_Ok.EnableMe();

		sb_Main.Caption = PlayerList[Elem.Item].DefaultName;
	}
	else
		sb_Main.Caption = "";
	
	UpdateSpinnyDude();
}

function bool IsUnlocked(xUtil.PlayerRecord Test)
{
	local int i;

	// If character has no menu filter, just Return True
	if ( PlayerOwner() == None )
		Return True;

	for( i = 0; i < CustomOffset; ++i )  {
		if ( PlayerList[i].DefaultName ~= Test.DefaultName )
			Return True;
	}

	Return PlayerOwner().CharacterAvailable(Test.DefaultName);
}

defaultproperties
{
	AllText="All"
	CustomText="Custom"
	StockText="Stock"

	Begin Object Class=moComboBox Name=CharRace
		bScaleToParent=True
		bBoundToParent=True
		WinWidth=0.388155
		WinHeight=0.042857
		WinLeft=0.052733
		WinTop=0.880000
		Caption="Show"
		Hint="Filter the available characters."
		CaptionWidth=0.25
		bAutoSizeCaption=True
		ComponentJustification=TXTA_Left
		TabOrder=4
		bReadOnly=True
	End Object
	co_Race=moComboBox'UnlimaginMod.UM_SRModelSelect.CharRace'
}
