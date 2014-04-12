//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_30WCF_H160FTX
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 18:48
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Hornady 30-30 Win 160 gr FTX
//					 Bullet diameter: 7.8 mm (.308 in). Bullet Mass: 10.368 g (160 gr)
//================================================================================
class UM_BaseProjectile_30WCF_H160FTX extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bCanBounce=True
	 BallisticCoefficient=0.330000
	 BallisticRandPercent=8.000000
	 EffectiveRange=1000.000000
	 ExpansionCoefficient=1.650000
	 ProjectileMass=0.010368		//kilograms
	 MuzzleVelocity=730.000000		//Meter/sec
     PenetrationEnergyReduction=0.650000
     HeadShotDamageMult=1.250000
   	 Damage=95.000000
	 MomentumTransfer=120000.000000
}
