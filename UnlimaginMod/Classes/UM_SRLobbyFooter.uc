//-----------------------------------------------------------
//
//-----------------------------------------------------------
class UM_SRLobbyFooter extends LobbyFooter;

var automated GUIButton b_ViewMap;

function bool InternalOnPreDraw(Canvas C)
{
	if ( PlayerOwner().PlayerReplicationInfo != None 
		 && PlayerOwner().PlayerReplicationInfo.bReadyToPlay )  {
		//Unhide ViewMap button
		EnableComponent(b_ViewMap);
		b_ViewMap.Show();
	}
	else  {
		//Hide ViewMap button
		b_ViewMap.Hide();
		DisableComponent(b_ViewMap);
	}

	Return Super.InternalOnPreDraw(C);
}

function bool OnFooterClick(GUIComponent Sender)
{
	local GUIController C;
	local PlayerController PC;

	PC = PlayerOwner();
	C = Controller;
	if ( Sender == b_Cancel )  {
		//Kill Window and exit game/disconnect from server
		LobbyMenu(PageOwner).bAllowClose = True;
		C.ViewportOwner.Console.ConsoleCommand("DISCONNECT");
		PC.ClientCloseMenu(true, false);
		C.AutoLoadMenus();
	}
	else if ( Sender == b_Ready )  {
		//Set Ready
		if ( PC.Level.NetMode == NM_Standalone || !PC.PlayerReplicationInfo.bReadyToPlay )  {
			PC.ServerRestartPlayer();
			PC.PlayerReplicationInfo.bReadyToPlay = True;
			//Hide Menu - Match has begun
			if ( PC.Level.GRI.bMatchHasBegun )
				PC.ClientCloseMenu(true, false);
			
			b_Ready.Caption = UnreadyString;
			//Unhide ViewMap button
			EnableComponent(b_ViewMap);
			b_ViewMap.Show();
		}
		//Set UnReady
		else if ( KFPlayerController(PC) != None )  {
			//Hide ViewMap button
			b_ViewMap.Hide();
			DisableComponent(b_ViewMap);
			KFPlayerController(PC).ServerUnreadyPlayer();
			PC.PlayerReplicationInfo.bReadyToPlay = False;
			b_Ready.Caption = ReadyString;
		}
	}
	else if ( Sender == b_Options )
		PC.ClientOpenMenu("KFGUI.KFSettingsPage", false);
	else if ( Sender == b_Perks )
		PC.ClientOpenMenu("UnlimaginMod.UM_SRInvasionLoginMenu", false);
	else if ( Sender == b_ViewMap && PC.PlayerReplicationInfo.bReadyToPlay )  {
		// Spectate map while waiting for players to get ready
		LobbyMenu(PageOwner).bAllowClose = True;
		PC.ClientCloseMenu(true, false);
	}
	
	Return False;
}


defaultproperties
{
	 Begin Object Class=GUIButton Name=ViewMapButton
         Caption="View Map"
         Hint="Explore the current map"
         WinTop=0.966146
         WinLeft=0.350000
         WinWidth=0.120000
         WinHeight=0.033203
         RenderWeight=2.000000
         TabOrder=1
         bBoundToParent=True
         ToolTip=None
         OnClick=UM_SRLobbyFooter.OnFooterClick
         OnKeyEvent=ViewMapButton.InternalOnKeyEvent
     End Object
     b_ViewMap=GUIButton'UnlimaginMod.UM_SRLobbyFooter.ViewMapButton'
	
	Begin Object Class=GUIButton Name=ReadyButton
         Caption="Ready"
         Hint="Click to indicate you are ready to play"
         WinTop=0.966146
         WinLeft=0.280000
         WinWidth=0.120000
         WinHeight=0.033203
         RenderWeight=2.000000
         TabOrder=2
         bBoundToParent=True
         ToolTip=None
         OnClick=UM_SRLobbyFooter.OnFooterClick
         OnKeyEvent=ReadyButton.InternalOnKeyEvent
     End Object
     b_Ready=GUIButton'UnlimaginMod.UM_SRLobbyFooter.ReadyButton'
	 
	 Begin Object Class=GUIButton Name=Perks
		Caption="Menu"
        Hint="Select Your Character and Perk"
		WinTop=0.966146
		WinLeft=-0.500000
		WinWidth=0.120000
		WinHeight=0.033203
		RenderWeight=2.000000
		TabOrder=3
		bBoundToParent=True
		ToolTip=None
		OnClick=UM_SRLobbyFooter.OnFooterClick
		OnKeyEvent=Perks.InternalOnKeyEvent
	End Object
	b_Perks=GUIButton'UnlimaginMod.UM_SRLobbyFooter.Perks'
	 
	 Begin Object Class=GUIButton Name=Options
         Caption="Options"
         Hint="Change game settings."
         WinTop=0.966146
         WinLeft=-0.500000
         WinWidth=0.120000
         WinHeight=0.033203
         RenderWeight=2.000000
         TabOrder=4
         bBoundToParent=True
         ToolTip=None
         OnClick=UM_SRLobbyFooter.OnFooterClick
         OnKeyEvent=Options.InternalOnKeyEvent
     End Object
     b_Options=GUIButton'UnlimaginMod.UM_SRLobbyFooter.Options'
	
	ReadyString="Ready"
    UnreadyString="Unready"
	OnPreDraw=UM_SRLobbyFooter.InternalOnPreDraw
}
