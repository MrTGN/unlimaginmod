//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BenelliM4MedGasBullet
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2012 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 26.11.2012 0:10
//================================================================================
class UM_BenelliM4MedGasBullet extends UM_AA12MedGasBullet;


defaultproperties
{
     HealBoostAmount=10
     MaxHeals=5
     MaxNumberOfPlayers=5
	 ExplosionSoundVolume=1.800000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM4MedGasImpact'
     ImpactDamage=100
	 Speed=8000.000000
     MaxSpeed=9000.000000
     Damage=70.000000
	 DamageRadius=160.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeBenelliM4MedGas'
}
