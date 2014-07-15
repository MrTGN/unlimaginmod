//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseEmitter
//	Parent class:	 Emitter
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.09.2013 14:00
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseEmitter extends Emitter
	Abstract;


//========================================================================
//[block] Functions

simulated event Trigger( Actor Other, Pawn EventInstigator )
{
	local	int		i;
	
	for ( i = 0; i < Emitters.Length; ++i )  {
		if ( Emitters[i] != None )
			Emitters[i].Trigger();
	}
}

simulated event SpawnParticle( int Amount )
{
	local	int		i;
	
	for ( i = 0; i < Emitters.Length; ++i )  {
		if ( Emitters[i] != None )
			Emitters[i].SpawnParticle(Amount);
	}
}

simulated function Reset()
{
	local	int		i;

	for ( i = 0; i < Emitters.Length; ++i )  {
		if ( Emitters[i] != None )
			Emitters[i].Reset();
	}	
}

//[end] Functions
//====================================================================


defaultproperties
{
     RemoteRole=ROLE_None
	 Style=STY_Particle
     bUnlit=True
     bNotOnDedServer=True
	 LifeSpan=0.000000
}
