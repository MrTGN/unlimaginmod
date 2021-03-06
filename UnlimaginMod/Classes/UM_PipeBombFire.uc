//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_PipeBombFire
//	Parent class:	 PipeBombFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 25.07.2012 20:40
//================================================================================
class UM_PipeBombFire extends PipeBombFire;

#exec OBJ LOAD FILE=KF_AxeSnd.uax

function projectile SpawnProjectile(Vector Start, Rotator Dir)
{
	local Projectile p;
	 
	// -- Switch damage types for the firebug --
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None 
		&& KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None 
		&& KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex == 5 )
		p = Weapon.Spawn(Class'UnlimaginMod.UM_NapalmPipeBombProj',,, Start, Dir);
	else
		p = Weapon.Spawn(default.ProjectileClass,,, Start, Dir);

	if( p == None )
		Return None;

	p.Damage *= DamageAtten;

	if( PipeBombProjectile(p) != None && Instigator != None )
		PipeBombProjectile(p).PlacedTeam = Instigator.PlayerReplicationInfo.Team.TeamIndex;

	Return p;
}

/*
event ModeDoFire()
{
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
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
