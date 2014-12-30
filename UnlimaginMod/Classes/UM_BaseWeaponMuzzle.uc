//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseWeaponMuzzle
//	Parent class:	 UM_BaseWeaponModule
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2014 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 22.08.2014 00:54
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseWeaponMuzzle extends UM_BaseWeaponModule
	Abstract;

//========================================================================
//[block] Variables

var	protected	UM_BaseProjectileWeaponFire		FireMode;
var		UM_BaseWeapon		Weapon;

var		float				MuzzleVelocityScale;
var		float				SpreadScale;

// This view shakes variables will be added to the same variables in the fire class.
// Use this variables to add the different effects from the different muzzles.
var		vector				RelativeShakeRotMag;		// how far to rot view
var		vector				RelativeShakeRotRate;		// how fast to rot view
var		float				RelativeShakeRotTime;		// how much time to rot the instigator's view
var		vector				RelativeShakeOffsetMag;		// max view offset vertically
var		vector				RelativeShakeOffsetRate;	// how fast to offset view vertically
var		float				RelativeShakeOffsetTime;	// how much time to offset view

//[end] Varibles
//====================================================================

//========================================================================
//[block] Replication

//[end] Replication
//====================================================================

//========================================================================
//[block] Functions

function SetFireMode( UM_BaseProjectileWeaponFire NewFireMode )
{
	FireMode = NewFireMode;
}

//[end] Functions
//====================================================================

defaultproperties
{
     bGameRelevant=True
	 MuzzleVelocityScale=1.000000
	 SpreadScale=1.000000
	 bReplicateMovement=True
	 bReplicateInstigator=True
	 bOnlyOwnerSee=True
     bOnlyRelevantToOwner=True
	 //bOnlyRelevantToOwner=False
     bOnlyDirtyReplication=True
	 bOnlyDrawIfAttached=True
	 //bOnlyDrawIfAttached=False
     //RemoteRole=ROLE_SimulatedProxy
	 RemoteRole=ROLE_None
	 //RemoteRole=ROLE_None
     NetUpdateFrequency=2.000000
     NetPriority=3.000000
     bTravel=True
     bClientAnim=True
     bNetNotify=True
	 bCollideWorld=False
	 bBlockActors=False
	 bBlockPlayers=False
	 bIgnoreEncroachers=True
	 bIgnoreOutOfWorld=True
	 CollisionRadius=0.0
	 CollisionHeight=0.0
}
