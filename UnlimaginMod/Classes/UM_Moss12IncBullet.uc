//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Moss12IncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.03.2013 19:10
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_Moss12IncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
     TransientSoundVolume=2.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeMoss12IncImpact'
     ImpactDamage=100.000000
	 //MuzzleVelocity
	 MuzzleVelocity=400.000000		// m/sec
     Damage=100.000000
	 DamageRadius=140.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMoss12IncBullet'
}
