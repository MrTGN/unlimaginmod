class UM_SRStatListBox extends GUIListBoxBase;

var UM_SRStatList List;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super.InitComponent(MyController,MyOwner);
	
	if ( DefaultListClass != "" )  {
		List = UM_SRStatList(AddComponent(DefaultListClass));
		if ( List == None )  {
			Warn(Class$".InitComponent - Could not create default list ["$DefaultListClass$"]");
			Return;
		}
	}
	
	if ( List == None )  {
		Warn("Could not initialize list!");
		Return;
	}
	
	InitBaseList(List);
}

function int GetIndex()
{
	Return List.Index;
}

defaultproperties
{
     DefaultListClass="UnlimaginMod.UM_SRStatList"
}
