//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_AA12IncBullet
//	Parent class:	 UM_BaseProjectile_ShotgunIncBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 20.09.2012 17:38
//================================================================================
class UM_AA12IncBullet extends UM_BaseProjectile_ShotgunIncBullet;


defaultproperties
{
	 DisintegrateSound=(Vol=1.5,Radius=250.0,bUse3D=True)
	 ExplodeSound=(Vol=1.5,Radius=250.0,bUse3D=True)
     ImpactDamageType=Class'UnlimaginMod.UM_DamTypeAA12IncImpact'
     ImpactDamage=80.000000
	 //MuzzleVelocity
	 MuzzleVelocity=420.000000		// m/sec
     Damage=75.000000
	 DamageRadius=120.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'UnlimaginMod.UM_DamTypeAA12IncBullet'
}
