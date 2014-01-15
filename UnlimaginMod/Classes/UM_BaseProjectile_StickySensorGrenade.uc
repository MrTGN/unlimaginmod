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
//[block] Replication

//[end] Replication
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
	local	Pawn	CheckPawn, CheckKFMonster;
	
	if ( !bHidden && !bTriggered )  {
		if ( !bEnemyDetected )  {
			bAlwaysRelevant = False;
			foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DetectionRadius, Location )  {
				if ( KFMonster(CheckPawn) != none )  {
					bEnemyDetected = True;
					bAlwaysRelevant = True;
					PlaySound(BeepSound.S,,(BeepSound.V * 1.5),,BeepSound.R);
					SetTimer(0.2,True);
					Break;
				}
			}
		}
		else  {
			foreach VisibleCollidingActors( class 'Pawn', CheckPawn, DamageRadius, Location )  {
				if ( CheckPawn == Instigator )
					++ExplodeDelay;
				else if ( KFMonster(CheckPawn) != None )
					CheckKFMonster = CheckPawn;
			}
			
			if ( CheckKFMonster == None )  {
				bEnemyDetected = False;
				SetTimer(ExplodeTimer, True);
				if ( ExplodeDelay > 0 )
					ExplodeDelay = 0;
				
				Return;
			}
			
			if ( ExplodeDelay > 0 )  {
				PlaySound(BeepSound.S,SLOT_Misc,BeepSound.V,,DamageRadius);
				--ExplodeDelay;
			}
			else
				Explode(Location,vect(0,0,1));
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
