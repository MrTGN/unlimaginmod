// Because this is most likely going to fail on init, spawn the real stats actor here...
Class UM_ServerTempStats extends KFSteamStatsAndAchievements;

event PostBeginPlay()
{
	local KFPlayerController PlayerOwner;

	PlayerOwner = KFPlayerController(Owner);
	if( PlayerOwner.Player==None )
		return; // very bad...
	Spawn(Class'UM_ServerStats',PlayerOwner);
}

defaultproperties
{
	bNetNotify=false
	bUsedCheats=True
	bFlushStatsToClient=false
	RemoteRole=ROLE_None
	LifeSpan=0.1
}
