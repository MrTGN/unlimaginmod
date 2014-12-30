//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Weapon_HandGrenade
//	Parent class:	 Frag
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 12.04.2013 22:52
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_Weapon_HandGrenade extends Frag;

/*
var		bool		bPawnCurrentWeightReduced;

function Tick( float DeltaTime )
{
    local Inventory I;
	
	Super.Tick(DeltaTime);
	
	if ( AmmoAmount(0) < 1 )
	{
		if ( !bPawnCurrentWeightReduced )
		{
			if ( Weight != 0.000000)
				Weight = 0.000000;
			if ( KFHumanPawn(Instigator) != None )
			{
				KFHumanPawn(Instigator).CurrentWeight -= default.Weight;
				bPawnCurrentWeightReduced = True;
			}
		}
	}
	else
	{
		if ( bPawnCurrentWeightReduced )
		{
			if ( Weight != default.Weight )
				Weight = default.Weight;
			if ( KFHumanPawn(Instigator) != None )
			{
				KFHumanPawn(Instigator).CurrentWeight += default.Weight;
				if ( KFHumanPawn(Instigator).CurrentWeight > KFHumanPawn(Instigator).MaxCarryWeight )
				{
					for ( I = Instigator.Inventory; I != none; I = I.Inventory )
					{
						if ( KFWeapon(I) != none && !KFWeapon(I).bKFNeverThrow &&
							 Knife(I) == None )
						{
							I.Velocity = Velocity;
							I.DropFrom(Instigator.Location + VRand() * 10);
							
							if ( KFHumanPawn(Instigator).CurrentWeight <= KFHumanPawn(Instigator).MaxCarryWeight )
								break; // Drop weapons until player is capable of carrying them all.
						}
					}
				}
				bPawnCurrentWeightReduced = False;
			}
		}
	}
} */

defaultproperties
{
     FireModeClass(0)=Class'UnlimaginMod.UM_HandGrenadeFire'
	 Weight=0.000000
}
