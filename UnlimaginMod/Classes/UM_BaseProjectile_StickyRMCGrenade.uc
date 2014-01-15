//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_StickyRMCGrenade
//	Parent class:	 UM_BaseProjectile_StickyGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 03:17
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Sticky grenade with remote control (RMC)
//================================================================================
class UM_BaseProjectile_StickyRMCGrenade extends UM_BaseProjectile_StickyGrenade
	Abstract;


event Timer()
{
	local	Pawn	CheckPawn;
	
	if ( !bHidden && !bTriggered )
	{
		foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DamageRadius, Location )
		{
			if ( CheckPawn == Instigator )
			{
				++ExplodeDelay;
				SetTimer(0.2,True);
				Break;
			}
		}
		
		if ( ExplodeDelay > 0 )
		{
			PlaySound(BeepSound.S,SLOT_Misc,BeepSound.V,,DamageRadius);
			--ExplodeDelay;
		}
		else
			Explode(Location,vect(0,0,1));
	}
	else
		Destroy();
}

function Activate()
{
	PlaySound(BeepSound.S,SLOT_Misc,(BeepSound.V * 1.5),,DamageRadius);
	SetTimer(ExplodeTimer, False);
}

defaultproperties
{
     //SafeRange=300.000000
	 ExplodeTimer=0.150000
	 Damage=280.000000
	 DamageRadius=330.000000
	 MomentumTransfer=50000.000000
}
