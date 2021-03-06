//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_FlameThrowerMedGas
//	Parent class:	 UM_MedGas
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 07.06.2013 22:52
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 
//================================================================================
class UM_FlameThrowerMedGas extends UM_MedGas;


defaultproperties
{
     bInitialAcceleration=True
	 SpeedDropScale=0.780000
	 BallisticRandRange=(Min=0.76,Max=1.14)
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=40.000000
	 HealBoostAmount=13
     MaxHeals=8
     HealInterval=0.500000
	 Damage=14.500000
	 DamageRadius=160.000000
     GasCloudEmitterClass=Class'UnlimaginMod.UM_MedGasCloud'
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_MedGasTrail',EmitterRotation=(Pitch=32768))
     MyDamageType=Class'UnlimaginMod.UM_DamTypeFlameThrowerMedGas'
	 LifeSpan=4.000000
}
