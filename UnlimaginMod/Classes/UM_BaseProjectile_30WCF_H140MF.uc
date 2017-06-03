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
     ProjectileDiameter=7.8
	 bCanRicochet=True
	 BallisticCoefficient=0.277000
	 BallisticRandRange=(Min=0.96,Max=1.04)
	 EffectiveRange=900.000000
	 MaxEffectiveRange=100.000000
	 ExpansionCoefficient=1.450000
	 ProjectileMass=9.072		//grams
	 MuzzleVelocity=750.000000		//Meter/sec
     HeadShotDamageMult=1.250000
   	 ImpactDamage=85.000000
	 ImpactMomentum=110000.000000
}
