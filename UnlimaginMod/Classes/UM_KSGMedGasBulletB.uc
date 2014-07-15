//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGMedGasBulletB
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.11.2012 0:19
//================================================================================
class UM_KSGMedGasBulletB extends UM_AA12MedGasBullet;

defaultproperties
{
     ExplosionSoundVolume=1.800000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeKSGMedGasImpact'
     ImpactDamage=80
	 Speed=7500.000000
     MaxSpeed=8500.000000
     Damage=45.000000
	 DamageRadius=200.000000
     MomentumTransfer=80000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeKSGMedGas'
}
