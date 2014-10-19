//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_StickySensorGrenade
//	Parent class:	 UM_BaseProjectile_StickyGrenade
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 19.07.2013 03:24
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_StickySensorGrenade extends UM_BaseProjectile_StickyGrenade
	Abstract;


//========================================================================
//[block] Variables

var		bool		bEnemyDetected;		// We've found an enemy
var		float		DetectionRadius;	// How far away to detect enemies

//[end] Varibles
//====================================================================

//========================================================================
//[block] Functions

simulated event PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	
	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
}

event Timer()
{
	if ( IsArmed() )  {
		// Idle
		if ( !bEnemyDetected )  {
			bEnemyDetected = MonsterIsInRadius(DetectionRadius);
			if ( bEnemyDetected )  {
				bAlwaysRelevant = True;
				if ( BeepSound.Snd != None )
					PlaySound(BeepSound.Snd, BeepSound.Slot, (BeepSound.Vol * 1.5), BeepSound.bNoOverride, BeepSound.Radius, GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
				SetTimer(0.2,True);
			}
		}
		// Armed
		else  {
			bEnemyDetected = MonsterIsInRadius(DamageRadius);
			if ( bEnemyDetected )  {
				if ( !FriendlyPawnIsInRadius(DamageRadius) )
					Explode(Location, Vector(Rotation));
				else if ( BeepSound.Snd != None )
					PlaySound(BeepSound.Snd, BeepSound.Slot, BeepSound.Vol, BeepSound.bNoOverride, BeepSound.Radius, GetRandPitch(BeepSound.PitchRange), BeepSound.bUse3D);
			}
			else  {
				bAlwaysRelevant = False;
				SetTimer(ExplodeTimer, True);
			}
		}
	}
	else
		Destroy();
}

simulated function Stick(actor HitActor, vector HitLocation, vector HitNormal)
{
	if ( Role == ROLE_Authority && !bTimerSet )  {
		SetTimer(ExplodeTimer, True);
		bTimerSet = True;
	}
	Super.Stick(HitActor, HitLocation, HitNormal);
}

//[end] Functions
//====================================================================

defaultproperties
{
     //Actually ExplodeTimer is a scanning delay time here
	 ExplodeTimer=0.500000
	 DetectionRadius=150.000000
	 Damage=290.000000
	 DamageRadius=320.000000
	 MomentumTransfer=50000.000000
}
