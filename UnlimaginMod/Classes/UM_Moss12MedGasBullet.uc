//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_Moss12MedGasBullet
//	Parent class:	 UM_AA12MedGasBullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 05.03.2013 06:15
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 
//================================================================================
class UM_Moss12MedGasBullet extends UM_AA12MedGasBullet;



defaultproperties
{
     HealBoostAmount=10
     MaxHeals=6
     MaxNumberOfPlayers=5
	 ExplosionSoundVolume=2.000000
	 ImpactDamageType=Class'UnlimaginMod.UM_DamTypeMoss12MedGasImpact'
     ImpactDamage=100
	 Speed=8200.000000
     MaxSpeed=9200.000000
     Damage=78.000000
	 DamageRadius=142.000000
     MomentumTransfer=100000.000000
	 MyDamageType=Class'UnlimaginMod.UM_DamTypeMoss12MedGas'
}
