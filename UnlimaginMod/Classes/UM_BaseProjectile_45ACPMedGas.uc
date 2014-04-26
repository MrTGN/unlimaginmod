//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_45ACPMedGas
//	Parent class:	 UM_MedGas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 13:58
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_BaseProjectile_45ACPMedGas extends UM_MedGas
	Abstract;


defaultproperties
{
     bInitialAcceleration=True
	 SpawnCheckRadiusScale=0.250000
	 SpeedDropScale=0.950000
	 BallisticRandRange=(Min=0.86,Max=1.14)
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=120.000000
	 HealBoostAmount=13
     MaxHeals=6
     HealInterval=0.500000
	 Damage=20.000000
	 DamageRadius=130.000000
     GasCloudEmitterClass=Class'UnlimaginMod.UM_45ACPMedGasCloud'
	 Trail=(EmitterClass=Class'UnlimaginMod.UM_MedGasTrail',EmitterRotation=(Pitch=32768))
     MyDamageType=None
	 LifeSpan=3.000000
}
