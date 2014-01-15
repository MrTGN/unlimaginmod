//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_TrenchgunMedGasBullet
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.11.2012 0:32
//================================================================================
class UM_TrenchgunMedGasBullet extends UM_AA12MedGasBullet;

defaultproperties
{
     HealBoostAmount=10
     MaxHeals=5
     MaxNumberOfPlayers=5
	 ExplosionSoundVolume=2.200000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeTrenchgunMedGasImpact'
     ImpactDamage=200
	 Speed=8000.000000
     MaxSpeed=9000.000000
     Damage=75.000000
	 DamageRadius=150.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeTrenchgunMedGas'
}
