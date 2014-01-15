Class UM_SRCustomProgressFloat extends UM_SRCustomProgress
	Abstract;

var float CurrentValue;

replication
{
	reliable if( Role==ROLE_Authority && bNetOwner )
		CurrentValue;
}

simulated function string GetProgress()
{
	Return string(CurrentValue);
}

simulated function int GetProgressInt()
{
	return CurrentValue;
}

function SetProgress( string S )
{
	CurrentValue = float(S);
}

function IncrementProgress( int Count )
{
	CurrentValue += Count;
	ValueUpdated();
}

defaultproperties
{
}