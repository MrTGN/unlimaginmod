Class UM_SRLevelCleanup extends Interaction;

function NotifyLevelChange()
{
	local	int		i;

	// Make sure GUI controller leaves no menus referenced.
	GUIController(ViewportOwner.GUIController).ResetFocus();
	GUIController(ViewportOwner.GUIController).FocusedControl = None;
	
	for ( i = 0; i < ViewportOwner.LocalInteractions.Length; ++i )  {
		if ( ViewportOwner.LocalInteractions[i] == Self )  {
			ViewportOwner.LocalInteractions.Remove(i, 1);
			--i;
		}
	}
	
	if ( ViewportOwner != None )
		ViewportOwner.Console.DelayedConsoleCommand("OBJ GARBAGE"); // Ensure to cleanup everything releated to this mod.
}

static final function AddSafeCleanup( PlayerController PC )
{
	local	int					i;
	local	UM_SRLevelCleanup	C;
	
	if ( PC.Player == None )
		Return;

	for ( i = 0; i < PC.Player.LocalInteractions.Length; ++i )  {
		if ( PC.Player.LocalInteractions[i].Class == Default.Class )
			Return;
	}
	
	C = new(None) Class'UM_SRLevelCleanup';
	C.ViewportOwner = PC.Player;
	C.Master = PC.Player.InteractionMaster;
	PC.Player.LocalInteractions[PC.Player.LocalInteractions.Length] = C;
	C.Initialize();
}

defaultproperties
{
}
