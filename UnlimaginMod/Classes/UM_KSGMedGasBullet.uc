//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_KSGMedGasBullet
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.11.2012 0:18
//================================================================================
class UM_KSGMedGasBullet extends UM_AA12MedGasBullet;

defaultproperties
{
     HealBoostAmount=10
     MaxHeals=6
     MaxNumberOfPlayers=5
	 ExplosionSoundVolume=2.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeKSGMedGasImpact'
     ImpactDamage=100
	 Speed=9000.000000
     MaxSpeed=10000.000000
     Damage=85.000000
	 DamageRadius=100.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeKSGMedGas'
}
