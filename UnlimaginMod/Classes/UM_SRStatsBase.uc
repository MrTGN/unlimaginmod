// Template class.
Class UM_SRStatsBase extends KFSteamStatsAndAchievements
	Abstract;

var UM_SRClientPerkRepLink Rep;
var KFPlayerController PlayerOwner;
var bool bStatsReadyNow;

function int GetID();
function SetID( int ID );
function ChangeCharacter( string CN );
function ApplyCharacter( string CN );

function ServerSelectPerkName( name N );
function ServerSelectPerk( Class<UM_SRVeterancyTypes> VetType );

function NotifyStatChanged();

defaultproperties
{
	bNetNotify=false
	bUsedCheats=true
	bFlushStatsToClient=false
	bInitialized=true
	RemoteRole=ROLE_None
}