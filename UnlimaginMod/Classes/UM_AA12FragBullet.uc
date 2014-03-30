//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12FragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.09.2012 17:23
//================================================================================
class UM_AA12FragBullet extends UM_BaseProjectile_ShotgunExpBullet;


defaultproperties
{
     ImpactDamageType=Class'UnlimaginMod.UM_DamTypeAA12FragImpact'
     ImpactDamage=140.000000
     //Sound Effects
	 TransientSoundVolume=2.000000
     //MuzzleVelocity
	 MuzzleVelocity=420.000000		// m/sec
     //
	 Damage=140.000000
	 DamageRadius=130.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'UnlimaginMod.UM_DamTypeAA12FragBullet'
}
