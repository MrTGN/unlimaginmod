Class UM_SRCustomProgress extends ReplicationInfo
	Abstract;

var() localized string ProgressName;
var UM_ClientRepInfoLink RepLink;
var UM_SRCustomProgress NextLink;

replication
{
	reliable if( Role==ROLE_Authority && bNetOwner )
		NextLink;
}

simulated function string GetProgress();

simulated function int GetProgressInt()
{
	Return int(GetProgress());
}

simulated function string GetDisplayString()
{
	Return GetProgress();
}

function SetProgress( string S );

function IncrementProgress( int Count );

final function ValueUpdated()
{
	if ( RepLink.StatObject != None )
		RepLink.StatObject.NotifyStatChanged();
}

simulated final function string GetTimeText( int V )
{
	local int Hours, Minutes;

	Minutes = V / 60;
	Hours   = Minutes / 60;
	V -= (Minutes * 60);
	Minutes -= (Hours * 60);

	return Eval(Hours<10,"0"$Hours,string(Hours))$":"$Eval(Minutes<10,"0"$Minutes,string(Minutes))$":"$Eval(V<10,"0"$V,string(V));
}

// Called when stat owner killed or was killed by a monster.
function NotifyPlayerKill( Pawn Killed, class<DamageType> damageType );
function NotifyPlayerKilled( Pawn Killer, class<DamageType> damageType );

defaultproperties
{
	bAlwaysRelevant=false
	bOnlyRelevantToOwner=true
	bOnlyDirtyReplication=true
	ProgressName="Lazy modder! Kill him!!"
	NetUpdateFrequency=2
}