//=============================================================================
// UM_SRGameRules
//=============================================================================
class UM_SRGameRules extends GameRules;

function PostBeginPlay()
{
	if ( Level.Game.GameRulesModifiers == None )
		Level.Game.GameRulesModifiers = Self;
	else 
		Level.Game.GameRulesModifiers.AddGameRules(Self);
}

function AddGameRules(GameRules GR)
{
	if ( GR != Self )
		Super.AddGameRules(GR);
}

function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	local UM_ClientRepInfoLink R;
	local UM_SRCustomProgress S;

	if ( (NextGameRules != None) && NextGameRules.PreventDeath(Killed,Killer, damageType,HitLocation) )
		Return True;

	if ( xPlayer(Killer) != None && Killed.Controller != None && Killed.Controller != Killer )  {
		R = FindStatsFor(Killer);
		if ( R != None )  {
			for( S = R.CustomLink; S != None; S = S.NextLink )
				S.NotifyPlayerKill(Killed,damageType);
		}
	}
	
	if( xPlayer(Killed.Controller) != None && Killer != None && Killer.Pawn != None )  {
		R = FindStatsFor(Killed.Controller);
		if ( R != None )  {
			for ( S = R.CustomLink; S != None; S = S.NextLink )
				S.NotifyPlayerKilled(Killer.Pawn,damageType);
		}
	}
	
	Return False;
}

final function UM_ClientRepInfoLink FindStatsFor( Controller C )
{
	local LinkedReplicationInfo L;

	if ( C.PlayerReplicationInfo == None )
		Return None;
	
	for ( L = C.PlayerReplicationInfo.CustomReplicationInfo; L != None; L = L.NextReplicationInfo )  {
		if ( UM_ClientRepInfoLink(L) != None )
			Return UM_ClientRepInfoLink(L);
	}
	
	return None;
}

defaultproperties
{
}