class UM_SRLobbyChat extends KFLobbyChat;

function InitComponent(GUIController MyController, GUIComponent MyOwner)
{
	Super(PopupPageBase).InitComponent( MyController, MyOwner );

	TextColor[0] = class'SayMessagePlus'.default.RedTeamColor;
	TextColor[1] = class'SayMessagePlus'.default.BlueTeamColor;
	TextColor[2] = class'SayMessagePlus'.default.DrawColor;

	eb_Send.MyEditBox.OnKeyEvent = InternalOnKeyEvent;
	lb_Chat.MyScrollText.bNeverFocus = True;
}

function bool NotifyLevelChange() // Don't keep this one around...
{
	bPersistent = False;
	
	Return True;
}

defaultproperties
{
}
