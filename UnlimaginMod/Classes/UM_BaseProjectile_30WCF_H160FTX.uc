//================================================================================
//	Package:		 UnlimaginMod
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Class name:		 UM_BaseProjectile_30WCF_H160FTX
//	Parent class:	 UM_BaseProjectile_Bullet
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Copyright:		 ｩ 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright ｩ 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright ｩ 2004-2013 Epic Games, Inc.
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Creation date:	 17.08.2013 18:48
//末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末末
//	Comments:		 Hornady 30-30 Win 160 gr FTX
//					 Bullet diameter: 7.8 mm (.308 in). Bullet Mass: 10.368 g (160 gr)
//================================================================================
class UM_BaseProjectile_30WCF_H160FTX extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanRebound=True
	 ProjectileDiameter=7.8
	 BallisticCoefficient=0.330000
	 BallisticRandPercent=8.000000
	 EffectiveRange=900.000000
	 MaxEffectiveRange=1000.000000
	 ExpansionCoefficient=1.650000
	 ProjectileMass=0.010368		//kilograms
	 MuzzleVelocity=730.000000		//Meter/sec
     PenetrationEnergyReduction=0.650000
     HeadShotDamageMult=1.250000
   	 Damage=95.000000
	 MomentumTransfer=120000.000000
}
