Class UM_SRCustomProgressInt extends UM_SRCustomProgress
	Abstract;

var int CurrentValue;

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
	Return CurrentValue;
}

function SetProgress( string S )
{
	CurrentValue = int(S);
}

function IncrementProgress( int Count )
{
	CurrentValue += Count;
	ValueUpdated();
}

defaultproperties
{
}