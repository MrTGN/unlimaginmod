//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_HandGrenadeFire
//	Parent class:	 FragFire
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 15.05.2013 02:33
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_HandGrenadeFire extends FragFire;

var		array< class<Projectile> >		PerkProjectileClass;

/* Accessor function that returns the type of projectile we want this weapon to fire right now*/
function class<Projectile> GetDesiredProjectileClass()
{
	local	byte	DefPerkIndex;
	
	if ( KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo) != None && 
		 KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill != None )
	{
		DefPerkIndex = KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkill.default.PerkIndex;
		if ( PerkProjectileClass[DefPerkIndex] != None && 
			 KFPlayerReplicationInfo(Instigator.PlayerReplicationInfo).ClientVeteranSkillLevel >= 3 )
			Return PerkProjectileClass[DefPerkIndex];
	}
	
    Return ProjectileClass;
}


/* Convenient place to perform changes to a newly spawned projectile */
function PostSpawnProjectile(Projectile P)
{
	local vector X, Y, Z;
	local float pawnSpeed;

	if ( P != None )
	{
		Weapon.GetViewAxes(X,Y,Z);
		pawnSpeed = X dot Instigator.Velocity;

		if ( Bot(Instigator.Controller) != None )
			P.Speed = mHoldSpeedMax;
		else
			P.Speed = mHoldSpeedMin + HoldTime*mHoldSpeedGainPerSec;

		P.Speed = FClamp(P.Speed, mHoldSpeedMin, mHoldSpeedMax);
		P.Speed = pawnSpeed + P.Speed;
		P.Velocity = P.Speed * Vector(P.Rotation);

        Super(BaseProjectileFire).PostSpawnProjectile(P);
	}
}

defaultproperties
{
     ProjectileClass=Class'UnlimaginMod.UM_StandardHandGrenade'
	 //Field Medic
	 PerkProjectileClass(0)=Class'KFMod.MedicNade'
	 //Support Specialist
	 PerkProjectileClass(1)=Class'UnlimaginMod.UM_HandGrenadeWithTungstenShrapnel'
	 //Commando
	 PerkProjectileClass(3)=Class'UnlimaginMod.UM_StickySensorHandGrenade'
	 //Firebug
	 PerkProjectileClass(5)=Class'UnlimaginMod.UM_NapalmHandGrenade'
	 //Demolitions
	 PerkProjectileClass(6)=Class'UnlimaginMod.UM_ClusterHandGrenade'
}
