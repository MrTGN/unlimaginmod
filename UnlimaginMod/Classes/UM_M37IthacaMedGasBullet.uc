//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_M37IthacaMedGasBullet
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 08.03.2013 19:35
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_M37IthacaMedGasBullet extends UM_AA12MedGasBullet;

defaultproperties
{
     HealBoostAmount=10
     MaxHeals=6
     MaxNumberOfPlayers=5
	 ExplosionSoundVolume=2.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeM37IthacaMedGasImpact'
     ImpactDamage=100
	 Speed=8500.000000
     MaxSpeed=9500.000000
     Damage=76.000000
	 DamageRadius=136.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeM37IthacaMedGas'
}
