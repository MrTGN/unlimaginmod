//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_FlameThrowerMedGas
//	Parent class:	 UM_MedGas
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 07.06.2013 22:52
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_FlameThrowerMedGas extends UM_MedGas;


defaultproperties
{
     bInitialAcceleration=True
	 SpeedDropScale=0.780000
	 BallisticRandPercent=28.000000
	 // MuzzleVelocity in m/sec
	 MuzzleVelocity=40.000000
	 HealBoostAmount=13
     MaxHeals=8
     HealInterval=0.500000
	 Damage=14.500000
	 DamageRadius=160.000000
     GasCloudEmitterClass=Class'UnlimaginMod.UM_MedGasCloud'
	 EmitterTrailsInfo(0)=(TrailClass=Class'UnlimaginMod.UM_MedGasTrail',bAttachTrail=True,TrailRotation=(Pitch=32768))
     MyDamageType=Class'UnlimaginMod.UM_DamTypeFlameThrowerMedGas'
	 LifeSpan=4.000000
}
