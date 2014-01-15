//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_PipeBombFire
//	Parent class:	 PipeBombFire
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 25.07.2012 20:40
//================================================================================
class UM_PipeBombFire extends PipeBombFire;

#exec OBJ LOAD FILE=KF_AxeSnd.uax

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;
	 
	// -- Switch damage types for the firebug --
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none 
		&& KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none 
		&& KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		p = Weapon.Spawn(Class'UnlimaginMod.UM_NapalmPipeBombProj',,, Start, Dir);
	else
		p = Weapon.Spawn(default.ProjectileClass,,, Start, Dir);

	if( p == None )
		return None;

	p.Damage *= DamageAtten;

	if( PipeBombProjectile(p) != none && Instigator != none )
		PipeBombProjectile(p).PlacedTeam = Instigator.PlayerReplicationInfo.Team.TeamIndex;

	return p;
}

/*
event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != none && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != none )
	{
		// -- Switch damage types for the firebug --
		if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
			ProjectileClass = Class'UnlimaginMod.UM_NapalmPipeBombProj';
		else
			ProjectileClass = default.ProjectileClass;
	}
	
	Super.ModeDoFire();
}
*/

defaultproperties
{
     FireRate=1.750000
     ProjectileClass=Class'KFMod.PipeBombProjectile'
}
