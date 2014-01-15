//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseGrenadeLauncher
//	Parent class:	 UM_BaseWeapon
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 11.07.2013 02:14
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseGrenadeLauncher extends UM_BaseWeapon
	Abstract;


simulated exec function ToggleIronSights()
{
	if ( bHasAimingMode )
	{
		if ( bAimingRifle )
			PerformZoom(false);
		else
		{
			/*
			if ( Owner != none && Owner.Physics == PHYS_Falling &&
				Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
				Return;
			*/

			InterruptReload();

			if ( bIsReloading || !CanZoomNow() )
				Return;

			PerformZoom(True);
		}
	}
}

simulated exec function IronSightZoomIn()
{
	if( bHasAimingMode )
	{
		/*
		if ( Owner != none && Owner.Physics == PHYS_Falling &&
			Owner.PhysicsVolume.Gravity.Z <= class'PhysicsVolume'.default.Gravity.Z )
			Return;
		*/

		InterruptReload();

		if ( bIsReloading || !CanZoomNow() )
			Return;

		PerformZoom(True);
	}
}


//[block] Copied from KFWeaponShotgun with some changes
simulated function AddReloadedAmmo()
{
	//ToDo: Only Fire mode 0 ammo checking here
	// May be we need to check secondary ammo too.
	if ( AmmoAmount(0) > 0 )
		MagAmmoRemaining++;

	// Don't do this on a "Hold to reload" weapon, as it can update too quick actually and cause issues maybe - Ramm
	if ( !bHoldToReload )
		ClientForceKFAmmoUpdate(MagAmmoRemaining,AmmoAmount(0));

	/*
	if ( PlayerController(Instigator.Controller) != None && 
		 KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements) != None )
		KFSteamStatsAndAchievements(PlayerController(Instigator.Controller).SteamStatsAndAchievements).OnWeaponReloaded();
	*/
}
//[end]

//StartFire with InterruptReload() function
simulated function bool StartFire(int Mode)
{
	if ( !ReadyToFire(Mode) )
		Return False;

	InterruptReload();
	
	Return Super.StartFire(Mode);
}


defaultproperties
{
     bHoldToReload=True
}
