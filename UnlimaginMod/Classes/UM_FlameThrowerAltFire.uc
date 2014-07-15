//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FlameThrowerAltFire
//	Parent class:	 UM_FlameThrowerFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.05.2013 00:09
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_FlameThrowerAltFire extends UM_FlameThrowerFire;

function AddKickMomentum()
{
	// Modified to always push the player
	if ( Instigator != None )
	{
		if ( Instigator.PhysicsVolume.Gravity.Z > class'PhysicsVolume'.default.Gravity.Z )
			Instigator.AddVelocity((KickMomentum * LowGravKickMomentumScale) >> Instigator.GetViewRotation());
		else
			Instigator.AddVelocity(KickMomentum >> Instigator.GetViewRotation());
	}
}

defaultproperties
{
	 bNoKickMomentum=False
	 ProjPerFire=1
	 AmmoPerFire=3
     KickMomentum=(X=-60.000000,Z=10.000000)
     // ProjectileClass=Class'UnlimaginMod.UM_FlameThrowerGas'
     ProjectileClass=Class'KFMod.FlameTendril'
}