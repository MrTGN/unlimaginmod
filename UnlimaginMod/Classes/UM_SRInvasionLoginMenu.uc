class UM_SRInvasionLoginMenu extends KFInvasionLoginMenu;

function bool NotifyLevelChange() // We want to get ride of this menu!
{
	bPersistent = False;
	
	Return True;
}

function InitComponent(GUIController MyController, GUIComponent MyComponent)
{
	Super(UT2K4PlayerLoginMenu).InitComponent(MyController, MyComponent);
	c_Main.RemoveTab(Panels[0].Caption);
	c_Main.ActivateTabByName(Panels[1].Caption, true);
}

defaultproperties
{
	Panels(1)=(ClassName="UnlimaginMod.UM_SRTab_MidGamePerks",Caption="Perks",Hint="Select your current Perk")
	Panels(4)=(ClassName="UnlimaginMod.UM_SRTab_MidGameStats",Caption="Stats",Hint="View your current stats of this server")
}