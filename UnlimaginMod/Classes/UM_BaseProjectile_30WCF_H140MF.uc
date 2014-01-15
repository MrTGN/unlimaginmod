//================================================================================
//	Package:		 UnlimaginMod
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Class name:		 UM_BaseProjectile_30WCF_H140MF
//	Parent class:	 UM_BaseProjectile_Bullet
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Copyright:		 © 2013 Tsiryuta G. N. <spbtgn@gmail.com>
//
//	Also some parts of the code with some changes copied from: 
//	Killing Floor Source - Copyright © 2009-2013 Tripwire Interactive, LLC 
//	Unreal Tournament 2004 Source - Copyright © 2004-2013 Epic Games, Inc.
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Creation date:	 17.08.2013 18:39
//––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
//	Comments:		 Hornady 30-30 Win 140 gr MonoFlex
//					 Bullet diameter: 7.8 mm (.308 in). Bullet Mass: 9.0718 g (140 gr)
//================================================================================
class UM_BaseProjectile_30WCF_H140MF extends UM_BaseProjectile_Bullet
	Abstract;


defaultproperties
{
     bBounce=True
	 BounceChance=0.600000
	 BallisticCoefficient=0.277000
	 BallisticRandPercent=8.000000
	 EffectiveRange=1000.000000
	 ExpansionCoefficient=1.450000
	 ProjectileMass=0.009072		//kilograms
	 MuzzleVelocity=750.000000		//Meter/sec
     PenitrationEnergyReduction=0.600000
     HeadShotDamageMult=1.250000
   	 Damage=85.000000
	 MomentumTransfer=110000.000000
}
