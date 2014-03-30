//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM4IncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.09.2012 17:46
//================================================================================
class UM_BenelliM4IncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
     TransientSoundVolume=1.800000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM4IncImpact'
     ImpactDamage=100.000000
	 //MuzzleVelocity
	 MuzzleVelocity=445.000000		// m/sec
     Damage=95.000000
	 DamageRadius=160.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM4IncBullet'
}
