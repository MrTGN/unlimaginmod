//================================================================================
//	Package:		 UnlimaginMod
//������������������������������������������������������������������������������
//	Class name:		 UM_M37IthacaFragBullet
//	Parent class:	 UM_BaseProjectile_ShotgunExpBullet
//������������������������������������������������������������������������������
//	Copyright:		 � 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright � 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright � 2004-2013 Epic Games, Inc.
//������������������������������������������������������������������������������
//	Creation date:	 08.03.2013 19:47
//������������������������������������������������������������������������������
//	Comments:		 
//================================================================================
class UM_M37IthacaFragBullet extends UM_BaseProjectile_ShotgunExpBullet;

defaultproperties
{
     SoundEffectsVolume=2.300000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeM37IthacaFragImpact'
     ImpactDamage=200.000000
	 //MuzzleVelocity
	 MuzzleVelocity=440.000000		// m/sec
     Damage=190.000000
     DamageRadius=140.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM37IthacaFragBullet'
}